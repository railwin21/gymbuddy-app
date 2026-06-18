import {getDBPool} from '../config/db.js';
import {success, error} from '../utils/response.js';
import cache from '../utils/cache.js';

export const getUserStats = async (req, res) => {
    try {
        const cacheKey = 'user_stats';
        const cachedData = cache.get(cacheKey);
        if (cachedData) return success(res, cachedData, 'Data dari cache');

        const db = await getDBPool();
        const [totalUsersRows, roleCounts] = await Promise.all([
            db.query('SELECT COUNT(id) as count FROM user'),
            db.query('SELECT role, COUNT(id) as count FROM user GROUP BY role')
        ]);

        const result = {
            totalUsers: totalUsersRows[0].count,
            roleDistribution: roleCounts
        };

        cache.set(cacheKey, result, 300);
        return success(res, result, 'Statistik user berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const getBookingStats = async (req, res) => {
    try {
        const cacheKey = 'booking_stats';
        const cachedData = cache.get(cacheKey);
        if (cachedData) return success(res, cachedData, 'Data dari cache');

        const db = await getDBPool();
        const [statusCounts, totalBookingsRows] = await Promise.all([
            db.query('SELECT status, COUNT(id) as count FROM booking GROUP BY status'),
            db.query('SELECT COUNT(id) as count FROM booking')
        ]);

        const result = {
            totalBookings: totalBookingsRows[0].count,
            statusDistribution: statusCounts
        };

        cache.set(cacheKey, result, 300);
        return success(res, result, 'Statistik booking berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};

export const getDashboardStats = async (req, res) => {
    try {
        const db = await getDBPool();
        const [userCount, sessionCount, bookingCount, recentBookings, recentUsers] = await Promise.all([
            db.query('SELECT COUNT(id) as count FROM user'),
            db.query('SELECT COUNT(id) as count FROM session'),
            db.query('SELECT COUNT(id) as count FROM booking'),
            db.query('SELECT b.id, b.status, b.payment_status, b.payment_amount, b.datetime_created, u.nama as member_name, s.title as session_title FROM booking b JOIN user u ON b.member_id = u.id JOIN session s ON b.session_id = s.id ORDER BY b.datetime_created DESC LIMIT 5'),
            db.query('SELECT id, nama, email, role, created_at FROM user ORDER BY created_at DESC LIMIT 5')
        ]);
        return success(res, {
            totalUsers: userCount[0]?.count || 0,
            totalSessions: sessionCount[0]?.count || 0,
            totalBookings: bookingCount[0]?.count || 0,
            recentBookings: recentBookings || [],
            recentUsers: recentUsers || []
        }, 'Data dashboard berhasil diambil');
    } catch (err) {
        return error(res, 'Gagal mengambil data dashboard', 500);
    }
};

export const getSessionStats = async (req, res) => {
    try {
        const cacheKey = 'session_stats';
        const cachedData = cache.get(cacheKey);
        if (cachedData) return success(res, cachedData, 'Data dari cache');

        const db = await getDBPool();
        const sessionStatsRows = await db.query(
            'SELECT status, COUNT(id) as total FROM session GROUP BY status'
        );

        cache.set(cacheKey, sessionStatsRows, 300);
        return success(res, sessionStatsRows, 'Statistik sesi berhasil diambil');
    } catch (err) {
        return error(res, 'Terjadi kesalahan server', 500);
    }
};
