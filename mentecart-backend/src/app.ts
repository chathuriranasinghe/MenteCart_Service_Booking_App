import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import { errorMiddleware } from './middlewares/error.middleware';
import authRoutes from './modules/auth/auth.routes';
import serviceRoutes from './modules/services/service.routes';

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'MenteCart backend is running',
  });
});

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/services', serviceRoutes);
app.use(errorMiddleware);

export default app;