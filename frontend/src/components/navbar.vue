<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const mobileMenuOpen = ref(false)

const isActive = (path) => route.path === path

const navLinks = [
  { path: '/', label: 'Beranda' },
  { path: '/about', label: 'Tentang' },
  { path: '/trainer', label: 'Trainer' },
]
</script>

<template>
  <header class="fixed top-0 left-0 w-full z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <nav class="flex items-center justify-between h-16 mt-2 px-6 glass rounded-2xl">
        
        <!-- Logo -->
        <router-link to="/" class="flex items-center gap-2 group">
          <img src="/src/assets/gymbuddy-logo.png" alt="GymBuddy" class="h-8 w-auto group-hover:scale-110 transition-transform" />
          <span class="text-white font-bold text-lg tracking-tight">GymBuddy</span>
        </router-link>

        <!-- Desktop Menu -->
        <div class="hidden md:flex items-center gap-8">
          <router-link
            v-for="link in navLinks"
            :key="link.path"
            :to="link.path"
            class="text-sm font-medium transition-colors duration-200"
            :class="isActive(link.path) ? 'text-red-500' : 'text-gray-400 hover:text-white'"
          >
            {{ link.label }}
          </router-link>
        </div>

        <!-- Right Side -->
        <div class="hidden md:flex items-center gap-3">
          <router-link
            to="/login"
            class="px-5 py-2 text-sm font-semibold text-white border border-white/20 rounded-xl hover:bg-white/5 transition-all duration-200"
          >
            Masuk
          </router-link>
          <router-link
            to="/register"
            class="px-5 py-2 text-sm font-semibold text-white bg-red-500 rounded-xl hover:bg-red-600 transition-all duration-200 shadow-lg shadow-red-500/20"
          >
            Daftar
          </router-link>
        </div>

        <!-- Mobile Menu Button -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="md:hidden p-2 text-gray-400 hover:text-white transition-colors"
        >
          <svg v-if="!mobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
          <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </nav>

      <!-- Mobile Menu -->
      <Transition name="mobile-menu">
        <div v-if="mobileMenuOpen" class="md:hidden mt-2 glass rounded-2xl overflow-hidden">
          <div class="py-4 px-6 space-y-1">
            <router-link
              v-for="link in navLinks"
              :key="link.path"
              :to="link.path"
              @click="mobileMenuOpen = false"
              class="block py-3 text-sm font-medium transition-colors"
              :class="isActive(link.path) ? 'text-red-500' : 'text-gray-400 hover:text-white'"
            >
              {{ link.label }}
            </router-link>
            <hr class="border-white/10 my-3">
            <router-link
              to="/login"
              @click="mobileMenuOpen = false"
              class="block py-3 text-sm font-medium text-gray-400 hover:text-white transition-colors"
            >
              Masuk
            </router-link>
            <router-link
              to="/register"
              @click="mobileMenuOpen = false"
              class="block py-3 text-sm font-semibold text-white bg-red-500 rounded-xl text-center hover:bg-red-600 transition-colors"
            >
              Daftar
            </router-link>
          </div>
        </div>
      </Transition>
    </div>
  </header>
</template>

<style scoped>
.mobile-menu-enter-active, .mobile-menu-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.mobile-menu-enter-from, .mobile-menu-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
