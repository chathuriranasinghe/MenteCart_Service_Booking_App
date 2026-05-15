import { NextFunction, Request, Response } from 'express';

import { AppError } from '../core/errors/app-error';
import { ResponseBuilder } from '../core/utils/response-builder';

export const errorMiddleware = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction,
): Response => {
  if (error instanceof AppError) {
    return ResponseBuilder.error(res, error.message, error.statusCode);
  }

  console.error(error);

  return ResponseBuilder.error(
    res,
    'Something went wrong. Please try again later.',
    500,
  );
};