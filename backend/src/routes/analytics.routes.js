import express from 'express';
import {getUserStats, getBookingStats, getSessionStats, getDashboardStats} from '../controllers/analytics.controller.js';
import {authMiddleware} from '../middleware/Auth.Middleware.js';
import {adminReq} from '../middleware/Role.Middleware.js';

const router = express.Router();

router.get('/users', authMiddleware, adminReq, getUserStats);
router.get('/bookings', authMiddleware, adminReq, getBookingStats);
router.get('/sessions', authMiddleware, adminReq, getSessionStats);
router.get('/dashboard', authMiddleware, adminReq, getDashboardStats);

export default router;
