<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  getMoodTypes, getFamilyMoods, getWeeklyMoods, checkinMood,
  getMyFamilyMembers, addMyFamilyMember, updateMyFamilyMember, deleteMyFamilyMember,
  getLinkableUsers,
} from '../api/index.js'
import { useAuth } from '../composables/useAuth'
import { AUTH_KEY } from '../constants.js'

const router = useRouter()
const { isGuest } = useAuth()

/** 真实登录（非 Guest）且本地有 token，请求头才会带 Authorization */
function hasRealLoginToken() {
  try {
    const s = JSON.parse(localStorage.getItem(AUTH_KEY) || '{}')
    return !!(s && s.token && !s.isGuest)
  } catch {
    return false
  }
}

// ── 兜底心情数据（API 失败时使用）─────────────────────
const DEFAULT_MOOD_TYPES = [
  { id: 'happy',    emoji: '😊', label: 'Happy',         color: '#FFF9C4' },
  { id: 'peaceful', emoji: '😌', label: 'Peaceful',      color: '#B2EBF2' },
  { id: 'grateful', emoji: '🥰', label: 'Grateful',      color: '#FCE4EC' },
  { id: 'anxious',  emoji: '😟', label: 'A Bit Worried', color: '#CFD8DC' },
  { id: 'tired',    emoji: '😴', label: 'Tired',         color: '#D1C4E9' },
  { id: 'excited',  emoji: '🎉', label: 'Excited',       color: '#FFE0B2' },
]

const moodTypes     = ref([...DEFAULT_MOOD_TYPES])
const familyMembers = ref([])
const weeklyData    = ref({})
const weekDayLabels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']

const myMood    = ref(null)
const myNote    = ref('')
const submitted = ref(false)
const activeMember = ref(null)
const showSheet    = ref(false)
const showHistory  = ref(false)
const historyLogs  = ref([])

// ── 家庭成员管理 ──────────────────────────────────────
const showManage   = ref(false)
const manageList   = ref([])
const editingMember = ref(null)   // null=新增；object=编辑
const memberForm   = ref({ name: '', role: 'parent', avatar: '👤', linkedUserId: '' })
const memberErr    = ref('')
const memberSaving = ref(false)
const linkableUsers = ref([])
const AVATAR_OPTIONS = ['👴', '👵', '👨', '👩', '🧑', '👦', '👧', '👶', '🧓', '🧔', '👱', '👤']

onMounted(async () => {
  try {
    const [mRes, fRes, wRes] = await Promise.all([
      getMoodTypes().catch(() => null),
      getFamilyMoods().catch(() => null),
      getWeeklyMoods().catch(() => null),
    ])
    if (mRes?.code === 200 && mRes.data?.length) moodTypes.value = mRes.data
    if (fRes?.code === 200) familyMembers.value = fRes.data
    if (wRes?.code === 200) {
      weeklyData.value = wRes.data
      // 汇总所有日志供历史记录使用
      const all = []
      Object.values(wRes.data).forEach(logs => all.push(...logs))
      historyLogs.value = all.sort((a, b) => new Date(b.logDate) - new Date(a.logDate))
    }
  } catch (e) {
    console.error('Mood board load error:', e)
  }
})

function selectMood(mood) { myMood.value = mood }

async function submitMood() {
  if (!myMood.value) return
  await checkinMood({ memberId: 'm3', moodId: myMood.value.id, note: myNote.value }).catch(() => {})
  submitted.value = true
}

function openMember(m) {
  if (!m.today) return
  activeMember.value = m
  showSheet.value = true
}

function closeSheet() { showSheet.value = false; activeMember.value = null }

function getTip(moodId) {
  const tips = {
    happy:    "Great time to share what made them smile — ask about the highlight of their day!",
    peaceful: "They're in a calm state. Perfect for a gentle, relaxed chat.",
    grateful: "They're feeling appreciative. Share something you're thankful for too.",
    anxious:  "Be gentle. Listen more, speak less. Just knowing you're there helps.",
    tired:    "Give them space. A simple 'I'm here' or a quiet moment together goes a long way.",
    excited:  "Match their energy! Ask what's got them excited and celebrate together.",
  }
  return tips[moodId] || ''
}

