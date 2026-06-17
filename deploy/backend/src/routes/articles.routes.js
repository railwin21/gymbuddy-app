import express from 'express';
import { getAllArticles, getArticleById, createArticle, updateArticle, deleteArticle } from '../controllers/articles.controller.js';
import { authMiddleware } from '../middleware/Auth.Middleware.js';
import { adminReq } from '../middleware/Role.Middleware.js';

const router = express.Router();

// Public: bisa akses artikel published
router.get('/', getAllArticles);
router.get('/:id', getArticleById);

// Admin only
router.post('/', authMiddleware, adminReq, createArticle);
router.put('/:id', authMiddleware, adminReq, updateArticle);
router.delete('/:id', authMiddleware, adminReq, deleteArticle);

export default router;
