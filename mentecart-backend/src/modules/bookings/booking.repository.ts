import { Types } from 'mongoose';

import { BookingDocument, BookingModel, BookingStatus, PaymentMethod, PaymentStatus, StatusHistoryEntry } from './booking.model';

export class BookingRepository {
  async createBooking(payload: {
    bookingNumber: string;
    userId: string;
    items: {
      serviceId: string;
      title: string;
      price: number;
      quantity: number;
      selectedDate: string;
      selectedTime: string;
      image: string;
    }[];
    totalAmount: number;
    bookingStatus: BookingStatus;
    paymentMethod: PaymentMethod;
    paymentStatus: PaymentStatus;
    statusHistory: StatusHistoryEntry[];
  }): Promise<BookingDocument> {
    return BookingModel.create({
      bookingNumber: payload.bookingNumber,
      userId: new Types.ObjectId(payload.userId),
      items: payload.items.map((item) => ({
        serviceId: new Types.ObjectId(item.serviceId),
        title: item.title,
        price: item.price,
        quantity: item.quantity,
        selectedDate: item.selectedDate,
        selectedTime: item.selectedTime,
        image: item.image,
      })),
      totalAmount: payload.totalAmount,
      bookingStatus: payload.bookingStatus,
      paymentMethod: payload.paymentMethod,
      paymentStatus: payload.paymentStatus,
      statusHistory: payload.statusHistory,
    });
  }

  async findByUserId(userId: string): Promise<BookingDocument[]> {
    return BookingModel.find({
      userId: new Types.ObjectId(userId),
    }).sort({ createdAt: -1 });
  }

  async findByIdAndUserId(
    bookingId: string,
    userId: string,
  ): Promise<BookingDocument | null> {
    return BookingModel.findOne({
      _id: new Types.ObjectId(bookingId),
      userId: new Types.ObjectId(userId),
    });
  }

  async countTodayBookings(userId: string): Promise<number> {
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date();
    endOfDay.setHours(23, 59, 59, 999);

    return BookingModel.countDocuments({
      userId: new Types.ObjectId(userId),
      bookingStatus: { $nin: ['cancelled', 'failed'] },
      createdAt: { $gte: startOfDay, $lte: endOfDay },
    });
  }

  async save(booking: BookingDocument): Promise<BookingDocument> {
    return booking.save();
  }

  async findByBookingNumber(bookingNumber: string): Promise<BookingDocument | null> {
    return BookingModel.findOne({ bookingNumber });
  }

  async findByPayhereOrderId(payhereOrderId: string): Promise<BookingDocument | null> {
    return BookingModel.findOne({ payhereOrderId });
  }
}