function getMoodInfo(id) {
  return moodTypes.value.find(m => m.id === id) || DEFAULT_MOOD_TYPES.find(m => m.id === id) || { emoji: '❓', label: id, color: '#e5e7eb' }
}

function getWeekMoods(memberId) {
  const logs = weeklyData.value[memberId] || []
  // 补齐为 7 天（不足则填 null）
  const filled = [...logs]
  while (filled.length < 7) filled.push(null)
  return filled.slice(0, 7).reverse()
}

function getMemberName(memberId) {
  const m = familyMembers.value.find(x => x.id === memberId)
  return m ? `${m.avatar} ${m.name}` : memberId
}

function viewHistory() { showHistory.value = true }
function closeHistory() { showHistory.value = false }
function goReport() { router.push('/report') }
function back() { router.push('/') }

// ── 管理家庭成员 ──────────────────────────────────────
async function openManage() {
  const [r, uRes] = await Promise.all([
    getMyFamilyMembers().catch(() => null),
    getLinkableUsers().catch(() => null),
  ])
  manageList.value = r?.code === 200 ? (r.data || []) : []
  linkableUsers.value = uRes?.code === 200 ? (uRes.data || []) : []
  editingMember.value = null
  memberForm.value = { name: '', role: 'parent', avatar: '👤', linkedUserId: '' }
  memberErr.value = ''
  showManage.value = true
}
function closeManage() { showManage.value = false }

function startAdd() {
  editingMember.value = null
  memberForm.value = { name: '', role: 'parent', avatar: '👤', linkedUserId: '' }
  memberErr.value = ''
}
function startEdit(m) {
  editingMember.value = m
  memberForm.value = {
    name: m.name,
    role: m.role || 'parent',
    avatar: m.avatar || '👤',
    linkedUserId: m.linkedUserId ? String(m.linkedUserId) : '',
  }
  memberErr.value = ''
}
function cancelForm() { editingMember.value = null; memberErr.value = '' }

async function saveMember() {
  memberErr.value = ''
  if (!memberForm.value.name.trim()) { memberErr.value = 'Please enter a name.'; return }
  if (isGuest.value || !hasRealLoginToken()) {
    memberErr.value =
      'Guest mode cannot save. Go back to the home page, tap Sign in or Register, then try again. ' +
      '（访客无法保存，请返回首页使用「登录 / 注册」后再添加家人。）'
    return
  }
  memberSaving.value = true
  const payload = {
    name: memberForm.value.name.trim(),
    role: memberForm.value.role,
    avatar: memberForm.value.avatar,
    linkedUserId: memberForm.value.linkedUserId ? Number(memberForm.value.linkedUserId) : null,
  }
  let r
  try {
    r = editingMember.value
      ? await updateMyFamilyMember(editingMember.value.id, payload)
      : await addMyFamilyMember(payload)
  } catch (e) {
    const d = e?.response?.data
    r = typeof d === 'object' && d !== null ? d : { code: 0, msg: e?.message || 'Network error' }
  }
  memberSaving.value = false
  if (r?.code === 200) {
    const list = await getMyFamilyMembers().catch(() => null)
    manageList.value = list?.code === 200 ? (list.data || []) : manageList.value
    familyMembers.value = manageList.value
    editingMember.value = null
  } else {
    const code = r?.code
    const msg = r?.msg
    if (code === 401 || /登录|sign in|token/i.test(String(msg || ''))) {
      memberErr.value =
        (msg || 'Session invalid.') +
        ' If the server was restarted, please sign out and sign in again.（若刚重启过后端，请退出并重新登录。）'
    } else {
      memberErr.value = msg || 'Save failed. Please try again.'
    }
  }
}

async function deleteMember(m) {
  if (!confirm(`Remove "${m.name}" from your family list?`)) return
  const r = await deleteMyFamilyMember(m.id).catch(e => e?.response?.data || null)
  if (r?.code === 200) {
    manageList.value = manageList.value.filter(x => x.id !== m.id)
    familyMembers.value = manageList.value
  } else {
    alert(r?.msg || 'Delete failed.')
  }
}
</script>

