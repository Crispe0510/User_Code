<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getTimeline } from '../api/index.js'

const router = useRouter()
const generating = ref(true)
const progress = ref(0)
const lineReady = ref(false)
const reportTimeline = ref([])

const monthlyStats = [
  { label: 'Topics Explored', value: 8 },
  { label: 'Questions Asked', value: 24 },
  { label: 'Moods Shared', value: 18 },
  { label: 'Days Active', value: 12 },
]

onMounted(async () => {
  // 先获取数据，再跑进度条
  const res = await getTimeline().catch(() => null)
  if (res?.code === 200) reportTimeline.value = res.data

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
function shareDemo() { alert('Demo: Share or download this family journal.') }
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
      <!-- Scroll card -->
      <button type="button" class="scroll-hero animate-in" @click="shareDemo">
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
          <button type="button" class="linkish" @click="shareDemo">Export</button>
        </div>

        <div class="timeline">
          <div class="timeline__track" :class="{ 'is-ready': lineReady }" />
          <article
            v-for="(item, i) in reportTimeline"
            :key="item.id"
            class="timeline__item slide-in"
            :style="{ animationDelay: `${0.15 + i * 0.1}s` }"
          >
            <button type="button" class="timeline__node">
              <span class="timeline__dot" :class="`t-${item.type}`" />
            </button>
            <div class="timeline__card">
              <time>{{ item.date }}</time>
              <h3>{{ item.title }}</h3>
              <p class="timeline__place">&#128205; {{ item.place }}</p>
              <p class="timeline__detail">{{ item.detail }}</p>
              <div class="timeline__btns">
                <button type="button" class="link-btn" @click="shareDemo">Share</button>
                <button type="button" class="link-btn" @click="shareDemo">Save</button>
              </div>
            </div>
          </article>
        </div>
      </section>

      <!-- Footer actions -->
      <div class="report__footer-actions animate-in" :style="{ animationDelay: '0.3s' }">
        <button type="button" class="btn-pill btn-pill--primary" @click="shareDemo">Save as Image</button>
        <button type="button" class="btn-pill btn-pill--ghost" @click="back">Back to Home</button>
      </div>
    </template>
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
.history__head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.history__head h2 { margin: 0; font-size: 1rem; }
.linkish { font-size: 0.8rem; color: var(--c-primary-dark); font-weight: 600; }

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
</style>
