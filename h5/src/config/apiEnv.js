/**
 * 接口环境：仅改此处 'dev' | 'prod' 即可切换本地 / 线上
 * - dev：走 Vite 代理，请求发到本地后端
 * - prod：直连下方线上地址
 */
export const API_PROFILE = 'prod'

/** 生产环境 API 根地址（不含末尾斜杠），需与后台部署域名一致 */
export const PROD_API_ORIGIN = 'https://user-code-lovat.vercel.app/'

/** H5 axios baseURL：后端上下文为 /api/h5 */
export function getH5ApiBase() {
  if (API_PROFILE === 'prod') {
    return `${PROD_API_ORIGIN}/api/h5`
  }
  return '/api/h5'
}
