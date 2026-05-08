<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import html2canvas from 'html2canvas'
import { getTimeline, postReportTimeline } from '../api/index.js'
import { useAuth } from '../composables/useAuth'
import { AUTH_KEY } from '../constants.js'

const router = useRouter()
const { isGuest } = useAuth()
const generating = ref(true)
const progress = ref(0)
const lineReady = ref(false)
const reportTimeline = ref([])
const reportCaptureRef = ref(null)
const toast = ref({ show: false, text: '', isError: false })

const showAddSheet = ref(false)
const addSaving = ref(false)
const addErr = ref('')
const addForm = ref({
  title: '',
  eventDate: '',
  place: '',
  detail: '',
  type: 'topic',
})

const monthlyStats = [
  { label: 'Topics Explored', value: 8 },
  { label: 'Questions Asked', value: 24 },
  { label: 'Moods Shared', value: 18 },
  { label: 'Days Active', value: 12 },
]

function showToast(text, isError = false) {
  toast.value = { show: true, text, isError }
  window.setTimeout(() => { toast.value.show = false }, 3200)
}

function displayDate(item) {
  return item?.eventDate || item?.date || ''
}

function hasRealLoginToken() {
  try {
    const s = JSON.parse(localStorage.getItem(AUTH_KEY) || '{}')
    return !!(s && s.token && !s.isGuest)
  } catch {
    return false
  }
}

function defaultEventDate() {
  return new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })
}

onMounted(async () => {
  const res = await getTimeline().catch(() => null)
  if (res?.code === 200) reportTimeline.value = res.data || []

  const interval = setInterval(() => {
    progress.value = Math.min(progress.value + 8, 100)
    if (progress.value >= 100) {
      clearInterval(interval)
      setTimeout(() => {
        generating.value = false
        setTimeout(() => { lineReady.value = true }, 200)
      }, 400)
    }
  }, 80)
})

function back() { router.push('/') }

/** 导出时间线 + 统计为 JSON 文件 */
function exportReport() {
  try {
    const data = {
      exportedAt: new Date().toISOString(),
      stats: monthlyStats,
      timeline: reportTimeline.value,
    }
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json;charset=utf-8' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `family-journal-${Date.now()}.json`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
    showToast('Export ready — check your downloads folder.')
  } catch (e) {
    showToast(String(e?.message || e), true)
  }
}

/** 将报告区域导出为 PNG（需 DOM 已渲染） */
async function saveAsImage() {
  await nextTick()
  const el = reportCaptureRef.value
  if (!el) {
    showToast('Nothing to capture yet.', true)
    return
  }
  try {
    const canvas = await html2canvas(el, {
      scale: Math.min(2, window.devicePixelRatio || 1),
      useCORS: true,
      logging: false,
      backgroundColor: getComputedStyle(document.documentElement).getPropertyValue('--c-bg').trim() || '#fff8f5',
    })
    const url = canvas.toDataURL('image/png')
    const a = document.createElement('a')
    a.href = url
    a.download = `family-journal-${Date.now()}.png`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    showToast('Image saved — check your downloads folder.')
  } catch (e) {
    showToast(String(e?.message || e) || 'Could not create image.', true)
  }
}

async function copyItemText(item) {
  const text = `${item.title}\n${displayDate(item)} ${item.place ? `· ${item.place}` : ''}\n${item.detail || ''}`
  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text)
      showToast('Copied to clipboard.')
      return
    }
  } catch { /* fall through */ }
  if (navigator.share) {
    try {
      await navigator.share({ title: item.title, text })
      showToast('Shared.')
      return
    } catch { /* user cancel */ }
  }
  showToast('Copy not available in this browser.', true)
}

function shareHeroSummary() {
  const text = '2026 Family Journal — Our Story Together'
  if (navigator.share) {
    navigator.share({ title: 'Family Journal', text }).catch(() => showToast('Tap Export to download data.'))
  } else {
    showToast('Use Export or Save as Image below.')
  }
}

