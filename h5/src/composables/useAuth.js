import { ref, computed } from 'vue'
import { AUTH_KEY } from '../constants'
import * as api from '../api/index.js'

function load() {
  try {
    const raw = localStorage.getItem(AUTH_KEY)
    return raw ? JSON.parse(raw) : null
  } catch { return null }
}

function save(state) {
  localStorage.setItem(AUTH_KEY, JSON.stringify(state))
}

const _state = ref(load())

export function useAuth() {
  const user        = computed(() => _state.value)
  const isLoggedIn  = computed(() => !!_state.value && !_state.value.isGuest)
  const isGuest     = computed(() => _state.value?.isGuest === true)
  const identity    = computed(() => _state.value?.identity || '')
  const unlocked    = computed(() => !!_state.value)
  const displayName = computed(() =>
    _state.value?.isGuest ? 'Guest' : (_state.value?.name || 'User')
  )

  function enterAsGuest(identityRole) {
    const s = { isGuest: true, identity: identityRole }
    _state.value = s
    save(s)
  }

  /** 调用后端注册接口，成功后写入 token */
  async function register(payload) {
    const res = await api.register({ ...payload, password: payload.password || 'demo1234' })
    if (res.code !== 200) throw new Error(res.msg || '注册失败')
    const s = {
      isGuest: false,
      token: res.data.token,
      id: res.data.id,
      name: res.data.name,
      email: res.data.email,
      identity: res.data.identity,
    }
    _state.value = s
    save(s)
    return s
  }

  /** 调用后端登录接口，成功后写入 token */
  async function login(payload) {
    const res = await api.login(payload)
    if (res.code !== 200) throw new Error(res.msg || '登录失败')
    const s = {
      isGuest: false,
      token: res.data.token,
      id: res.data.id,
      name: res.data.name,
      email: res.data.email,
      identity: res.data.identity,
    }
    _state.value = s
    save(s)
    return s
  }

  async function logout() {
    await api.logout().catch(() => {})
    _state.value = null
    localStorage.removeItem(AUTH_KEY)
  }

  return {
    user, isLoggedIn, isGuest, identity, unlocked, displayName,
    enterAsGuest, register, login, logout,
  }
}
