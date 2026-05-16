import dotenv from 'dotenv';

dotenv.config();

export const envConfig = {
  port: process.env.PORT || '5000',
  mongoUri: process.env.MONGO_URI || '',
  jwtSecret: process.env.JWT_SECRET || '',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '7d',
  nodeEnv: process.env.NODE_ENV || 'development',
  payheremerchantId: process.env.PAYHERE_MERCHANT_ID || '',
  payhereMerchantSecret: process.env.PAYHERE_MERCHANT_SECRET || '',
};