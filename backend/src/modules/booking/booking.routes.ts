import { Router } from 'express';
import { validate } from '../../middleware/validate';
import { authMiddleware } from '../../middleware/auth';
import { requireRole } from '../../middleware/role';
import {
    createBookingSchema,
    updateBookingStatusSchema,
    listBookingsQuerySchema,
    idParamSchema,
} from './booking.schema';
import {
    listBookingsController,
    getMyBookingsController,
    getBookingByIdController,
    createBookingController,
    updateBookingStatusController,
} from './booking.controller';

const router = Router();

router.get('/', authMiddleware, requireRole('admin'), validate(listBookingsQuerySchema), listBookingsController);
router.get('/my', authMiddleware, getMyBookingsController);
router.get('/:id', authMiddleware, validate(idParamSchema), getBookingByIdController);
router.post('/', authMiddleware, requireRole('customer', 'admin'), validate(createBookingSchema), createBookingController);
router.patch('/:id/status', authMiddleware, requireRole('trainer', 'admin'), validate(idParamSchema), validate(updateBookingStatusSchema), updateBookingStatusController);

export default router;
