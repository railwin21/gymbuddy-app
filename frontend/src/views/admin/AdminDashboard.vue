<template>
  <div class="p-8 text-white">
    <header class="mb-8">
      <h1 class="text-3xl font-black uppercase tracking-tighter">Dashboard Admin</h1>
      <p class="text-gray-500 text-sm mt-1">Ringkasan data platform GymBuddy</p>
    </header>

    <div v-if="loading" class="flex justify-center py-20">
      <div class="animate-pulse text-red-500 font-black uppercase tracking-widest text-xs">Memuat data...</div>
    </div>

    <div v-else>
      <!-- Stats Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
        <div class="bg-[#0f1115] p-6 rounded-2xl border border-gray-900">
          <p class="text-3xl font-black text-white">{{ stats.totalUsers || 0 }}</p>
          <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mt-1">Total User</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-2xl border border-gray-900">
          <p class="text-3xl font-black text-white">{{ stats.trainers || 0 }}</p>
          <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mt-1">Trainer</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-2xl border border-gray-900">
          <p class="text-3xl font-black text-white">{{ stats.totalBookings || 0 }}</p>
          <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mt-1">Total Booking</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-2xl border border-gray-900">
          <p class="text-3xl font-black text-green-400">{{ stats.settledPayments || 0 }}</p>
          <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mt-1">Pembayaran Lunas</p>
        </div>
      </div>

      <!-- Role Distribution -->
      <div class="bg-[#0f1115] p-8 rounded-2xl border border-gray-900 mb-8">
        <h3 class="font-black uppercase text-xs tracking-widest text-gray-400 mb-6">Distribusi Role User</h3>
        <div class="grid grid-cols-3 gap-4">
          <div v-for="role in roleDistribution" :key="role.role" class="text-center p-4 bg-black/30 rounded-xl">
            <p class="text-2xl font-black text-white">{{ role.count }}</p>
            <p class="text-[10px] text-gray-500 uppercase font-bold mt-1">{{ role.role }}</p>
          </div>
        </div>
      </div>

      <!-- Status Booking Distribution -->
      <div class="bg-[#0f1115] p-8 rounded-2xl border border-gray-900">
        <h3 class="font-black uppercase text-xs tracking-widest text-gray-400 mb-6">Status Booking</h3>
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div v-for="s in bookingStatus" :key="s.status" class="text-center p-4 bg-black/30 rounded-xl">
            <p class="text-2xl font-black text-white">{{ s.count }}</p>
            <p class="text-[10px] text-gray-500 uppercase font-bold mt-1">{{ s.status }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../utils/api'

const loading = ref(true)
const stats = ref({})
const roleDistribution = ref([])
const bookingStatus = ref([])

const fetchStats = async () => {
  try {
    const [usersRes, bookingsRes] = await Promise.all([
      api.get('/users', { params: { limit: 999 } }),
      api.get('/bookings', { params: { limit: 999 } })
    ])

    const allUsers = usersRes.data?.data || []
    const allBookings = bookingsRes.data?.data || []

    // Compute role distribution
    const roles = ['admin', 'trainer', 'customer']
    roleDistribution.value = roles.map(role => ({
      role,
      count: allUsers.filter(u => u.role === role).length
    }))

    // Compute booking status distribution
    const statuses = ['pending', 'confirmed', 'cancelled']
    bookingStatus.value = statuses.map(status => ({
      status,
      count: allBookings.filter(b => b.status === status).length
    }))

    const trainerCount = allUsers.filter(u => u.role === 'trainer').length
    const settledPayments = allBookings.filter(b => b.payment_status === 'settlement').length

    stats.value = {
      totalUsers: allUsers.length,
      trainers: trainerCount,
      totalBookings: allBookings.length,
      settledPayments
    }
  } catch (err) {
    console.error('Fetch stats error:', err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchStats)
</script>
