<template>
  <div>
    <div class="card">
      <div class="card__header flex-between">
        <h2>Admin accounts</h2>
        <button class="btn btn-primary btn-sm" @click="openAdd">+ Add admin</button>
      </div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr><th>ID</th><th>Username</th><th>Display name</th><th>Role</th><th>Status</th><th>Last login</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="a in admins" :key="a.id">
                <td>{{ a.id }}</td>
                <td>{{ a.username }}</td>
                <td>{{ a.name }}</td>
                <td><span :class="a.role==='super'?'tag tag-purple':'tag tag-blue'">{{ a.role }}</span></td>
                <td><span :class="a.status===1?'tag tag-green':'tag tag-red'">{{ a.status===1?'Enabled':'Disabled' }}</span></td>
                <td>{{ formatDate(a.lastLogin) }}</td>
                <td>
                  <div class="actions">
                    <button class="btn btn-ghost btn-xs" @click="openEdit(a)">Edit</button>
                    <button class="btn btn-danger btn-xs" @click="handleDelete(a)">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-mask" @click.self="showModal=false">
      <div class="modal">
        <div class="modal__header">
          <h3>{{ editMode ? 'Edit admin' : 'Add admin' }}</h3>
          <button class="modal__close" @click="showModal=false">×</button>
        </div>
        <div class="modal__body">
          <div class="form-group"><label>Username</label><input class="form-control" v-model="form.username" :disabled="editMode" /></div>
          <div class="form-group"><label>Display name</label><input class="form-control" v-model="form.name" /></div>
          <div v-if="!editMode" class="form-group"><label>Password</label><input class="form-control" type="password" v-model="form.password" /></div>
          <div class="form-group">
            <label>Role</label>
            <select class="form-control" v-model="form.role">
              <option value="admin">admin</option>
              <option value="super">super</option>
            </select>
          </div>
          <div class="form-group">
            <label>Status</label>
            <select class="form-control" v-model="form.status">
              <option :value="1">Enabled</option>
              <option :value="0">Disabled</option>
            </select>
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
import { getAdmins, addAdmin, updateAdmin, deleteAdmin } from '../../api/index.js'

const admins = ref([])
const loading = ref(true)
const showModal = ref(false)
const editMode = ref(false)
const form = ref({})

onMounted(loadData)

async function loadData() {
  loading.value = true
  const res = await getAdmins().catch(() => null)
  if (res?.code === 200) admins.value = res.data
  loading.value = false
}

function openAdd() { form.value = { role: 'admin', status: 1 }; editMode.value = false; showModal.value = true }
function openEdit(a) { form.value = { ...a }; editMode.value = true; showModal.value = true }

async function handleSave() {
  if (editMode.value) {
    await updateAdmin(form.value.id, form.value)
  } else {
    const res = await addAdmin(form.value)
    if (res?.code !== 200) { alert(res?.msg || 'Save failed'); return }
  }
  showModal.value = false
  loadData()
}

async function handleDelete(a) {
  if (!confirm(`Delete "${a.name}"?`)) return
  await deleteAdmin(a.id)
  admins.value = admins.value.filter(x => x.id !== a.id)
}

function formatDate(dt) {
  if (!dt) return '-'
  return new Date(dt).toLocaleString('en-US')
}
</script>