<template>
  <div class="app-shell page-pad mood">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">Mood Board</h1>
        <p class="h5-sub">Share how you feel today. See how the family is doing.</p>
      </div>
    </nav>

    <!-- Today's check-in -->
    <section v-if="!submitted" class="mood__checkin card animate-in">
      <h2>How are you feeling today?</h2>
      <p class="mood__checkin-hint">Choose one that best describes your mood right now</p>

      <div class="mood__grid">
        <button
          v-for="m in moodTypes"
          :key="m.id"
          type="button"
          class="mood__btn"
          :class="{ 'is-active': myMood?.id === m.id }"
          :style="myMood?.id === m.id ? { background: m.color, borderColor: '#c94f6d' } : {}"
          @click="selectMood(m)"
        >
          <span class="mood__emoji">{{ m.emoji }}</span>
          <span class="mood__label">{{ m.label }}</span>
        </button>
      </div>

      <div v-if="myMood" class="mood__note-wrap animate-in">
        <p class="mood__note-label">Add a short note (optional)</p>
        <input
          v-model="myNote"
          type="text"
          class="mood__note-input"
          placeholder="e.g. Went for a lovely walk this morning..."
          maxlength="80"
        />
        <span class="mood__note-count">{{ myNote.length }}/80</span>
      </div>

      <button
        type="button"
        class="btn-pill btn-pill--primary mood__submit"
        :disabled="!myMood"
        @click="submitMood"
      >
        Share with Family &#10084;
      </button>
    </section>

    <!-- Submitted state -->
    <section v-else class="mood__shared card animate-in">
      <div class="mood__shared-inner">
        <span class="mood__shared-emoji">{{ myMood.emoji }}</span>
        <h2>Shared!</h2>
        <p>Your family can now see you're feeling <strong>{{ myMood.label }}</strong> today.</p>
        <button type="button" class="btn-pill btn-pill--ghost" style="margin-top:10px" @click="submitted = false; myMood = null; myNote = ''">
          Update Mood
        </button>
      </div>
    </section>

    <!-- Family mood board -->
    <section class="mood__family animate-in" :style="{ animationDelay: '0.07s' }">
      <div class="mood__family-head">
        <h2 class="mood__section-title" style="margin:0">Family's Mood Today</h2>
        <button type="button" class="manage-btn" @click="openManage">
          &#9881; Manage
        </button>
      </div>
      <div class="mood__members">
        <button
          v-for="m in familyMembers"
          :key="m.id"
          type="button"
          class="member-card card"
          :class="{ 'has-mood': !!m.today, 'is-you': m.id === 'm3' }"
          @click="openMember(m)"
        >
          <span class="member-card__avatar">{{ m.avatar }}</span>
          <span class="member-card__name">{{ m.name }}</span>
          <div v-if="m.today" class="member-card__mood" :style="{ background: getMoodInfo(m.today.moodId).color }">
            <span>{{ getMoodInfo(m.today.moodId).emoji }}</span>
            <span class="member-card__mood-label">{{ getMoodInfo(m.today.moodId).label }}</span>
          </div>
          <div v-else class="member-card__empty">
            <span>Not shared yet</span>
          </div>
          <p v-if="m.today" class="member-card__time">{{ m.today.logTime }}</p>
        </button>
      </div>
    </section>

    <!-- Weekly trend -->
    <section class="mood__week card animate-in" :style="{ animationDelay: '0.12s' }">
      <h2 class="mood__section-title">This Week at a Glance</h2>
      <div class="week__days">
        <span v-for="d in weekDayLabels" :key="d" class="week__day-label">{{ d }}</span>
      </div>
      <template v-if="familyMembers.length">
        <div v-for="m in familyMembers" :key="m.id" class="week__row">
          <span class="week__name">{{ m.avatar }} {{ m.name }}</span>
          <div class="week__dots">
            <span
              v-for="(log, i) in getWeekMoods(m.id)"
              :key="i"
              class="week__dot"
              :class="{ 'week__dot--empty': !log }"
              :style="log ? { background: getMoodInfo(log.moodId).color, borderColor: getMoodInfo(log.moodId).color } : {}"
              :title="log ? getMoodInfo(log.moodId).label : 'No record'"
            />
          </div>
        </div>
      </template>
      <p v-else class="week__empty">Family data loading...</p>
    </section>

    <!-- CTA buttons -->
    <div class="mood__actions animate-in" :style="{ animationDelay: '0.18s' }">
      <button type="button" class="btn-pill btn-pill--ghost mood__action-btn" @click="viewHistory">
        View History
      </button>
      <button type="button" class="btn-pill btn-pill--primary mood__action-btn" @click="goReport">
        Generate Report
      </button>
    </div>

    <!-- History modal -->
    <transition name="sheet">
      <div v-if="showHistory" class="sheet-overlay" @click.self="closeHistory">
        <div class="sheet">
          <div class="sheet__handle" />
          <div class="sheet__head">
            <h3>Mood History</h3>
            <button type="button" class="sheet__close" @click="closeHistory">&#10005;</button>
          </div>
          <div class="history__list">
            <template v-if="historyLogs.length">
              <div v-for="log in historyLogs" :key="log.id" class="history__item">
                <span
                  class="history__dot"
                  :style="{ background: getMoodInfo(log.moodId).color }"
                >{{ getMoodInfo(log.moodId).emoji }}</span>
                <div class="history__info">
                  <p class="history__date">{{ log.logDate }} · {{ getMemberName(log.memberId) }}</p>
                  <p class="history__label">{{ getMoodInfo(log.moodId).label }}</p>
                  <p v-if="log.note" class="history__note">"{{ log.note }}"</p>
                </div>
              </div>
            </template>
            <p v-else class="week__empty">No mood records yet.</p>
          </div>
        </div>
      </div>
    </transition>

    <!-- Bottom sheet: member detail -->
    <transition name="sheet">
      <div v-if="showSheet && activeMember" class="sheet-overlay" @click.self="closeSheet">
        <div class="sheet">
          <div class="sheet__handle" />
          <div class="sheet__head">
            <span class="sheet__avatar">{{ activeMember.avatar }}</span>
            <div>
              <h3>{{ activeMember.name }}</h3>
              <p>Shared at {{ activeMember.today.logTime }}</p>
            </div>
            <button type="button" class="sheet__close" @click="closeSheet">&#10005;</button>
          </div>
          <div class="sheet__mood" :style="{ background: getMoodInfo(activeMember.today.moodId).color }">
            <span class="sheet__mood-emoji">{{ getMoodInfo(activeMember.today.moodId).emoji }}</span>
            <span>{{ getMoodInfo(activeMember.today.moodId).label }}</span>
          </div>
          <p class="sheet__note">"{{ activeMember.today.note }}"</p>
          <div class="sheet__tip card">
            <h4>Communication Tip</h4>
            <p>{{ getTip(activeMember.today.moodId) }}</p>
          </div>
          <div class="sheet__btns">
            <button type="button" class="btn-pill btn-pill--primary" style="width:100%;text-align:center" @click="alert('Demo: Start a conversation with ' + activeMember.name)">
              Start a Conversation
            </button>
          </div>
        </div>
      </div>
    </transition>

    <!-- Manage family members sheet -->
    <transition name="sheet">
      <div v-if="showManage" class="sheet-overlay" @click.self="closeManage">
        <div class="sheet sheet--manage">
          <div class="sheet__handle" />
          <div class="sheet__head">
            <h3>My Family</h3>
            <button type="button" class="sheet__close" @click="closeManage">&#10005;</button>
          </div>

          <!-- Member list -->
          <div class="manage__list">
            <div v-if="!manageList.length" class="manage__empty">
              No family members yet. Add one below!
            </div>
            <div v-for="m in manageList" :key="m.id" class="manage__item">
              <span class="manage__av">{{ m.avatar }}</span>
              <div class="manage__info">
                <strong>{{ m.name }}</strong>
                <span class="manage__role">{{ m.role === 'parent' ? 'Parent' : 'Child' }}</span>
                <span v-if="m.linkedUserId" class="manage__linked">
                  &#128279; Linked · {{ linkableUsers.find(u => u.id === m.linkedUserId)?.name || 'User #'+m.linkedUserId }}
                </span>
              </div>
              <div class="manage__item-btns">
                <button type="button" class="manage__icon-btn" @click="startEdit(m)">&#9998;</button>
                <button type="button" class="manage__icon-btn manage__icon-btn--del" @click="deleteMember(m)">&#128465;</button>
              </div>
            </div>
          </div>

          <!-- Add / edit inline form -->
          <div class="manage__form card">
            <p class="manage__form-title">{{ editingMember ? 'Edit Member' : 'Add Member' }}</p>
            <p v-if="memberErr" class="manage__err">{{ memberErr }}</p>

            <label class="manage__label">Name</label>
            <input v-model="memberForm.name" class="manage__input" placeholder="e.g. Grandma / Dad" maxlength="64" />

            <label class="manage__label" style="margin-top:10px">Role</label>
            <div class="manage__role-row">
              <button type="button"
                class="manage__role-btn"
                :class="{ 'is-active': memberForm.role === 'parent' }"
                @click="memberForm.role = 'parent'">
                &#128106; Parent
              </button>
              <button type="button"
                class="manage__role-btn"
                :class="{ 'is-active': memberForm.role === 'child' }"
                @click="memberForm.role = 'child'">
                &#128103; Child
              </button>
            </div>

            <label class="manage__label" style="margin-top:10px">Avatar</label>
            <div class="manage__av-picker">
              <button v-for="e in AVATAR_OPTIONS" :key="e" type="button"
                class="manage__av-btn"
                :class="{ 'is-active': memberForm.avatar === e }"
                @click="memberForm.avatar = e">{{ e }}</button>
            </div>

            <label class="manage__label" style="margin-top:12px">
              Link to Registered User
              <span class="manage__label-hint">（关联后双方可在同一话题下共享聊天记录）</span>
            </label>
            <select class="manage__input" v-model="memberForm.linkedUserId">
              <option value="">— Not linked —</option>
              <option v-for="u in linkableUsers" :key="u.id" :value="String(u.id)">
                {{ u.name }}（{{ u.email }}）
              </option>
            </select>
            <p v-if="!linkableUsers.length" class="manage__label-hint" style="margin-top:4px">
              No other registered users found yet.
            </p>

            <div class="manage__form-btns">
              <button v-if="editingMember" type="button" class="btn-pill btn-pill--ghost" style="flex:1" @click="cancelForm">
                Cancel
              </button>
              <button type="button" class="btn-pill btn-pill--primary" style="flex:2" :disabled="memberSaving" @click="saveMember">
                {{ memberSaving ? 'Saving…' : (editingMember ? 'Update' : '+ Add') }}
              </button>
            </div>
          </div>

          <p v-if="isGuest || !hasRealLoginToken()" class="manage__login-tip">
            &#9888; Guest mode cannot save. Use <strong>Sign in / Register</strong> on the home page first.
            （访客无法保存，请返回首页登录或注册。）
          </p>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
