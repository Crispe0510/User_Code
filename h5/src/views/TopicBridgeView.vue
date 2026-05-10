<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getScenarios, getRecentTopics, getCustomScenarios } from '../api/index.js'
import { useAuth } from '../composables/useAuth'

const router = useRouter()
const { isLoggedIn } = useAuth()

const scenarios = ref([])
const recentTopics = ref([])
const customScenarios = ref([])

onMounted(async () => {
  const [sRes, rRes] = await Promise.all([getScenarios(), getRecentTopics()])
  if (sRes.code === 200) scenarios.value = sRes.data
  if (rRes.code === 200) recentTopics.value = rRes.data
  if (isLoggedIn.value) {
    const cRes = await getCustomScenarios().catch(() => null)
    if (cRes?.code === 200) customScenarios.value = cRes.data
  }
})

function openScenario(id) { router.push(`/topics/${id}`) }
function openRecent(topic) { router.push(`/topics/${topic.scenarioId}/${topic.id}`) }
function back() { router.push('/') }
function goCustom() {
  if (isLoggedIn.value) router.push('/custom-scenario')
  else router.push({ path: '/auth', query: { redirect: '/custom-scenario' } })
}
function openCustom(s) { router.push(`/topics/custom-${s.id}`) }
</script>

<template>
  <div class="app-shell page-pad bridge">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">&#8592;</button>
      <div>
        <h1 class="h5-title">Topic Bridge</h1>
        <p class="h5-sub">Smart conversation starters — pick a scene and let the talking begin.</p>
      </div>
    </nav>

    <!-- Info banner -->
    <section class="bridge__intro card animate-in">
      <div class="bridge__intro-head">
        <span class="bridge__wand" aria-hidden="true">&#127775;</span>
        <div>
          <h2>Scene-Based Suggestions</h2>
          <p>Choose a real-life scene, then pick a topic — each one comes with opening questions and deeper conversation prompts.</p>
        </div>
      </div>
    </section>

    <!-- Built-in scenarios -->
    <h3 class="bridge__section-label">Built-in Scenarios</h3>
    <section class="bridge__grid">
      <button
        v-for="(s, i) in scenarios"
        :key="s.id"
        type="button"
        class="sc-card animate-in"
        :style="{ animationDelay: `${0.03 * i}s` }"
        @click="openScenario(s.id)"
      >
        <div class="sc-card__bg" :style="{ backgroundImage: `url(${s.cover})` }" />
        <div class="sc-card__mask" />
        <div class="sc-card__body">
          <span class="sc-card__icon" aria-hidden="true">{{ s.icon }}</span>
          <span class="sc-card__badge">{{ s.topicCount }} topics</span>
          <h3>{{ s.title }}</h3>
          <p>{{ s.subtitle }}</p>
        </div>
      </button>
    </section>

    <!-- Custom scenarios -->
    <div class="bridge__custom-head">
      <h3 class="bridge__section-label" style="margin-bottom: 0">My Custom Scenarios</h3>
      <button type="button" class="bridge__add-btn" @click="goCustom">+ Create</button>
    </div>

    <div v-if="!isLoggedIn" class="bridge__custom-lock card animate-in">
      <p>Sign in to create your own scenarios and topics.</p>
      <button type="button" class="btn-pill btn-pill--primary" style="width:100%;text-align:center;margin-top:10px" @click="goCustom">Sign In to Personalise</button>
    </div>

    <template v-else>
      <div v-if="customScenarios.length === 0" class="bridge__custom-empty card animate-in">
        <p>No custom scenarios yet.</p>
        <button type="button" class="btn-pill btn-pill--ghost" style="margin-top:8px" @click="goCustom">Create My First Scenario</button>
      </div>
      <section v-else class="bridge__custom-list">
        <button
          v-for="s in customScenarios"
          :key="s.id"
          type="button"
          class="custom-card card animate-in"
          @click="openCustom(s)"
        >
          <div>
            <h3>{{ s.title }}</h3>
            <p>{{ s.topics?.length ?? 0 }} topic(s)</p>
          </div>
          <span class="custom-card__go">&#8250;</span>
        </button>
      </section>
    </template>

    <!-- Recent topics -->
    <section class="bridge__recent card animate-in" style="margin-top:16px">
      <div class="bridge__recent-head">
        <h2>Recent Topics</h2>
        <button type="button" class="linkish" @click="router.push('/topics/s1')">View All</button>
      </div>
      <ul class="bridge__recent-list">
        <li v-for="t in recentTopics" :key="t.id">
          <button type="button" class="recent-row" @click="openRecent(t)">
            <div>
              <strong>{{ t.title }}</strong>
              <span class="recent-row__meta">{{ t.time }}</span>
            </div>
            <span class="recent-row__go">&#8250;</span>
          </button>
        </li>
      </ul>
    </section>
  </div>
