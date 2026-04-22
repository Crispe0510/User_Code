<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getTopicDetail, getCustomScenarios } from '../api/index.js'

const route = useRoute()
const router = useRouter()
const expanded = ref(true)
const topic = ref(null)

onMounted(async () => {
  const isCustom = String(route.params.scenarioId).startsWith('custom-')
  if (isCustom) {
    const sid = route.params.scenarioId.replace('custom-', '')
    const cRes = await getCustomScenarios().catch(() => null)
    if (cRes?.code === 200) {
      const scen = cRes.data.find(s => String(s.id) === String(sid))
      topic.value = scen?.topics?.find(t => String(t.id) === String(route.params.topicId)) || null
      // custom topics already have string arrays
    }
  } else {
    const res = await getTopicDetail(route.params.topicId)
    if (res.code === 200) {
      const t = res.data
      // normalize TopicQuestion objects to plain strings
      t.opening = (t.opening || []).map(q => (typeof q === 'string' ? q : q.content))
      t.deep    = (t.deep    || []).map(q => (typeof q === 'string' ? q : q.content))
      topic.value = t
    }
  }
})

function back() { router.push(`/topics/${route.params.scenarioId}`) }
function toggleOpen() { expanded.value = !expanded.value }
function startChat() { alert('Demo: This is where the conversation begins! Use any of the questions above.') }
</script>

<template>
  <div v-if="topic" class="app-shell page-pad detail">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">{{ topic.title }}</h1>
        <p class="h5-sub">{{ topic.titleSub }}</p>
      </div>
    </nav>

    <!-- Why this topic -->
    <section class="detail__why card animate-in">
      <div class="detail__why-head">
        <span class="bulb-icon" aria-hidden="true">&#128161;</span>
        <h2>Why This Topic?</h2>
      </div>
      <p>{{ topic.recommend }}</p>
    </section>

    <!-- Opening questions -->
    <section class="detail__block animate-in" :style="{ animationDelay: '0.06s' }">
      <div class="detail__block-head">
        <span aria-hidden="true">&#128172;</span>
        <h2>Opening Questions</h2>
        <span class="q-count">{{ topic.opening?.length ?? 0 }}</span>
      </div>
      <ul class="q-list" :class="{ 'is-collapsed': !expanded }">
        <li v-for="(q, i) in topic.opening" :key="i" class="q-card">
          <span class="q-num">{{ i + 1 }}</span>
          <span>{{ q }}</span>
        </li>
      </ul>
      <button type="button" class="collapse-btn" @click="toggleOpen">
        {{ expanded ? 'Collapse &#8743;' : 'Show All &#8744;' }}
      </button>
    </section>

    <!-- Deep dive -->
    <section class="detail__block animate-in" :style="{ animationDelay: '0.1s' }">
      <div class="detail__block-head">
        <span aria-hidden="true">&#128270;</span>
        <h2>Go Deeper</h2>
        <span class="q-count q-count--deep">{{ topic.deep?.length ?? 0 }}</span>
      </div>
      <ul class="q-list">
        <li v-for="(q, i) in topic.deep" :key="i" class="q-card q-card--deep">
          <span class="q-num q-num--deep">{{ i + 1 }}</span>
          <span>{{ q }}</span>
        </li>
      </ul>
    </section>

    <div class="detail__cta">
      <button type="button" class="btn-pill btn-pill--primary detail__cta-btn" @click="startChat">
        Start This Conversation
      </button>
    </div>
  </div>

  <div v-else class="app-shell page-pad">
    <p class="empty-state">Topic not found.</p>
    <button type="button" class="btn-pill btn-pill--ghost" @click="router.push('/topics')">Back to Topic Bridge</button>
  </div>
</template>

<style scoped>
.detail__why {
  padding: 14px; margin-bottom: 14px;
  background: linear-gradient(135deg, #eef5fc, #ffffff);
  border: 1px solid rgba(107,155,209,0.2);
}
.detail__why-head { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.bulb-icon { font-size: 1.25rem; }
.detail__why h2 { margin: 0; font-size: 1rem; }
.detail__why p { margin: 0; font-size: 0.88rem; line-height: 1.6; color: var(--c-text); }

.detail__block { margin-bottom: 14px; }
.detail__block-head {
  display: flex; align-items: center; gap: 8px; margin-bottom: 10px;
}
.detail__block-head h2 { margin: 0; font-size: 1rem; flex: 1; }

.q-count {
  padding: 2px 10px; border-radius: 999px;
  background: rgba(232,93,117,0.12);
  color: var(--c-primary-dark); font-size: 0.75rem; font-weight: 700;
}
.q-count--deep { background: rgba(107,155,209,0.12); color: var(--c-accent); }

.q-list { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 8px; position: relative; }
.q-list.is-collapsed { max-height: 140px; overflow: hidden; }
.q-list.is-collapsed::after {
  content: ''; position: absolute; left: 0; right: 0; bottom: 0; height: 56px;
  background: linear-gradient(transparent, var(--c-bg));
}

.q-card {
  display: flex; gap: 10px; align-items: flex-start;
  padding: 12px 14px; border-radius: 14px;
  background: linear-gradient(135deg, #fff5f7, #fff);
  font-size: 0.88rem; line-height: 1.5;
  box-shadow: 0 2px 12px rgba(232,93,117,0.07);
}
.q-card--deep {
  background: linear-gradient(135deg, #f0f6ff, #fff);
  box-shadow: 0 2px 12px rgba(107,155,209,0.1);
}

.q-num {
  flex-shrink: 0; width: 20px; height: 20px; border-radius: 50%;
  background: var(--c-primary); color: #fff;
  font-size: 0.72rem; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  margin-top: 1px;
}
.q-num--deep { background: var(--c-accent); }

.collapse-btn {
  margin-top: 10px; width: 100%; padding: 10px;
  border-radius: 12px; background: rgba(0,0,0,0.04);
  color: var(--c-muted); font-size: 0.85rem;
}

.detail__cta { position: sticky; bottom: calc(12px + var(--safe-bottom)); padding-top: 8px; }
.detail__cta-btn { width: 100%; padding: 14px; font-size: 1rem; }

.empty-state { color: var(--c-muted); text-align: center; margin-bottom: 12px; }
</style>
