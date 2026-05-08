<template>
  <div>
    <div class="card">
      <div class="card__header"><h2>Mood types</h2></div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr><th>ID</th><th>Emoji</th><th>Label</th><th>Color</th><th>Tip</th></tr>
            </thead>
            <tbody>
              <tr v-for="m in moods" :key="m.id">
                <td>{{ m.id }}</td>
                <td style="font-size:24px">{{ m.emoji }}</td>
                <td>{{ m.label }}</td>
                <td><span :style="{background:m.color,padding:'3px 10px',borderRadius:'8px',fontSize:'12px'}">{{ m.color }}</span></td>
                <td style="font-size:13px;color:#555;max-width:320px">{{ m.tip }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p style="margin-top:16px;font-size:13px;color:#aaa">Mood types are built in. Contact developers to change them.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMoodTypes } from '../../api/index.js'

const moods = ref([])
const loading = ref(true)

onMounted(async () => {
  const res = await getMoodTypes().catch(() => null)
  if (res?.code === 200) moods.value = res.data
  loading.value = false
})
</script>
