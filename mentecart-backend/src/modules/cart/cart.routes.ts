import { Router } from 'express';

import { authMiddleware } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { CartController } from './cart.controller';
import {
  addCartItemSchema,
  cartItemIdSchema,
  updateCartItemSchema,
} from './cart.validation';

const router = Router();

router.use(authMiddleware);

router.get('/', CartController.getCart);

router.post(
  '/items',
  validate(addCartItemSchema),
  CartController.addItem,
);

router.patch(
  '/items/:itemId',
  validate(updateCartItemSchema),
  CartController.updateItem,
);

router.delete(
  '/items/:itemId',
  validate(cartItemIdSchema),
  CartController.removeItem,
);

export default router;