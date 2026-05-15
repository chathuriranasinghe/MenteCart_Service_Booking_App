import { Router } from 'express';

import { validate } from '../../middlewares/validate.middleware';
import { ServiceController } from './service.controller';
import {
  getServiceByIdSchema,
  getServicesSchema,
} from './service.validation';

const router = Router();

router.get('/', validate(getServicesSchema), ServiceController.getServices);
router.get(
  '/:id',
  validate(getServiceByIdSchema),
  ServiceController.getServiceById,
);

export default router;