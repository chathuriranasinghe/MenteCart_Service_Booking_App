import app from './app';
import { connectDatabase } from './config/database.config';
import { envConfig } from './config/env.config';
import { logger } from './config/logger.config';

const startServer = async (): Promise<void> => {
  await connectDatabase();

  app.listen(Number(envConfig.port), '0.0.0.0', () => {
    logger.info(
      {
        port: envConfig.port,
      },
      'Server started successfully',
    );
  });
};

startServer();