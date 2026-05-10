<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

function back() {
  router.push('/')
}

function notify() {
  alert('演示：功能二仅占位，后续接入产品方案。')
}
</script>

<template>
  <div class="app-shell page-pad f2">
    <nav class="h5-nav">
      <button type="button" class="h5-nav__back" @click="back">←</button>
      <div>
        <h1 class="h5-title">功能二（占位）</h1>
        <p class="h5-sub">界面预留，按钮齐全，数据为模拟。</p>
      </div>
    </nav>

    <section class="f2__hero card animate-in">
      <h2>即将开放</h2>
      <p>
        此处可接入「情绪分享看板」或其他家庭互动能力。当前版本仅展示布局与操作位。
      </p>
      <div class="f2__actions">
        <button type="button" class="btn-pill btn-pill--primary" @click="notify">预约提醒（演示）</button>
        <button type="button" class="btn-pill btn-pill--ghost" @click="notify">查看说明</button>
      </div>
    </section>

    <section class="f2__grid">
      <div class="f2__card card">
        <h3>占位模块 A</h3>
        <p>卡片式入口</p>
        <button type="button" class="mini-btn" @click="notify">进入</button>
      </div>
      <div class="f2__card card">
        <h3>占位模块 B</h3>
        <p>图表 / 列表位</p>
        <button type="button" class="mini-btn" @click="notify">配置</button>
      </div>
    </section>
  </div>
</template>

<style scoped>
.f2__hero {
  padding: 18px;
  margin-bottom: 14px;
  border: 1px dashed rgba(107, 101, 112, 0.35);
  background: linear-gradient(145deg, #fafafa, #fff);
}

.f2__hero h2 {
  margin: 0 0 8px;
}

.f2__hero p {
  margin: 0 0 14px;
  font-size: 0.88rem;
  color: var(--c-muted);
  line-height: 1.5;
}

.f2__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.f2__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.f2__card {
  padding: 14px;
}

.f2__card h3 {
  margin: 0 0 6px;
  font-size: 0.95rem;
}

.f2__card p {
  margin: 0 0 10px;
  font-size: 0.8rem;
  color: var(--c-muted);
}

.mini-btn {
  padding: 8px 14px;
  border-radius: 10px;
  background: rgba(232, 93, 117, 0.12);
  color: var(--c-primary-dark);
  font-weight: 600;
  font-size: 0.85rem;
}
</style>
