import { createRouter, createWebHistory } from 'vue-router'
import AdminLayout from '../layouts/AdminLayout.vue'

const routes = [
  { path: '/login', name: 'login', component: () => import('../views/LoginView.vue') },
  {
    path: '/',
    component: AdminLayout,
    redirect: '/dashboard',
    children: [
      { path: 'dashboard',   name: 'dashboard',   component: () => import('../views/DashboardView.vue') },
      { path: 'users',       name: 'users',        component: () => import('../views/users/UserListView.vue') },
      { path: 'admins',      name: 'admins',       component: () => import('../views/users/AdminListView.vue') },
      { path: 'scenarios',   name: 'scenarios',    component: () => import('../views/content/ScenarioView.vue') },
      { path: 'topics',      name: 'topics',       component: () => import('../views/content/TopicView.vue') },
      { path: 'mood',        name: 'mood',         component: () => import('../views/mood/MoodView.vue') },
      { path: 'family',      name: 'family',       component: () => import('../views/family/FamilyMemberView.vue') },
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to) => {
  const token = localStorage.getItem('admin_token')
  if (to.name !== 'login' && !token) return { name: 'login' }
})

export default router
