import bcrypt from 'bcryptjs';
import jwt, { SignOptions } from 'jsonwebtoken';

import { AppError } from '../../core/errors/app-error';
import { envConfig } from '../../config/env.config';
import {
  AuthUserResponseDto,
  LoginDto,
  LoginResponseDto,
  RegisterDto,
} from './auth.dto';
import { AuthRepository } from './auth.repository';
import { UserDocument } from './user.model';

export class AuthService {
  constructor(private readonly authRepository: AuthRepository) { }

  async register(payload: RegisterDto): Promise<AuthUserResponseDto> {
    const existingUser = await this.authRepository.findByEmail(payload.email);

    if (existingUser) {
      throw new AppError('Email is already registered', 409);
    }

    const hashedPassword = await bcrypt.hash(payload.password, 10);

    const user = await this.authRepository.createUser({
      ...payload,
      password: hashedPassword,
    });

    return this.mapUserResponse(user);
  }

  async login(payload: LoginDto): Promise<LoginResponseDto> {
    const user = await this.authRepository.findByEmail(payload.email);

    if (!user) {
      throw new AppError('Invalid email or password', 401);
    }

    const isPasswordValid = await bcrypt.compare(
      payload.password,
      user.password,
    );

    if (!isPasswordValid) {
      throw new AppError('Invalid email or password', 401);
    }

    const signOptions: SignOptions = {
      expiresIn: envConfig.jwtExpiresIn as SignOptions['expiresIn'],
    };

    const token = jwt.sign(
      {
        userId: user._id.toString(),
        email: user.email,
      },
      envConfig.jwtSecret,
      signOptions,
    );

    return {
      token,
      user: this.mapUserResponse(user),
    };
  }

  async getCurrentUser(userId: string): Promise<AuthUserResponseDto> {
    const user = await this.authRepository.findById(userId);

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return this.mapUserResponse(user);
  }

  private mapUserResponse(user: UserDocument): AuthUserResponseDto {
    return {
      id: user._id.toString(),
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
    };
  }
}