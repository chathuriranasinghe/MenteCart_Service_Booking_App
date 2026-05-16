import { FilterQuery } from 'mongoose';

import { ServiceQueryDto } from './service.dto';
import { ServiceDocument, ServiceModel } from './service.model';

export class ServiceRepository {
  async findAll(
    query: ServiceQueryDto,
  ): Promise<{ services: ServiceDocument[]; total: number }> {
    const filter = this.buildFilter(query);

    const skip = (query.page - 1) * query.limit;

    const [services, total] = await Promise.all([
      ServiceModel.find(filter)
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(query.limit),
      ServiceModel.countDocuments(filter),
    ]);

    return {
      services,
      total,
    };
  }

  async findById(serviceId: string): Promise<ServiceDocument | null> {
    return ServiceModel.findOne({
      _id: serviceId,
      isActive: true,
    });
  }

  async decrementSlotCapacity(
    serviceId: string,
    selectedDate: string,
    selectedTime: string,
    quantity: number,
  ): Promise<boolean> {
    // Try to decrement an existing slot that has enough capacity
    const decremented = await ServiceModel.findOneAndUpdate(
      {
        _id: serviceId,
        isActive: true,
        availableSlots: {
          $elemMatch: { date: selectedDate, time: selectedTime, remainingCapacity: { $gte: quantity } },
        },
      },
      { $inc: { 'availableSlots.$.remainingCapacity': -quantity } },
      { new: true },
    );

    if (decremented) return true;

    // Slot doesn't exist yet — create it using capacityPerSlot as the base,
    // then decrement. Two atomic ops; safe because the first push only runs
    // when no matching slot exists.
    const service = await ServiceModel.findOne({ _id: serviceId, isActive: true });
    if (!service) return false;

    const initialCapacity = service.capacityPerSlot - quantity;
    if (initialCapacity < 0) return false;

    // Push the new slot only if it still doesn't exist (guard against races)
    const pushed = await ServiceModel.findOneAndUpdate(
      {
        _id: serviceId,
        isActive: true,
        availableSlots: { $not: { $elemMatch: { date: selectedDate, time: selectedTime } } },
      },
      {
        $push: {
          availableSlots: { date: selectedDate, time: selectedTime, remainingCapacity: initialCapacity },
        },
      },
      { new: true },
    );

    if (pushed) return true;

    // Another request pushed the slot concurrently — retry the decrement once
    const retried = await ServiceModel.findOneAndUpdate(
      {
        _id: serviceId,
        isActive: true,
        availableSlots: {
          $elemMatch: { date: selectedDate, time: selectedTime, remainingCapacity: { $gte: quantity } },
        },
      },
      { $inc: { 'availableSlots.$.remainingCapacity': -quantity } },
      { new: true },
    );

    return retried !== null;
  }

  async releaseSlotCapacity(
    serviceId: string,
    selectedDate: string,
    selectedTime: string,
    quantity: number,
  ): Promise<void> {
    // Increment if slot exists
    const updated = await ServiceModel.updateOne(
      {
        _id: serviceId,
        isActive: true,
        availableSlots: { $elemMatch: { date: selectedDate, time: selectedTime } },
      },
      { $inc: { 'availableSlots.$.remainingCapacity': quantity } },
    );

    if (updated.modifiedCount === 0) {
      // Slot was never persisted (e.g. booking failed before push) — nothing to release
    }
  }

  private buildFilter(query: ServiceQueryDto): FilterQuery<ServiceDocument> {
    const filter: FilterQuery<ServiceDocument> = {
      isActive: true,
    };

    if (query.category) {
      filter.category = {
        $regex: query.category,
        $options: 'i',
      };
    }

    if (query.search) {
      filter.title = {
        $regex: query.search,
        $options: 'i',
      };
    }

    return filter;
  }
}