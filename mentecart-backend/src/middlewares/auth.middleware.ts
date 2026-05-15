import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';

import { envConfig } from '../config/env.config';
import { AppError } from '../core/errors/app-error';

export interface AuthRequest extends Request {
  user?: {
    userId: string;
    email: string;
  };
}

interface JwtPayload {
  userId: string;
  email: string;
}

export const authMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
): void => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    next(new AppError('Authorization token is required', 401));
    return;
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, envConfig.jwtSecret) as JwtPayload;

    req.user = {
      userId: decoded.userId,
      email: decoded.email,
    };

    next();
  } catch (error) {
    next(new AppError('Invalid or expired token', 401));
  }
};