<script setup>
import aboutImg from '../assets/about-conten.jpg'
</script>

<template>
  <div class="bg-black text-white">

    <!-- ================= HERO ================= -->
    <section class="relative h-[60vh] flex items-center justify-center text-center">

      <div 
        class="absolute inset-0 bg-cover bg-center"
        style="background-image: url('https://images.unsplash.com/photo-1517836357463-d25dfeac3438')"
      ></div>

      <div class="absolute inset-0 bg-black/70"></div>

      <div class="relative z-10">
        <h1 class="text-4xl md:text-5xl font-bold">
          About GymBuddy
        </h1>
        <p class="text-gray-400 mt-2">About / Tentang Kami</p>
      </div>

    </section>

    <!-- ================= MASALAH & SOLUSI ================= -->
      <section class="bg-black text-white py-24">
    <div class="max-w-6xl mx-auto px-6 grid md:grid-cols-2 gap-12 items-center">

      <!-- TEXT -->
      <div>
        <h2 class="text-3xl font-bold mb-2">
          Hi, Kenalin Kita, <span class="text-red-500">GYMBUDDY</span>!
        </h2>
        <p class="text-gray-400  mb-4">
          Kami <span class="text-red-500 font-semibold">GymBuddy</span> hadir sebagai platform manajemen fitness digital yang menjembatani kesenjangan antara pelatih berkompeten dan penggiat olahraga. Kami menyediakan ekosistem terpadu untuk pencarian trainer hingga penjadwalan sesi latihan dalam satu genggaman.
        </p>

        <p class="text-gray-400">
          Kami membantu kamu tetap konsisten olahraga dengan trainer dan program latihan yang tepat. Temukan partner latihan, atur jadwal, dan capai tujuan fitness kamu bersama GymBuddy!
        </p>
      </div>

      <!-- IMAGE -->
      <div class="relative">
        <img
          src="/src/assets/about-conten-3.jpg"
          class="rounded-lg"
        />

        <!-- FRAME EFFECT -->
        <div class="absolute -top-4 -right-4 w-full h-full border-4 border-red-500"></div>
      </div>

    </div>
  </section>

  <section class="py-20 bg-zinc-900">
  <div class="max-w-6xl mx-auto px-6 grid md:grid-cols-2 gap-16">
    
    <!-- Bagian Visi -->
    <div>
      <h2 class="text-red-500 text-sm font-bold uppercase tracking-widest mb-2">Visi Kami</h2>
      <p class="text-2xl md:text-3xl font-semibold text-white leading-tight">
        Menjadi jembatan utama menuju gaya hidup sehat yang <span class="text-red-500">terkoneksi dan berkelanjutan.</span>
      </p>
    </div>

    <!-- Bagian Misi -->
    <div>
      <h2 class="text-red-500 text-sm font-bold uppercase tracking-widest mb-4">Misi Kami</h2>
      <ul class="space-y-4 text-gray-400">
        <li class="flex items-start">
          <span class="text-red-500 mr-2">01.</span>
          Memberdayakan pelatih lokal dengan teknologi manajemen.
        </li>
        <li class="flex items-start">
          <span class="text-red-500 mr-2">02.</span>
          Menyediakan alat bantu digital bagi trainer untuk memaksimalkan jadwal dan produktivitas sesi.
        </li>
        <li class="flex items-start">
          <span class="text-red-500 mr-2">03.</span>
          Menyederhanakan proses booking untuk efisiensi waktu pengguna.
        </li>
      </ul>
    </div>

  </div>
</section>

    <!-- ================= CARD ================= -->
  <section class="bg-black text-white py-20 fade-up" style="animation-delay: 0.1s">
  <div class="max-w-6xl mx-auto px-6 text-center">

    <!-- TITLE -->
    <h2 class="text-3xl font-bold mb-4 fade-up" style="animation-delay: 0.2s">
      Kenapa <span class="text-red-500">GymBuddy</span>?
    </h2>

    <p class="text-gray-400 max-w-2xl mx-auto mb-12">
      Akses ke pelatih berpengalaman kini ada dalam genggaman Anda.
    </p>

    <!-- GRID -->
    <div class="grid md:grid-cols-3 gap-8 text-left">

      <!-- CARD 1 -->
      <div class="bg-zinc-900 p-6 rounded-2xl border border-white/10 
                  hover:border-red-500/30 transition group">

        <div class="w-14 h-14 bg-red-500/10 rounded-full flex items-center justify-center mb-4">
          <span class="text-red-500 text-3xl">🏋️</span>
        </div>

        <h3 class="font-semibold text-lg mb-2">
          Trainer Berpengalaman
        </h3>

        <p class="text-gray-400 text-sm mb-4 leading-relaxed">
          Akses ke pelatih tanpa ribet administrasi. 
          Pilih trainer sesuai target seperti Weight Loss, Strength, atau Hypertrophy.
        </p>
      </div>

      <!-- CARD 2 -->
      <div class="bg-zinc-900 p-6 rounded-2xl border border-white/10 
                  hover:border-red-500/30 transition group">

        <div class="w-14 h-14 bg-red-500/10 rounded-full flex items-center justify-center mb-4">
          <span class="text-red-500 text-3xl">📅</span>
        </div>

        <h3 class="font-semibold text-lg mb-2">
          Fleksibel & Efisien
        </h3>

        <p class="text-gray-400 text-sm mb-4 leading-relaxed">
          Atur jadwal latihan sesuai waktumu. Tidak perlu antre atau menyesuaikan dengan gym.
        </p>
      </div>

      <!-- CARD 3 -->
      <div class="bg-zinc-900 p-6 rounded-2xl border border-white/10 
                  hover:border-red-500/30 transition group">

        <div class="w-14 h-14 bg-red-500/10 rounded-full flex items-center justify-center mb-4">
          <span class="text-red-500 text-3xl">📱</span>
        </div>

        <h3 class="font-semibold text-lg mb-2">
          Booking Mudah
        </h3>

        <p class="text-gray-400 text-sm mb-4 leading-relaxed">
          Semua dilakukan langsung dari aplikasi. Proses cepat, simpel, dan tanpa ribet.
        </p>
      </div>

    </div>

  </div>
</section>

<!-- ===== JOIN NOW ===== -->
<section class="pt-20 pb-16 text-center ">
  <div class="max-w-6xl mx-auto px-6">

    <div class="relative rounded-2xl overflow-hidden h-[220px]">

      <!-- BACKGROUND -->
      <div 
        class="absolute inset-0 bg-cover bg-center transition duration-500 hover:scale-105"
        style="background-image: url('/src/assets/conten-traine-2.jpg')">
      </div>

      <!-- OVERLAY -->
      <div class="absolute inset-0 bg-black/70"></div>

      <!-- CONTENT -->
      <div class="relative z-10 flex flex-col items-center justify-center h-full text-center text-white">

        <p class="text-xs text-gray-300 mb-1 uppercase tracking-widest">Gabung Sekarang</p>

        <h2 class="text-xl md:text-2xl font-bold mb-6">
          Mulai perjalanan fitness kamu sekarang
        </h2>
        
        <RouterLink
            to="/login"
            class="mt-6 inline-block bg-red-500 px-6 py-3 rounded-full font-semibold text-white shadow-[0_0_25px_rgba(239,68,68,0.6)] transition-all duration-300 hover:scale-110 hover:shadow-[0_0_40px_rgba(239,68,68,0.9)]"
          >
            Gabung Sekarang
          </RouterLink>
      </div>

    </div>

  </div>
</section>
  </div>
</template>