/* Check-in */
.mood__checkin { padding: 18px; margin-bottom: 16px; }
.mood__checkin h2 { margin: 0 0 4px; font-size: 1.1rem; }
.mood__checkin-hint { margin: 0 0 14px; font-size: 0.82rem; color: var(--c-muted); }

.mood__grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-bottom: 14px; }

.mood__btn {
  display: flex; flex-direction: column; align-items: center; gap: 5px;
  padding: 12px 6px; border-radius: 14px;
  background: #f9fafb; border: 2px solid transparent;
  transition: all 0.2s; cursor: pointer;
}
.mood__btn.is-active { transform: scale(1.04); }
.mood__emoji { font-size: 1.6rem; }
.mood__label { font-size: 0.72rem; font-weight: 600; color: var(--c-text); text-align: center; }

.mood__note-wrap { position: relative; margin-bottom: 14px; }
.mood__note-label { margin: 0 0 6px; font-size: 0.8rem; color: var(--c-muted); }
.mood__note-input {
  width: 100%; padding: 10px 44px 10px 12px;
  border: 1px solid #e5e7eb; border-radius: 12px;
  font-size: 0.88rem; color: var(--c-text);
}
.mood__note-count {
  position: absolute; right: 10px; bottom: 10px;
  font-size: 0.7rem; color: var(--c-muted);
}

