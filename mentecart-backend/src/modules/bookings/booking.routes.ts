import { Router } from 'express';

import { authMiddleware } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { BookingController } from './booking.controller';
import { bookingIdSchema, checkoutSchema } from './booking.validation';

const router = Router();

router.use(authMiddleware);

router.post('/checkout', validate(checkoutSchema), BookingController.checkout);
router.get('/', BookingController.getBookings);
router.get('/:id', validate(bookingIdSchema), BookingController.getBookingById);
router.post('/:id/cancel', validate(bookingIdSchema), BookingController.cancelBooking);

export default router;
