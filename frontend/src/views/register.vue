<template>
  <div class="min-h-screen bg-[#000000] flex flex-col items-center justify-center p-6 font-sans">
    
    <div class="max-w-5xl w-full mx-auto flex justify-center mt-20 mb-12">
      
      <div class="w-full grid grid-cols-1 md:grid-cols-2 bg-[#111111] rounded-[2.5rem] overflow-hidden shadow-2xl">
        
        <div class="relative hidden md:block overflow-hidden">
          <img src="/src/assets/gymapp-register.jpg" alt="Register Image"
               class="absolute inset-0 w-full h-full object-cover" />
          
          <div class="absolute inset-0 bg-black/60 backdrop-blur-[2px]"></div>
          
          <div class="relative z-10 p-12 h-full flex flex-col justify-center text-white">
            <p class="text-red-500 font-bold uppercase tracking-widest text-xs mb-3">Bergabung dengan GymBuddy</p>
            <h1 class="text-4xl lg:text-5xl font-bold leading-tight mb-6">
              Mulai Perjalanan Fitness-mu <span class="text-red-500">Hari ini</span>, Jadilah versi Terbaik Dirimu!
            </h1>
            <p class="text-gray-300 text-sm mb-8 max-w-xs">
              Daftar sekarang dan temukan cara termudah serta aman untuk memesan personal trainer sesuai kebutuhanmu.
            </p>
          </div>
        </div>

        <div class="p-10 md:p-14 bg-[#000000] flex flex-col justify-center">
          <div class="mb-10">
            <h2 class="text-4xl font-bold text-white mb-2">Daftar Akun<span class="text-red-500">.</span></h2>
            <p class="text-gray-400">Silakan lengkapi detail data diri Anda.</p>
          </div>

          <form @submit.prevent="handleRegister" class="space-y-6">
            <div class="space-y-2">
              <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Nama Lengkap</label>
              <input v-model="formData.nama" type="text" placeholder="Masukkan nama lengkap" required
                     class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none transition-all placeholder-gray-700">
            </div>

            <div class="space-y-2">
              <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Email Address</label>
              <input v-model="formData.email" type="email" placeholder="nama@email.com" required
                     class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none transition-all placeholder-gray-700">
            </div>

            <div class="space-y-2">
              <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Password</label>
              <input v-model="formData.password" type="password" placeholder="••••••••" required
                     class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none transition-all placeholder-gray-700">
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="space-y-2">
                <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Provinsi</label>
                <input v-model="formData.propinsi" type="text" placeholder="Jawa Tengah" required
                       class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none transition-all placeholder-gray-700">
              </div>
              <div class="space-y-2">
                <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Kota</label>
                <input v-model="formData.kota" type="text" placeholder="Purwokerto" required
                       class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none transition-all placeholder-gray-700">
              </div>
            </div>

            <div class="space-y-2 relative">
              <label class="text-xs font-semibold text-gray-500 uppercase ml-1">Daftar Sebagai</label>
              <select v-model="formData.role" required
                      class="w-full bg-[#1A1A1A] border-none text-white px-6 py-4 rounded-full focus:ring-2 focus:ring-red-500 outline-none appearance-none cursor-pointer">
                <option value="" disabled>Pilih peran Anda</option>
                <option value="customer">Member (Customer)</option>
                <option value="trainer">Trainer (Pelatih)</option>
              </select>
              <span class="absolute right-6 top-[55px] -translate-y-1/2 text-red-500 pointer-events-none text-xs">▼</span>
            </div>

            <button type="submit" :disabled="loading"
                    class="w-full bg-red-500 text-white py-4 rounded-full font-bold text-lg hover:bg-red-600 shadow-xl shadow-red-500/20 transition-all mt-4">
              {{ loading ? 'Memproses...' : 'Buat Akun' }}
            </button>
          </form>

          <p class="mt-8 text-center text-gray-400 text-sm">
            Sudah punya akun? 
            <router-link to="/login" class="text-blue-400 font-bold hover:underline">Log in di sini</router-link>
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- Toast Notification -->
  <Transition name="toast">
    <div v-if="toast.show" 
         :class="toast.type === 'success' ? 'bg-green-500' : 'bg-red-500'"
         class="fixed bottom-6 right-6 px-6 py-4 rounded-2xl text-white font-bold text-sm shadow-2xl z-50">
      {{ toast.message }}
    </div>
  </Transition>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../utils/api'

const router = useRouter()
const loading = ref(false)
const toast = ref({ show: false, message: '', type: 'success' })

const showToast = (message, type = 'success') => {
  toast.value = { show: true, message, type }
  setTimeout(() => { toast.value.show = false }, 3000)
}

const formData = ref({
  nama: '',
  email: '',
  password: '',
  role: '',
  propinsi: '',
  kota: ''
})

const handleRegister = async () => {
  loading.value = true
  try {
    // Pilih endpoint berdasarkan role
    const endpoint = formData.value.role === 'trainer' 
      ? '/auth/register/trainer' 
      : '/auth/register'
    
    const payload = {
      nama: formData.value.nama,
      email: formData.value.email,
      password: formData.value.password,
      propinsi: formData.value.propinsi,
      kota: formData.value.kota
    }

    await api.post(endpoint, payload)
    
    showToast('Pendaftaran Berhasil! Silakan Login.', 'success')
    setTimeout(() => router.push('/login'), 1500)
  } catch (error) {
    const msg = error.response?.data?.message || 'Gagal mendaftar. Periksa koneksi.'
    showToast(msg, 'error')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.toast-enter-active, .toast-leave-active {
  transition: all 0.4s ease;
}
.toast-enter-from {
  opacity: 0;
  transform: translateX(100px);
}
.toast-leave-to {
  opacity: 0;
  transform: translateY(20px);
}
</style>
