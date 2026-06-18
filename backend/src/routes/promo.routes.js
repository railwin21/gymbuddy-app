import express from 'express';
import { getAllPromo, getPromoById, getPromoByCode, createPromo, updatePromo, deletePromo } from '../controllers/promo.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

router.get('/', authMiddleware, adminReq, getAllPromo);
router.get('/check', getPromoByCode);
router.get('/:id', authMiddleware, adminReq, getPromoById);
router.post('/', authMiddleware, adminReq, createPromo);
router.put('/:id', authMiddleware, adminReq, updatePromo);
router.delete('/:id', authMiddleware, adminReq, deletePromo);

export default router;
