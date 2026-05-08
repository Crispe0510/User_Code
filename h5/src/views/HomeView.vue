<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { useAuth } from '../composables/useAuth'

const route = useRoute()
const router = useRouter()
const { unlocked, isLoggedIn, isGuest, displayName, identity, enterAsGuest, logout } = useAuth()

const selectedRole = ref(identity.value || '')

const features = [
  { icon: 'T', label: 'Topic Bridge', desc: 'Scenario-based conversation starters for every moment', path: '/topics', color: '#ffeef2' },
  { icon: 'M', label: 'Mood Board', desc: 'Share daily moods and see how the family feels', path: '/mood-board', color: '#eef5fc' },
  { icon: 'J', label: 'Family Journal', desc: 'Your journey together, beautifully visualised', path: '/report', color: '#f0fdf4' },
]

function pickRole(role) {
  selectedRole.value = role
}

function continueAsGuest() {
  if (!selectedRole.value) return
  enterAsGuest(selectedRole.value)
  const redirect = route.query.redirect ? String(route.query.redirect) : null
  if (redirect) router.replace(redirect)
}

function goToAuth(mode) {
  if (!selectedRole.value) return
  router.push({ path: '/auth', query: { mode, redirect: route.query.redirect || '' } })
}

function goTo(path) {
  if (!unlocked.value) return
  router.push(path)
}

function doLogout() {
  logout()
  selectedRole.value = ''
}

onMounted(() => {
  if (unlocked.value && route.query.redirect) {
    router.replace(String(route.query.redirect))
  }
})
</script>