</template>

<style scoped>
.bridge__intro {
  padding: 14px; margin-bottom: 16px;
  background: linear-gradient(135deg, #fff0f3, #ffffff);
  border: 1px solid rgba(232,93,117,0.15);
}
.bridge__intro-head { display: flex; gap: 12px; align-items: flex-start; }
.bridge__wand { font-size: 1.6rem; line-height: 1; }
.bridge__intro h2 { margin: 0 0 6px; font-size: 1rem; }
.bridge__intro p { margin: 0; font-size: 0.82rem; color: var(--c-muted); line-height: 1.45; }

.bridge__section-label { margin: 0 0 10px; font-size: 0.9rem; font-weight: 700; color: var(--c-muted); }

.bridge__grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }

.sc-card {
  position: relative; border: none; padding: 0;
  border-radius: var(--radius); overflow: hidden;
  min-height: 136px; text-align: left; color: #fff;
  box-shadow: var(--shadow);
}
.sc-card__bg {
  position: absolute; inset: 0; background-size: cover; background-position: center;
  transform: scale(1.02); transition: transform 0.4s;
}
.sc-card:active .sc-card__bg { transform: scale(1.07); }
.sc-card__mask {
  position: absolute; inset: 0;
  background: linear-gradient(180deg, rgba(0,0,0,0.1) 0%, rgba(20,18,24,0.85) 100%);
}
.sc-card__body { position: absolute; left: 0; right: 0; bottom: 0; padding: 8px 10px 12px; }
.sc-card__icon { font-size: 1.1rem; display: block; margin-bottom: 2px; }
.sc-card__badge {
  display: inline-block; font-size: 0.63rem; padding: 2px 7px;
  border-radius: 999px; background: rgba(255,255,255,0.2); margin-bottom: 4px;
}
.sc-card h3 { margin: 0 0 1px; font-size: 0.92rem; }
.sc-card p { margin: 0; font-size: 0.7rem; opacity: 0.88; }

/* Custom section */
.bridge__custom-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.bridge__add-btn {
  padding: 6px 14px; border-radius: 999px;
  background: var(--c-primary); color: #fff;
  font-size: 0.82rem; font-weight: 700;
}
.bridge__custom-lock, .bridge__custom-empty {
  padding: 16px; text-align: center; margin-bottom: 16px;
}
.bridge__custom-lock p, .bridge__custom-empty p { margin: 0; font-size: 0.88rem; color: var(--c-muted); }

.bridge__custom-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }

.custom-card {
  display: flex; justify-content: space-between; align-items: center;
  padding: 14px; border: none; width: 100%; text-align: left; cursor: pointer;
}
.custom-card h3 { margin: 0 0 3px; font-size: 0.95rem; }
.custom-card p { margin: 0; font-size: 0.78rem; color: var(--c-muted); }
.custom-card__go { font-size: 1.3rem; color: var(--c-muted); }

/* Recent */
.bridge__recent { padding: 12px 12px 4px; }
.bridge__recent-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
.bridge__recent-head h2 { margin: 0; font-size: 1rem; }
.linkish { font-size: 0.8rem; color: var(--c-primary-dark); font-weight: 600; }
.bridge__recent-list { list-style: none; margin: 0; padding: 0; }
.recent-row {
  width: 100%; display: flex; justify-content: space-between; align-items: center;
  padding: 12px 4px; border-top: 1px solid rgba(0,0,0,0.06);
  text-align: left; color: inherit;
}
.recent-row strong { display: block; font-size: 0.92rem; }
.recent-row__meta { font-size: 0.75rem; color: var(--c-muted); }
.recent-row__go { font-size: 1.3rem; color: var(--c-muted); }
</style>