async function refreshTimeline() {
  const res = await getTimeline().catch(() => null)
  if (res?.code === 200) reportTimeline.value = res.data || []
}

function openAddEntry() {
  addErr.value = ''
  if (isGuest.value || !hasRealLoginToken()) {
    showToast('Please sign in from the home page to add timeline entries.（请先登录后再添加。）', true)
    return
  }
  addForm.value = {
    title: '',
    eventDate: defaultEventDate(),
    place: '',
    detail: '',
    type: 'topic',
  }
  showAddSheet.value = true
}

function closeAddEntry() {
  showAddSheet.value = false
}

async function submitAddEntry() {
  addErr.value = ''
  if (!addForm.value.title.trim()) {
    addErr.value = 'Please enter a title.'
    return
  }
  if (!addForm.value.eventDate.trim()) {
    addErr.value = 'Please enter a date.'
    return
  }
  addSaving.value = true
  let r
  try {
    r = await postReportTimeline({
      title: addForm.value.title.trim(),
      eventDate: addForm.value.eventDate.trim(),
      place: addForm.value.place.trim() || null,
      detail: addForm.value.detail.trim() || null,
      type: addForm.value.type,
    })
  } catch (e) {
    const d = e?.response?.data
    r = typeof d === 'object' && d !== null ? d : { code: 0, msg: e?.message || 'Network error' }
  }
  addSaving.value = false
  if (r?.code === 200) {
    showAddSheet.value = false
    await refreshTimeline()
    showToast('Saved to your timeline.')
  } else {
    addErr.value = r?.msg || 'Save failed.'
  }
}
</script>

