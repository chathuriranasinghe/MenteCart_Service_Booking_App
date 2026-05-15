import { z } from 'zod';

export const getServicesSchema = z.object({
  query: z.object({
    page: z
      .string()
      .optional()
      .transform((value) => Number(value ?? 1))
      .refine((value) => value > 0, {
        message: 'Page must be greater than 0',
      }),

    limit: z
      .string()
      .optional()
      .transform((value) => Number(value ?? 10))
      .refine((value) => value > 0 && value <= 50, {
        message: 'Limit must be between 1 and 50',
      }),

    category: z.string().optional(),

    search: z.string().optional(),
  }),
});

export const getServiceByIdSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Service id is required'),
  }),
});