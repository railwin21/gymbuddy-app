import { Router } from 'express';
import { validate } from '../../middleware/validate';
import { authMiddleware } from '../../middleware/auth';
import { requireRole } from '../../middleware/role';
import {
    registerCustomerSchema,
    registerTrainerSchema,
    registerAdminSchema,
    loginSchema,
} from './auth.schema';
import {
    registerCustomerController,
    registerTrainerController,
    registerAdminController,
    loginController,
    getMeController,
} from './auth.controller';

const router = Router();

router.post('/register', validate(registerCustomerSchema), registerCustomerController);
router.post('/register/trainer', validate(registerTrainerSchema), registerTrainerController);
router.post('/register/admin', authMiddleware, requireRole('admin'), validate(registerAdminSchema), registerAdminController);
router.post('/login', validate(loginSchema), loginController);
router.get('/me', authMiddleware, getMeController);

export default router;
