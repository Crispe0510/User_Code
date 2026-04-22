<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuth } from '../composables/useAuth'

const router = useRouter()
const route = useRoute()
const { register, login } = useAuth()

const mode     = ref(route.query.mode === 'register' ? 'register' : 'login')
const name     = ref('')
const email    = ref('')
const password = ref('')
const identity = ref('parent')
const error    = ref('')
const loading  = ref(false)

function redirectAfter() {
  const dest = route.query.redirect ? String(route.query.redirect) : '/'
  router.replace(dest)
}

async function submit() {
  error.value = ''
  if (!email.value)    { error.value = 'Please enter your email.'; return }
  if (!password.value) { error.value = 'Please enter your password.'; return }
  if (mode.value === 'register' && !name.value) { error.value = 'Please enter your name.'; return }
  loading.value = true
  try {
    if (mode.value === 'register') {
      await register({ name: name.value, email: email.value, password: password.value, identity: identity.value })
    } else {
      await login({ email: email.value, password: password.value })
    }
    redirectAfter()
  } catch (e) {
    error.value = e.message || 'Something went wrong. Please try again.'
  } finally {
    loading.value = false
  }
}

function back() {
  if (window.history.length > 1) router.back()
  else router.push('/')
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-bg" aria-hidden="true" />
    <div class="auth-overlay" />

    <div class="app-shell auth-wrap">
      <button type="button" class="auth-back" @click="back">&#8592; Back</button>

      <div class="auth-card card animate-in">
        <h1 class="auth-title">{{ mode === 'login' ? 'Welcome Back' : 'Join the Family' }}</h1>
        <p class="auth-sub">{{ mode === 'login' ? 'Sign in to access all features and save your custom topics.' : 'Create an account to customise scenarios and save your journey.' }}</p>

        <div class="auth-tabs">
          <button type="button" :class="['auth-tab', { 'is-active': mode === 'login' }]" @click="mode = 'login'">Sign In</button>
          <button type="button" :class="['auth-tab', { 'is-active': mode === 'register' }]" @click="mode = 'register'">Register</button>
        </div>

        <form class="auth-form" @submit.prevent="submit">
          <template v-if="mode === 'register'">
            <label>
              Your Name
              <input v-model="name" type="text" placeholder="e.g. Grandma Li" />
            </label>
            <label>
              I am a...
              <select v-model="identity">
                <option value="parent">Parent / Grandparent</option>
                <option value="child">Child / Grandchild</option>
              </select>
            </label>
          </template>
          <label>
            Email
            <input v-model="email" type="email" placeholder="your@email.com" autocomplete="email" />
          </label>
          <label>
            Password
            <input v-model="password" type="password" placeholder="&#8226;&#8226;&#8226;&#8226;&#8226;&#8226;" autocomplete="current-password" />
          </label>
          <p v-if="error" class="auth-error">{{ error }}</p>
          <button type="submit" class="btn-pill btn-pill--primary auth-btn" :disabled="loading">
            {{ loading ? 'Please wait...' : (mode === 'login' ? 'Sign In' : 'Create Account') }}
          </button>
        </form>

        <p class="auth-switch">
          {{ mode === 'login' ? "Don't have an account?" : 'Already have an account?' }}
          <button type="button" class="auth-switch-btn" @click="mode = mode === 'login' ? 'register' : 'login'">
            {{ mode === 'login' ? 'Register' : 'Sign In' }}
          </button>
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-page { position: relative; min-height: 100vh; }
.auth-bg {
  position: fixed; inset: 0;
  background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200&q=80');
  background-size: cover; background-position: center; z-index: 0;
}
.auth-overlay {
  position: fixed; inset: 0;
  background: linear-gradient(160deg, rgba(20,18,24,0.78) 0%, rgba(20,18,24,0.58) 100%);
  z-index: 1;
}
.auth-wrap { position: relative; z-index: 2; padding: 24px 18px 40px; }
.auth-back { color: rgba(255,255,255,0.85); font-size: 0.9rem; margin-bottom: 20px; padding: 0; }
.auth-card { padding: 24px 20px; }
.auth-title { margin: 0 0 6px; font-size: 1.4rem; }
.auth-sub { margin: 0 0 18px; font-size: 0.85rem; color: var(--c-muted); line-height: 1.5; }
.auth-tabs { display: flex; gap: 0; background: #f3f4f6; border-radius: 10px; padding: 4px; margin-bottom: 18px; }
.auth-tab { flex: 1; padding: 8px; border-radius: 8px; font-size: 0.9rem; font-weight: 600; color: var(--c-muted); transition: all 0.2s; }
.auth-tab.is-active { background: #fff; color: var(--c-text); box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.auth-form { display: flex; flex-direction: column; gap: 14px; }
.auth-form label { display: flex; flex-direction: column; gap: 5px; font-size: 0.8125rem; color: var(--c-muted); }
.auth-form input, .auth-form select { padding: 10px 12px; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 0.9rem; color: var(--c-text); }
.auth-error { margin: 0; padding: 10px 12px; background: #fef2f2; border-radius: 8px; color: #dc2626; font-size: 0.82rem; }
.auth-btn { width: 100%; text-align: center; margin-top: 4px; }
.auth-switch { margin: 16px 0 0; text-align: center; font-size: 0.82rem; color: var(--c-muted); }
.auth-switch-btn { color: var(--c-primary-dark); font-weight: 600; margin-left: 4px; font-size: 0.82rem; }
</style>
