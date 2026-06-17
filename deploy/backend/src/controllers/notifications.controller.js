import { getDBPool } from '../config/db.js';
import { success, error } from '../utils/response.js';

export const getAllNotifications = async (req, res) => {
    try {
        const db = await getDBPool();
        const { is_read, _page, _limit } = req.query;
        const page = parseInt(_page) || 1;
        const limit = parseInt(_limit) || 20;
        const offset = (page - 1) * limit;
        
        let query = 'SELECT * FROM notifications';
        let countQuery = 'SELECT COUNT(*) as total FROM notifications';
        let params = [];
        
        if (is_read !== undefined) { 
            query += ' WHERE is_read = ?'; 
            countQuery += ' WHERE is_read = ?'; 
            params.push(is_read === 'true' ? 1 : 0); 
        }
        
        const countResult = await db.query(countQuery, params);
        query += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
        const rows = await db.query(query, [...params, limit, offset]);
        const total = countResult[0]?.total || 0;
        
        res.setHeader('X-Total-Count', total);
        res.json({ success: true, data: rows, total });
    } catch (err) { return error(res, 'Gagal mengambil notifikasi', 500); }
};

export const getMyNotifications = async (req, res) => {
    try {
        const db = await getDBPool();
        const rows = await db.query(
            'SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 50',
            [req.user.id]
        );
        const unread = await db.query(
            'SELECT COUNT(*) as count FROM notifications WHERE user_id = ? AND is_read = 0',
            [req.user.id]
        );
        return success(res, { notifications: rows, unread_count: unread[0]?.count || 0 }, 'Notifikasi berhasil diambil');
    } catch (err) { return error(res, 'Gagal mengambil notifikasi', 500); }
};

export const markAsRead = async (req, res) => {
    try {
        const db = await getDBPool();
        await db.query('UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?', [req.params.id, req.user.id]);
        return success(res, null, 'Notifikasi ditandai sudah dibaca');
    } catch (err) { return error(res, 'Gagal memperbarui notifikasi', 500); }
};

export const markAllAsRead = async (req, res) => {
    try {
        const db = await getDBPool();
        await db.query('UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0', [req.user.id]);
        return success(res, null, 'Semua notifikasi ditandai sudah dibaca');
    } catch (err) { return error(res, 'Gagal memperbarui notifikasi', 500); }
};

export const deleteNotification = async (req, res) => {
    try {
        const db = await getDBPool();
        await db.query('DELETE FROM notifications WHERE id = ?', [req.params.id]);
        return success(res, null, 'Notifikasi berhasil dihapus');
    } catch (err) { return error(res, 'Gagal menghapus notifikasi', 500); }
};

export const sendNotification = async (req, res) => {
    try {
        const { user_id, title, message, type } = req.body;
        if (!user_id || !title || !message) return error(res, 'user_id, title, dan message wajib diisi', 400);
        const db = await getDBPool();
        await db.query(
            'INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, ?)',
            [user_id, title, message, type || 'system']
        );
        return success(res, null, 'Notifikasi berhasil dikirim', 201);
    } catch (err) { return error(res, 'Gagal mengirim notifikasi', 500); }
};
