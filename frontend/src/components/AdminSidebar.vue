<template>
  <aside class="w-64 bg-[#0a0a0a] text-gray-400 flex flex-col min-h-screen border-r border-white/5 shadow-2xl shrink-0">
    <div class="p-6">
      <router-link to="/admin/dashboard" class="flex items-center gap-3">
        <img src="/src/assets/gymbuddy-logo.png" alt="GymBuddy" class="h-8 w-auto" />
      </router-link>
    </div>

    <nav class="flex-1 px-4 space-y-1 overflow-y-auto">
      <router-link
        v-for="item in navItems" :key="item.path"
        :to="item.path"
        class="flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all duration-200"
        :class="isActive(item.path) ? 'bg-red-500/10 text-red-500 border border-red-500/20' : 'text-gray-400 hover:text-white hover:bg-white/5'"
      >
        <span>{{ item.icon }}</span>
        <span>{{ item.label }}</span>
      </router-link>
    </nav>

    <div class="p-5 border-t border-white/5 space-y-2">
      <router-link to="/dashboard" class="flex items-center gap-2 px-4 py-2 text-xs text-gray-500 hover:text-white transition-colors">
        <span>←</span> Kembali ke User
      </router-link>
      <button @click="handleLogout"
        class="flex w-full items-center justify-center gap-2 px-4 py-3 border border-white/10 rounded-xl text-sm hover:bg-red-500/10 hover:border-red-500/30 hover:text-red-400 transition-all cursor-pointer">
        <span>🚪</span> Keluar
      </button>
    </div>
  </aside>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const navItems = [
  { path: '/admin/dashboard', label: 'Dashboard', icon: '📊' },
  { path: '/admin/users', label: 'User', icon: '👥' },
  { path: '/admin/trainers', label: 'Trainer', icon: '💪' },
  { path: '/admin/bookings', label: 'Booking', icon: '📋' },
  { path: '/admin/payments', label: 'Pembayaran', icon: '💰' },
  { path: '/admin/articles', label: 'Artikel', icon: '📝' },
  { path: '/admin/promo', label: 'Promo', icon: '🏷️' },
  { path: '/admin/faq', label: 'FAQ', icon: '❓' },
  { path: '/admin/banners', label: 'Banner', icon: '🖼️' },
  { path: '/admin/notifications', label: 'Notifikasi', icon: '🔔' },
]

const isActive = (path) => route.path.startsWith(path)

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>
