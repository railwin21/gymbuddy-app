import express from 'express';
import { getAllNotifications, getMyNotifications, markAsRead, markAllAsRead, deleteNotification, sendNotification } from '../controllers/notifications.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

// User's own notifications
router.get('/my', authMiddleware, getMyNotifications);
router.patch('/:id/read', authMiddleware, markAsRead);
router.patch('/read-all', authMiddleware, markAllAsRead);

// Admin
router.get('/', authMiddleware, adminReq, getAllNotifications);
router.post('/send', authMiddleware, adminReq, sendNotification);
router.delete('/:id', authMiddleware, adminReq, deleteNotification);

export default router;
