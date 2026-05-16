import crypto from 'crypto';
import { envConfig } from '../../config/env.config';
import { AppError } from '../../core/errors/app-error';
import { ServiceRepository } from '../services/service.repository';
import { BookingRepository } from '../bookings/booking.repository';

const bookingRepository = new BookingRepository();
const serviceRepository = new ServiceRepository();

// PayHere sandbox base URL
export const PAYHERE_CHECKOUT_URL = 'https://sandbox.payhere.lk/pay/checkout';

/**
 * Generate the PayHere hash for a payment request.
 * Formula: MD5( merchant_id + order_id + amount_formatted + currency +
 *               MD5(merchant_secret).toUpperCase() ).toUpperCase()
 */
export function generatePayhereHash(
  orderId: string,
  amount: number,
  currency: string,
): string {
  const merchantId = envConfig.payheremerchantId;
  const merchantSecret = envConfig.payhereMerchantSecret;

  const hashedSecret = crypto
    .createHash('md5')
    .update(merchantSecret)
    .digest('hex')
    .toUpperCase();

  const amountFormatted = amount.toFixed(2);

  const raw = `${merchantId}${orderId}${amountFormatted}${currency}${hashedSecret}`;

  return crypto.createHash('md5').update(raw).digest('hex').toUpperCase();
}

/**
 * Verify the PayHere webhook notification signature.
 * Formula: MD5( merchant_id + order_id + amount_formatted + currency +
 *               status_code + MD5(merchant_secret).toUpperCase() ).toUpperCase()
 */
export function verifyWebhookSignature(params: {
  merchant_id: string;
  order_id: string;
  payhere_amount: string;
  payhere_currency: string;
  status_code: string;
  md5sig: string;
}): boolean {
  const merchantSecret = envConfig.payhereMerchantSecret;

  const hashedSecret = crypto
    .createHash('md5')
    .update(merchantSecret)
    .digest('hex')
    .toUpperCase();

  const raw = `${params.merchant_id}${params.order_id}${params.payhere_amount}${params.payhere_currency}${params.status_code}${hashedSecret}`;

  const expected = crypto
    .createHash('md5')
    .update(raw)
    .digest('hex')
    .toUpperCase();

  return expected === params.md5sig.toUpperCase();
}

/**
 * Process a PayHere webhook notification idempotently.
 *
 * status_code meanings:
 *   2  = success
 *   0  = pending
 *  -1  = cancelled
 *  -2  = failed
 *  -3  = chargedback
 */
export async function processWebhookNotification(body: Record<string, string>): Promise<void> {
  const {
    merchant_id,
    order_id,       // our bookingNumber
    payhere_amount,
    payhere_currency,
    status_code,
    md5sig,
    payment_id,     // PayHere's own payment ID — used as payhereOrderId
  } = body;

  // 1. Verify signature
  if (!verifyWebhookSignature({ merchant_id, order_id, payhere_amount, payhere_currency, status_code, md5sig })) {
    throw new AppError('Invalid webhook signature', 400, 'INVALID_SIGNATURE');
  }

  // 2. Find booking by bookingNumber (order_id)
  const booking = await bookingRepository.findByBookingNumber(order_id);
  if (!booking) {
    throw new AppError('Booking not found', 404, 'BOOKING_NOT_FOUND');
  }

  const code = parseInt(status_code, 10);

  // 3. Idempotency — skip if already processed with this payment_id
  if (booking.payhereOrderId && booking.payhereOrderId === payment_id) {
    return;
  }

  // 4. Also skip if booking is already in a terminal state
  if (['confirmed', 'cancelled', 'failed'].includes(booking.bookingStatus) && booking.payhereOrderId) {
    return;
  }

  if (code === 2) {
    // Payment success
    booking.paymentStatus = 'paid';
    booking.bookingStatus = 'confirmed';
    booking.payhereOrderId = payment_id;
    booking.statusHistory.push({ status: 'confirmed', changedAt: new Date() });
    await bookingRepository.save(booking);

  } else if (code === -1 || code === -2 || code === -3) {
    // Payment failed / cancelled / chargedback — release capacity
    if (booking.bookingStatus !== 'failed' && booking.bookingStatus !== 'cancelled') {
      for (const item of booking.items) {
        await serviceRepository.releaseSlotCapacity(
          item.serviceId.toString(),
          item.selectedDate,
          item.selectedTime,
          item.quantity,
        );
      }
      booking.paymentStatus = 'failed';
      booking.bookingStatus = 'failed';
      booking.payhereOrderId = payment_id;
      booking.statusHistory.push({ status: 'failed', changedAt: new Date() });
      await bookingRepository.save(booking);
    }
  }
  // status_code 0 (pending) — no action needed
}
