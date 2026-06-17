import express from 'express';
import { createPayment, handleNotification, checkPaymentStatus, getPaymentConfig } from '../controllers/payment.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';

const router = express.Router();

// Webhook dari Midtrans (tanpa auth karena dari server Midtrans)
router.post('/notification', handleNotification);

// Konfigurasi client key (publik, tanpa auth)
router.get('/config', getPaymentConfig);

// Routes yang perlu autentikasi
router.post('/create', authMiddleware, createPayment);
router.get('/:booking_id/status', authMiddleware, checkPaymentStatus);

export default router;
