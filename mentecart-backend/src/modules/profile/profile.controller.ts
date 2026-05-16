import { NextFunction, Response } from 'express';

import { ResponseBuilder } from '../../core/utils/response-builder';
import { AuthRequest } from '../../middlewares/auth.middleware';
import { ProfileRepository } from './profile.repository';
import { ProfileService } from './profile.service';

const profileRepository = new ProfileRepository();
const profileService = new ProfileService(profileRepository);

export class ProfileController {
  static async getProfile(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await profileService.getProfile(userId);

      return ResponseBuilder.success(res, 'Profile fetched successfully', result);
    } catch (error) {
      next(error);
    }
  }

  static async updateProfile(
    req: AuthRequest,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        throw new Error('Authenticated user not found');
      }

      const result = await profileService.updateProfile(userId, req.body);

      return ResponseBuilder.success(res, 'Profile updated successfully', result);
    } catch (error) {
      next(error);
    }
  }
}
