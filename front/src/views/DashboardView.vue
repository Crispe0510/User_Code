<template>
  <div class="dashboard">
    <!-- KPI cards -->
    <div class="kpi-row">
      <div class="kpi-card kpi-purple">
        <div class="kpi-left">
          <div class="kpi-num">{{ stats.h5UserCount ?? '-' }}</div>
          <div class="kpi-label">H5 sign-ups</div>
          <div class="kpi-sub">Registered accounts</div>
        </div>
        <div class="kpi-icon">👥</div>
        <div class="kpi-wave" />
      </div>
      <div class="kpi-card kpi-blue">
        <div class="kpi-left">
          <div class="kpi-num">10</div>
          <div class="kpi-label">Scenarios</div>
          <div class="kpi-sub">6 life + 4 topic</div>
        </div>
        <div class="kpi-icon">🗂</div>
        <div class="kpi-wave" />
      </div>
      <div class="kpi-card kpi-green">
        <div class="kpi-left">
          <div class="kpi-num">59</div>
          <div class="kpi-label">Topics</div>
          <div class="kpi-sub">Full question sets</div>
        </div>
        <div class="kpi-icon">💬</div>
        <div class="kpi-wave" />
      </div>
      <div class="kpi-card kpi-orange">
        <div class="kpi-left">
          <div class="kpi-num">6</div>
          <div class="kpi-label">Mood types</div>
          <div class="kpi-sub">Daily emotional states</div>
        </div>
        <div class="kpi-icon">😊</div>
        <div class="kpi-wave" />
      </div>
    </div>

    <!-- Shortcuts -->
    <div class="card">
      <div class="card__header"><h2>Shortcuts</h2></div>
      <div class="card__body">
        <div class="shortcut-grid">
          <RouterLink v-for="item in shortcuts" :key="item.path" :to="item.path" class="shortcut-card">
            <span class="shortcut-icon">{{ item.icon }}</span>
            <span class="shortcut-label">{{ item.label }}</span>
            <span class="shortcut-arrow">›</span>
          </RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAdminStats } from '../api/index.js'

const stats = ref({})
onMounted(async () => {
  const res = await getAdminStats().catch(() => ({}))
  if (res.code === 200) stats.value = res.data
})

const shortcuts = [
  { path: '/users',     icon: '👥', label: 'H5 Users' },
  { path: '/admins',    icon: '🔑', label: 'Admins' },
  { path: '/scenarios', icon: '🗂', label: 'Scenarios' },
  { path: '/topics',    icon: '💬', label: 'Topics' },
  { path: '/mood',      icon: '😊', label: 'Mood types' },
  { path: '/family',    icon: '👨‍👩‍👧', label: 'Family members' },
]
</script>

<style scoped>
.dashboard { display: flex; flex-direction: column; gap: 20px; }

/* KPI row */
.kpi-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.kpi-card {
  position: relative; overflow: hidden;
  border-radius: 14px; padding: 24px 20px;
  display: flex; align-items: center; justify-content: space-between;
  box-shadow: 0 4px 16px rgba(0,0,0,0.10);
  color: #fff;
}

/* Gradients */
.kpi-purple { background: linear-gradient(135deg, #6c63ff 0%, #a78bfa 100%); }
.kpi-blue   { background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%); }
.kpi-green  { background: linear-gradient(135deg, #10b981 0%, #34d399 100%); }
.kpi-orange { background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%); }

.kpi-left { position: relative; z-index: 1; }
.kpi-num  { font-size: 36px; font-weight: 800; line-height: 1; margin-bottom: 4px; }
.kpi-label { font-size: 14px; font-weight: 600; opacity: 0.95; }
.kpi-sub  { font-size: 12px; opacity: 0.75; margin-top: 3px; }

.kpi-icon {
  font-size: 48px; opacity: 0.25;
  position: relative; z-index: 1;
  transform: rotate(-10deg);
}

/* Decorative wave */
.kpi-wave {
  position: absolute; right: -20px; bottom: -30px;
  width: 120px; height: 120px; border-radius: 50%;
  background: rgba(255,255,255,0.12);
}
.kpi-wave::before {
  content: ''; position: absolute;
  right: 20px; bottom: 20px;
  width: 80px; height: 80px; border-radius: 50%;
  background: rgba(255,255,255,0.10);
}

/* Shortcuts */
.shortcut-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 12px;
}

.shortcut-card {
  display: flex; align-items: center; gap: 10px;
  padding: 16px; background: #f9f9ff; border-radius: 10px;
  border: 1px solid #e8e8ff; cursor: pointer; transition: all 0.2s;
  font-size: 14px; font-weight: 500; color: #333;
}
.shortcut-card:hover {
  background: var(--primary); color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(108,99,255,0.25);
  border-color: var(--primary);
}
.shortcut-icon { font-size: 22px; flex-shrink: 0; }
.shortcut-label { flex: 1; }
.shortcut-arrow { opacity: 0.4; font-size: 18px; }
.shortcut-card:hover .shortcut-arrow { opacity: 1; }
</style>
