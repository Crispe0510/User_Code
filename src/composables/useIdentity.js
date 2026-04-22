import { ref, computed } from 'vue'
import { IDENTITY_KEY } from '../constants'

const identity = ref(sessionStorage.getItem(IDENTITY_KEY) || '')

export function useIdentity() {
  function setIdentity(role) {
    identity.value = role
    sessionStorage.setItem(IDENTITY_KEY, role)
  }

  function clearIdentity() {
    identity.value = ''
    sessionStorage.removeItem(IDENTITY_KEY)
  }

  const unlocked = computed(() => !!identity.value)

  return { identity, unlocked, setIdentity, clearIdentity }
}
