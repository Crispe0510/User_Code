<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getScenarios, getTopics, getCustomScenarios } from '../api/index.js'
import { useAuth } from '../composables/useAuth'

const route = useRoute()
const router = useRouter()
const { isLoggedIn } = useAuth()

const scenarioId = computed(() => route.params.scenarioId)
const isCustom = computed(() => String(scenarioId.value).startsWith('custom-'))
const realId = computed(() => isCustom.value ? scenarioId.value.replace('custom-', '') : scenarioId.value)

const scenario = ref(null)
const list = ref([])

onMounted(load)
watch(scenarioId, load)

async function load() {
  if (isCustom.value) {
    const cRes = await getCustomScenarios().catch(() => null)
    if (cRes?.code === 200) {
      const found = cRes.data.find(s => String(s.id) === String(realId.value))
      scenario.value = found || null
      list.value = found?.topics || []
    }
  } else {
    const [sRes, tRes] = await Promise.all([getScenarios(), getTopics(scenarioId.value)])
    if (sRes.code === 200) scenario.value = sRes.data.find(s => s.id === scenarioId.value)
    if (tRes.code === 200) {
      list.value = tRes.data.map(t => ({
        ...t,
        opening: (t.opening || []).map(q => typeof q === 'string' ? q : q.content),
        deep: (t.deep || []).map(q => typeof q === 'string' ? q : q.content),
      }))
    }
  }
}

function openTopic(topicId) {
  router.push(`/topics/${scenarioId.value}/${topicId}`)
}

function back() { router.push('/topics') }

function addTopic() {
  if (isLoggedIn.value) router.push(`/custom-scenario?edit=${realId.value}`)
  else router.push('/auth')
}
</script>

<template>
  <div class="app-shell page-pad list-page">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">{{ scenario?.title ?? 'Scenario' }}</h1>
        <p class="h5-sub">{{ scenario?.subtitle ?? 'Pick a topic to start talking' }}</p>
      </div>
    </nav>

    <p v-if="!scenario" class="empty-state">Scenario not found. <button type="button" @click="back">Go back</button></p>

    <ul v-else-if="list.length" class="topic-list">
      <li v-for="(t, i) in list" :key="t.id">
        <button
          type="button"
          class="topic-row card animate-in"
          :style="{ animationDelay: `${i * 0.06}s` }"
          @click="openTopic(t.id)"
        >
          <div class="topic-row__main">
            <h2>{{ t.title }}</h2>
            <p class="topic-row__en">{{ t.titleSub }}</p>
            <p class="topic-row__d">{{ t.recommend ? t.recommend.slice(0, 64) + '...' : '' }}</p>
          </div>
          <div class="topic-row__right">
            <span class="topic-row__count">{{ t.opening?.length ?? 0 }} questions</span>
            <span class="topic-row__go">&#8250;</span>
          </div>
        </button>
      </li>
    </ul>

    <div v-else class="empty-state card">
      <p>No topics in this scenario yet.</p>
      <button v-if="isCustom" type="button" class="btn-pill btn-pill--primary" style="margin-top:12px;width:100%;text-align:center" @click="addTopic">
        Add a Topic
      </button>
    </div>

    <div v-if="isCustom && isLoggedIn && list.length" class="list-add-btn animate-in">
      <button type="button" class="btn-pill btn-pill--ghost" style="width:100%;text-align:center" @click="addTopic">
        + Add Topic to this Scenario
      </button>
    </div>
  </div>
</template>

<style scoped>
.topic-list { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 10px; }

.topic-row {
  width: 100%; display: flex; justify-content: space-between; align-items: flex-start;
  gap: 12px; padding: 14px; border: none; text-align: left; cursor: pointer;
  transition: transform 0.15s;
}
.topic-row:active { transform: scale(0.99); }
.topic-row__main { flex: 1; }
.topic-row h2 { margin: 0 0 4px; font-size: 1.02rem; }
.topic-row__en { margin: 0 0 5px; font-size: 0.75rem; color: var(--c-accent); font-weight: 600; }
.topic-row__d { margin: 0; font-size: 0.8rem; color: var(--c-muted); line-height: 1.4; }

.topic-row__right { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; flex-shrink: 0; }
.topic-row__count { font-size: 0.72rem; color: var(--c-muted); }
.topic-row__go { font-size: 1.3rem; color: var(--c-primary-dark); font-weight: 700; }

.empty-state {
  text-align: center; color: var(--c-muted);
  padding: 28px 16px; margin-top: 20px;
}
.empty-state button { color: var(--c-primary-dark); font-weight: 600; }
.list-add-btn { margin-top: 14px; }
</style>
