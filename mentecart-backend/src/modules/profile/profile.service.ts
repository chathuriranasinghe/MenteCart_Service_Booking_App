import { UserDocument } from '../auth/user.model';
import { AppError } from '../../core/errors/app-error';
import { ProfileResponseDto, UpdateProfileDto } from './profile.dto';
import { ProfileRepository } from './profile.repository';

export class ProfileService {
  constructor(private readonly profileRepository: ProfileRepository) {}

  async getProfile(userId: string): Promise<ProfileResponseDto> {
    const user = await this.profileRepository.findByUserId(userId);

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return this.mapProfileResponse(user);
  }

  async updateProfile(userId: string, payload: UpdateProfileDto): Promise<ProfileResponseDto> {
    if (!payload.fullName && !payload.phoneNumber && !payload.address) {
      throw new AppError('At least one profile field is required', 400);
    }

    const user = await this.profileRepository.updateProfile(userId, payload);

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return this.mapProfileResponse(user);
  }

  private mapProfileResponse(user: UserDocument): ProfileResponseDto {
    return {
      id: user._id.toString(),
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      address: user.address,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }
}