<template>
  <div class="app-shell page-pad report">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">Family Journal</h1>
        <p class="h5-sub">Your journey together, beautifully visualised</p>
      </div>
    </nav>

    <!-- Generating animation -->
    <div v-if="generating" class="report__generating card animate-in">
      <div class="gen__icon" aria-hidden="true">&#128218;</div>
      <h2>Generating your family journal...</h2>
      <p>Weaving your memories and conversations together</p>
      <div class="gen__bar-wrap">
        <div class="gen__bar" :style="{ width: progress + '%' }" />
      </div>
      <span class="gen__pct">{{ progress }}%</span>
    </div>

    <!-- Content (shown after generation) -->
    <template v-else>
      <div ref="reportCaptureRef" class="report__capture">
      <!-- Scroll card -->
      <button type="button" class="scroll-hero animate-in" @click="shareHeroSummary">
        <div class="scroll-hero__roll" />
        <div class="scroll-hero__paper">
          <p class="scroll-hero__sub">2026 Family Journal</p>
          <h2>Our Story Together</h2>
          <p>Every conversation is a thread in the tapestry of family — tap to share.</p>
        </div>
        <div class="scroll-hero__roll" />
      </button>

      <!-- Monthly stats -->
      <div class="report__stats animate-in" :style="{ animationDelay: '0.05s' }">
        <div v-for="s in monthlyStats" :key="s.label" class="stat-card card">
          <span class="stat-card__val">{{ s.value }}</span>
          <span class="stat-card__label">{{ s.label }}</span>
        </div>
      </div>

      <!-- Timeline -->
      <section class="report__history card animate-in" :style="{ animationDelay: '0.1s' }">
        <div class="history__head">
          <h2>Activity Timeline</h2>
          <div class="history__actions">
            <button type="button" class="linkish" @click="openAddEntry">+ Add</button>
            <button type="button" class="linkish" @click="exportReport">Export</button>
          </div>
        </div>

        <div class="timeline">
          <div class="timeline__track" :class="{ 'is-ready': lineReady }" />
          <p v-if="!reportTimeline.length" class="timeline__empty">
            No activities yet. Tap <strong>+ Add</strong> to log a memory (sign in required).
          </p>
          <article
            v-for="(item, i) in reportTimeline"
            :key="item.id"
            class="timeline__item slide-in"
            :style="{ animationDelay: `${0.15 + i * 0.1}s` }"
          >
            <button type="button" class="timeline__node">
              <span class="timeline__dot" :class="`t-${item.type || 'topic'}`" />
            </button>
            <div class="timeline__card">
              <time>{{ displayDate(item) }}</time>
              <h3>{{ item.title }}</h3>
              <p class="timeline__place">&#128205; {{ item.place || '—' }}</p>
              <p class="timeline__detail">{{ item.detail }}</p>
              <div class="timeline__btns">
                <button type="button" class="link-btn" @click="copyItemText(item)">Share</button>
                <button type="button" class="link-btn" @click="copyItemText(item)">Copy</button>
              </div>
            </div>
          </article>
        </div>
      </section>

      <!-- Footer actions -->
      <div class="report__footer-actions animate-in" :style="{ animationDelay: '0.3s' }">
        <button type="button" class="btn-pill btn-pill--primary" @click="saveAsImage">Save as Image</button>
        <button type="button" class="btn-pill btn-pill--ghost" @click="back">Back to Home</button>
      </div>
      </div>
    </template>

    <div v-if="toast.show" class="report-toast" :class="{ 'report-toast--err': toast.isError }" role="status">
      {{ toast.text }}
    </div>

    <!-- Add timeline entry -->
    <transition name="sheet">
      <div v-if="showAddSheet" class="sheet-overlay" @click.self="closeAddEntry">
        <div class="sheet sheet--add">
          <div class="sheet__handle" />
          <div class="sheet__head">
            <h3>Log an activity</h3>
            <button type="button" class="sheet__close" @click="closeAddEntry">&#10005;</button>
          </div>
          <p v-if="addErr" class="add-form__err">{{ addErr }}</p>
          <label class="add-form__label">Title</label>
          <input v-model="addForm.title" class="add-form__input" maxlength="256" placeholder="e.g. Talked about weekend plans" />

          <label class="add-form__label">Date</label>
          <input v-model="addForm.eventDate" class="add-form__input" placeholder="e.g. 25 Apr 2026" />

          <label class="add-form__label">Place (optional)</label>
          <input v-model="addForm.place" class="add-form__input" maxlength="128" placeholder="e.g. Home · Kitchen" />

          <label class="add-form__label">Details (optional)</label>
          <textarea v-model="addForm.detail" class="add-form__textarea" rows="3" maxlength="2000" placeholder="What happened?" />

          <label class="add-form__label">Type</label>
          <div class="add-form__types">
            <button type="button" :class="['add-type', { 'is-on': addForm.type === 'topic' }]" @click="addForm.type = 'topic'">Topic</button>
            <button type="button" :class="['add-type', { 'is-on': addForm.type === 'browse' }]" @click="addForm.type = 'browse'">Browse</button>
            <button type="button" :class="['add-type', { 'is-on': addForm.type === 'report' }]" @click="addForm.type = 'report'">Report</button>
          </div>

          <div class="add-form__btns">
            <button type="button" class="btn-pill btn-pill--ghost" style="flex:1" @click="closeAddEntry">Cancel</button>
            <button type="button" class="btn-pill btn-pill--primary" style="flex:2" :disabled="addSaving" @click="submitAddEntry">
              {{ addSaving ? 'Saving…' : 'Save' }}
            </button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
