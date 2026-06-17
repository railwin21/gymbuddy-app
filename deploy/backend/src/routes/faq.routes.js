import express from 'express';
import { getAllFaq, createFaq, updateFaq, deleteFaq } from '../controllers/faq.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

// Public
router.get('/', getAllFaq);

// Admin only
router.post('/', authMiddleware, adminReq, createFaq);
router.put('/:id', authMiddleware, adminReq, updateFaq);
router.delete('/:id', authMiddleware, adminReq, deleteFaq);

export default router;