.mood__submit { width: 100%; text-align: center; }
.mood__submit:disabled { opacity: 0.5; pointer-events: none; }

/* Shared */
.mood__shared { padding: 24px 16px; margin-bottom: 16px; text-align: center; }
.mood__shared-inner { display: flex; flex-direction: column; align-items: center; gap: 8px; }
.mood__shared-emoji { font-size: 2.5rem; }
.mood__shared h2 { margin: 0; }
.mood__shared p { margin: 0; font-size: 0.9rem; color: var(--c-muted); }

/* Family section */
.mood__section-title { margin: 0 0 12px; font-size: 1rem; font-weight: 700; }
.mood__family { margin-bottom: 14px; }
.mood__family-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
.manage-btn {
  font-size: 0.75rem; font-weight: 600; color: var(--c-primary-dark);
  padding: 4px 12px; border-radius: 999px;
  background: rgba(232,93,117,0.1); border: 1px solid rgba(232,93,117,0.25);
}

.mood__members { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }

.member-card {
  display: flex; flex-direction: column; align-items: center; gap: 5px;
  padding: 12px 8px; border: none; cursor: pointer; transition: transform 0.15s;
}
.member-card.has-mood:active { transform: scale(0.97); }
.member-card.is-you { border: 2px dashed var(--c-primary); }