/* Generating */
.report__generating {
  padding: 30px 18px; text-align: center;
  background: linear-gradient(145deg, #fafafa, #fff);
}
.gen__icon { font-size: 2.8rem; margin-bottom: 12px; }
.report__generating h2 { margin: 0 0 6px; font-size: 1.15rem; }
.report__generating p { margin: 0 0 20px; font-size: 0.85rem; color: var(--c-muted); }

.gen__bar-wrap {
  height: 8px; background: #e5e7eb;
  border-radius: 999px; overflow: hidden; margin-bottom: 8px;
}
.gen__bar {
  height: 100%; border-radius: 999px;
  background: linear-gradient(90deg, var(--c-primary), #f97316, var(--c-primary));
  background-size: 200% 100%;
  animation: shimmer 1.5s linear infinite;
  transition: width 0.08s linear;
}
.gen__pct { font-size: 0.82rem; color: var(--c-muted); }

/* Scroll hero */
.scroll-hero {
  width: 100%; border: none; padding: 0; margin-bottom: 14px;
  display: grid; grid-template-columns: 28px 1fr 28px;
  align-items: stretch; background: transparent; cursor: pointer;
  filter: drop-shadow(0 10px 24px rgba(45,42,50,0.12));
  transition: transform 0.3s;
}
.scroll-hero:active { transform: scale(0.99); }

.scroll-hero__roll {
  background: linear-gradient(90deg, #c4a574, #e8d5b2 45%, #a67c52);
}
.scroll-hero__roll:first-child { border-radius: 12px 4px 4px 12px; }
.scroll-hero__roll:last-child { border-radius: 4px 12px 12px 4px; }

.scroll-hero__paper {
  background: linear-gradient(180deg, #fffef8, #faf6e9);
  padding: 18px 14px; text-align: center;
  border-top: 1px solid rgba(166,124,82,0.3);
  border-bottom: 1px solid rgba(166,124,82,0.3);
}
.scroll-hero__sub { margin: 0 0 4px; font-size: 0.72rem; color: #7c6246; letter-spacing: 0.08em; }
.scroll-hero__paper h2 { margin: 0 0 6px; font-family: var(--font-display); font-size: 1.2rem; color: #5c4030; }
.scroll-hero__paper p { margin: 0; font-size: 0.82rem; color: #6b5344; line-height: 1.45; }

/* Stats */
.report__stats {
  display: grid; grid-template-columns: repeat(2, 1fr);
  gap: 8px; margin-bottom: 14px;
}
.stat-card {
  display: flex; flex-direction: column; align-items: center;
  padding: 14px 8px; text-align: center;
  background: linear-gradient(145deg, #fff5f7, #fff);
}
.stat-card__val { font-size: 1.75rem; font-weight: 800; color: var(--c-primary); margin-bottom: 4px; }
.stat-card__label { font-size: 0.72rem; color: var(--c-muted); }

/* Timeline */
.report__history { padding: 14px 14px 20px; overflow: hidden; }
.history__head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; gap: 8px; }
.history__head h2 { margin: 0; font-size: 1rem; flex: 1; min-width: 0; }
.history__actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
.linkish { font-size: 0.8rem; color: var(--c-primary-dark); font-weight: 600; }
.timeline__empty {
  font-size: 0.85rem; color: var(--c-muted); text-align: center;
  padding: 16px 12px 8px; margin: 0; line-height: 1.5;
}

.timeline { position: relative; padding-left: 6px; }

.timeline__track {
  position: absolute; left: 19px; top: 14px; bottom: 14px;
  width: 3px; background: rgba(232,93,117,0.18); border-radius: 4px;
  transform: scaleY(0); transform-origin: top;
  transition: transform 1s cubic-bezier(0.22,1,0.36,1);
}
.timeline__track.is-ready { transform: scaleY(1); }

.timeline__item {
  position: relative; display: grid;
  grid-template-columns: 40px 1fr; gap: 6px 10px;
  margin-bottom: 18px;
}

.timeline__node {
  width: 40px; height: 40px; padding: 0; border: none;
  background: transparent; display: flex; align-items: center; justify-content: center;
  position: relative; z-index: 1;
}

.timeline__dot {
  width: 14px; height: 14px; border-radius: 50%;
  background: var(--c-primary); box-shadow: 0 0 0 5px rgba(232,93,117,0.15);
  animation: pulse-dot 2.4s ease-in-out infinite;
  display: block;
}
.timeline__dot.t-browse { background: var(--c-accent); box-shadow: 0 0 0 5px rgba(107,155,209,0.18); }
.timeline__dot.t-report { background: #9b7ebd; box-shadow: 0 0 0 5px rgba(155,126,189,0.18); animation-delay: 0.6s; }

.timeline__card { background: #fafafa; border-radius: 14px; padding: 12px 14px; box-shadow: var(--shadow); }
.timeline__card time { font-size: 0.72rem; color: var(--c-muted); }
.timeline__card h3 { margin: 4px 0 5px; font-size: 0.95rem; }
.timeline__place { margin: 0 0 4px; font-size: 0.78rem; color: var(--c-primary-dark); font-weight: 600; }
.timeline__detail { margin: 0; font-size: 0.82rem; color: var(--c-muted); line-height: 1.45; }
.timeline__btns { margin-top: 10px; display: flex; gap: 14px; }
.link-btn { font-size: 0.8rem; font-weight: 600; color: var(--c-primary-dark); padding: 0; }

/* Footer */
.report__footer-actions { margin-top: 18px; display: flex; flex-direction: column; gap: 10px; }
.report__footer-actions .btn-pill { width: 100%; text-align: center; }

.report__capture { min-height: 1px; }

.report-toast {
  position: fixed; left: 50%; bottom: calc(24px + var(--safe-bottom));
  transform: translateX(-50%); z-index: 200;
  max-width: 90%; padding: 10px 16px; border-radius: 12px;
  font-size: 0.85rem; font-weight: 600; text-align: center;
  background: rgba(45, 42, 50, 0.88); color: #fff;
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
  animation: toast-in 0.25s ease;
}
.report-toast--err { background: rgba(185, 28, 28, 0.92); }
@keyframes toast-in {
  from { opacity: 0; transform: translateX(-50%) translateY(8px); }
  to { opacity: 1; transform: translateX(-50%) translateY(0); }
}

/* Add-entry sheet */
.sheet-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 150;
  display: flex; align-items: flex-end;
}
.sheet {
  width: 100%; max-width: 480px; margin: 0 auto;
  background: #fff; border-radius: 24px 24px 0 0;
  padding: 16px 18px calc(22px + var(--safe-bottom));
}
.sheet__handle {
  width: 40px; height: 4px; border-radius: 2px;
  background: #e5e7eb; margin: 0 auto 14px;
}
.sheet__head {
  display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;
}
.sheet__head h3 { margin: 0; font-size: 1rem; }
.sheet__close {
  width: 32px; height: 32px; border-radius: 50%; background: #f3f4f6;
  font-size: 0.85rem; border: none; cursor: pointer;
}
.add-form__err { color: #dc2626; font-size: 0.82rem; margin: 0 0 10px; }
.add-form__label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--c-muted); margin: 10px 0 4px; }
.add-form__label:first-of-type { margin-top: 0; }
.add-form__input, .add-form__textarea {
  width: 100%; padding: 10px 12px; border-radius: 12px; border: 1px solid #e5e7eb;
  font-size: 0.88rem; font-family: inherit; color: var(--c-text);
}
.add-form__types { display: flex; gap: 8px; margin-top: 4px; }
.add-type {
  flex: 1; padding: 8px; border-radius: 12px; font-size: 0.78rem; font-weight: 600;
  border: 2px solid #e5e7eb; background: #fafafa; color: var(--c-text);
}
.add-type.is-on { border-color: var(--c-primary); background: rgba(232,93,117,0.08); color: var(--c-primary-dark); }
.add-form__btns { display: flex; gap: 10px; margin-top: 18px; }

.sheet-enter-active, .sheet-leave-active { transition: all 0.3s ease; }
.sheet-enter-from, .sheet-leave-to { opacity: 0; }
.sheet-enter-from .sheet, .sheet-leave-to .sheet { transform: translateY(100%); }
</style>
