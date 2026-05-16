import { Types } from 'mongoose';

import { UserDocument, UserModel } from '../auth/user.model';
import { UpdateProfileDto } from './profile.dto';

export class ProfileRepository {
  async findByUserId(userId: string): Promise<UserDocument | null> {
    return UserModel.findById(new Types.ObjectId(userId));
  }

  async updateProfile(
    userId: string,
    payload: UpdateProfileDto,
  ): Promise<UserDocument | null> {
    return UserModel.findByIdAndUpdate(
      new Types.ObjectId(userId),
      { $set: payload },
      { new: true, runValidators: true },
    );
  }
}
