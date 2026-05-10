<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  getTopicDetail,
  getCustomScenarios,
  getTopicChatMessages,
  postTopicChatMessage,
  postAiReply,
  getFamilyMoods,
} from '../api/index.js'
import { useAuth } from '../composables/useAuth'

const route = useRoute()
const router = useRouter()
const { displayName } = useAuth()

const topicTitle = ref('Conversation')
const messages = ref([])
const familyMembers = ref([])
const activeVoice = ref('me')
const draft = ref('')
const loading = ref(true)
const sending = ref(false)
const aiThinking = ref(false)
const listEl = ref(null)

const scenarioKey = () => String(route.params.scenarioId)
const topicKey = () => String(route.params.topicId)

async function loadTopicTitle() {
  const sid = scenarioKey()
  if (sid.startsWith('custom-')) {
    const raw = sid.replace('custom-', '')
    const cRes = await getCustomScenarios().catch(() => null)
    if (cRes?.code === 200) {
      const scen = cRes.data.find(s => String(s.id) === String(raw))
      const t = scen?.topics?.find(x => String(x.id) === String(topicKey()))
      if (t?.title) topicTitle.value = t.title
    }
  } else {
    const res = await getTopicDetail(topicKey())
    if (res.code === 200 && res.data?.title) topicTitle.value = res.data.title
  }
}

async function loadMessages() {
  const r = await getTopicChatMessages(scenarioKey(), topicKey()).catch(() => null)
  if (r?.code === 200) messages.value = Array.isArray(r.data) ? r.data : []
}

async function loadFamily() {
  const r = await getFamilyMoods().catch(() => null)
  if (r?.code === 200) familyMembers.value = r.data || []
}

function scrollBottom() {
  nextTick(() => {
    const el = listEl.value
    if (el) el.scrollTop = el.scrollHeight
  })
}

onMounted(async () => {
  loading.value = true
  await Promise.all([loadTopicTitle(), loadFamily(), loadMessages()])
  loading.value = false
  scrollBottom()
})

watch(messages, () => scrollBottom(), { deep: true })

function back() {
  router.push(`/topics/${scenarioKey()}/${topicKey()}`)
}

function pickVoice(id) {
  activeVoice.value = id
}

async function send() {
  const text = draft.value.trim()
  if (!text || sending.value) return
  sending.value = true
  let body
  if (activeVoice.value === 'me') {
    body = {
      scenarioKey: scenarioKey(),
      topicKey: topicKey(),
      senderType: 'me',
      senderName: displayName.value || 'Me',
      content: text,
    }
  } else {
    const m = familyMembers.value.find(x => x.id === activeVoice.value)
    if (!m) { sending.value = false; return }
    body = {
      scenarioKey: scenarioKey(),
      topicKey: topicKey(),
      senderType: 'family',
      memberId: m.id,
      senderName: m.name,
      content: text,
    }
  }
  const r = await postTopicChatMessage(body).catch(() => null)
  if (r?.code === 200 && r.data) {
    messages.value = [...messages.value, r.data]
    draft.value = ''
    sending.value = false
    // Auto AI reply after every user message
    await askAi()
    return
  }
  sending.value = false
}

async function askAi() {
  if (aiThinking.value) return
  aiThinking.value = true
  const r = await postAiReply({
    scenarioKey: scenarioKey(),
    topicKey: topicKey(),
    topicTitle: topicTitle.value,
  }).catch(() => null)
  if (r?.code === 200 && r.data) {
    messages.value = [...messages.value, r.data]
  }
  aiThinking.value = false
}

function formatTime(msg) {
  if (!msg?.createdAt) return ''
  const s = String(msg.createdAt)
  return s.length >= 16 ? s.slice(0, 16).replace('T', ' ') : s
}

function isMine(msg) { return msg.senderType === 'me' }
function isAi(msg)   { return msg.senderType === 'ai' }
</script>

