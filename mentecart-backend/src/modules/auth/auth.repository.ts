import { RegisterDto } from './auth.dto';
import { UserDocument, UserModel } from './user.model';

export class AuthRepository {
  async findByEmail(email: string): Promise<UserDocument | null> {
    return UserModel.findOne({ email }).select('+password');
  }

  async findById(userId: string): Promise<UserDocument | null> {
    return UserModel.findById(userId);
  }

  async createUser(payload: RegisterDto): Promise<UserDocument> {
    return UserModel.create(payload);
  }
}