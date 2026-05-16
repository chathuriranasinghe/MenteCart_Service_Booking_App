import mongoose from 'mongoose';

import { envConfig } from './env.config';
import { logger } from './logger.config';

export const connectDatabase = async (): Promise<void> => {
  try {
    if (!envConfig.mongoUri) {
      throw new Error('MONGO_URI is missing in .env file');
    }

    await mongoose.connect(envConfig.mongoUri);

    logger.info('MongoDB connected successfully');
  } catch (error) {
    logger.error(
      {
        error,
      },
      'MongoDB connection failed',
    );

    process.exit(1);
  }
};