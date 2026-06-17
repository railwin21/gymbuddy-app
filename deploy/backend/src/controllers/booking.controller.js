import {getDBPool} from '../config/db.js';
import {success, error} from '../utils/response.js';
import cache from '../utils/cache.js';

export const getAllBookings = async (req, res) => {
    try {
        const cacheKey = 'all_bookings';
        const cachedData = cache.get(cacheKey);
        if (cachedData) return success(res, cachedData, 'Data dari cache');

        const db = await getDBPool();
        const rows = await db.query(
            `SELECT b.id, b.session_id, b.member_id, b.status, b.payment_status, b.payment_method,
                    b.payment_amount, b.payment_date, b.midtrans_token, b.datetime_created,
                    u.nama as member_name, s.title as session_title, s.price
             FROM booking b
             JOIN user u ON b.member_id = u.id
             JOIN session s ON b.session_id = s.id`
        );

        cache.set(cacheKey, rows, 300);
        return success(res, rows, 'Semua booking berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const getBookingById = async (req, res) => {
    try {
        const {id} = req.params;
        const db = await getDBPool();
        const rows = await db.query(
            `SELECT b.id, b.session_id, b.member_id, b.status, b.payment_status, b.payment_method,
                    b.payment_amount, b.payment_date, b.midtrans_token, b.datetime_created,
                    u.nama as member_name, s.title as session_title
             FROM booking b
             JOIN user u ON b.member_id = u.id
             JOIN session s ON b.session_id = s.id
             WHERE b.id = ?`,
            [id]
        );
        if (rows.length === 0) {
            return error(res, 'Booking tidak ditemukan', 404);
        }

        const booking = rows[0];
        if (req.user.role !== 'admin' && req.user.id !== booking.member_id) {
            return error(res, 'Akses ditolak', 403);
        }

        return success(res, booking, 'Data booking berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const createBooking = async (req, res) => {
    try {
        const { session_id } = req.body;
        const member_id = req.user.id;

        if (!session_id) return error(res, 'session_id wajib diisi', 400);

        const db = await getDBPool();

        const userRows = await db.query('SELECT nama FROM user WHERE id = ?', [member_id]);
        if (userRows.length === 0) {
            return error(res, 'Member tidak ditemukan', 404);
        }

        const sessionRows = await db.query(
            `SELECT s.*, u.nama as trainer_name
             FROM session s
             JOIN user u ON s.trainer_id = u.id
             WHERE s.id = ? AND s.status NOT IN ('cancelled', 'completed')`,
            [session_id]
        );

        if (sessionRows.length === 0) {
            return error(res, 'Sesi tidak ditemukan atau tidak tersedia', 404);
        }

        const session = sessionRows[0];

        if (new Date(session.start_time) < new Date()) {
            return error(res, 'Tidak bisa booking sesi yang sudah dimulai', 400);
        }

        const existing = await db.query(
            "SELECT id FROM booking WHERE session_id = ? AND member_id = ? AND status != 'Cancel'",
            [session_id, member_id]
        );
        if (existing.length > 0) return error(res, 'Anda sudah booking sesi ini', 400);

        // Simpan booking dengan payment_amount dari harga sesi
        const result = await db.query(
            'INSERT INTO booking (session_id, member_id, status, payment_status, payment_amount) VALUES (?, ?, ?, ?, ?)',
            [session_id, member_id, 'Pending', 'pending', session.price || 0]
        );

        cache.del(`customer_booking_history_${member_id}`);
        cache.del('all_bookings');

        return success(res, { 
            id: Number(result.insertId), 
            session_title: session.title, 
            trainer_name: session.trainer_name,
            payment_amount: session.price || 0
        }, 'Booking berhasil. Silakan lanjutkan ke pembayaran.', 201);
    } catch (err) {
        console.error('Create booking error:', err);
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const updateBookingStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const validStatuses = ['Pending', 'Confirmed', 'Cancel'];

        if (!status || !validStatuses.includes(status)) {
            return error(res, 'Status tidak valid', 400);
        }

        const db = await getDBPool();

        const rows = await db.query(
            `SELECT b.*, s.trainer_id FROM booking b 
             JOIN session s ON b.session_id = s.id WHERE b.id = ?`,
            [id]
        );

        if (rows.length === 0) return error(res, 'Booking tidak ditemukan', 404);
        const booking = rows[0];

        if (req.user.role === 'customer' && (req.user.id !== booking.member_id || status !== 'Cancel')) {
            return error(res, 'Tidak memiliki izin', 403);
        }
        if (req.user.role === 'trainer' && req.user.id !== booking.trainer_id) {
            return error(res, 'Bukan sesi Anda', 403);
        }

        await db.query('UPDATE booking SET status = ? WHERE id = ?', [status, id]);

        cache.del(`customer_booking_history_${booking.member_id}`);
        cache.del('all_bookings');
        return success(res, null, 'Status berhasil diperbarui');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const getMyBookings = async (req, res) => {
    try {
        const member_id = req.user.id;
        const db = await getDBPool();

        const rows = await db.query(
            `SELECT b.id as booking_id, b.status, b.payment_status, b.payment_method,
                    b.payment_amount, b.payment_date, b.midtrans_token,
                    s.title as session_title, s.start_time, s.end_time, s.price,
                    u.nama as trainer_name
             FROM booking b
             JOIN session s ON b.session_id = s.id
             JOIN user u ON s.trainer_id = u.id
             WHERE b.member_id = ?
             ORDER BY s.start_time DESC`,
            [member_id]
        );

        return success(res, rows, 'Data booking berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};
