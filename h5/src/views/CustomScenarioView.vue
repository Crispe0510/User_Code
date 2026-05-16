<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { createCustomScenario } from '../api/index.js'

const router = useRouter()

const scenarioTitle = ref('')
const topics = ref([newTopic()])
const saving = ref(false)
const error = ref('')

function newTopic() {
  return { title: '', titleSub: '', recommend: '', opening: [''], deep: [''] }
}

function addTopic() { topics.value.push(newTopic()) }

function removeTopic(i) {
  if (topics.value.length <= 1) return
  topics.value.splice(i, 1)
}

function addQ(topic, type) { topic[type].push('') }
function removeQ(topic, type, i) {
  if (topic[type].length <= 1) return
  topic[type].splice(i, 1)
}

async function save() {
  error.value = ''
  if (!scenarioTitle.value.trim()) { error.value = 'Please enter a scenario title.'; return }
  if (topics.value.some(t => !t.title.trim())) { error.value = 'Each topic needs a title.'; return }

  saving.value = true
  try {
    const payload = {
      title: scenarioTitle.value.trim(),
      topics: topics.value.map(t => ({
        title: t.title.trim(),
        titleSub: t.titleSub,
        recommend: t.recommend,
        opening: t.opening.filter(q => q.trim()),
        deep: t.deep.filter(q => q.trim()),
      })),
    }
    const res = await createCustomScenario(payload)
    if (res.code === 200) router.push('/topics')
    else error.value = res.msg || '保存失败'
  } catch {
    error.value = 'Network error. Please check if you are signed in.'
  } finally {
    saving.value = false
  }
}

function back() { router.push('/topics') }
</script>

<template>
  <div class="app-shell page-pad custom">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">Create Scenario</h1>
        <p class="h5-sub">Build your own scenario with custom topics and questions.</p>
      </div>
    </nav>

    <section class="custom__scenario card animate-in">
      <label class="cust-label">
        Scenario Title *
        <input v-model="scenarioTitle" type="text" class="cust-input" placeholder="e.g. Playing Board Games" />
      </label>
    </section>

    <div
      v-for="(t, ti) in topics"
      :key="t.id"
      class="custom__topic card animate-in"
      :style="{ animationDelay: `${ti * 0.05}s` }"
    >
      <div class="topic-head">
        <h3>Topic {{ ti + 1 }}</h3>
        <button v-if="topics.length > 1" type="button" class="remove-btn" @click="removeTopic(ti)">&#10005;</button>
      </div>

      <label class="cust-label">
        Topic Title *
        <input v-model="t.title" type="text" class="cust-input" placeholder="e.g. Games We Played as Kids" />
      </label>
      <label class="cust-label">
        Subtitle
        <input v-model="t.titleSub" type="text" class="cust-input" placeholder="e.g. Old school fun across generations" />
      </label>
      <label class="cust-label">
        Why recommend this topic?
        <textarea v-model="t.recommend" class="cust-input" rows="2" placeholder="Brief reason why this topic works well..." />
      </label>

      <div class="q-section">
        <div class="q-section-head">
          <span>Opening Questions</span>
          <button type="button" class="add-q-btn" @click="addQ(t, 'opening')">+ Add</button>
        </div>
        <div v-for="(q, qi) in t.opening" :key="qi" class="q-row">
          <input v-model="t.opening[qi]" type="text" class="cust-input q-input" :placeholder="`Question ${qi + 1}...`" />
          <button v-if="t.opening.length > 1" type="button" class="remove-q" @click="removeQ(t, 'opening', qi)">&#10005;</button>
        </div>
      </div>

      <div class="q-section">
        <div class="q-section-head">
          <span>Deep Dive Questions</span>
          <button type="button" class="add-q-btn" @click="addQ(t, 'deep')">+ Add</button>
        </div>
        <div v-for="(q, qi) in t.deep" :key="qi" class="q-row">
          <input v-model="t.deep[qi]" type="text" class="cust-input q-input" :placeholder="`Deep question ${qi + 1}...`" />
          <button v-if="t.deep.length > 1" type="button" class="remove-q" @click="removeQ(t, 'deep', qi)">&#10005;</button>
        </div>
      </div>
    </div>

    <button type="button" class="add-topic-btn btn-pill btn-pill--ghost animate-in" @click="addTopic">
      + Add Another Topic
    </button>

    <p v-if="error" class="cust-error">{{ error }}</p>

    <div class="custom__footer">
      <button type="button" class="btn-pill btn-pill--ghost" @click="back">Cancel</button>
      <button type="button" class="btn-pill btn-pill--primary" :disabled="saving" @click="save">
        {{ saving ? 'Saving...' : 'Save Scenario' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.custom__scenario { padding: 16px; margin-bottom: 14px; }

.custom__topic { padding: 16px; margin-bottom: 12px; }

.topic-head {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 12px;
}
.topic-head h3 { margin: 0; font-size: 1rem; color: var(--c-primary-dark); }
.remove-btn { color: #dc2626; font-size: 0.85rem; background: #fef2f2; padding: 5px 9px; border-radius: 8px; }

.cust-label { display: flex; flex-direction: column; gap: 5px; font-size: 0.8125rem; color: var(--c-muted); margin-bottom: 12px; }

.cust-input {
  padding: 10px 12px; border: 1px solid #e5e7eb; border-radius: 10px;
  font-size: 0.88rem; color: var(--c-text); width: 100%; resize: vertical;
}
.cust-input:focus { outline: none; border-color: var(--c-primary); }

.q-section { margin-bottom: 12px; }
.q-section-head {
  display: flex; justify-content: space-between; align-items: center;
  margin-bottom: 8px; font-size: 0.82rem; font-weight: 700; color: var(--c-text);
}
.add-q-btn { font-size: 0.78rem; color: var(--c-primary-dark); font-weight: 700; }

.q-row { display: flex; gap: 6px; margin-bottom: 6px; align-items: center; }
.q-input { flex: 1; }
.remove-q { color: var(--c-muted); font-size: 0.8rem; flex-shrink: 0; }

.add-topic-btn { width: 100%; text-align: center; margin-bottom: 12px; }

.cust-error {
  padding: 10px 14px; background: #fef2f2;
  border-radius: 10px; color: #dc2626; font-size: 0.85rem; margin-bottom: 12px;
}

.custom__footer { display: flex; gap: 10px; margin-top: 8px; }
.custom__footer .btn-pill { flex: 1; text-align: center; }
.custom__footer .btn-pill:disabled { opacity: 0.5; pointer-events: none; }
</style>
