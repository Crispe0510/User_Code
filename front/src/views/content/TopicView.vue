<template>
  <div>
    <div class="card">
      <div class="card__header flex-between">
        <h2>Topics</h2>
        <div style="display:flex;gap:10px;align-items:center">
          <select class="form-control" v-model="filterScenario" style="width:180px" @change="loadTopics">
            <option value="">All scenarios</option>
            <option v-for="s in scenarios" :key="s.id" :value="s.id">{{ s.icon }} {{ s.title }}</option>
          </select>
          <button class="btn btn-primary btn-sm" @click="openAdd">+ Add topic</button>
        </div>
      </div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else-if="topics.length===0" class="empty">No topics</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr><th>ID</th><th>Title</th><th>Subtitle</th><th>Scenario</th><th>Opening Qs</th><th>Deep Qs</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="t in topics" :key="t.id">
                <td style="font-size:12px;color:#888">{{ t.id }}</td>
                <td><strong>{{ t.title }}</strong></td>
                <td style="font-size:13px;color:#888">{{ t.titleSub }}</td>
                <td><span class="tag tag-blue">{{ t.scenarioId }}</span></td>
                <td>{{ t.opening?.length ?? 0 }}</td>
                <td>{{ t.deep?.length ?? 0 }}</td>
                <td><span :class="t.enabled===1?'tag tag-green':'tag tag-red'">{{ t.enabled===1?'Enabled':'Disabled' }}</span></td>
                <td>
                  <div class="actions">
                    <button class="btn btn-ghost btn-xs" @click="openEdit(t)">Edit</button>
                    <button class="btn btn-danger btn-xs" @click="handleDelete(t)">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Topic modal -->
    <div v-if="showModal" class="modal-mask" @click.self="showModal=false">
      <div class="modal" style="width:700px">
        <div class="modal__header">
          <h3>{{ editMode ? 'Edit topic' : 'Add topic' }}</h3>
          <button class="modal__close" @click="showModal=false">×</button>
        </div>
        <div class="modal__body">
          <div class="form-row">
            <div class="form-group"><label>Topic ID (ASCII)</label><input class="form-control" v-model="form.id" :disabled="editMode" /></div>
            <div class="form-group">
              <label>Scenario</label>
              <select class="form-control" v-model="form.scenarioId">
                <option v-for="s in scenarios" :key="s.id" :value="s.id">{{ s.title }}</option>
              </select>
            </div>
          </div>
          <div class="form-group"><label>Title</label><input class="form-control" v-model="form.title" /></div>
          <div class="form-group"><label>Subtitle (EN)</label><input class="form-control" v-model="form.titleSub" /></div>
          <div class="form-group"><label>Recommendation</label><textarea class="form-control" v-model="form.recommend"></textarea></div>
          <div class="form-group">
            <label>Opening questions <button class="btn btn-ghost btn-xs" style="margin-left:8px" @click="addQ('opening')">+ Add</button></label>
            <div v-for="(q, i) in form.opening" :key="i" style="display:flex;gap:8px;margin-bottom:8px">
              <input class="form-control" :value="q.content" @input="q.content=$event.target.value" :placeholder="`Question ${i+1}`" />
              <button class="btn btn-danger btn-xs" @click="removeQ('opening', i)">×</button>
            </div>
          </div>
          <div class="form-group">
            <label>Deep questions <button class="btn btn-ghost btn-xs" style="margin-left:8px" @click="addQ('deep')">+ Add</button></label>
            <div v-for="(q, i) in form.deep" :key="i" style="display:flex;gap:8px;margin-bottom:8px">
              <input class="form-control" :value="q.content" @input="q.content=$event.target.value" :placeholder="`Question ${i+1}`" />
              <button class="btn btn-danger btn-xs" @click="removeQ('deep', i)">×</button>
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
import { getScenarios, getTopics, addTopic, updateTopic, deleteTopic } from '../../api/index.js'

const scenarios = ref([])
const topics = ref([])
const loading = ref(true)
const filterScenario = ref('')
const showModal = ref(false)
const editMode = ref(false)
const form = ref({})

onMounted(async () => {
  const sRes = await getScenarios()
  if (sRes?.code === 200) scenarios.value = sRes.data
  await loadTopics()
})

async function loadTopics() {
  loading.value = true
  const res = await getTopics(filterScenario.value || undefined).catch(() => null)
  if (res?.code === 200) topics.value = res.data
  loading.value = false
}

function openAdd() {
  form.value = { opening: [], deep: [], enabled: 1, sortOrder: 99 }
  editMode.value = false; showModal.value = true
}

function openEdit(t) {
  form.value = {
    ...t,
    opening: (t.opening || []).map(q => ({ ...q })),
    deep: (t.deep || []).map(q => ({ ...q })),
  }
  editMode.value = true; showModal.value = true
}

function addQ(type) { form.value[type].push({ content: '', type }) }
function removeQ(type, i) { form.value[type].splice(i, 1) }

async function handleSave() {
  const res = editMode.value
    ? await updateTopic(form.value.id, form.value)
    : await addTopic(form.value)
  if (res?.code === 200) { showModal.value = false; loadTopics() }
  else alert(res?.msg || 'Request failed')
}

async function handleDelete(t) {
  if (!confirm(`Delete topic "${t.title}"?`)) return
  await deleteTopic(t.id)
  loadTopics()
}
</script>
