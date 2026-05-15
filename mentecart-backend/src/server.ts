import app from './app';
import { connectDatabase } from './config/database.config';
import { envConfig } from './config/env.config';

const startServer = async (): Promise<void> => {
  await connectDatabase();

  app.listen(envConfig.port, () => {
    console.log(`Server is running on port ${envConfig.port}`);
  });
};

startServer();