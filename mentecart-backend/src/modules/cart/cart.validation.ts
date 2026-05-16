import { z } from 'zod';

export const addCartItemSchema = z.object({
  body: z.object({
    serviceId: z.string().min(1, 'Service id is required'),

    selectedDate: z
      .string()
      .min(1, 'Selected date is required'),

    selectedTime: z
      .string()
      .min(1, 'Selected time is required'),

    quantity: z
      .number({ error: 'Quantity is required' })
      .int('Quantity must be a whole number')
      .min(1, 'Quantity must be at least 1'),
  }),
});

export const updateCartItemSchema = z.object({
  params: z.object({
    itemId: z.string().min(1, 'Cart item id is required'),
  }),
  body: z.object({
    selectedDate: z.string().optional(),
    selectedTime: z.string().optional(),

    quantity: z
      .number()
      .int('Quantity must be a whole number')
      .min(1, 'Quantity must be at least 1')
      .optional(),
  }),
});

export const cartItemIdSchema = z.object({
  params: z.object({
    itemId: z.string().min(1, 'Cart item id is required'),
  }),
});