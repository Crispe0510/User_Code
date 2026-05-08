/**
 * API profile: switch between local / production by setting 'dev' | 'prod'.
 * - dev: Vite proxy (see vite.config.js) to local backend.
 * - prod: direct requests to PROD_API_ORIGIN (must match deployed API and CORS).
 */
export const API_PROFILE = 'prod'

/** Production API origin (no trailing slash), e.g. https://api.example.com */
export const PROD_API_ORIGIN = 'http://47.108.243.127:8791'

/** Admin axios baseURL (/api prefix) */
export function getAdminApiBase() {
  if (API_PROFILE === 'prod') {
    return `${PROD_API_ORIGIN}/api`
  }
  return '/api'
}
