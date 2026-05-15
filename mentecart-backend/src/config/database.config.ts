import mongoose from 'mongoose';
import { envConfig } from './env.config';

export const connectDatabase = async (): Promise<void> => {
  try {
    await mongoose.connect(envConfig.mongoUri);
    console.log('MongoDB connected successfully');
  } catch (error) {
    console.error('MongoDB connection failed:', error);
    process.exit(1);
  }
};