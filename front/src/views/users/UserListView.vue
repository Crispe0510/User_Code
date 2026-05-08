<template>
  <div>
    <div class="card">
      <div class="card__header flex-between">
        <h2>H5 users</h2>
        <div class="search-bar" style="margin:0">
          <input class="form-control" v-model="keyword" placeholder="Search name or email..." style="width:220px" />
        </div>
      </div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else-if="filtered.length === 0" class="empty">No users</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Joined</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="u in filtered" :key="u.id">
                <td>{{ u.id }}</td>
                <td>{{ u.name }}</td>
                <td>{{ u.email }}</td>
                <td><span :class="u.identity==='parent'?'tag tag-blue':'tag tag-purple'">{{ u.identity === 'parent' ? 'Parent' : 'Child' }}</span></td>
                <td><span :class="u.status===1?'tag tag-green':'tag tag-red'">{{ u.status===1?'Enabled':'Disabled' }}</span></td>
                <td>{{ formatDate(u.createdAt) }}</td>
                <td>
                  <div class="actions">
                    <button class="btn btn-warning btn-xs" @click="toggleStatus(u)">{{ u.status===1?'Disable':'Enable' }}</button>
                    <button class="btn btn-danger btn-xs" @click="handleDelete(u)">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getH5Users, updateH5UserStatus, deleteH5User } from '../../api/index.js'

const users = ref([])
const loading = ref(true)
const keyword = ref('')

onMounted(loadData)

async function loadData() {
  loading.value = true
  const res = await getH5Users().catch(() => null)
  if (res?.code === 200) users.value = res.data
  loading.value = false
}

const filtered = computed(() => {
  const kw = keyword.value.toLowerCase()
  return kw ? users.value.filter(u => u.name.toLowerCase().includes(kw) || u.email.toLowerCase().includes(kw)) : users.value
})

async function toggleStatus(u) {
  const newStatus = u.status === 1 ? 0 : 1
  await updateH5UserStatus(u.id, newStatus)
  u.status = newStatus
}

async function handleDelete(u) {
  if (!confirm(`Delete user "${u.name}"?`)) return
  await deleteH5User(u.id)
  users.value = users.value.filter(x => x.id !== u.id)
}

function formatDate(dt) {
  if (!dt) return '-'
  return new Date(dt).toLocaleDateString('en-US')
}
</script>