.member-card__avatar { font-size: 1.9rem; }
.member-card__name { font-size: 0.78rem; font-weight: 700; }

.member-card__mood {
  display: flex; flex-direction: column; align-items: center; gap: 3px;
  padding: 6px 12px; border-radius: 12px; width: 100%;
}
.member-card__mood span { font-size: 1.1rem; }
.member-card__mood-label { font-size: 0.65rem; font-weight: 600; color: var(--c-text); }

.member-card__empty { padding: 6px; }
.member-card__empty span { font-size: 0.65rem; color: var(--c-muted); text-align: center; display: block; }

.member-card__time { margin: 0; font-size: 0.65rem; color: var(--c-muted); }

/* Weekly */
.mood__week { padding: 14px; margin-bottom: 14px; }
.week__days { display: grid; grid-template-columns: 80px repeat(7, 1fr); gap: 4px; margin-bottom: 8px; }
.week__day-label { font-size: 0.68rem; color: var(--c-muted); text-align: center; }
.week__row { display: grid; grid-template-columns: 80px repeat(7, 1fr); gap: 4px; align-items: center; margin-bottom: 8px; }
.week__name { font-size: 0.78rem; font-weight: 600; }
.week__dots { display: contents; }
.week__dot {
  width: 22px; height: 22px; border-radius: 50%;
  border: 2px solid #e5e7eb;
  justify-self: center;
  display: block;
  transition: transform 0.15s;
}
.week__dot--empty {
  background: #f3f4f6 !important;
  border-color: #e5e7eb !important;
}
.week__empty { font-size: 0.82rem; color: var(--c-muted); text-align: center; padding: 10px 0 2px; margin: 0; }

/* Actions */
.mood__actions { display: flex; gap: 10px; }
.mood__action-btn { flex: 1; text-align: center; }

/* History list */
.history__list { max-height: 60vh; overflow-y: auto; padding: 4px 0; }
.history__item {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 12px 0; border-bottom: 1px solid #f3f4f6;
}
.history__item:last-child { border-bottom: none; }
.history__dot {
  width: 40px; height: 40px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 1.3rem; flex-shrink: 0;
}
.history__info { flex: 1; min-width: 0; }
.history__date { margin: 0 0 2px; font-size: 0.72rem; color: var(--c-muted); }
.history__label { margin: 0 0 2px; font-size: 0.88rem; font-weight: 700; }
.history__note { margin: 0; font-size: 0.78rem; color: var(--c-muted); font-style: italic; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

/* Bottom sheet */
.sheet-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 100;
  display: flex; align-items: flex-end;
}

.sheet {
  width: 100%; max-width: 480px; margin: 0 auto;
  background: #fff; border-radius: 24px 24px 0 0;
  padding: 16px 18px calc(24px + var(--safe-bottom));
}

.sheet__handle {
  width: 40px; height: 4px; border-radius: 2px;
  background: #e5e7eb; margin: 0 auto 16px;
}

