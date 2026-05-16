import { NextFunction, Request, Response } from 'express';

import { logger } from '../config/logger.config';
import { AppError } from '../core/errors/app-error';
import { ResponseBuilder } from '../core/utils/response-builder';

export const errorMiddleware = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction,
): Response => {
  const requestId = req.id;

  if (error instanceof AppError) {
    logger.warn(
      {
        requestId,
        statusCode: error.statusCode,
        errorMessage: error.message,
        method: req.method,
        url: req.originalUrl,
      },
      'Application error occurred',
    );

    return ResponseBuilder.error(res, error.message, error.statusCode, error.errorCode);
  }

  logger.error(
    {
      requestId,
      errorMessage: error.message,
      stack: error.stack,
      method: req.method,
      url: req.originalUrl,
    },
    'Unhandled error occurred',
  );

  return ResponseBuilder.error(
    res,
    'Something went wrong. Please try again later.',
    500,
    'INTERNAL_SERVER_ERROR',
  );
};