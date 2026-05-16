import pino from 'pino';

import { envConfig } from './env.config';

export const logger = pino({
  level: envConfig.nodeEnv === 'production' ? 'info' : 'debug',

  transport:
    envConfig.nodeEnv !== 'production'
      ? {
          target: 'pino-pretty',
          options: {
            colorize: true,
            translateTime: 'SYS:standard',
            ignore: 'pid,hostname',
          },
        }
      : undefined,

  base: {
    service: 'mentecart-backend',
    environment: envConfig.nodeEnv,
  },

  timestamp: pino.stdTimeFunctions.isoTime,
});