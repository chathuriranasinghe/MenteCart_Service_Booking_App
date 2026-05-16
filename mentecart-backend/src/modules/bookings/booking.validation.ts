import { z } from 'zod';

export const checkoutSchema = z.object({
  body: z.object({
    paymentMethod: z.enum(['cash', 'card', 'pay_on_arrival'], {
      error: 'Payment method is required',
    }),
  }),
});

export const bookingIdSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Booking id is required'),
  }),
});