<template>
  <div class="chat app-shell">
    <header class="chat__head">
      <button type="button" class="h5-nav__back chat__back" @click="back">&#8592;</button>
      <div class="chat__head-text">
        <h1 class="chat__title">{{ topicTitle }}</h1>
        <p class="chat__sub">Switch voice to speak as a family member. Tap ✨ for AI suggestions.</p>
      </div>
    </header>

    <div ref="listEl" class="chat__list">
      <p v-if="loading" class="chat__hint">Loading…</p>
      <template v-else>
        <p v-if="!messages.length" class="chat__hint">
          No messages yet — say hello, or tap ✨ to let AI start the conversation!
        </p>
        <div
          v-for="msg in messages"
          :key="msg.id"
          class="chat__row"
          :class="{
            'chat__row--mine': isMine(msg),
            'chat__row--ai':   isAi(msg),
          }"
        >
          <div class="chat__bubble-wrap">
            <span class="chat__who">
              <span v-if="isAi(msg)" class="chat__ai-badge">✨ AI</span>
              <template v-else>{{ isMine(msg) ? (msg.senderName || 'Me') : (msg.senderName || 'Family') }}</template>
            </span>
            <div
              class="chat__bubble"
              :class="{
                'chat__bubble--mine': isMine(msg),
                'chat__bubble--ai':   isAi(msg),
              }"
            >
              {{ msg.content }}
            </div>
            <span class="chat__time">{{ formatTime(msg) }}</span>
          </div>
        </div>

        <!-- AI thinking indicator -->
        <div v-if="aiThinking" class="chat__row chat__row--ai">
          <div class="chat__bubble-wrap">
            <span class="chat__who"><span class="chat__ai-badge">✨ AI</span></span>
            <div class="chat__bubble chat__bubble--ai chat__bubble--thinking">
              <span class="dot"></span><span class="dot"></span><span class="dot"></span>
            </div>
          </div>
        </div>
      </template>
    </div>

    <footer class="chat__footer">
      <!-- AI button row -->
      <div class="chat__ai-row">
        <button
          type="button"
          class="chat__ai-btn"
          :disabled="aiThinking"
          @click="askAi"
        >
          <span>✨</span>
          <span>{{ aiThinking ? 'AI is thinking…' : 'Ask AI' }}</span>
        </button>
        <span class="chat__ai-hint">Get a conversation suggestion</span>
      </div>

      <!-- Voice selector -->
      <p class="chat__voice-label">Send as</p>
      <div class="chat__voices">
        <button
          type="button"
          class="chat__chip"
          :class="{ 'is-active': activeVoice === 'me' }"
          @click="pickVoice('me')"
        >
          Me
        </button>
        <button
          v-for="m in familyMembers"
          :key="m.id"
          type="button"
          class="chat__chip"
          :class="{ 'is-active': activeVoice === m.id }"
          @click="pickVoice(m.id)"
        >
          <span class="chat__chip-av">{{ m.avatar }}</span>
          {{ m.name }}
        </button>
      </div>

      <!-- Input row -->
      <div class="chat__input-row">
        <textarea
          v-model="draft"
          class="chat__input"
          rows="2"
          maxlength="2000"
          placeholder="Type a message…"
          @keydown.enter.exact.prevent="send"
        />
        <button
          type="button"
          class="btn-pill btn-pill--primary chat__send"
          :disabled="sending || !draft.trim()"
          @click="send"
        >
          Send
        </button>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.chat {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  padding-bottom: calc(var(--safe-bottom) + 8px);
}

/* ── header ── */
.chat__head {
  display: flex; align-items: flex-start; gap: 8px;
  padding: 12px 16px 10px;
  background: var(--c-card);
  box-shadow: 0 4px 20px rgba(45,42,50,0.06);
  position: sticky; top: 0; z-index: 2;
}
.chat__back {
  margin-top: 2px; flex-shrink: 0;
  width: 40px; height: 40px; border-radius: 12px;
  background: rgba(232,93,117,0.1); color: var(--c-primary-dark); font-size: 1.1rem;
}
.chat__head-text { min-width: 0; }
.chat__title { margin: 0; font-size: 1.05rem; font-weight: 700; line-height: 1.25; }
.chat__sub { margin: 4px 0 0; font-size: 0.72rem; color: var(--c-muted); line-height: 1.4; }

/* ── message list ── */
.chat__list {
  flex: 1; overflow-y: auto;
  padding: 14px 16px 12px;
  display: flex; flex-direction: column; gap: 12px;
}
.chat__hint {
  text-align: center; color: var(--c-muted); font-size: 0.85rem; margin: 24px 0;
}

.chat__row { display: flex; justify-content: flex-start; }
.chat__row--mine { justify-content: flex-end; }
.chat__row--ai   { justify-content: center; }

