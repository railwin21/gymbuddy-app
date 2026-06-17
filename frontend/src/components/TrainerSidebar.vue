<template>
  <aside class="w-64 bg-[#0a0a0a] text-gray-400 flex flex-col min-h-screen border-r border-white/5 shadow-2xl">
    
    <div class="p-6">
      <router-link to="/" class="flex items-center gap-3">
        <span class="w-8 h-8 bg-red-500 rounded-lg flex items-center justify-center font-black text-white text-sm">GB</span> 
        <span class="text-white font-bold">GymBuddy</span>
      </router-link>
    </div>
    
    <nav class="flex-1 px-4 space-y-1">
      <router-link 
        v-for="item in navItems" :key="item.path"
        :to="item.path"
        class="flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all duration-200"
        :class="$route.path === item.path 
          ? 'bg-red-500/10 text-red-500 border border-red-500/20' 
          : 'text-gray-400 hover:text-white hover:bg-white/5'"
      >
        <span class="text-lg">{{ item.icon }}</span>
        <span>{{ item.label }}</span>
      </router-link>
    </nav>

    <div class="p-5 border-t border-white/5">
      <button 
        @click="handleLogout"
        class="flex w-full items-center justify-center gap-2 px-4 py-3 border border-white/10 rounded-xl text-sm hover:bg-red-500/10 hover:border-red-500/30 hover:text-red-400 transition-all duration-200 cursor-pointer"
      >
        <span>🚪</span>
        <span>Keluar</span>
      </button>
    </div>
  </aside>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const navItems = [
  { path: '/trainer-panel/dashboard', label: 'Dashboard', icon: '📊' },
  { path: '/trainer-panel/sesion', label: 'Kelola Sesi', icon: '📅' },
  { path: '/trainer-panel/clien', label: 'Daftar Booker', icon: '👥' },
  { path: '/trainer-panel/profile', label: 'Profil', icon: '👤' },
]

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>
