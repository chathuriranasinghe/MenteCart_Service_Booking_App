import { NextFunction, Request, Response } from 'express';

import { ResponseBuilder } from '../../core/utils/response-builder';
import { ServiceQueryDto } from './service.dto';
import { ServiceRepository } from './service.repository';
import { ServiceService } from './service.service';

const serviceRepository = new ServiceRepository();
const serviceService = new ServiceService(serviceRepository);

export class ServiceController {
  static async getServices(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const query: ServiceQueryDto = {
        page: Number(req.query.page ?? 1),
        limit: Number(req.query.limit ?? 10),
        category: req.query.category as string | undefined,
        search: req.query.search as string | undefined,
      };

      const result = await serviceService.getServices(query);

      return ResponseBuilder.success(
        res,
        'Services fetched successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }

  static async getServiceById(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<Response | void> {
    try {
      const result = await serviceService.getServiceById(req.params['id'] as string);

      return ResponseBuilder.success(
        res,
        'Service details fetched successfully',
        result,
      );
    } catch (error) {
      next(error);
    }
  }
}