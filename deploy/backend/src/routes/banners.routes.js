import express from 'express';
import { getAllBanners, createBanner, updateBanner, deleteBanner } from '../controllers/banners.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

// Public
router.get('/', getAllBanners);

// Admin only
router.post('/', authMiddleware, adminReq, createBanner);
router.put('/:id', authMiddleware, adminReq, updateBanner);
router.delete('/:id', authMiddleware, adminReq, deleteBanner);

export default router;
