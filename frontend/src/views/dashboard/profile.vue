<template>
  <main class="p-8 text-white">
      <div class="bg-[#161920] rounded-[2rem] p-8 border border-gray-900 mb-8 relative overflow-hidden">
        <div class="relative z-10 flex flex-col md:flex-row items-center gap-8">
          <div class="w-24 h-24 bg-red-500 rounded-2xl flex items-center justify-center text-black font-black text-3xl uppercase">
            {{ getInitials(user.nama) }}
          </div>

          <div class="flex-grow text-center md:text-left">
            <h2 class="text-2xl font-black uppercase tracking-tight mb-1">{{ user.nama || 'Loading...' }}</h2>
            <div class="text-gray-500 text-sm mb-4">
              <p>📧 {{ user.email }}</p>
              <p class="uppercase">📍 {{ user.kota || 'Kota belum diatur' }}</p>
            </div>
            
            <router-link :to="`/dashboard/profile/edit/${user.id}`" class="inline-block bg-red-500 text-black px-5 py-2 rounded-lg font-bold text-[10px] uppercase tracking-wider hover:bg-red-400">
              Edit Profile
            </router-link>
          </div>
        </div>
      </div>
      
      <div class="bg-[#161920] p-8 rounded-[2rem] border border-gray-900">
        <h3 class="font-black uppercase text-[10px] tracking-[0.2em] text-gray-500 mb-6">Detailed Information</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="(val, label) in infoFields" :key="label">
            <p class="text-[9px] uppercase font-bold text-red-500 tracking-widest mb-1">{{ label }}</p>
            <p class="text-sm font-medium text-white uppercase">{{ val || '-' }}</p>
          </div>
        </div>
      </div>
    </main>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '../../utils/api'

const user = ref({ id: '', nama: '', email: '', role: '', kota: '', propinsi: '' })

const infoFields = computed(() => ({
  "Full Name": user.value.nama,
  "Email Address": user.value.email,
  "Current City": user.value.kota,
  "Province": user.value.propinsi,
  "Account Role": user.value.role
}))

const fetchUserProfile = async () => {
  try {
    // Memanggil endpoint auth/me untuk ambil data user login
    const response = await api.get('/auth/me') 
    user.value = response.data 
  } catch (error) {
    console.error("Gagal ambil data:", error)
  }
}

const getInitials = (name) => {
  if (!name) return '?'
  const parts = name.split(' ')
  return parts.length > 1 ? (parts[0][0] + parts[1][0]).toUpperCase() : parts[0][0].toUpperCase()
}

onMounted(fetchUserProfile)
</script>