.chat__bubble-wrap {
  max-width: 88%;
  display: flex; flex-direction: column; align-items: flex-start;
}
.chat__row--mine .chat__bubble-wrap { align-items: flex-end; }
.chat__row--ai   .chat__bubble-wrap { align-items: center; max-width: 92%; }

.chat__who {
  font-size: 0.68rem; font-weight: 600; color: var(--c-muted);
  margin-bottom: 4px; padding: 0 4px;
}
.chat__ai-badge {
  display: inline-flex; align-items: center; gap: 3px;
  padding: 2px 8px; border-radius: 999px;
  background: linear-gradient(135deg, #7c3aed22, #c026d322);
  color: #7c3aed; font-size: 0.68rem; font-weight: 700;
}

/* bubbles */
.chat__bubble {
  padding: 10px 14px; border-radius: 16px 16px 16px 6px;
  background: #fff; box-shadow: var(--shadow);
  font-size: 0.9rem; line-height: 1.5; word-break: break-word; color: var(--c-text);
}
.chat__bubble--mine {
  background: linear-gradient(135deg, #ffeef2, #fff5f7);
  border: 1px solid rgba(232,93,117,0.2);
  border-radius: 16px 16px 6px 16px;
}
.chat__bubble--ai {
  background: linear-gradient(135deg, #f5f3ff, #fdf4ff);
  border: 1px solid rgba(124,58,237,0.18);
  border-radius: 14px; text-align: left;
  box-shadow: 0 2px 12px rgba(124,58,237,0.1);
}

/* thinking dots */
.chat__bubble--thinking {
  display: flex; align-items: center; gap: 5px; padding: 12px 18px;
}
.dot {
  width: 8px; height: 8px; border-radius: 50%;
  background: #9333ea; opacity: 0.6;
  animation: bounce 1.2s infinite ease-in-out;
}
.dot:nth-child(2) { animation-delay: 0.2s; }
.dot:nth-child(3) { animation-delay: 0.4s; }
@keyframes bounce {
  0%, 80%, 100% { transform: translateY(0); }
  40%           { transform: translateY(-6px); }
}

.chat__time {
  font-size: 0.65rem; color: var(--c-muted); margin-top: 4px; padding: 0 4px;
}

/* ── footer ── */
.chat__footer {
  flex-shrink: 0;
  padding: 10px 16px 12px;
  background: var(--c-card);
  border-top: 1px solid rgba(0,0,0,0.06);
  box-shadow: 0 -6px 24px rgba(45,42,50,0.05);
}

/* AI button row */
.chat__ai-row {
  display: flex; align-items: center; gap: 10px; margin-bottom: 10px;
}
.chat__ai-btn {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 7px 16px; border-radius: 999px;
  background: linear-gradient(135deg, #7c3aed, #c026d3);
  color: #fff; font-size: 0.82rem; font-weight: 700;
  box-shadow: 0 3px 10px rgba(124,58,237,0.35);
  transition: opacity 0.2s, transform 0.15s;
  flex-shrink: 0;
}
.chat__ai-btn:active { transform: scale(0.97); }
.chat__ai-btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
.chat__ai-hint { font-size: 0.72rem; color: var(--c-muted); }

/* voice selector */
.chat__voice-label { margin: 0 0 6px; font-size: 0.72rem; font-weight: 600; color: var(--c-muted); }
.chat__voices { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 10px; }
.chat__chip {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 6px 12px; border-radius: 999px;
  font-size: 0.78rem; font-weight: 600;
  color: var(--c-text); background: #f3f4f6;
  border: 2px solid transparent;
}
.chat__chip.is-active {
  border-color: var(--c-primary);
  background: rgba(232,93,117,0.1);
  color: var(--c-primary-dark);
}
.chat__chip-av { font-size: 1rem; line-height: 1; }

/* input row */
.chat__input-row { display: flex; gap: 10px; align-items: flex-end; }
.chat__input {
  flex: 1; resize: none; padding: 10px 12px;
  border-radius: 14px; border: 1px solid #e5e7eb;
  font-size: 0.88rem; font-family: inherit;
  color: var(--c-text); line-height: 1.45;
}
.chat__send { flex-shrink: 0; padding: 10px 18px; font-size: 0.88rem; }
.chat__send:disabled { opacity: 0.45; cursor: not-allowed; }
</style>
