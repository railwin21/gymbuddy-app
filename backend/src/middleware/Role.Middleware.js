import {error} from '../utils/response.js';

export const adminReq = (req, res, next) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ success: false, message: 'Akses admin diperlukan' });
    }
    next();
};

export const trainerReq = (req, res, next) => {
    if (req.user.role !== 'trainer' && req.user.role !== 'admin') {
        return error(res, 'Tidak memiliki izin untuk aksi ini', 403);
    }
    next();
};

export const customerReq = (req, res, next) => {
    if (req.user.role !== 'customer') {
        return error(res, 'Tidak memiliki izin untuk aksi ini', 403);
    }
    next();
};
