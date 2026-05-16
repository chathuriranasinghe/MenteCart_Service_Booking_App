import { randomUUID } from 'crypto';
import { NextFunction, Request, Response } from 'express';
import pinoHttp from 'pino-http';

import { logger } from '../config/logger.config';

export const requestLogger = pinoHttp({
    logger,

    genReqId: (req: Request): string => {
        const existingRequestId = req.headers['x-request-id'];

        if (typeof existingRequestId === 'string' && existingRequestId.trim()) {
            return existingRequestId;
        }

        return randomUUID();
    },

    customProps: (req: Request) => ({
        requestId: req.id,
    }),

    customSuccessMessage: (req: Request, res: Response) => {
        return `${req.method} ${req.originalUrl} completed with status ${res.statusCode}`;
    },

    customErrorMessage: (req: Request, res: Response) => {
        return `${req.method} ${req.originalUrl} failed with status ${res.statusCode}`;
    },

    serializers: {
        req(req) {
            return {
                id: req.id,
                method: req.method,
                url: req.originalUrl,
                query: req.query,
                params: req.params,
                remoteAddress: req.remoteAddress,
            };
        },

        res(res) {
            return {
                statusCode: res.statusCode,
            };
        },
    },
});

export const attachRequestIdHeader = (
    req: Request,
    res: Response,
    next: NextFunction,
): void => {
    res.setHeader('x-request-id', String(req.id));
    next();
};