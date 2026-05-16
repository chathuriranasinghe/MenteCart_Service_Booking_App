import { Response } from 'express';

import { ApiResponse } from '../interfaces/api-response.interface';
import { ErrorResponse } from '../interfaces/error-response.interface';

export class ResponseBuilder {
  static success<T>(
    res: Response,
    message: string,
    data: T,
    statusCode = 200,
  ): Response<ApiResponse<T>> {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static error(
    res: Response,
    message: string,
    statusCode = 500,
    errorCode = 'INTERNAL_SERVER_ERROR',
  ): Response<ErrorResponse> {
    return res.status(statusCode).json({
      statusCode,
      message,
      errorCode,
    });
  }
}
