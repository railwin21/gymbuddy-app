import { getDBPool } from '../config/db.js';
import { success, error } from '../utils/response.js';
import Midtrans from 'midtrans-client';
import cache from '../utils/cache.js';

// Inisialisasi Midtrans Snap
const snap = new Midtrans.Snap({
    isProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true',
    serverKey: process.env.MIDTRANS_SERVER_KEY,
    clientKey: process.env.MIDTRANS_CLIENT_KEY
});

// Inisialisasi Midtrans Core API (untuk notifikasi)
const core = new Midtrans.CoreApi({
    isProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true',
    serverKey: process.env.MIDTRANS_SERVER_KEY,
    clientKey: process.env.MIDTRANS_CLIENT_KEY
});

/**
 * Membuat transaksi pembayaran untuk booking
 * POST /api/payments/create
 * Body: { booking_id }
 */
export const createPayment = async (req, res) => {
    try {
        const { booking_id } = req.body;
        const member_id = req.user.id;

        if (!booking_id) {
            return error(res, 'booking_id wajib diisi', 400);
        }

        const db = await getDBPool();

        // Ambil data booking + sesi
        const [booking] = await db.query(
            `SELECT b.*, s.title, s.price, u.nama as member_name, u.email as member_email
             FROM booking b
             JOIN session s ON b.session_id = s.id
             JOIN user u ON b.member_id = u.id
             WHERE b.id = ? AND b.member_id = ?`,
            [booking_id, member_id]
        );

        if (!booking) {
            return error(res, 'Booking tidak ditemukan', 404);
        }

        if (booking.status !== 'Pending') {
            return error(res, 'Booking sudah diproses atau dibatalkan', 400);
        }

        if (booking.payment_status === 'settlement') {
            return error(res, 'Booking ini sudah dibayar', 400);
        }

        const grossAmount = Number(booking.price) || 0;
        if (grossAmount <= 0) {
            return error(res, 'Harga sesi tidak valid', 400);
        }

        // Buat order_id unik
        const orderId = `GB-${booking_id}-${Date.now()}`;

        // Parameter untuk Midtrans Snap
        const parameter = {
            transaction_details: {
                order_id: orderId,
                gross_amount: grossAmount
            },
            customer_details: {
                first_name: booking.member_name || 'Member',
                email: booking.member_email || 'member@gymbuddy.site'
            },
            item_details: [{
                id: `SESSION-${booking.session_id}`,
                price: grossAmount,
                quantity: 1,
                name: booking.title || 'Sesi Latihan'
            }],
            callbacks: {
                finish: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/dashboard/my-bookings`,
                error: `${process.env.FRONTEND_URL || 'http://localhost:5173'}/dashboard/my-bookings`
            }
        };

        // Buat transaksi di Midtrans
        const transaction = await snap.createTransaction(parameter);

        // Simpan order_id dan snap token ke booking
        await db.query(
            'UPDATE booking SET midtrans_order_id = ?, midtrans_token = ?, payment_amount = ? WHERE id = ?',
            [orderId, transaction.token, grossAmount, booking_id]
        );

        return success(res, {
            token: transaction.token,
            redirect_url: transaction.redirect_url,
            order_id: orderId
        }, 'Pembayaran berhasil dibuat', 201);

    } catch (err) {
        console.error('Create payment error:', err);
        return error(res, 'Gagal membuat pembayaran', 500);
    }
};

/**
 * Webhook dari Midtrans untuk notifikasi status pembayaran
 * POST /api/payments/notification
 */
export const handleNotification = async (req, res) => {
    try {
        const notificationJson = req.body;

        // Verifikasi notifikasi menggunakan Midtrans library
        const statusResponse = await core.transaction.notification(notificationJson);

        const orderId = statusResponse.order_id;
        const transactionStatus = statusResponse.transaction_status;
        const fraudStatus = statusResponse.fraud_status;
        const paymentType = statusResponse.payment_type;
        const transactionTime = statusResponse.transaction_time;

        console.log(`[Payment] Notification received: ${orderId} -> ${transactionStatus}`);

        // Cari booking berdasarkan order_id
        const db = await getDBPool();
        const [booking] = await db.query(
            'SELECT id, member_id, status, payment_status FROM booking WHERE midtrans_order_id = ?',
            [orderId]
        );

        if (!booking) {
            console.warn(`[Payment] Booking not found for order: ${orderId}`);
            return res.status(404).json({ message: 'Booking tidak ditemukan' });
        }

        let bookingStatus = booking.status;
        let paymentStatus = 'pending';

        // Mapping status Midtrans ke status booking
        if (transactionStatus === 'capture') {
            if (fraudStatus === 'accept') {
                // Pembayaran sukses via kartu kredit
                bookingStatus = 'Confirmed';
                paymentStatus = 'settlement';
            }
        } else if (transactionStatus === 'settlement') {
            // Pembayaran sukses
            bookingStatus = 'Confirmed';
            paymentStatus = 'settlement';
        } else if (transactionStatus === 'pending') {
            // Menunggu pembayaran
            bookingStatus = 'Pending';
            paymentStatus = 'pending';
        } else if (['deny', 'cancel', 'expire'].includes(transactionStatus)) {
            // Pembayaran gagal / dibatalkan / kadaluarsa
            bookingStatus = 'Cancel';
            paymentStatus = transactionStatus;
        }

        // Update database
        await db.query(
            `UPDATE booking 
             SET status = ?, payment_status = ?, payment_method = ?, payment_date = NOW()
             WHERE id = ?`,
            [bookingStatus, paymentStatus, paymentType, booking.id]
        );

        // Buat notifikasi untuk user jika member_id tersedia
        if (booking.member_id) {
            const notificationTitle = paymentStatus === 'settlement' 
                ? 'Pembayaran Berhasil' 
                : 'Pembayaran Gagal';
            const notificationMessage = paymentStatus === 'settlement'
                ? `Pembayaran untuk booking #${booking.id} telah berhasil dikonfirmasi. Sesi Anda siap!`
                : `Pembayaran untuk booking #${booking.id} ${transactionStatus}. Silakan coba lagi.`;

            await db.query(
                `INSERT INTO notifications (user_id, title, message, type) VALUES (?, ?, ?, ?)`,
                [booking.member_id, notificationTitle, notificationMessage, 'payment']
            );
        }

        // Hapus cache terkait
        cache.del('all_bookings');
        cache.del(`customer_booking_history_${booking.member_id}`);

        return res.status(200).json({ 
            success: true, 
            message: 'Notifikasi diterima',
            order_id: orderId,
            transaction_status: transactionStatus,
            booking_status: bookingStatus,
            payment_status: paymentStatus
        });

    } catch (err) {
        console.error('Handle notification error:', err);
        return res.status(500).json({ message: 'Gagal memproses notifikasi' });
    }
};

/**
 * Cek status pembayaran berdasarkan booking_id
 * GET /api/payments/:booking_id/status
 */
export const checkPaymentStatus = async (req, res) => {
    try {
        const { booking_id } = req.params;
        const member_id = req.user.id;

        const db = await getDBPool();
        const [booking] = await db.query(
            `SELECT id, midtrans_order_id, payment_status, payment_method, payment_amount, payment_date, status
             FROM booking WHERE id = ? AND member_id = ?`,
            [booking_id, member_id]
        );

        if (!booking) {
            return error(res, 'Booking tidak ditemukan', 404);
        }

        // Jika ada order_id di Midtrans, cek status langsung
        if (booking.midtrans_order_id) {
            try {
                const statusResponse = await snap.transaction.status(booking.midtrans_order_id);
                
                // Update status jika ada perubahan
                if (statusResponse.transaction_status !== booking.payment_status) {
                    let newPaymentStatus = statusResponse.transaction_status;
                    let newBookingStatus = booking.status;

                    if (['settlement', 'capture'].includes(statusResponse.transaction_status)) {
                        newBookingStatus = 'Confirmed';
                        newPaymentStatus = 'settlement';
                    } else if (['deny', 'cancel', 'expire'].includes(statusResponse.transaction_status)) {
                        newBookingStatus = 'Cancel';
                    }

                    await db.query(
                        'UPDATE booking SET status = ?, payment_status = ? WHERE id = ?',
                        [newBookingStatus, newPaymentStatus, booking.id]
                    );

                    booking.status = newBookingStatus;
                    booking.payment_status = newPaymentStatus;
                }

                return success(res, {
                    ...booking,
                    midtrans_status: statusResponse.transaction_status,
                    midtrans_fraud_status: statusResponse.fraud_status
                }, 'Status pembayaran berhasil diambil');

            } catch (midtransErr) {
                // Jika error dari Midtrans, tetap kirim data lokal
                console.warn('Midtrans status check error:', midtransErr.message);
            }
        }

        return success(res, booking, 'Status pembayaran berhasil diambil');

    } catch (err) {
        console.error('Check payment status error:', err);
        return error(res, 'Gagal mengecek status pembayaran', 500);
    }
};

/**
 * Mendapatkan client key untuk frontend Snap
 * GET /api/payments/config
 */
export const getPaymentConfig = async (req, res) => {
    return success(res, {
        clientKey: process.env.MIDTRANS_CLIENT_KEY,
        isProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true'
    }, 'Konfigurasi pembayaran berhasil diambil');
};
