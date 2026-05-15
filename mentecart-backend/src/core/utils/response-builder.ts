import { Response } from 'express';
import { ApiResponse } from '../interfaces/api-response.interface';

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
  ): Response<ApiResponse<null>> {
    return res.status(statusCode).json({
      success: false,
      message,
      data: null,
    });
  }
}