<template>
  <div>
    <!-- Toolbar -->
    <div class="card">
      <div class="card__header flex-between">
        <h2>Family members</h2>
        <div style="display:flex;gap:10px;align-items:center">
          <select class="form-control" v-model="filterUserId" style="width:200px" @change="load">
            <option value="">All users</option>
            <option v-for="u in h5Users" :key="u.id" :value="u.id">
              {{ u.name }} ({{ u.email }})
            </option>
          </select>
          <button class="btn btn-primary" @click="openAdd">+ Add member</button>
        </div>
      </div>
      <div class="card__body">
        <div v-if="loading" class="loading">Loading...</div>
        <div v-else-if="!members.length" class="empty">No family members yet</div>
        <div v-else class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Avatar</th>
                <th>Name</th>
                <th>Role</th>
                <th>Sort</th>
                <th>Owner</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="m in members" :key="m.id">
                <td style="font-size:0.8rem;color:#999">{{ m.id }}</td>
                <td style="font-size:1.5rem">{{ m.avatar || '👤' }}</td>
                <td>{{ m.name }}</td>
                <td>
                  <span :class="m.role === 'parent' ? 'tag tag-blue' : 'tag tag-purple'">
                    {{ m.role === 'parent' ? 'Parent' : 'Child' }}
                  </span>
                </td>
                <td>{{ m.sortOrder }}</td>
                <td>{{ getUserName(m.userId) }}</td>
                <td>
                  <div class="actions">
                    <button class="btn btn-warning btn-xs" @click="openEdit(m)">Edit</button>
                    <button class="btn btn-danger btn-xs" @click="handleDelete(m)">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal">
        <div class="modal__head">
          <h3>{{ editId ? 'Edit member' : 'Add member' }}</h3>
          <button class="modal__close" @click="closeModal">&#10005;</button>
        </div>
        <div class="modal__body">
          <div v-if="formErr" class="alert alert-danger">{{ formErr }}</div>

          <label class="form-label">H5 user <span class="req">*</span></label>
          <select class="form-control" v-model="form.userId" :disabled="!!editId">
            <option value="">Select user</option>
            <option v-for="u in h5Users" :key="u.id" :value="u.id">
              {{ u.name }} ({{ u.email }})
            </option>
          </select>

          <label class="form-label" style="margin-top:12px">Display name <span class="req">*</span></label>
          <input class="form-control" v-model="form.name" placeholder="e.g. Grandma, Dad, Alex" maxlength="64" />

          <label class="form-label" style="margin-top:12px">Role</label>
          <select class="form-control" v-model="form.role">
            <option value="parent">Parent</option>
            <option value="child">Child</option>
          </select>

          <label class="form-label" style="margin-top:12px">Avatar emoji</label>
          <div class="emoji-picker">
            <button
              v-for="e in avatarOptions"
              :key="e"
              type="button"
              class="emoji-btn"
              :class="{ 'is-active': form.avatar === e }"
              @click="form.avatar = e"
            >{{ e }}</button>
          </div>
          <input
            class="form-control"
            v-model="form.avatar"
            placeholder="Or type an emoji, e.g. 👵"
            maxlength="8"
            style="margin-top:6px"
          />

          <label class="form-label" style="margin-top:12px">Sort order (lower first)</label>
          <input class="form-control" type="number" v-model.number="form.sortOrder" min="1" />
        </div>
        <div class="modal__foot">
          <button class="btn" @click="closeModal">Cancel</button>
          <button class="btn btn-primary" :disabled="saving" @click="handleSave">
            {{ saving ? 'Saving...' : 'Save' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  getFamilyMembers,
  addFamilyMember,
  updateFamilyMember,
  deleteFamilyMember,
  getH5Users,
} from '../../api/index.js'

const members     = ref([])
const h5Users     = ref([])
const loading     = ref(false)
const filterUserId = ref('')

const showModal = ref(false)
const editId    = ref('')
const saving    = ref(false)
const formErr   = ref('')

const emptyForm = () => ({ userId: '', name: '', role: 'parent', avatar: '👤', sortOrder: 1 })
const form = ref(emptyForm())

const avatarOptions = ['👴', '👵', '👨', '👩', '🧑', '👦', '👧', '👶', '👤', '🧓', '🧔', '👱']

async function loadUsers() {
  const r = await getH5Users().catch(() => null)
  if (r?.code === 200) h5Users.value = r.data || []
}

async function load() {
  loading.value = true
  const uid = filterUserId.value ? Number(filterUserId.value) : undefined
  const r = await getFamilyMembers(uid).catch(() => null)
  members.value = r?.code === 200 ? (r.data || []) : []
  loading.value = false
}

onMounted(async () => {
  await loadUsers()
  await load()
})

function getUserName(userId) {
  const u = h5Users.value.find(x => x.id === userId)
  return u ? `${u.name} (${u.email})` : userId
}

function openAdd() {
  editId.value = ''
  form.value = emptyForm()
  formErr.value = ''
  showModal.value = true
}

function openEdit(m) {
  editId.value = m.id
  form.value = {
    userId: m.userId,
    name: m.name,
    role: m.role || 'parent',
    avatar: m.avatar || '👤',
    sortOrder: m.sortOrder ?? 1,
  }
  formErr.value = ''
  showModal.value = true
}

function closeModal() { showModal.value = false }

async function handleSave() {
  formErr.value = ''
  if (!form.value.userId) { formErr.value = 'Select an H5 user'; return }
  if (!form.value.name?.trim()) { formErr.value = 'Name is required'; return }
  saving.value = true
  const payload = { ...form.value, userId: Number(form.value.userId) }
  const r = editId.value
    ? await updateFamilyMember(editId.value, payload).catch(e => e?.response?.data || null)
    : await addFamilyMember(payload).catch(e => e?.response?.data || null)
  saving.value = false
  if (r?.code === 200) {
    closeModal()
    load()
  } else {
    formErr.value = r?.msg || 'Save failed. Try again.'
  }
}

async function handleDelete(m) {
  if (!confirm(`Delete member "${m.name}"? This cannot be undone.`)) return
  const r = await deleteFamilyMember(m.id).catch(e => e?.response?.data || null)
  if (r?.code === 200) {
    load()
  } else {
    alert(r?.msg || 'Delete failed')
  }
}
</script>

<style scoped>
.emoji-picker {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 4px;
}
.emoji-btn {
  font-size: 1.5rem;
  padding: 4px 6px;
  border-radius: 8px;
  background: #f3f4f6;
  cursor: pointer;
  border: 2px solid transparent;
  line-height: 1;
}
.emoji-btn.is-active {
  border-color: #6366f1;
  background: #eef2ff;
}
</style>
