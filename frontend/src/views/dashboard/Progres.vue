<template>
  <div class="flex min-h-screen bg-[#0a0a0a]">
    <DashboardSidebar class="fixed inset-y-0 left-0 z-50" />

    <main class="flex-grow p-8 text-white overflow-y-auto">
      <div class="p-8 lg:p-12 max-w-6xl mx-auto space-y-10">
        
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div>
            <h1 class="text-5xl font-black  tracking-tighter text-white uppercase">
              PROGRESS TRACKER
            </h1>
            <p class="text-gray-500 mt-2 font-medium">Catat dan pantau perkembangan latihan harianmu</p>
          </div>
          
          <button
            @click="showAddForm = !showAddForm"
            class="px-6 py-3 bg-red-500 text-black font-black rounded-xl hover:bg-red-400 transition-all shadow-[0_0_20px_rgba(239,68,68,0.2)] flex items-center gap-2 group"
          >
            <PlusIcon class="w-5 h-5 group-hover:rotate-90 transition-transform" />
            {{ showAddForm ? 'TUTUP FORM' : 'TAMBAH LATIHAN' }}
          </button>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="stat in summaryStats" :key="stat.label" 
               class="p-6 rounded-2xl bg-[#111111] border border-gray-900 hover:border-red-500/50 transition-all group">
            <div :class="`text-4xl font-black mb-1 ${stat.textColor} `">
              {{ stat.value }}
            </div>
            <div class="text-gray-500 text-xs uppercase tracking-[0.2em] font-bold group-hover:text-gray-300 transition-colors">
              {{ stat.label }}
            </div>
          </div>
        </div>

        <Transition name="fade-slide">
          <div v-if="showAddForm" class="p-8 rounded-3xl bg-[#111111] border border-gray-800 shadow-2xl">
            <div class="flex items-center gap-3 mb-8">
              <div class="w-2 h-8 bg-red-500 rounded-full"></div>
              <h2 class="text-2xl font-black  text-white">LOG NEW WORKOUT</h2>
            </div>
            
            <form @submit.prevent="handleAddWorkout" class="space-y-8">
              <div class="grid md:grid-cols-2 gap-8">
                <div class="space-y-2">
                  <label class="text-[10px] font-black uppercase text-gray-500 tracking-widest ml-1">Nama Latihan</label>
                  <input
                    v-model="newWorkout.exercise"
                    type="text"
                    placeholder="E.g. Bench Press"
                    class="w-full px-5 py-4 rounded-xl bg-black border border-gray-800 text-white focus:outline-none focus:border-red-500 focus:ring-1 focus:ring-red-500 transition-all"
                    required
                  />
                </div>
                <div class="grid grid-cols-3 gap-4">
                  <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-gray-500 tracking-widest ml-1">Sets</label>
                    <input v-model.number="newWorkout.sets" type="number" class="input-field" required />
                  </div>
                  <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-gray-500 tracking-widest ml-1">Reps</label>
                    <input v-model.number="newWorkout.reps" type="number" class="input-field" required />
                  </div>
                  <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-gray-500 tracking-widest ml-1">Kg</label>
                    <input v-model.number="newWorkout.weight" type="number" class="input-field" required />
                  </div>
                </div>
              </div>
              
              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase text-gray-500 tracking-widest ml-1">Catatan Tambahan</label>
                <input v-model="newWorkout.notes" type="text" placeholder="Grip lebih lebar, terasa ringan..." class="w-full px-5 py-4 rounded-xl bg-black border border-gray-800 text-white" />
              </div>

              <div class="flex gap-4 pt-4">
                <button type="submit" class="flex-1 py-4 bg-red-500 text-black font-black rounded-xl hover:bg-red-400 transition-all uppercase tracking-widest">Simpan Data</button>
                <button type="button" @click="showAddForm = false" class="px-8 py-4 bg-gray-900 text-white font-bold rounded-xl hover:bg-gray-800 transition-all uppercase tracking-widest text-xs">Batal</button>
              </div>
            </form>
          </div>
        </Transition>

        <div class="space-y-6">
          <div class="flex items-center gap-4">
             <h2 class="text-2xl font-black  text-white uppercase tracking-tighter">Riwayat Latihan</h2>
             <div class="flex-1 h-[1px] bg-gray-900"></div>
          </div>
          
          <TransitionGroup name="list" tag="div" class="grid gap-4">
            <div
              v-for="workout in workouts"
              :key="workout.id"
              class="p-6 rounded-2xl bg-[#111111] border border-gray-900 hover:border-gray-700 transition-all group flex items-center justify-between"
            >
              <div class="flex items-center gap-6">
                <div class="w-14 h-14 rounded-xl bg-red-500/10 border border-red-500/20 flex items-center justify-center group-hover:bg-red-500 group-hover:text-black transition-all duration-300">
                  <DumbbellIcon class="w-7 h-7 text-red-500 group-hover:text-black" />
                </div>
                <div>
                  <div class="flex items-center gap-3 mb-1">
                    <h3 class="font-bold text-xl text-white uppercase  tracking-tight">{{ workout.exercise }}</h3>
                    <span class="text-[10px] font-bold bg-white/5 border border-white/10 px-2 py-1 rounded text-gray-500 uppercase tracking-widest">{{ workout.date }}</span>
                  </div>
                  <div class="flex items-center gap-6 text-sm">
                    <div class="flex items-center gap-2">
                      <span class="text-gray-500 uppercase text-[10px] font-black">Volume:</span>
                      <span class="text-white font-bold">{{ workout.sets }} <span class="text-gray-600">×</span> {{ workout.reps }}</span>
                    </div>
                    <div class="flex items-center gap-2">
                      <span class="text-gray-500 uppercase text-[10px] font-black">Beban:</span>
                      <span class="text-red-500 font-black">{{ workout.weight }} KG</span>
                    </div>
                    <p v-if="workout.notes" class="text-gray-600  text-xs ml-2 border-l border-gray-800 pl-3">"{{ workout.notes }}"</p>
                  </div>
                </div>
              </div>
              <button
                @click="handleDeleteWorkout(workout.id)"
                class="p-3 text-gray-700 hover:text-red-500 hover:bg-red-500/10 rounded-full transition-all"
              >
                <TrashIcon class="w-5 h-5" />
              </button>
            </div>
          </TransitionGroup>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import DashboardSidebar from '../../components/DashboardSidebar.vue'
