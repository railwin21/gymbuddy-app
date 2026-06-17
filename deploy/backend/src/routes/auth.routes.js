import express from 'express';
import { login, getMe, registerUser, registerTrainer, registerAdmin } from '../controllers/auth.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

// Public routes
router.post('/login', login);
router.post('/register', registerUser);
router.post('/register/trainer', registerTrainer);

// Protected routes
router.get('/me', authMiddleware, getMe);
router.post('/register/admin', authMiddleware, adminReq, registerAdmin);

export default router;