.sheet__head {
  display: flex; align-items: center; gap: 12px; margin-bottom: 14px;
}
.sheet__avatar { font-size: 2rem; }
.sheet__head h3 { margin: 0 0 3px; font-size: 1rem; }
.sheet__head p { margin: 0; font-size: 0.78rem; color: var(--c-muted); }
.sheet__close {
  margin-left: auto; width: 32px; height: 32px;
  border-radius: 50%; background: #f3f4f6; font-size: 0.85rem;
}

.sheet__mood {
  display: flex; align-items: center; gap: 10px;
  padding: 12px 14px; border-radius: 14px; margin-bottom: 12px;
}
.sheet__mood-emoji { font-size: 1.6rem; }
.sheet__mood span:last-child { font-weight: 700; font-size: 1rem; }

.sheet__note {
  margin: 0 0 12px; font-size: 0.9rem; color: var(--c-text);
  font-style: italic; line-height: 1.5;
}

.sheet__tip { padding: 12px 14px; margin-bottom: 14px; background: #f9fafb; }
.sheet__tip h4 { margin: 0 0 6px; font-size: 0.85rem; color: var(--c-primary-dark); }
.sheet__tip p { margin: 0; font-size: 0.85rem; color: var(--c-muted); line-height: 1.5; }

.sheet__btns { margin-top: 4px; }

/* Manage sheet */
.sheet--manage { max-height: 90vh; overflow-y: auto; }
.manage__list { margin-bottom: 14px; display: flex; flex-direction: column; gap: 8px; }
.manage__empty { font-size: 0.82rem; color: var(--c-muted); text-align: center; padding: 8px 0; }
.manage__item {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 12px; border-radius: 14px; background: #f9fafb;
}
.manage__av { font-size: 1.5rem; flex-shrink: 0; }
.manage__info { flex: 1; display: flex; flex-direction: column; }
.manage__info strong { font-size: 0.9rem; }
.manage__role { font-size: 0.7rem; color: var(--c-muted); }
.manage__linked { font-size: 0.68rem; color: var(--c-accent); font-weight: 600; margin-top: 2px; }
.manage__label-hint { font-size: 0.68rem; color: var(--c-muted); font-weight: normal; margin-left: 4px; }
.manage__item-btns { display: flex; gap: 6px; }
.manage__icon-btn {
  width: 30px; height: 30px; border-radius: 8px; font-size: 0.9rem;
  background: #e5e7eb; color: var(--c-text);
}
.manage__icon-btn--del { background: #fee2e2; color: #dc2626; }

.manage__form { padding: 14px; margin-bottom: 6px; }
.manage__form-title { margin: 0 0 10px; font-size: 0.88rem; font-weight: 700; }
.manage__err { font-size: 0.8rem; color: #dc2626; margin: 0 0 8px; }
.manage__label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--c-muted); margin-bottom: 4px; }
.manage__input {
  width: 100%; padding: 9px 12px; border-radius: 12px;
  border: 1px solid #e5e7eb; font-size: 0.88rem; font-family: inherit;
}
.manage__role-row { display: flex; gap: 8px; }
.manage__role-btn {
  flex: 1; padding: 8px; border-radius: 12px; font-size: 0.82rem; font-weight: 600;
  background: #f3f4f6; border: 2px solid transparent; color: var(--c-text);
}
.manage__role-btn.is-active { border-color: var(--c-primary); background: rgba(232,93,117,0.08); color: var(--c-primary-dark); }
.manage__av-picker { display: flex; flex-wrap: wrap; gap: 6px; }
.manage__av-btn {
  font-size: 1.4rem; padding: 4px 6px; border-radius: 8px;
  background: #f3f4f6; border: 2px solid transparent; line-height: 1;
}
.manage__av-btn.is-active { border-color: var(--c-primary); background: rgba(232,93,117,0.08); }
.manage__form-btns { display: flex; gap: 8px; margin-top: 12px; }
.manage__login-tip {
  text-align: center; font-size: 0.78rem; color: #f59e0b;
  margin: 4px 0 0; padding: 0 4px;
}

/* Transition */
.sheet-enter-active, .sheet-leave-active { transition: all 0.35s cubic-bezier(0.32, 0.72, 0, 1); }
.sheet-enter-from { opacity: 0; }
.sheet-enter-from .sheet { transform: translateY(100%); }
.sheet-leave-to { opacity: 0; }
.sheet-leave-to .sheet { transform: translateY(100%); }
</style>
