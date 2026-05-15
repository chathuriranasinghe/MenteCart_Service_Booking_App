import { NextFunction, Request, Response } from 'express';
import { ZodObject, ZodError } from 'zod';

import { ResponseBuilder } from '../core/utils/response-builder';

export const validate =
  (schema: ZodObject<any>) =>
  (req: Request, res: Response, next: NextFunction): Response | void => {
    try {
      schema.parse({
        body: req.body,
        params: req.params,
        query: req.query,
      });

      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const message = error.issues[0]?.message || 'Validation failed';
        return ResponseBuilder.error(res, message, 400);
      }

      next(error);
    }
  };