import { Router } from 'express';

import { authMiddleware } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ProfileController } from './profile.controller';
import { updateProfileSchema } from './profile.validation';

const router = Router();

router.use(authMiddleware);

router.get('/', ProfileController.getProfile);
router.patch('/', validate(updateProfileSchema), ProfileController.updateProfile);

export default router;