<template>
  <div class="home">
    <!-- Animated background -->
    <div class="home__bg" aria-hidden="true" />
    <div class="home__overlay" />

    <!-- Floating particles -->
    <div class="particles" aria-hidden="true">
      <span class="particle" style="left:7%;width:7px;height:7px;animation-duration:18s;animation-delay:0s" />
      <span class="particle" style="left:18%;width:5px;height:5px;animation-duration:24s;animation-delay:4s" />
      <span class="particle" style="left:33%;width:9px;height:9px;animation-duration:20s;animation-delay:2s" />
      <span class="particle" style="left:52%;width:6px;height:6px;animation-duration:28s;animation-delay:7s" />
      <span class="particle" style="left:68%;width:4px;height:4px;animation-duration:22s;animation-delay:1s" />
      <span class="particle" style="left:80%;width:8px;height:8px;animation-duration:16s;animation-delay:5s" />
      <span class="particle" style="left:90%;width:5px;height:5px;animation-duration:30s;animation-delay:9s" />
    </div>

    <div class="app-shell home__content">
      <!-- Header -->
      <header class="home__header animate-in">
        <div class="home__badge">Family Connection · Web</div>
        <h1 class="home__title">Generations<br>Together</h1>
        <p class="home__lead">Closing the distance between generations — one conversation at a time.</p>
        <div class="home__tags">
          <span>Parents &amp; Children</span>
          <span>Grandparents</span>
          <span>Family Bonding</span>
        </div>
      </header>

      <!-- Already logged in -->
      <div v-if="unlocked" class="home__user-bar card animate-in">
        <div class="home__user-info">
          <span class="home__avatar" aria-hidden="true">{{ isGuest ? '&#128100;' : '&#128588;' }}</span>
          <div>
            <strong>{{ displayName }}</strong>
            <p>{{ isGuest ? 'Guest Mode' : (identity === 'parent' ? 'Parent / Grandparent' : 'Child / Grandchild') }}</p>
          </div>
        </div>
        <button type="button" class="btn-pill btn-pill--ghost home__logout" @click="doLogout">Switch</button>
      </div>

      <!-- Identity + access selection (only when not unlocked) -->
      <template v-else>
        <section class="home__identity card animate-in" :style="{ animationDelay: '0.08s' }">
          <h2>Who are you?</h2>
          <p class="home__identity-hint">Choose your role to get started</p>
          <div class="home__role-btns">
            <button
              type="button"
              :class="['role-btn', { 'is-active': selectedRole === 'parent' }]"
              @click="pickRole('parent')"
            >
              <span class="role-btn__icon" aria-hidden="true">&#128106;</span>
              <span>Parent / Grandparent</span>
            </button>
            <button
              type="button"
              :class="['role-btn', { 'is-active': selectedRole === 'child' }]"
              @click="pickRole('child')"
            >
              <span class="role-btn__icon" aria-hidden="true">&#128103;</span>
              <span>Child / Grandchild</span>
            </button>
          </div>
        </section>

        <div class="home__access-row animate-in" :style="{ animationDelay: '0.14s' }">
          <p v-if="!selectedRole" class="home__access-hint">Select a role above to continue</p>
          <template v-else>
            <button type="button" class="btn-pill btn-pill--blue home__access-btn" @click="continueAsGuest">
              Browse as Guest
            </button>
            <button type="button" class="btn-pill btn-pill--primary home__access-btn" @click="goToAuth('login')">
              Sign In
            </button>
            <button type="button" class="home__access-link" @click="goToAuth('register')">
              New here? Register &#8594;
            </button>
          </template>
        </div>
      </template>

      <!-- Lock row -->
      <div class="home__lock-row animate-in" :style="{ animationDelay: '0.2s' }">
        <span class="home__lock-line" />
        <span class="home__lock-icon" :class="{ 'is-open': unlocked }">
          <template v-if="unlocked">&#128275;</template>
          <template v-else>&#128274;</template>
        </span>
        <span class="home__lock-line" />
      </div>
      <p class="home__lock-caption">
        {{ unlocked ? 'Unlocked · All features ready' : 'Select your role and access mode above' }}
      </p>

      <!-- Feature cards -->
      <section class="home__features" :class="{ 'is-blurred': !unlocked }">
        <article
          v-for="(f, i) in features"
          :key="f.path"
          class="feature-card card animate-in"
          :style="{ animationDelay: `${0.22 + i * 0.06}s` }"
          role="button"
          tabindex="0"
          @click="goTo(f.path)"
          @keydown.enter="goTo(f.path)"
        >
          <div class="feature-card__icon" :style="{ background: f.color }">{{ f.icon }}</div>
          <div>
            <h3>{{ f.label }}</h3>
            <p>{{ f.desc }}</p>
          </div>
          <span class="feature-card__go">&#8250;</span>
        </article>
      </section>

      <!-- Guest upgrade notice -->
      <div v-if="isGuest" class="home__guest-notice animate-in" :style="{ animationDelay: '0.4s' }">
        <p>Sign in to unlock custom topics and save your family journal.</p>
        <button type="button" class="btn-pill btn-pill--primary home__notice-btn" @click="goToAuth('register')">
          Create Free Account
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home { position: relative; min-height: 100vh; overflow: hidden; }

.home__bg {
  position: fixed; inset: -8%;
  background-image: url('https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1400&q=80');
  background-size: 120% 120%; background-position: center;
  animation: bg-pan 48s ease-in-out infinite;
  z-index: 0;
}

.home__overlay {
  position: fixed; inset: 0;
  background: linear-gradient(180deg, rgba(20,18,24,0.55) 0%, rgba(20,18,24,0.3) 38%, rgba(20,18,24,0.78) 100%);
  z-index: 1;
}

.home__content {
  position: relative; z-index: 2;
  padding: 28px 18px calc(32px + var(--safe-bottom));
  color: #fff;
}

/* Header */
.home__header { text-align: center; margin-bottom: 20px; }

.home__badge {
  display: inline-block; padding: 4px 14px; border-radius: 999px;
  background: rgba(255,255,255,0.18); font-size: 0.72rem;
  letter-spacing: 0.08em; margin-bottom: 12px;
}

.home__title {
  font-family: var(--font-display);
  font-size: 2.6rem; margin: 0 0 12px;
  text-shadow: 0 4px 24px rgba(0,0,0,0.4);
  line-height: 1.1;
}

.home__lead {
  margin: 0 auto 14px; max-width: 300px;
  font-size: 0.92rem; line-height: 1.55; opacity: 0.9;
}

.home__tags { display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; }

