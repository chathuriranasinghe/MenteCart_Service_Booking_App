import express, { Router } from 'express';
import { authMiddleware } from '../../middlewares/auth.middleware';
import { PayhereController } from './payhere.controller';

const router = Router();

/**
 * Webhook — uses urlencoded body parser (raw, not JSON).
 * Must NOT use express.json() here; PayHere posts form-encoded data.
 */
router.post(
  '/webhook',
  express.urlencoded({ extended: false }),
  PayhereController.webhook,
);

/**
 * Hash generation — requires auth so only the booking owner can get params.
 */
router.get('/hash', authMiddleware, PayhereController.getCheckoutParams);

export default router;
