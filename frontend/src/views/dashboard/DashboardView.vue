<template>
  <div class="flex min-h-screen bg-black font-sans selection:bg-red-500 selection:text-black">
    <DashboardSidebar />

    <main class="flex-grow p-8 text-white overflow-y-auto">
      
      <header class="mb-8">
        <h2 class="text-3xl font-black uppercase tracking-tighter text-white">Dashboard</h2>
        <p class="text-gray-500 text-sm mt-1">Welcome back! <span class="text-red-500/80 italic font-medium">Keep pushing towards your goals.</span></p>
      </header>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-red-500/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">👥</div>
          <p class="text-4xl font-black text-white tracking-tighter">3</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Active Sessions</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-orange-400/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">📅</div>
          <p class="text-4xl font-black text-white tracking-tighter">5</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">This Week</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-purple-400/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">🦾</div>
          <p class="text-4xl font-black text-white tracking-tighter">8</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Gym Partners</p>
        </div>
        <div class="bg-[#0f1115] p-6 rounded-[2rem] border border-gray-900 hover:border-red-500/30 transition-all shadow-xl group">
          <div class="w-12 h-12 bg-red-500/10 rounded-2xl flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">📈</div>
          <p class="text-4xl font-black text-white tracking-tighter">12</p>
          <p class="text-gray-500 text-xs uppercase font-bold tracking-widest mt-1">Saved Days</p>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        <div class="bg-[#0f1115] p-8 rounded-[2.5rem] border border-gray-900 shadow-2xl">
          <div class="flex justify-between items-center mb-8">
            <h3 class="font-black uppercase text-sm tracking-widest text-gray-300">Upcoming Sessions</h3>
            <button class="text-red-500 text-[10px] font-bold uppercase hover:underline">View All</button>
          </div>
          
          <div class="space-y-4">
            <div v-for="n in 3" :key="n" class="bg-[#161920] p-5 rounded-2xl border border-gray-800 hover:border-red-500/20 transition-all cursor-pointer group">
              <div class="flex justify-between items-center">
                <div>
                  <p class="font-bold text-white group-hover:text-red-500 transition-colors">David Martinez</p>
                  <div class="flex items-center gap-3 mt-1 text-[10px] text-gray-500 font-semibold uppercase tracking-tighter">
                    <span class="flex items-center gap-1">🕒 09:00 AM</span>
                    <span class="flex items-center gap-1 text-red-500/60">💪 Strength Training</span>
                  </div>
                </div>
                <div class="w-8 h-8 rounded-full bg-black flex items-center justify-center text-xs">➡️</div>
              </div>
            </div>
          </div>

          <button class="w-full mt-8 py-4 bg-red-500 text-black font-black uppercase text-xs tracking-widest rounded-2xl hover:bg-red-400 transition-all shadow-lg shadow-red-500/10 active:scale-[0.98]">
            Book New Session
          </button>
        </div>

        <div class="bg-[#0f1115] p-8 rounded-[2.5rem] border border-gray-900 shadow-2xl">
          <div class="flex justify-between items-center mb-8">
            <h3 class="font-black uppercase text-sm tracking-widest text-gray-300">Recommended</h3>
            <button class="text-red-500 text-[10px] font-bold uppercase hover:underline">Browse All</button>
          </div>

          <div class="space-y-6">
            <div v-for="n in 3" :key="n" class="flex items-center justify-between group">
              <div class="flex items-center gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-gray-700 to-gray-900 rounded-2xl flex items-center justify-center font-bold text-xs text-red-500 border border-gray-800">
                  DM
                </div>
                <div>
                  <p class="text-sm font-bold text-white group-hover:text-red-500 transition-colors">David Martinez</p>
                  <p class="text-[10px] text-gray-500 uppercase font-semibold">Strength & Conditioning</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-black text-red-500">$80</p>
                <p class="text-[10px] text-gray-600 font-bold">⭐ 4.8</p>
              </div>
            </div>
          </div>
        </div>

      </div>

    </main>
  </div>
</template>

<script setup>
import DashboardSidebar from '../../components/DashboardSidebar.vue'
</script>