import { PlusIcon, TrashIcon, DumbbellIcon } from 'lucide-vue-next'

const showAddForm = ref(false)
const workouts = ref([
  { id: 1, date: "2026-04-14", exercise: "Bench Press", sets: 4, reps: 10, weight: 85, notes: "Felt strong" },
  { id: 2, date: "2026-04-14", exercise: "Squats", sets: 4, reps: 8, weight: 100, notes: "Good depth" }
])

const newWorkout = ref({ exercise: "", sets: null, reps: null, weight: null, notes: "" })

const summaryStats = computed(() => [
  { label: "Latihan Hari Ini", value: workouts.value.length, textColor: "text-red-500" },
  { label: "Total Sets", value: workouts.value.reduce((sum, w) => sum + w.sets, 0), textColor: "text-white" },
  { label: "Day Streak", value: 12, textColor: "text-white" },
  { label: "Total Workouts", value: 42, textColor: "text-white" }
])

const handleAddWorkout = () => {
  const payload = {
    id: Date.now(),
    date: new Date().toISOString().split("T")[0],
    ...newWorkout.value
  }
  workouts.value.unshift(payload)
  newWorkout.value = { exercise: "", sets: null, reps: null, weight: null, notes: "" }
  showAddForm.value = false
}

const handleDeleteWorkout = (id) => {
  workouts.value = workouts.value.filter(w => w.id !== id)
}
</script>

<style scoped>
.input-field {
  @apply w-full px-4 py-4 rounded-xl bg-black border border-gray-800 text-white focus:outline-none focus:border-red-500 transition-all;
}

.fade-slide-enter-active, .fade-slide-leave-active { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
.fade-slide-enter-from, .fade-slide-leave-to { opacity: 0; transform: translateY(-30px); }

.list-enter-active, .list-leave-active { transition: all 0.4s ease; }
.list-enter-from { opacity: 0; transform: translateX(-30px); }
.list-leave-to { opacity: 0; transform: translateX(30px); }
</style>