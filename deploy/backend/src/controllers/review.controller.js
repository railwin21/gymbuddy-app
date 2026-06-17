import {getDBPool} from '../config/db.js';
import {success, error} from '../utils/response.js';
import cache from '../utils/cache.js';

export const getAllReviews = async (req, res) => {
    try {
        const db = await getDBPool();
        const rows = await db.query(
            `SELECT r.id, r.session_id, r.member_id, r.rating_score, r.comment, r.datetime_created,
                    u.nama as member_name, s.title as session_title
             FROM reviews r
             JOIN user u ON r.member_id = u.id
             JOIN session s ON r.session_id = s.id`
        );
        return success(res, rows, 'Semua review berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const getSessionReviews = async (req, res) => {
    try {
        const {session_id} = req.params;
        const db = await getDBPool();
        const rows = await db.query(
            `SELECT r.id, r.rating_score, r.comment, r.datetime_created,
                    u.nama as member_name
             FROM reviews r
             JOIN user u ON r.member_id = u.id
             WHERE r.session_id = ?`,
            [session_id]
        );
        return success(res, rows, 'Review sesi berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const createReview = async (req, res) => {
    try {
        const {session_id, rating_score, comment} = req.body;
        const member_id = req.user.id;

        if (req.user.role !== 'customer') {
            return error(res, 'Hanya customer yang bisa memberikan review', 403);
        }

        if (!session_id || !rating_score) {
            return error(res, 'Session_id dan rating_score wajib diisi', 400);
        }

        if (rating_score < 1 || rating_score > 5) {
            return error(res, 'Rating harus antara 1-5', 400);
        }

        const db = await getDBPool();

        const booking = await db.query(
            `SELECT id FROM booking
             WHERE session_id = ? AND member_id = ? AND status = 'Confirmed'`,
            [session_id, member_id]
        );
        if (booking.length === 0) {
            return error(res, 'Anda hanya bisa mereview sesi yang sudah dihadiri', 400);
        }

        const existingReview = await db.query(
            'SELECT id FROM reviews WHERE session_id = ? AND member_id = ?',
            [session_id, member_id]
        );
        if (existingReview.length > 0) {
            return error(res, 'Anda sudah mereview sesi ini', 400);
        }

        const result = await db.query(
            'INSERT INTO reviews (session_id, member_id, rating_score, comment) VALUES (?, ?, ?, ?)',
            [session_id, member_id, rating_score, comment || null]
        );

        return success(res, {id: Number(result.insertId)}, 'Review berhasil dibuat', 201);
    } catch (err) {
        console.error('Create review error:', err);
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const updateReview = async (req, res) => {
    try {
        const { id } = req.params;
        const { rating_score, comment } = req.body;
        const member_id = req.user.id;

        if (rating_score !== undefined && (rating_score < 1 || rating_score > 5)) {
            return error(res, 'Rating harus antara 1-5', 400);
        }

        const db = await getDBPool();

        const reviewRows = await db.query('SELECT id, member_id FROM reviews WHERE id = ?', [id]);
        if (reviewRows.length === 0) {
            return error(res, 'Review tidak ditemukan', 404);
        }

        if (req.user.role !== 'admin' && reviewRows[0].member_id !== member_id) {
            return error(res, 'Tidak memiliki izin', 403);
        }

        const fields = [];
        const values = [];

        if (rating_score !== undefined) { fields.push('rating_score = ?'); values.push(rating_score); }
        if (comment !== undefined)      { fields.push('comment = ?');      values.push(comment); }

        if (fields.length === 0) {
            return error(res, 'Tidak ada field yang diupdate', 400);
        }

        values.push(id);
        await db.query(`UPDATE reviews SET ${fields.join(', ')} WHERE id = ?`, values);

        return success(res, null, 'Review berhasil diperbarui');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const deleteReview = async (req, res) => {
    try {
        const {id} = req.params;
        const db = await getDBPool();

        const reviewRows = await db.query('SELECT member_id FROM reviews WHERE id = ?', [id]);
        if (reviewRows.length === 0) {
            return error(res, 'Review tidak ditemukan', 404);
        }

        if (req.user.role !== 'admin' && reviewRows[0].member_id !== req.user.id) {
            return error(res, 'Tidak memiliki izin', 403);
        }

        const result = await db.query('DELETE FROM reviews WHERE id = ?', [id]);
        if (result.affectedRows === 0) {
            return error(res, 'Review tidak ditemukan', 404);
        }

        return success(res, null, 'Review berhasil dihapus');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};
