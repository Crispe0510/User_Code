<template>
  <div>
    <div class="card">
      <div class="card__header flex-between">
        <h2>Scenarios</h2>
        <button class="btn btn-primary btn-sm" @click="openAdd">+ Add scenario</button>
      </div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr><th>Cover</th><th>ID</th><th>Icon</th><th>Title</th><th>Subtitle</th><th>Topics</th><th>Sort</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="s in scenarios" :key="s.id">
                <td>
                  <img v-if="s.cover" :src="s.cover" style="width:52px;height:36px;object-fit:cover;border-radius:6px;border:1px solid #eee" />
                  <span v-else style="color:#ccc;font-size:12px">No cover</span>
                </td>
                <td style="font-size:12px;color:#888">{{ s.id }}</td>
                <td style="font-size:20px">{{ s.icon }}</td>
                <td><strong>{{ s.title }}</strong></td>
                <td style="color:#888;font-size:13px;max-width:180px">{{ s.subtitle }}</td>
                <td>{{ s.topicCount }}</td>
                <td>{{ s.sortOrder }}</td>
                <td>
                  <span :class="s.enabled===1?'tag tag-green':'tag tag-red'">{{ s.enabled===1?'Enabled':'Disabled' }}</span>
                </td>
                <td>
                  <div class="actions">
                    <button class="btn btn-ghost btn-xs" @click="openEdit(s)">Edit</button>
                    <button class="btn btn-warning btn-xs" @click="toggleEnabled(s)">{{ s.enabled===1?'Disable':'Enable' }}</button>
                    <button class="btn btn-danger btn-xs" @click="handleDelete(s)">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div v-if="showModal" class="modal-mask" @click.self="showModal=false">
      <div class="modal">
        <div class="modal__header">
          <h3>{{ editMode ? 'Edit scenario' : 'Add scenario' }}</h3>
          <button class="modal__close" @click="showModal=false">×</button>
        </div>
        <div class="modal__body">
          <div class="form-row">
            <div class="form-group"><label>Scenario ID (ASCII)</label><input class="form-control" v-model="form.id" :disabled="editMode" placeholder="e.g. s7" /></div>
            <div class="form-group"><label>Icon (emoji)</label><input class="form-control" v-model="form.icon" placeholder="🏖" /></div>
          </div>
          <div class="form-group"><label>Title</label><input class="form-control" v-model="form.title" /></div>
          <div class="form-group"><label>Subtitle</label><input class="form-control" v-model="form.subtitle" /></div>
          <div class="form-group">
            <label>Cover image</label>
            <ImageUpload v-model="form.cover" />
          </div>
          <div class="form-row">
            <div class="form-group"><label>Sort order</label><input class="form-control" type="number" v-model.number="form.sortOrder" /></div>
            <div class="form-group">
              <label>Status</label>
              <select class="form-control" v-model.number="form.enabled">
                <option :value="1">Enabled</option><option :value="0">Disabled</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal__footer">
          <button class="btn btn-ghost" @click="showModal=false">Cancel</button>
          <button class="btn btn-primary" @click="handleSave">Save</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getScenarios, addScenario, updateScenario, toggleScenario, deleteScenario } from '../../api/index.js'
import ImageUpload from '../../components/ImageUpload.vue'

const scenarios = ref([])
const loading   = ref(true)
const showModal = ref(false)
const editMode  = ref(false)
const form      = ref({})

onMounted(loadData)

async function loadData() {
  loading.value = true
  const res = await getScenarios().catch(() => null)
  if (res?.code === 200) scenarios.value = res.data
  loading.value = false
}

function openAdd() { form.value = { enabled: 1, sortOrder: 99, cover: '' }; editMode.value = false; showModal.value = true }
function openEdit(s) { form.value = { ...s }; editMode.value = true; showModal.value = true }

async function handleSave() {
  const res = editMode.value
    ? await updateScenario(form.value.id, form.value)
    : await addScenario(form.value)
  if (res?.code === 200) { showModal.value = false; loadData() }
  else alert(res?.msg || 'Request failed')
}

async function toggleEnabled(s) {
  const newVal = s.enabled === 1 ? 0 : 1
  await toggleScenario(s.id, newVal)
  s.enabled = newVal
}

async function handleDelete(s) {
  if (!confirm(`Delete scenario "${s.title}"?`)) return
  await deleteScenario(s.id)
  loadData()
}
</script>
