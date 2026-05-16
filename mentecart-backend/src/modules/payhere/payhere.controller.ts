import { NextFunction, Request, Response } from 'express';
import { envConfig } from '../../config/env.config';
import { ResponseBuilder } from '../../core/utils/response-builder';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { BookingRepository } from '../bookings/booking.repository';
import {
  PAYHERE_CHECKOUT_URL,
  generatePayhereHash,
  processWebhookNotification,
} from './payhere.service';

const bookingRepository = new BookingRepository();

export class PayhereController {
  /**
   * GET /api/v1/payhere/hash?bookingNumber=MC-xxx
   * Returns the PayHere checkout params including the hash.
   * Called by the Flutter app just before launching the WebView.
   */
  static async getCheckoutParams(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;
      if (!userId) throw new Error('Authenticated user not found');

      const bookingNumber = req.query['bookingNumber'] as string;
      if (!bookingNumber) {
        return res.status(400).json({ success: false, message: 'bookingNumber is required' });
      }

      const booking = await bookingRepository.findByBookingNumber(bookingNumber);
      if (!booking || booking.userId.toString() !== userId) {
        return res.status(404).json({ success: false, message: 'Booking not found' });
      }

      const currency = 'LKR';
      const amountFormatted = booking.totalAmount.toFixed(2);
      const hash = generatePayhereHash(bookingNumber, booking.totalAmount, currency);

      // Temporary debug — remove before production
      console.log(JSON.stringify({
        merchantId: envConfig.payheremerchantId,
        orderId: bookingNumber,
        amount: amountFormatted,
        currency,
        hashLength: hash.length,
        hashUppercase: hash === hash.toUpperCase(),
      }));

      return ResponseBuilder.success(res, 'Checkout params generated', {
        checkoutUrl: PAYHERE_CHECKOUT_URL,
        merchantId: envConfig.payheremerchantId,
        orderId: bookingNumber,
        amount: amountFormatted,
        currency,
        hash,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/v1/payhere/webhook
   * Receives PayHere payment notifications.
   * Must be registered BEFORE express.json() so raw body is available for signature verification.
   * PayHere sends application/x-www-form-urlencoded.
   */
  static async webhook(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      // Body is already parsed as urlencoded by the route-level middleware
      await processWebhookNotification(req.body as Record<string, string>);
      return res.status(200).send('OK');
    } catch (error) {
      next(error);
    }
  }
}
