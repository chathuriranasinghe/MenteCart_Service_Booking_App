import { z } from 'zod';

export const registerSchema = z.object({
  body: z.object({
    fullName: z
      .string({ error: 'Full name is required' })
      .min(2, 'Full name must be at least 2 characters'),

    email: z
      .string({ error: 'Email is required' })
      .email('Enter a valid email address'),

    phoneNumber: z
      .string({ error: 'Phone number is required' })
      .min(9, 'Enter a valid phone number'),

    password: z
      .string({ error: 'Password is required' })
      .min(6, 'Password must be at least 6 characters'),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z
      .string({ error: 'Email is required' })
      .email('Enter a valid email address'),

    password: z
      .string({ error: 'Password is required' })
      .min(6, 'Password must be at least 6 characters'),
  }),
});
