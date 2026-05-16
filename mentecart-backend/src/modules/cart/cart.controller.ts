import { NextFunction, Response } from 'express';

import { AuthRequest } from '../../middlewares/auth.middleware';
import { ResponseBuilder } from '../../core/utils/response-builder';
import { ServiceRepository } from '../services/service.repository';
import { CartRepository } from './cart.repository';
import { CartService } from './cart.service';

const cartRepository = new CartRepository();
const serviceRepository = new ServiceRepository();
const cartService = new CartService(cartRepository, serviceRepository);

export class CartController {
  static async getCart(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await cartService.getCart(userId);

      return ResponseBuilder.success(
        res,
        'Cart fetched successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }

  static async addItem(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await cartService.addItem(userId, req.body);

      return ResponseBuilder.success(
        res,
        'Item added to cart successfully',
        result,
        201,
      );
    } catch (error) {
      next(error);
    }
  }

  static async updateItem(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await cartService.updateItem(
        userId,
        req.params['itemId'] as string,
        req.body,
      );

      return ResponseBuilder.success(
        res,
        'Cart item updated successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }

  static async removeItem(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await cartService.removeItem(userId, req.params['itemId'] as string);

      return ResponseBuilder.success(
        res,
        'Cart item removed successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }
}