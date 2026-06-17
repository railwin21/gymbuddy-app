<template>
  <div class="flex min-h-screen bg-[#0a0b10] text-white font-sans selection:bg-red-500 selection:text-black">
    <DashboardSidebar />
    
    <main class="flex-grow p-6 lg:p-12 overflow-y-auto">
      <div class="max-w-4xl mx-auto mb-10">
        <div class="flex items-center gap-6">
          <router-link 
            to="/dashboard/profile" 
            class="group w-12 h-12 bg-[#161920] border border-gray-800 rounded-2xl flex items-center justify-center hover:border-red-500/50 transition-all duration-300 shadow-xl"
          >
            <span class="text-gray-400 group-hover:text-red-500 transform group-hover:-translate-x-1 transition-all text-xl">←</span>
          </router-link>
          <div>
            <h1 class="text-3xl font-black uppercase tracking-tight text-white leading-none">Edit Profile</h1>
            <p class="text-gray-500 text-[10px] font-bold uppercase tracking-[0.3em] mt-2">Personal Information • GymBuddy</p>
          </div>
        </div>
      </div>

      <div class="max-w-4xl mx-auto">
        <div class="bg-[#161920] rounded-[2.5rem] border border-gray-900 shadow-2xl overflow-hidden relative">
          <div class="h-1.5 w-full bg-gradient-to-r from-red-500 via-red-500 to-blue-500"></div>
          
          <div class="p-8 lg:p-14">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-10">
              
              <div class="space-y-3">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-widest px-1">Full Name</label>
                <div class="relative group">
                  <input 
                    v-model="profile.nama"
                    type="text"
                    placeholder="E.g. John Doe"
                    class="w-full bg-black/40 border border-gray-800 text-gray-200 p-4 rounded-2xl outline-none focus:border-red-500/50 focus:ring-4 focus:ring-red-500/5 transition-all duration-300 text-sm"
                  >
                </div>
              </div>

              <div class="space-y-3">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-widest px-1">Email Address</label>
                <input 
                  v-model="profile.email"
                  type="email"
                  placeholder="name@company.com"
                  class="w-full bg-black/40 border border-gray-800 text-gray-200 p-4 rounded-2xl outline-none focus:border-red-500/50 focus:ring-4 focus:ring-red-500/5 transition-all duration-300 text-sm"
                >
              </div>

              <div class="space-y-3">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-widest px-1">City</label>
                <input 
                  v-model="profile.kota"
                  type="text"
                  placeholder="Your city"
                  class="w-full bg-black/40 border border-gray-800 text-gray-200 p-4 rounded-2xl outline-none focus:border-red-500/50 focus:ring-4 focus:ring-red-500/5 transition-all duration-300 text-sm"
                >
              </div>

              <div class="space-y-3">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-widest px-1">Province</label>
                <input 
                  v-model="profile.propinsi"
                  type="text"
                  placeholder="Your province"
                  class="w-full bg-black/40 border border-gray-800 text-gray-200 p-4 rounded-2xl outline-none focus:border-red-500/50 focus:ring-4 focus:ring-red-500/5 transition-all duration-300 text-sm"
                >
              </div>

            </div>

            <div class="mt-16 pt-10 border-t border-gray-800/50 flex flex-col sm:flex-row items-center justify-between gap-8">
              
              <div class="flex items-center gap-4 w-full sm:w-auto">
                <router-link to="/dashboard/profile" class="flex-1 sm:flex-none text-center text-[10px] font-black uppercase tracking-widest text-gray-500 hover:text-white transition-colors px-6">
                  Cancel
                </router-link>
                
                <button 
                  @click="handleSave" 
                  :disabled="loading"
                  class="flex-1 sm:flex-none relative overflow-hidden group bg-red-500 disabled:bg-gray-800 text-black px-12 py-4 rounded-2xl font-black uppercase text-xs tracking-[0.2em] hover:bg-red-400 hover:scale-[1.02] active:scale-[0.98] transition-all duration-300 shadow-[0_0_20px_rgba(239,68,68,0.2)]"
                >
                  <span v-if="!loading">Save Profile</span>
                  <div v-else class="flex items-center gap-2">
                    <div class="w-3 h-3 border-2 border-black/20 border-t-black rounded-full animate-spin"></div>
                    <span>Saving...</span>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import DashboardSidebar from '../../components/DashboardSidebar.vue'
import api from '../../utils/api'

const router = useRouter()
const loading = ref(false)
const profile = ref({ id: null, nama: '', email: '', kota: '', propinsi: '' })

const fetchUserData = async () => {
  try {
    const { data } = await api.get('/auth/me')
    if (data) {
      profile.value = {
        id: data.id || data.id_user,
        nama: data.nama || '',
        email: data.email || '',
        kota: data.kota || '',
        propinsi: data.propinsi || ''
      }
    }
  } catch (err) {
    console.error('Fetch error:', err)
  }
}

const handleSave = async () => {
  if (!profile.value.id) return
  loading.value = true
  
  try {
    // Sesuai server.js: app.use('/api/user', userRoutes)
    // api.js baseURL sudah /api, jadi tembak ke /user/:id
    await api.put(`/user/${profile.value.id}`, {
      nama: profile.value.nama,
      email: profile.value.email,
      kota: profile.value.kota,
      propinsi: profile.value.propinsi
    })
    
    alert('Profile updated successfully!')
    router.push('/dashboard/profile')
  } catch (err) {
    console.error('Update Error:', err)
    const status = err.response?.status
    if (status === 404) {
      alert('Error 404: Jalur /api/user tidak ditemukan. Periksa backend.')
    } else {
      alert('Update failed: ' + (err.response?.data?.message || 'Server error'))
    }
  } finally {
    loading.value = false
  }
}

onMounted(fetchUserData)
</script>