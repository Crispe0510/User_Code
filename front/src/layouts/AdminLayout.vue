<template>
  <div class="layout">
    <aside class="sidebar">
      <div class="sidebar__logo"><span>🏠</span>Generations Together</div>
      <nav class="sidebar__nav">
        <div class="sidebar__section">Main</div>
        <RouterLink to="/dashboard"><span class="nav-icon">📊</span>Dashboard</RouterLink>
        <div class="sidebar__section">Users</div>
        <RouterLink to="/users"><span class="nav-icon">👥</span>H5 Users</RouterLink>
        <RouterLink to="/admins"><span class="nav-icon">🔑</span>Admins</RouterLink>
        <div class="sidebar__section">Content</div>
        <RouterLink to="/scenarios"><span class="nav-icon">🗂</span>Scenarios</RouterLink>
        <RouterLink to="/topics"><span class="nav-icon">💬</span>Topics</RouterLink>
        <div class="sidebar__section">Engagement</div>
        <RouterLink to="/mood"><span class="nav-icon">😊</span>Mood types</RouterLink>
        <RouterLink to="/family"><span class="nav-icon">👨‍👩‍👧</span>Family members</RouterLink>
      </nav>
    </aside>
    <div class="main">
      <header class="topbar">
        <div class="topbar__title">{{ pageTitle }}</div>
        <div class="topbar__user">
          <span>👤 {{ adminName }}</span>
          <button @click="handleLogout">Log out</button>
        </div>
      </header>
      <div class="page">
        <RouterView />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { adminLogout } from '../api/index.js'

const route = useRoute()
const router = useRouter()
const adminName = localStorage.getItem('admin_name') || 'Admin'

const titleMap = {
  dashboard: 'Dashboard',
  users: 'H5 Users',
  admins: 'Admin accounts',
  scenarios: 'Scenarios',
  topics: 'Topics',
  mood: 'Mood types',
  family: 'Family members',
}
const pageTitle = computed(() => titleMap[route.name] || 'Admin')

async function handleLogout() {
  await adminLogout().catch(() => {})
  localStorage.removeItem('admin_token')
  localStorage.removeItem('admin_name')
  router.push('/login')
}
</script>
