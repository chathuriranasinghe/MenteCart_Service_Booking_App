import { z } from 'zod';

export const updateProfileSchema = z.object({
  body: z.object({
    fullName: z.string().min(2, 'Full name must be at least 2 characters').optional(),
    phoneNumber: z.string().min(9, 'Enter a valid phone number').optional(),
    address: z.object({
      label: z.string().min(1).optional(),
      line: z.string().min(5, 'Enter a valid address').optional(),
      phone: z.string().min(9, 'Enter a valid phone number').optional(),
    }).optional(),
  }),
});
