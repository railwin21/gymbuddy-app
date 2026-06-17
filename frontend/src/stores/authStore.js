// stores/authStore.js
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    // Ambil data user dari localStorage jika ada, lalu ubah dari String kembali jadi Object
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('token') || null,
  }),
  actions: {
    setUser(userData) {
      this.user = userData 
      // Simpan object user ke localStorage dalam bentuk String
      localStorage.setItem('user', JSON.stringify(userData))
    },
    logout() {
      this.user = null
      this.token = null
      localStorage.removeItem('token')
      localStorage.removeItem('user') // Hapus juga data user saat logout
    }
  }
})