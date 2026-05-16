import { NextFunction, Response } from 'express';

import { ResponseBuilder } from '../../core/utils/response-builder';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { CartRepository } from '../cart/cart.repository';
import { ServiceRepository } from '../services/service.repository';
import { BookingRepository } from './booking.repository';
import { BookingService } from './booking.service';

const bookingRepository = new BookingRepository();
const cartRepository = new CartRepository();
const serviceRepository = new ServiceRepository();

const bookingService = new BookingService(
  bookingRepository,
  cartRepository,
  serviceRepository,
);

export class BookingController {
  static async checkout(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await bookingService.checkout(userId, req.body);

      return ResponseBuilder.success(res, 'Booking created successfully', result, 201);
    } catch (error) {
      next(error);
    }
  }

  static async getBookings(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await bookingService.getBookings(userId);

      return ResponseBuilder.success(res, 'Bookings fetched successfully', result);
    } catch (error) {
      next(error);
    }
  }

  static async getBookingById(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await bookingService.getBookingById(
        userId,
        req.params['id'] as string,
      );

      return ResponseBuilder.success(res, 'Booking details fetched successfully', result);
    } catch (error) {
      next(error);
    }
  }

  static async cancelBooking(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await bookingService.cancelBooking(
        userId,
        req.params['id'] as string,
      );

      return ResponseBuilder.success(res, 'Booking cancelled successfully', result);
    } catch (error) {
      next(error);
    }
  }
}