.home__tags span {
  padding: 5px 14px; border-radius: 999px;
  background: rgba(255,255,255,0.15); font-size: 0.8rem;
  border: 1px solid rgba(255,255,255,0.25);
}

/* User bar */
.home__user-bar {
  display: flex; align-items: center; justify-content: space-between;
  gap: 12px; padding: 14px 16px; margin-bottom: 16px;
  background: rgba(255,255,255,0.96); color: var(--c-text);
}

.home__user-info { display: flex; align-items: center; gap: 10px; }

.home__avatar { font-size: 1.6rem; }

.home__user-info strong { display: block; font-size: 0.95rem; }

.home__user-info p { margin: 2px 0 0; font-size: 0.78rem; color: var(--c-muted); }

.home__logout { padding: 8px 14px; font-size: 0.82rem; }

/* Identity */
.home__identity {
  padding: 18px 16px; margin-bottom: 12px;
  background: rgba(255,255,255,0.96); color: var(--c-text);
}

.home__identity h2 { margin: 0 0 4px; font-size: 1.05rem; }

.home__identity-hint { margin: 0 0 14px; font-size: 0.8rem; color: var(--c-muted); }

.home__role-btns { display: flex; gap: 10px; }

.role-btn {
  flex: 1; padding: 12px 10px; border-radius: 14px;
  background: #f9fafb; border: 2px solid transparent;
  display: flex; flex-direction: column; align-items: center; gap: 6px;
  font-size: 0.85rem; font-weight: 600; color: var(--c-text);
  transition: all 0.2s;
}

.role-btn.is-active {
  background: linear-gradient(135deg, #fff5f7, #fce4ec);
  border-color: var(--c-primary);
  color: var(--c-primary-dark);
}

.role-btn__icon { font-size: 1.6rem; }

/* Access row */
.home__access-row {
  display: flex; flex-direction: column; align-items: center; gap: 10px;
  margin-bottom: 16px;
}

.home__access-hint { margin: 0; font-size: 0.85rem; opacity: 0.8; }

.home__access-btn { width: 100%; text-align: center; }

.home__access-link {
  font-size: 0.88rem; color: rgba(255,255,255,0.88);
  text-decoration: underline; text-underline-offset: 3px;
  background: none;
}

/* Lock */
.home__lock-row {
  display: flex; align-items: center; gap: 12px;
  margin: 16px 0 6px; justify-content: center;
}

.home__lock-line {
  flex: 1; height: 1px;
  background: rgba(255,255,255,0.3); max-width: 100px;
}

.home__lock-icon {
  font-size: 1.4rem;
  filter: drop-shadow(0 2px 6px rgba(0,0,0,0.35));
  transition: transform 0.35s ease;
}

.home__lock-icon.is-open { transform: rotate(-8deg) scale(1.08); }

.home__lock-caption {
  text-align: center; font-size: 0.78rem; opacity: 0.85; margin: 0 0 16px;
}

/* Feature cards */
.home__features { display: flex; flex-direction: column; gap: 10px; transition: filter 0.45s, opacity 0.45s; }

.home__features.is-blurred { filter: blur(10px); opacity: 0.3; pointer-events: none; user-select: none; }

.feature-card {
  display: grid; grid-template-columns: 48px 1fr auto;
  gap: 12px; align-items: center; padding: 14px;
  color: var(--c-text); cursor: pointer; transition: transform 0.15s;
}

.feature-card:active { transform: scale(0.99); }

.feature-card__icon {
  width: 48px; height: 48px; border-radius: 14px;
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem; font-weight: 800; color: var(--c-primary-dark);
}

.feature-card h3 { margin: 0 0 3px; font-size: 0.98rem; }

.feature-card p { margin: 0; font-size: 0.78rem; color: var(--c-muted); line-height: 1.4; }

.feature-card__go { font-size: 1.3rem; color: var(--c-muted); }

/* Guest notice */
.home__guest-notice {
  margin-top: 18px; padding: 16px;
  background: rgba(255,255,255,0.12);
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: var(--radius);
  text-align: center;
}

.home__guest-notice p { margin: 0 0 12px; font-size: 0.85rem; opacity: 0.9; }

.home__notice-btn { width: 100%; }
</style>
