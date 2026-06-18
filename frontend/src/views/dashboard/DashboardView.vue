<template>
  <main class="p-8 text-white overflow-y-auto">
      
      <header class="mb-8">
        <h2 class="text-3xl font-black uppercase tracking-tighter text-white">Dashboard</h2>
        <p class="text-gray-500 text-sm mt-1">Welcome back! <span class="text-red-500/80 italic font-medium">Keep pushing towards your goals.</span></p>
      </header>

      <div v-if="loading" class="flex justify-center py-10">
        <div class="animate-pulse text-red-500 font-black uppercase tracking-widest text-xs">Memuat data...</div>
      </div>

      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-red-500/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">👥</div>
          <p class="text-4xl font-black text-white tracking-tighter">{{ stats.activeSessions }}</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Active Sessions</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-orange-400/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">📅</div>
          <p class="text-4xl font-black text-white tracking-tighter">{{ stats.thisWeek }}</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">This Week</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-purple-400/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">🦾</div>
          <p class="text-4xl font-black text-white tracking-tighter">{{ stats.partners }}</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Gym Partners</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-red-500/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">📈</div>
          <p class="text-4xl font-black text-white tracking-tighter">{{ stats.savedDays }}</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Saved Days</p>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        <div class="bg-[#0f1115] p-8 rounded-[2.5rem] border border-gray-900 shadow-2xl">
          <div class="flex justify-between items-center mb-8">
            <h3 class="font-black uppercase text-sm tracking-widest text-gray-300">Upcoming Sessions</h3>
            <button class="text-red-500 text-[10px] font-bold uppercase hover:underline">View All</button>
          </div>
          
          <div v-if="upcomingSessions.length === 0" class="text-gray-600 text-xs font-bold uppercase py-10 text-center border border-dashed border-gray-900 rounded-3xl">
            Belum ada sesi mendatang.
          </div>
          <div v-else class="space-y-4">
            <div v-for="session in upcomingSessions" :key="session.id" class="bg-[#161920] p-5 rounded-2xl border border-gray-800 hover:border-red-500/20 transition-all cursor-pointer group">
              <div class="flex justify-between items-center">
                <div>
                  <p class="font-bold text-white group-hover:text-red-500 transition-colors">{{ session.title }}</p>
                  <div class="flex items-center gap-3 mt-1 text-[10px] text-gray-500 font-semibold uppercase tracking-tighter">
                    <span class="flex items-center gap-1">🕒 {{ formatTime(session.start_time) }}</span>
                    <span class="flex items-center gap-1 text-red-500/60">💪 {{ session.trainer_name || 'Trainer' }}</span>
                  </div>
                </div>
                <div class="text-right">
                  <p class="text-sm font-black text-red-500">{{ formatRupiah(session.price) }}</p>
                </div>
              </div>
            </div>
          </div>

          <router-link to="/dashboard/find-trainers" class="block w-full mt-8 py-4 bg-red-500 text-black font-black uppercase text-xs tracking-widest rounded-2xl hover:bg-red-400 transition-all shadow-lg shadow-red-500/10 active:scale-[0.98] text-center">
            Book New Session
          </router-link>
        </div>

        <div class="bg-[#0f1115] p-8 rounded-[2.5rem] border border-gray-900 shadow-2xl">
          <div class="flex justify-between items-center mb-8">
            <h3 class="font-black uppercase text-sm tracking-widest text-gray-300">Recommended</h3>
            <button class="text-red-500 text-[10px] font-bold uppercase hover:underline">Browse All</button>
          </div>

          <div v-if="upcomingSessions.length === 0" class="text-gray-600 text-xs font-bold uppercase py-10 text-center border border-dashed border-gray-900 rounded-3xl">
            Belum ada data.
          </div>
          <div v-else class="space-y-6">
            <div v-for="session in upcomingSessions" :key="session.id" class="flex items-center justify-between group">
              <div class="flex items-center gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-gray-700 to-gray-900 rounded-2xl flex items-center justify-center font-bold text-xs text-red-500 border border-gray-800">
                  {{ (session.title || 'S').charAt(0).toUpperCase() }}
                </div>
                <div>
                  <p class="text-sm font-bold text-white group-hover:text-red-500 transition-colors">{{ session.title }}</p>
                  <p class="text-[10px] text-gray-500 uppercase font-semibold">{{ session.trainer_name || 'Trainer' }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-black text-red-500">{{ formatRupiah(session.price) }}</p>
                <p class="text-[10px] text-gray-600 font-bold">⭐ 4.8</p>
              </div>
            </div>
          </div>
        </div>

      </div>

    </main>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../utils/api'

const loading = ref(true)
const stats = ref({ activeSessions: 0, thisWeek: 0, partners: 0, savedDays: 0 })
const upcomingSessions = ref([])

const formatRupiah = (price) => {
  if (!price) return 'Rp0'
  return `Rp${Number(price).toLocaleString('id-ID')}`
}

const formatTime = (dateStr) => {
  if (!dateStr) return '--:--'
  return new Date(dateStr).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
}

const fetchDashboardData = async () => {
  try {
    const [sessionsRes, bookingsRes] = await Promise.all([
      api.get('/sessions'),
      api.get('/bookings/my').catch(() => ({ data: { data: [] } }))
    ])

    const sessions = sessionsRes.data?.data || []
    const myBookings = bookingsRes.data?.data || []

    stats.value = {
      activeSessions: sessions.filter(s => s.status === 'scheduled' || s.status === 'ongoing').length,
      thisWeek: sessions.filter(s => {
        const d = new Date(s.start_time)
        const now = new Date()
        const weekStart = new Date(now)
        weekStart.setDate(now.getDate() - now.getDay())
        const weekEnd = new Date(weekStart)
        weekEnd.setDate(weekStart.getDate() + 7)
        return d >= weekStart && d <= weekEnd
      }).length,
      partners: myBookings.length || 0,
      savedDays: sessions.filter(s => s.status === 'completed').length || 0
    }

    // Ambil 3 upcoming sessions
    upcomingSessions.value = sessions
      .filter(s => new Date(s.start_time) > new Date())
      .sort((a, b) => new Date(a.start_time) - new Date(b.start_time))
      .slice(0, 3)

  } catch (err) {
    console.error('Dashboard fetch error:', err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchDashboardData)
</script>