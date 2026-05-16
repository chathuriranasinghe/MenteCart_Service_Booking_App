import { AppError } from '../../core/errors/app-error';
import { CartRepository } from '../cart/cart.repository';
import { ServiceRepository } from '../services/service.repository';
import {
  BookingListResponseDto,
  BookingResponseDto,
  CheckoutDto,
} from './booking.dto';
import { BookingDocument, BookingStatus } from './booking.model';
import { BookingRepository } from './booking.repository';

const MAX_BOOKINGS_PER_DAY = 3;

export class BookingService {
  constructor(
    private readonly bookingRepository: BookingRepository,
    private readonly cartRepository: CartRepository,
    private readonly serviceRepository: ServiceRepository,
  ) {}

  async checkout(userId: string, payload: CheckoutDto): Promise<BookingResponseDto> {
    const cart = await this.cartRepository.findByUserId(userId);

    if (!cart || cart.items.length === 0) {
      throw new AppError('Cart is empty', 400, 'CART_EMPTY');
    }

    if (cart.expiresAt < new Date()) {
      throw new AppError('Cart has expired. Please add items again.', 400, 'CART_EXPIRED');
    }

    const todayBookingCount = await this.bookingRepository.countTodayBookings(userId);
    if (todayBookingCount >= MAX_BOOKINGS_PER_DAY) {
      throw new AppError(
        `You can only make ${MAX_BOOKINGS_PER_DAY} bookings per day`,
        409,
        'DAILY_BOOKING_LIMIT_REACHED',
      );
    }

    // Atomically decrement capacity for each cart item
    for (const item of cart.items) {
      const decremented = await this.serviceRepository.decrementSlotCapacity(
        item.serviceId.toString(),
        item.selectedDate,
        item.selectedTime,
        item.quantity,
      );

      if (!decremented) {
        throw new AppError(
          `No available capacity for "${item.title}" on ${item.selectedDate} at ${item.selectedTime}`,
          409,
          'SLOT_CAPACITY_EXCEEDED',
        );
      }
    }

    const totalAmount = cart.items.reduce(
      (total, item) => total + item.price * item.quantity,
      0,
    ) + 50 - 100; // platform fee: +50, discount: -100

    const initialStatus: BookingStatus =
      payload.paymentMethod === 'card' ? 'pending' : 'confirmed';

    const booking = await this.bookingRepository.createBooking({
      bookingNumber: this.generateBookingNumber(),
      userId,
      items: cart.items.map((item) => ({
        serviceId: item.serviceId.toString(),
        title: item.title,
        price: item.price,
        quantity: item.quantity,
        selectedDate: item.selectedDate,
        selectedTime: item.selectedTime,
        image: item.image,
      })),
      totalAmount,
      bookingStatus: initialStatus,
      paymentMethod: payload.paymentMethod,
      paymentStatus: 'unpaid',
      statusHistory: [{ status: initialStatus, changedAt: new Date() }],
    });

    await this.cartRepository.clearCart(userId);

    return this.mapBookingResponse(booking);
  }

  async getBookings(userId: string): Promise<BookingListResponseDto> {
    const bookings = await this.bookingRepository.findByUserId(userId);
    return { bookings: bookings.map((b) => this.mapBookingResponse(b)) };
  }

  async getBookingById(userId: string, bookingId: string): Promise<BookingResponseDto> {
    const booking = await this.bookingRepository.findByIdAndUserId(bookingId, userId);
    if (!booking) {
      throw new AppError('Booking not found', 404, 'BOOKING_NOT_FOUND');
    }
    return this.mapBookingResponse(booking);
  }

  async cancelBooking(userId: string, bookingId: string): Promise<BookingResponseDto> {
    const booking = await this.bookingRepository.findByIdAndUserId(bookingId, userId);

    if (!booking) {
      throw new AppError('Booking not found', 404, 'BOOKING_NOT_FOUND');
    }

    if (booking.bookingStatus === 'cancelled') {
      throw new AppError('Booking is already cancelled', 409, 'BOOKING_CANNOT_BE_CANCELLED');
    }

    if (booking.bookingStatus === 'completed') {
      throw new AppError('Completed booking cannot be cancelled', 409, 'BOOKING_CANNOT_BE_CANCELLED');
    }

    if (booking.bookingStatus === 'failed') {
      throw new AppError('Failed booking cannot be cancelled', 409, 'BOOKING_CANNOT_BE_CANCELLED');
    }

    // Release capacity back to each slot
    for (const item of booking.items) {
      await this.serviceRepository.releaseSlotCapacity(
        item.serviceId.toString(),
        item.selectedDate,
        item.selectedTime,
        item.quantity,
      );
    }

    booking.bookingStatus = 'cancelled';
    booking.cancelledAt = new Date();
    booking.statusHistory.push({ status: 'cancelled', changedAt: new Date() });

    const savedBooking = await this.bookingRepository.save(booking);
    return this.mapBookingResponse(savedBooking);
  }

  private generateBookingNumber(): string {
    const timestamp = Date.now();
    const randomNumber = Math.floor(1000 + Math.random() * 9000);
    return `MC-${timestamp}-${randomNumber}`;
  }

  private mapBookingResponse(booking: BookingDocument): BookingResponseDto {
    return {
      id: booking._id.toString(),
      bookingNumber: booking.bookingNumber,
      userId: booking.userId.toString(),
      items: booking.items.map((item) => ({
        serviceId: item.serviceId.toString(),
        title: item.title,
        price: item.price,
        quantity: item.quantity,
        selectedDate: item.selectedDate,
        selectedTime: item.selectedTime,
        image: item.image,
        total: item.price * item.quantity,
      })),
      totalAmount: booking.totalAmount,
      bookingStatus: booking.bookingStatus,
      paymentMethod: booking.paymentMethod,
      paymentStatus: booking.paymentStatus,
      statusHistory: booking.statusHistory.map((h) => ({
        status: h.status,
        changedAt: h.changedAt,
      })),
      cancelledAt: booking.cancelledAt,
      createdAt: booking.createdAt,
      updatedAt: booking.updatedAt,
    };
  }
}
