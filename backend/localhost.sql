-- Database: gymbuddy_database_1
-- Schema terbaru dengan single user table untuk semua role

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

DROP DATABASE IF EXISTS `gymbuddy_database_1`;
CREATE DATABASE IF NOT EXISTS `gymbuddy_database_1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `gymbuddy_database_1`;

-- ============================================================
-- TABEL: user (menampung semua role: customer, trainer, admin)
-- ============================================================
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('customer','trainer','admin') NOT NULL DEFAULT 'customer',
  `jenis_kelamin` enum('L','P') DEFAULT NULL,
  `no_telp` varchar(20) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `propinsi` varchar(45) DEFAULT '',
  `kota` varchar(45) DEFAULT '',
  `spesialisasi` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_kota` (`kota`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: session (sesi latihan)
-- ============================================================
CREATE TABLE `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `trainer_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `status` enum('scheduled','ongoing','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  `max_participants` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `session_ibfk_trainer` (`trainer_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_trainer_start` (`trainer_id`,`start_time`),
  CONSTRAINT `session_ibfk_trainer` FOREIGN KEY (`trainer_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: booking (pemesanan sesi)
-- ============================================================
CREATE TABLE `booking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `status` enum('Pending','Confirmed','Completed','Cancel') NOT NULL DEFAULT 'Pending',
  `payment_status` enum('pending','settlement','cancel','expire') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_amount` decimal(10,2) DEFAULT 0.00,
  `payment_date` datetime DEFAULT NULL,
  `midtrans_transaction_id` varchar(100) DEFAULT NULL,
  `midtrans_order_id` varchar(100) DEFAULT NULL,
  `midtrans_token` text DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `datetime_created` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_booking` (`session_id`,`member_id`),
  KEY `member_id` (`member_id`),
  KEY `idx_status` (`status`),
  KEY `idx_payment_status` (`payment_status`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: progress (progress latihan harian)
-- ============================================================
CREATE TABLE `progress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `booking_id` int(11) DEFAULT NULL,
  `activity` varchar(100) NOT NULL,
  `duration` int(11) NOT NULL COMMENT 'durasi dalam menit',
  `note` text DEFAULT NULL,
  `recorded_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  KEY `progress_ibfk_booking` (`booking_id`),
  CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user` (`id`),
  CONSTRAINT `progress_ibfk_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: body_progress (berat badan, tinggi, BMI, body fat, foto)
-- ============================================================
CREATE TABLE `body_progress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `berat_badan` decimal(5,2) DEFAULT NULL COMMENT 'kg',
  `tinggi_badan` decimal(5,2) DEFAULT NULL COMMENT 'cm',
  `bmi` decimal(4,2) DEFAULT NULL,
  `body_fat` decimal(4,1) DEFAULT NULL COMMENT 'persen',
  `target_berat` decimal(5,2) DEFAULT NULL,
  `foto_before` varchar(255) DEFAULT NULL,
  `foto_after` varchar(255) DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `recorded_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `body_progress_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: reviews (rating dan review)
-- ============================================================
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `rating_score` tinyint(4) NOT NULL CHECK (`rating_score` between 1 and 5),
  `comment` text DEFAULT NULL,
  `datetime_created` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `member_id` (`member_id`),
  KEY `idx_rating` (`rating_score`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: notifications (notifikasi in-app)
-- ============================================================
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('booking','payment','progress','promo','system') DEFAULT 'system',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: articles (artikel)
-- ============================================================
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `content` longtext DEFAULT NULL,
  `excerpt` text DEFAULT NULL,
  `kategori` enum('Diet','Bulking','Cutting','Workout','Motivasi') DEFAULT 'Workout',
  `author_id` int(11) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT 0,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `kategori` (`kategori`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: promo (promo, voucher, diskon)
-- ============================================================
CREATE TABLE `promo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kode` varchar(50) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `tipe` enum('persen','nominal') DEFAULT 'nominal',
  `nilai` decimal(10,2) NOT NULL COMMENT 'jumlah diskon atau persen',
  `min_booking` int(11) DEFAULT 1,
  `maks_diskon` decimal(10,2) DEFAULT NULL,
  `kuota` int(11) DEFAULT NULL,
  `terpakai` int(11) DEFAULT 0,
  `tanggal_mulai` datetime DEFAULT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode` (`kode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: banners (banner halaman utama)
-- ============================================================
CREATE TABLE `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `judul` varchar(200) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `gambar` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `urutan` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: faq (pertanyaan umum)
-- ============================================================
CREATE TABLE `faq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pertanyaan` text NOT NULL,
  `jawaban` longtext NOT NULL,
  `kategori` varchar(50) DEFAULT 'umum',
  `urutan` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: reminders (pengingat jadwal)
-- ============================================================
CREATE TABLE `reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `tipe` enum('latihan','minum','makan','tidur','custom') DEFAULT 'latihan',
  `waktu` time DEFAULT NULL,
  `hari` varchar(50) DEFAULT NULL COMMENT 'JSON array hari: [\"senin\",\"rabu\"]',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reminders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABEL: diet_programs (program diet)
-- ============================================================
CREATE TABLE `diet_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tipe` enum('bulking','cutting','maintenance') NOT NULL,
  `target_kalori` int(11) DEFAULT NULL,
  `target_protein` int(11) DEFAULT NULL COMMENT 'gram',
  `target_karbohidrat` int(11) DEFAULT NULL COMMENT 'gram',
  `target_lemak` int(11) DEFAULT NULL COMMENT 'gram',
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `catatan` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `diet_programs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- SEED DATA: Admin default
-- ============================================================
INSERT INTO `user` (`nama`, `email`, `password`, `role`, `jenis_kelamin`, `no_telp`, `kota`, `spesialisasi`, `bio`) VALUES
('Admin GymBuddy', 'admin@gmail.com', '$2b$10$8U5ecdrkOX6RpJ04X.E4LOV7VZDEVvtjzyFG1GHv20dVEGjbYHPDS', 'admin', 'L', '081234567890', 'Purwokerto', NULL, 'Admin Platform GymBuddy'),
('Fadhel Setiawan', 'fadhel@gmail.com', '$2b$10$doLA4P.QxJoB6u.X2aY7Z..Ld1TrWYFd0pn.Vs1Xu7Il3Fqyw1/wm', 'trainer', 'L', '081234567893', 'Purwokerto', 'Hypertrophy Coach', 'Spesialis pembentukan otot dan program hypertrophy untuk hasil maksimal'),
('Arif Rachman', 'arif@gmail.com', '$2b$10$doLA4P.QxJoB6u.X2aY7Z..Ld1TrWYFd0pn.Vs1Xu7Il3Fqyw1/wm', 'trainer', 'L', '081234567894', 'Purwokerto', 'Lose Weight Coach', 'Ahli program penurunan berat badan dengan pendekatan ilmiah dan terukur'),
('Gusti Caesar Yuliawan', 'gusti@gmail.com', '$2b$10$doLA4P.QxJoB6u.X2aY7Z..Ld1TrWYFd0pn.Vs1Xu7Il3Fqyw1/wm', 'trainer', 'L', '081234567895', 'Purwokerto', 'Strength Coach', 'Pelatih strength training profesional dengan pengalaman lebih dari 5 tahun'),
('Siti Rahmawati', 'user@gmail.com', '$2b$10$GtJBBDGfoRkW3JdlF6AY.ufoZcWfv/FMwW1zV3Uk/4oy5ZKdTbQai', 'customer', 'P', '081234567892', 'Purwokerto', NULL, 'Member GymBuddy');

-- ============================================================
-- SEED DATA: FAQ default
-- ============================================================
INSERT INTO `faq` (`pertanyaan`, `jawaban`, `kategori`, `urutan`) VALUES
('Bagaimana cara memesan personal trainer?', 'Anda bisa login ke akun, lalu pilih menu \"Cari Trainer\", pilih trainer yang diinginkan, dan klik \"Ambil Sesi\".', 'booking', 1),
('Bagaimana cara membatalkan booking?', 'Anda bisa membatalkan booking di menu \"Booking Saya\" selama status masih \"Pending\".', 'booking', 2),
('Apa saja metode pembayaran yang tersedia?', 'Kami menerima pembayaran melalui GoPay, OVO, DANA, Bank Transfer, dan Kartu Kredit melalui Midtrans.', 'pembayaran', 3),
('Bagaimana cara menjadi trainer?', 'Silakan daftar dengan memilih role \"Trainer\" pada halaman registrasi. Admin akan memverifikasi akun Anda.', 'akun', 4);

-- ============================================================
-- SEED DATA: Artikel default
-- ============================================================
INSERT INTO `articles` (`title`, `slug`, `content`, `excerpt`, `kategori`, `is_published`, `published_at`) VALUES
('Panduan Bulking untuk Pemula', 'panduan-bulking-pemula', 'Bulking adalah fase menambah massa otot dengan cara meningkatkan asupan kalori...', 'Panduan lengkap bulking untuk pemula yang ingin membentuk otot.', 'Bulking', 1, NOW()),
('Tips Cutting yang Efektif', 'tips-cutting-efektif', 'Cutting adalah fase membakar lemak sambil mempertahankan massa otot...', 'Tips cutting yang efektif untuk mendapatkan body goals.', 'Cutting', 1, NOW()),
('5 Gerakan Workout Terbaik', '5-gerakan-workout-terbaik', 'Berikut adalah 5 gerakan workout terbaik yang wajib Anda coba...', 'Gerakan workout terbaik untuk hasil maksimal.', 'Workout', 1, NOW());

-- ============================================================
-- SEED DATA: Promo default
-- ============================================================
INSERT INTO `promo` (`kode`, `judul`, `deskripsi`, `tipe`, `nilai`, `min_booking`, `is_active`) VALUES
('WELCOME10', 'Diskon Member Baru', 'Diskon 10% untuk booking pertama Anda', 'persen', 10.00, 1, 1),
('FREEPASS', 'Free Session', 'Gratis 1 sesi untuk setiap 5 booking', 'nominal', 50000.00, 5, 1);

-- ============================================================
-- SEED DATA: Sample session (trainer_id=2 = Ahmad Fauzi)
-- ============================================================
INSERT INTO `session` (`title`, `deskripsi`, `trainer_id`, `start_time`, `end_time`, `price`, `status`, `max_participants`) VALUES
('Private Gym Training', 'Sesi latihan pribadi 1-on-1 dengan trainer profesional. Cocok untuk pemula maupun lanjutan.', 2, DATE_ADD(NOW(), INTERVAL 1 DAY), NOW() + INTERVAL 1 DAY + INTERVAL 1 HOUR, 75000.00, 'scheduled', 1),
('Yoga & Fleksibilitas', 'Latihan yoga untuk meningkatkan fleksibilitas dan kekuatan inti tubuh.', 2, DATE_ADD(NOW(), INTERVAL 3 DAY), NOW() + INTERVAL 3 DAY + INTERVAL 1 HOUR, 50000.00, 'scheduled', 5),

-- Sesi untuk Fadhel Setiawan (trainer_id=3)
('Hypertrophy Program', 'Program hypertrophy intensif untuk membangun massa otot maksimal. Cocok untuk intermediate hingga advanced.', 3, DATE_ADD(NOW(), INTERVAL 2 DAY), NOW() + INTERVAL 2 DAY + INTERVAL 1 HOUR, 100000.00, 'scheduled', 1),
('Arms & Shoulders Day', 'Fokus pada pembentukan lengan dan bahu dengan teknik isolasi terbaik.', 3, DATE_ADD(NOW(), INTERVAL 4 DAY), NOW() + INTERVAL 4 DAY + INTERVAL 1 HOUR, 85000.00, 'scheduled', 1),

-- Sesi untuk Arif Rachman (trainer_id=4)
('Weight Loss Bootcamp', 'Program penurunan berat badan intensif dengan HIIT dan cardio terstruktur.', 4, NOW() + INTERVAL 1 DAY + INTERVAL 2 HOUR, NOW() + INTERVAL 1 DAY + INTERVAL 3 HOUR, 90000.00, 'scheduled', 5),
('Fat Burning Circuit', 'Latihan sirkuit pembakaran lemak full-body. Efektif untuk menurunkan berat badan.', 4, DATE_ADD(NOW(), INTERVAL 5 DAY), NOW() + INTERVAL 5 DAY + INTERVAL 1 HOUR, 80000.00, 'scheduled', 3),

-- Sesi untuk Gusti Caesar (trainer_id=5)
('Strength Foundation', 'Program dasar strength training untuk membangun kekuatan fundamental.', 5, NOW() + INTERVAL 3 DAY + INTERVAL 2 HOUR, NOW() + INTERVAL 3 DAY + INTERVAL 3 HOUR, 95000.00, 'scheduled', 1),
('Powerlifting Prep', 'Persiapan teknik powerlifting: squat, bench press, deadlift dengan koreksi form detail.', 5, DATE_ADD(NOW(), INTERVAL 6 DAY), NOW() + INTERVAL 6 DAY + INTERVAL 2 HOUR, 120000.00, 'scheduled', 1);

-- ============================================================
-- VIEWS (untuk memudahkan query)
-- ============================================================

-- View: customer_booking_history
CREATE VIEW `customer_booking_history` AS
SELECT b.id as booking_id, s.title as session_title, s.start_time, s.end_time,
       u.nama as customer_name, u.id as customer_id,
       tr.nama as trainer_name, b.status, b.datetime_created as booked_on
FROM booking b
JOIN session s ON b.session_id = s.id
JOIN user u ON b.member_id = u.id
JOIN user tr ON s.trainer_id = tr.id
ORDER BY b.datetime_created DESC;

-- View: matched_trainer_customer
CREATE VIEW `matched_trainer_customer` AS
SELECT b.id as booking_id, s.id as session_id, s.title as session_title, s.start_time,
       tr.id as trainer_id, tr.nama as trainer_name, tr.email as trainer_email,
       u.id as customer_id, u.nama as customer_name, u.email as customer_email,
       b.status, b.datetime_created
FROM booking b
JOIN session s ON b.session_id = s.id
JOIN user tr ON s.trainer_id = tr.id
JOIN user u ON b.member_id = u.id
WHERE b.status = 'Confirmed';

-- View: trainer_schedule
CREATE VIEW `trainer_schedule` AS
SELECT s.*, tr.nama as trainer_name,
    (SELECT COUNT(*) FROM booking b WHERE b.session_id = s.id AND b.status = 'Confirmed') as confirmed_customers
FROM session s
JOIN user tr ON s.trainer_id = tr.id
WHERE tr.role = 'trainer'
ORDER BY s.start_time ASC;

COMMIT;
