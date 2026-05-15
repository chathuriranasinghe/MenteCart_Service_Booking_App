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