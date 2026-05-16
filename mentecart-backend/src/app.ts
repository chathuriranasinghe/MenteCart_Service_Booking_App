import cors from 'cors';
import express from 'express';
import helmet from 'helmet';

import { errorMiddleware } from './middlewares/error.middleware';
import {
  attachRequestIdHeader,
  requestLogger,
} from './middlewares/request-logger.middleware';
import authRoutes from './modules/auth/auth.routes';
import bookingRoutes from './modules/bookings/booking.routes';
import cartRoutes from './modules/cart/cart.routes';
import payhereRoutes from './modules/payhere/payhere.routes';
import profileRoutes from './modules/profile/profile.routes';
import serviceRoutes from './modules/services/service.routes';

const app = express();

app.use(cors());
app.use(helmet());

// PayHere webhook must be registered before express.json()
// because it needs urlencoded body parsing
app.use('/api/v1/payhere', payhereRoutes);

app.use(express.json());

app.use(requestLogger);
app.use(attachRequestIdHeader);

app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'MenteCart backend is running',
  });
});

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/services', serviceRoutes);
app.use('/api/v1/cart', cartRoutes);
app.use('/api/v1/bookings', bookingRoutes);
app.use('/api/v1/profile', profileRoutes);

app.use(errorMiddleware);

export default app;