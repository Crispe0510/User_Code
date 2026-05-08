<template>
  <div class="login-page">
    <div class="login-box">
      <div class="login-logo">🏠 Generations Together</div>
      <h2 class="login-title">Admin console</h2>
      <p v-if="error" class="login-error">{{ error }}</p>
      <div class="form-group">
        <label>Username</label>
        <input class="form-control" v-model="form.username" placeholder="Enter username" @keyup.enter="handleLogin" />
      </div>
      <div class="form-group">
        <label>Password</label>
        <input class="form-control" type="password" v-model="form.password" placeholder="Enter password" @keyup.enter="handleLogin" />
      </div>
      <button class="btn btn-primary" style="width:100%;justify-content:center;margin-top:8px" @click="handleLogin" :disabled="loading">
        {{ loading ? 'Signing in...' : 'Sign in' }}
      </button>
      <p class="login-hint">Demo: admin / admin123</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { adminLogin } from '../api/index.js'

const router = useRouter()
const form = ref({ username: '', password: '' })
const error = ref('')
const loading = ref(false)

async function handleLogin() {
  if (!form.value.username || !form.value.password) { error.value = 'Please enter username and password'; return }
  loading.value = true; error.value = ''
  try {
    const res = await adminLogin(form.value)
    if (res.code === 200) {
      localStorage.setItem('admin_token', res.data.token)
      localStorage.setItem('admin_name', res.data.name)
      router.push('/dashboard')
    } else {
      error.value = res.msg || 'Sign-in failed'
    }
  } catch {
    error.value = 'Network error. Is the backend running?'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh; background: linear-gradient(135deg, #1e1e2e 0%, #2d2b55 100%);
  display: flex; align-items: center; justify-content: center;
}
.login-box {
  background: #fff; border-radius: 16px; padding: 40px;
  width: 400px; box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}
.login-logo { font-size: 28px; text-align: center; margin-bottom: 8px; }
.login-title { text-align: center; font-size: 18px; color: #333; margin-bottom: 28px; font-weight: 600; }
.login-error { background: #fee2e2; color: #991b1b; border-radius: 6px; padding: 10px 14px; font-size: 13px; margin-bottom: 16px; }
.login-hint { text-align: center; font-size: 12px; color: #aaa; margin-top: 16px; }
</style>
