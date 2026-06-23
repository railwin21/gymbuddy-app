// utils/api.js
import axios from 'axios'

// Base URL: prioritaskan environment variable, lalu fallback ke production URL
const API_BASE_URL = import.meta.env.VITE_API_URL 
  || (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1' ? 'http://localhost:5000/api' 
  : 'https://gymbuddy-api-production-81df.up.railway.app/api')


const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Tambahkan interceptor untuk token (penting buat Find Trainer & My Booking)
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token') // sesuaikan nama key token kamu
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default api