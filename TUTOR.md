# 🏋️ GymBuddy — Platform Fitness Purwokerto

## 📋 Daftar Isi
1. [Tentang Aplikasi](#-tentang-aplikasi)
2. [Tech Stack & Arsitektur](#-tech-stack--arsitektur)
3. [Cara Menjalankan Aplikasi](#-cara-menjalankan-aplikasi)
4. [Cara Menggunakan](#-cara-menggunakan)
5. [Akun & Password](#-akun--password)
6. [Fitur Lengkap](#-fitur-lengkap)
7. [Struktur Project](#-struktur-project)
8. [API Endpoints](#-api-endpoints)
9. [Deployment](#-deployment)

---

## 🎯 Tentang Aplikasi

**GymBuddy** adalah platform fitness yang menghubungkan **personal trainer** dengan **member** di area **Purwokerto** dan sekitarnya. Aplikasi ini memudahkan pengguna untuk:

- **Mencari personal trainer** berdasarkan lokasi dan keahlian
- **Booking sesi latihan** secara online
- **Melakukan pembayaran** via Midtrans (kartu kredit, transfer bank, dll)
- **Melacak progress** latihan
- **Mengelola jadwal** bagi trainer

Aplikasi tersedia dalam 3 platform:
- 🌐 **Website** — Frontend Vue.js di Vercel
- 📱 **Mobile App** — Flutter (iOS & Android)
- ⚙️ **Backend API** — Node.js di Railway

---

## 🛠 Tech Stack & Arsitektur

### Arsitektur 3-Tier (Full Stack)

```
[Frontend Web] ──── HTTP/JSON ──── [Backend API] ──── SQL ──── [Database]
[Mobile App]  ──── HTTP/JSON ────  [Node.js/Express] ────  [MySQL/Aiven]
```

### Teknologi yang Digunakan

| Layer | Teknologi | Versi |
|-------|-----------|-------|
| **Frontend Web** | Vue 3 + Vite + Tailwind CSS | Vue 3.x |
| **Mobile App** | Flutter + Riverpod + GoRouter | Flutter 3.x |
| **Backend API** | Node.js + Express.js | Node 18+ |
| **Database** | MySQL (Aiven Cloud) | MySQL 8.x |
| **Payment** | Midtrans Snap (Sandbox) | — |
| **Hosting Web** | Vercel | — |
| **Hosting API** | Railway | — |
| **File Upload** | Multer (local storage) | — |
| **Caching** | In-memory cache | — |
| **Auth** | JWT (JSON Web Token) | — |

### Package Penting (Mobile/Flutter)
- `flutter_riverpod` — State management
- `go_router` — Routing & navigasi
- `dio` — HTTP client
- `cached_network_image` — Load & cache gambar
- `url_launcher` — Buka link payment
- `image_picker` — Upload foto profil
- `intl` — Format tanggal & mata uang
- `shared_preferences` — Simpan token lokal

### Package Penting (Backend)
- `express` — Web framework
- `mysql2` — Database driver
- `jsonwebtoken` — JWT auth
- `midtrans-client` — Payment gateway
- `multer` — File upload
- `bcryptjs` — Hash password

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- **Node.js** v18 atau lebih baru
- **Flutter SDK** 3.x atau lebih baru
- **Xcode** (untuk iOS simulator)
- **Android Studio** (untuk Android emulator)
- **Git**

### 1. Clone Repository

```bash
git clone https://github.com/arif200/gymbuddy-app.git
cd gymbuddy-app
```

### 2. Setup Backend

```bash
cd backend
npm install
```

Buat file `.env` di folder `backend/`:

```env
PORT=5000
DB_HOST=your-mysql-host.aivencloud.com
DB_PORT=12345
DB_USER=avnadmin
DB_PASSWORD=your-password
DB_NAME=gymbuddy

JWT_SECRET=gymbuddy_jwt_secret_key_2024

MIDTRANS_SERVER_KEY=Mid-server-your-key
MIDTRANS_CLIENT_KEY=Mid-client-your-key
MIDTRANS_IS_PRODUCTION=false

FRONTEND_URL=http://localhost:5173
```

Jalankan backend:

```bash
npm start
# atau untuk development:
npm run dev
```

Backend akan berjalan di `http://localhost:5000`.

### 3. Setup Frontend Web

```bash
cd frontend
npm install
npm run dev
```

Frontend akan berjalan di `http://localhost:5173`.

### 4. Setup Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

Atau untuk build spesifik:

```bash
# iOS Simulator
flutter run -d simulator

# Android Emulator
flutter run -d emulator-5554

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

---

## 📖 Cara Menggunakan

### Untuk Member (Pengguna Biasa)

#### 1. Registrasi & Login
1. Buka aplikasi/web di browser
2. Klik **"Daftar"** atau **"Register"**
3. Isi: Nama, Email, Password, Kota, Provinsi
4. Klik **"Daftar"**
5. Login dengan email & password yang sudah didaftarkan

#### 2. Cari Trainer & Booking
1. Setelah login, klik menu **"Cari Trainer"**
2. Lihat daftar sesi yang tersedia (dilengkapi foto trainer)
3. Klik **"Ambil Sesi"** untuk booking
4. Booking akan muncul di menu **"Booking Saya"**

#### 3. Pembayaran
1. Di menu **"Booking Saya"**, klik **"Bayar"**
2. Akan muncul halaman pembayaran dengan detail booking
3. Klik **"Bayar Sekarang via Midtrans"**
4. Pilih metode pembayaran:
   - **Kartu Kredit** (test: `4811 1111 1111 1114`, exp: kapan saja, CVV: apapun)
   - **Bank Transfer** (BCA, Mandiri, BRI, dll)
   - **E-Wallet** (GoPay, OVO, DANA, dll)
5. Selesaikan pembayaran
6. Setelah sukses, status booking akan berubah menjadi **"Confirmed / LUNAS"**

#### 4. Lihat Profil
1. Klik ikon **profil** di pojok kanan atas
2. Lihat data diri, role badge (Member/Trainer/Admin)
3. Klik ikon **edit** (pensil) untuk mengubah profil
4. Klik ikon **kamera** untuk upload foto profil

#### 5. Progress Latihan
1. Catat progress latihan harian
2. Lihat riwayat progress

### Untuk Trainer

1. Login sebagai akun trainer
2. Dashboard khusus trainer akan muncul
3. Kelola sesi latihan yang ditawarkan
4. Lihat daftar client yang booking
5. Edit profil trainer

### Untuk Admin

1. Login sebagai akun admin
2. Dashboard admin dengan statistik lengkap
3. Kelola Users, Trainer, Booking, Artikel
4. Kelola Promo/Voucher
5. Kelola FAQ
6. Lihat Banner

---

## 🔑 Akun & Password

### Akun Test

| Role | Email | Password |
|------|-------|----------|
| **👤 Member** | `user@gymbuddy.site` | `user123` |
| **🏋️ Trainer** | `fadhel@gymbuddy.site` | `trainer123` |
| **🛠️ Admin** | `admin@gymbuddy.site` | `admin123` |

### Kartu Kredit Test Midtrans (Sandbox)

| Provider | Nomor Kartu | CVV | Expiry |
|----------|-------------|-----|--------|
| **Visa** | `4811 1111 1111 1114` | Apa saja | Masa depan |
| **Visa** | `4911 1111 1111 1113` | Apa saja | Masa depan |
| **Mastercard** | `5211 1111 1111 1117` | Apa saja | Masa depan |

> Untuk testing 3DS: gunakan `4811 1111 1111 1114` dan klik "Accept" saat diminta 3DS.
> Untuk simulasi gagal: gunakan kartu dengan saldo tidak mencukupi atau kartu kadaluarsa.

---

## ✨ Fitur Lengkap

### ✅ Website (Vue.js)
- [x] Landing page dengan hero & stats real-time
- [x] Registrasi & Login (JWT)
- [x] Dashboard member (statistik booking)
- [x] Cari Trainer dengan filter
- [x] Booking sesi latihan
- [x] Booking Saya (aktif & riwayat)
- [x] Pembayaran via Midtrans (redirect)
- [x] Profil & Edit Profil
- [x] Harga sesi (Pricing)
- [x] Progress latihan
- [x] Admin panel lengkap (CRUD)
- [x] Trainer panel (kelola sesi)
- [x] Artikel fitness
- [x] FAQ
- [x] Promo/Voucher

### ✅ Mobile App (Flutter)
- [x] Login & Register
- [x] Home screen (sesi & booking)
- [x] Cari Trainer dengan foto
- [x] Booking Saya (dengan foto trainer)
- [x] Detail sesi (dengan foto trainer)
- [x] Pembayaran via Midtrans (inAppWebView)
- [x] Profil & Edit Profil
- [x] Upload foto profil (via kamera/gallery)
- [x] Back navigation arrows
- [x] Admin panel
- [x] Trainer panel
- [x] Notifikasi
- [x] About screen

### ✅ Backend API (Node.js)
- [x] Auth (login, register, JWT)
- [x] CRUD User
- [x] CRUD Session
- [x] CRUD Booking + Payment status
- [x] Midtrans payment integration
- [x] Upload foto profil (multer)
- [x] Cache (in-memory)
- [x] Role-based access (admin/trainer/member)
- [x] Analytics dashboard
- [x] Articles, FAQ, Promo, Banners
- [x] Notifications
- [x] Webhook Midtrans

---

## 📁 Struktur Project

```
gymbuddy-app/
├── frontend/                 # Vue 3 Web App
│   ├── src/
│   │   ├── views/           # Halaman-halaman
│   │   │   ├── dashboard/   # Dashboard member
│   │   │   ├── admin/       # Halaman admin
│   │   │   ├── dashboard_trainer/ # Halaman trainer
│   │   │   ├── home.vue     # Landing page
│   │   │   ├── LoginView.vue
│   │   │   └── register.vue
│   │   ├── components/      # Komponen reusable
│   │   ├── stores/          # Pinia stores
│   │   ├── utils/           # API helper
│   │   └── router/          # Vue Router
│   └── vercel.json          # Vercel config
│
├── backend/                  # Node.js Express API
│   ├── src/
│   │   ├── controllers/     # Logic handler
│   │   ├── routes/          # Route definitions
│   │   ├── middleware/       # Auth, role, upload
│   │   ├── config/          # DB config
│   │   └── utils/           # Helpers
│   ├── server.js            # Entry point
│   └── uploads/profiles/    # Foto profil
│
├── mobile/                   # Flutter App
│   ├── lib/
│   │   ├── screens/         # Semua screen
│   │   │   ├── auth/        # Login & Register
│   │   │   ├── booking/     # Cari trainer & booking
│   │   │   ├── payment/     # Pembayaran
│   │   │   ├── profile/     # Profil
│   │   │   ├── admin/       # Admin panel
│   │   │   ├── trainer/     # Trainer panel
│   │   │   └── ...
│   │   ├── services/        # API service, Auth provider
│   │   ├── routing/         # GoRouter
│   │   └── main.dart
│   ├── test/                # Unit & widget tests
│   └── android/             # Android config
│
├── TUTOR.md                 # Dokumentasi ini
└── README.md
```

---

## 🔌 API Endpoints

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/register` | Registrasi user baru |
| POST | `/api/auth/login` | Login user |
| GET | `/api/auth/profile` | Get data user (by token) |

### User
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/user/profile` | Get profil user |
| PUT | `/api/user/profile` | Update profil user |
| GET | `/api/user/` | List users (admin) |
| DELETE | `/api/user/:id` | Hapus user (admin) |

### Session
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/sessions` | List sesi |
| GET | `/api/sessions/:id` | Detail sesi |

### Booking
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/bookings` | Buat booking baru |
| GET | `/api/bookings/my` | Booking saya |
| PATCH | `/api/bookings/:id/status` | Update status booking |

### Payment
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/payments/create` | Buat transaksi Midtrans |
| GET | `/api/payments/:booking_id/status` | Cek status pembayaran |
| POST | `/api/payments/notification` | Webhook dari Midtrans |
| GET | `/api/payments/config` | Client key Midtrans |

### Upload
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/upload/profile` | Upload foto profil (multipart) |

### Admin
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/analytics/dashboard` | Statistik dashboard |
| GET | `/api/trainers` | List trainers |
| CRUD | `/api/articles` | Artikel |
| CRUD | `/api/faq` | FAQ |
| CRUD | `/api/promo` | Promo/Voucher |
| CRUD | `/api/banners` | Banners |

---

## 🚢 Deployment

### Backend (Railway)
```bash
cd backend
railway login
railway up
```

### Frontend (Vercel)
```bash
cd frontend
vercel --prod
```

### Git (Push terbaru)
```bash
git add .
git commit -m "Update terbaru"
git push origin main
```

---

## 📊 Status Testing

| Test | Status | Detail |
|------|--------|--------|
| **Flutter Unit Tests** | ✅ **18/18 Pass** | Payment, Booking, Profile, Session Detail |
| **Flutter Analyze** | ✅ **0 issues** | Clean |
| **Frontend Build** | ✅ | Vite build success |
| **Backend APIs** | ✅ | All endpoints responding |
| **Backend Railway** | ✅ | Deployed, DB connected |
| **Frontend Vercel** | ✅ | Deployed, live |
| **Android APK** | ⚠️ Perlu compileSdk 36 | fluttertoast compatibility |

---

## 🐛 Known Issues

1. **Trainer photos null untuk data lama** — Booking lama tidak punya foto trainer karena field `trainer_photo` baru ditambahkan. Booking baru akan punya foto jika trainer upload foto profil.
2. **APK build** — Perlu compileSdk 36 atau update `fluttertoast` ke versi terbaru.
3. **Pricing page** — Route di `/dashboard/pricingview` (bukan `/pricing`).

---

> **Dibuat oleh:** Arif Rachman  
> **Email:** 2311102300@ittelkom-pwt.ac.id  
> **Versi:** 1.0.0  
> **Dokumen ini:** TUTOR.md — Panduan Lengkap GymBuddy
