import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import { AUTH_KEY } from '../constants'

function isAuthed() {
  try {
    const raw = localStorage.getItem(AUTH_KEY)
    return !!raw
  } catch { return false }
}

const routes = [
  { path: '/', name: 'home', component: HomeView },
  {
    path: '/auth',
    name: 'auth',
    component: () => import('../views/AuthView.vue'),
  },
  {
    path: '/topics',
    name: 'topic-bridge',
    component: () => import('../views/TopicBridgeView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/topics/:scenarioId',
    name: 'topic-list',
    component: () => import('../views/TopicListView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/topics/:scenarioId/:topicId',
    name: 'topic-detail',
    component: () => import('../views/TopicDetailView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/mood-board',
    name: 'mood-board',
    component: () => import('../views/MoodBoardView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/report',
    name: 'report',
    component: () => import('../views/ReportView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/custom-scenario',
    name: 'custom-scenario',
    component: () => import('../views/CustomScenarioView.vue'),
    meta: { requiresAuth: true, requiresLogin: true },
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior() { return { top: 0 } },
})

router.beforeEach((to, _from, next) => {
  const authed = isAuthed()
  if (to.meta.requiresAuth && !authed) {
    next({ path: '/', query: { redirect: to.fullPath } })
    return
  }
  next()
})

export default router
