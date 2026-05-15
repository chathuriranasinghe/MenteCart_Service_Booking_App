import { NextFunction, Request, Response } from 'express';
import { ResponseBuilder } from '../../core/utils/response-builder';
import { AuthRepository } from './auth.repository';
import { AuthService } from './auth.service';
import { AuthRequest } from '../../middlewares/auth.middleware';

const authRepository = new AuthRepository();
const authService = new AuthService(authRepository);

export class AuthController {
  static async register(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const result = await authService.register(req.body);

      return ResponseBuilder.success(
        res,
        'Account created successfully',
        result,
        201,
      );
    } catch (error) {
      next(error);
    }
  }

  static async login(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const result = await authService.login(req.body);

      return ResponseBuilder.success(
        res,
        'Login successful',
        result,
      );
    } catch (error) {
      next(error);
    }
  }

  static async me(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      if (!req.user) {
        throw new Error('Authenticated user not found');
      }

      const result = await authService.getCurrentUser(req.user.userId);

      return ResponseBuilder.success(
        res,
        'Current user fetched successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }
}