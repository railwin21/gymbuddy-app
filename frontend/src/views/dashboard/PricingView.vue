<template>
  <div class="flex min-h-screen bg-black">
    <DashboardSidebar />
    <main class="flex-grow p-10 text-white overflow-y-auto">
      <div class="text-center mb-12">
        <h2 class="text-4xl font-black uppercase text-white mb-4">Level Up Your Fitness Game</h2>
        <p class="text-gray-400">Unlock exclusive features and priority access to top trainers.</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-5xl mx-auto">
        <div class="bg-[#111111] p-8 rounded-[2.5rem] border border-gray-800">
          <h3 class="text-xl font-bold mb-2">FREE</h3>
          <p class="text-4xl font-black mb-6">$0 <span class="text-sm text-gray-500 font-normal">/ month</span></p>
          <ul class="space-y-4 mb-8 text-sm text-gray-400">
            <li>✓ Browse and book trainers</li>
            <li>✓ Up to 8 bookings per month</li>
          </ul>
          <button class="w-full py-3 border border-gray-700 rounded-xl font-bold hover:bg-white/5 transition">Current Plan</button>
        </div>

        <div class="bg-gradient-to-b from-[#2c1a11] to-[#111111] p-8 rounded-[2.5rem] border border-orange-500/30 relative overflow-hidden">
          <div class="absolute top-4 right-4 bg-orange-500 text-black text-[10px] font-black px-3 py-1 rounded-full">POPULAR</div>
          <h3 class="text-xl font-bold mb-2 text-orange-500">PREMIUM</h3>
          <p class="text-4xl font-black mb-6">$29 <span class="text-sm text-gray-500 font-normal">/ month</span></p>
          <ul class="space-y-4 mb-8 text-sm text-gray-300">
            <li>✓ Unlimited bookings</li>
            <li>✓ Priority access to top trainers</li>
            <li>✓ Advanced analytics & insights</li>
          </ul>
          <button class="w-full py-3 bg-orange-600 text-white rounded-xl font-black hover:bg-orange-500 transition shadow-lg shadow-orange-900/40">Upgrade to Premium</button>
        </div>
      </div>
<section class="mt-20 max-w-5xl mx-auto">
        <div class="text-center mb-10">
          <h3 class="text-2xl font-black uppercase tracking-tighter">Premium Benefits</h3>
          <p class="text-gray-500 text-sm mt-1">Everything you need to maximize your fitness potential!</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">👑</div>
            <h4 class="font-bold text-sm mb-2">Priority Access to Top Trainers</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">Get exclusive access to our highest-rated and most experienced trainers.</p>
          </div>
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">📅</div>
            <h4 class="font-bold text-sm mb-2">Unlimited Bookings</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">Book as many sessions as you want without any restrictions.</p>
          </div>
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">👥</div>
            <h4 class="font-bold text-sm mb-2">Premium Partner Matching</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">Priority placement in gym partner searches with advanced filtering.</p>
          </div>
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">📈</div>
            <h4 class="font-bold text-sm mb-2">Advanced Analytics</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">In-depth progress tracking with charts, trends, and personalized insights.</p>
          </div>
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">⚡</div>
            <h4 class="font-bold text-sm mb-2">Early Access to Features</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">Be the first to try new features and updates.</p>
          </div>
          <div class="bg-[#0f1115] p-6 rounded-3xl border border-gray-900 group hover:border-orange-500/30 transition-all">
            <div class="w-10 h-10 bg-orange-500/10 rounded-xl flex items-center justify-center text-orange-500 mb-4 group-hover:scale-110 transition-transform">⭐</div>
            <h4 class="font-bold text-sm mb-2">Exclusive Community</h4>
            <p class="text-[11px] text-gray-500 leading-relaxed">Join premium-only events, workshops, and networking sessions.</p>
          </div>
        </div>
      </section>

      <section class="mt-24 mb-20 max-w-3xl mx-auto">
        <h3 class="text-3xl font-black text-center uppercase tracking-widest mb-10">Questions?</h3>
        
        <div class="space-y-4">
          <div class="bg-[#0f1115] border border-gray-900 p-5 rounded-2xl hover:border-gray-700 transition-all cursor-pointer group">
            <h5 class="font-bold text-sm text-gray-300 group-hover:text-white">Can I cancel anytime?</h5>
            <p class="text-[11px] text-gray-500 mt-2">Yes! You can cancel your premium subscription at any time. You'll continue to have access until the end of your billing period.</p>
          </div>
          <div class="bg-[#0f1115] border border-gray-900 p-5 rounded-2xl hover:border-gray-700 transition-all cursor-pointer group">
            <h5 class="font-bold text-sm text-gray-300 group-hover:text-white">What payment methods do you accept?</h5>
            <p class="text-[11px] text-gray-500 mt-2">We accept e-wallets (GoPay, OVO, DANA), bank transfers, and credit/debit cards.</p>
          </div>
          <div class="bg-[#0f1115] border border-gray-900 p-5 rounded-2xl hover:border-gray-700 transition-all cursor-pointer group">
            <h5 class="font-bold text-sm text-gray-300 group-hover:text-white">Can I switch between monthly and yearly?</h5>
            <p class="text-[11px] text-gray-500 mt-2">Absolutely! You can upgrade or downgrade your plan at any time through your account settings.</p>
          </div>
        </div>
      </section>

      <p class="text-center text-[10px] text-gray-700 uppercase tracking-[0.3em] pb-10">© 2026 GymBuddy. All rights reserved.</p>

    </main>
  </div>
</template>

<script setup>
import DashboardSidebar from '../../components/DashboardSidebar.vue'
</script>