import axios from 'axios'
import { AUTH_KEY } from '../constants.js'
import { getH5ApiBase } from '../config/apiEnv.js'

const http = axios.create({
  baseURL: getH5ApiBase(),
  timeout: 10000,
})

// 请求拦截：自动带 H5 token
http.interceptors.request.use(config => {
  const auth = localStorage.getItem(AUTH_KEY)
  if (auth) {
    try {
      const user = JSON.parse(auth)
      if (user.token) config.headers.Authorization = `Bearer ${user.token}`
    } catch {}
  }
  return config
})

// 响应拦截
http.interceptors.response.use(
  res => res.data,
  err => Promise.reject(err)
)

// ── 认证 ──────────────────────────────────────────────
export const register = (data) => http.post('/auth/register', data)
export const login = (data) => http.post('/auth/login', data)
export const logout = () => http.post('/auth/logout')

// ── 场景 & 话题 ───────────────────────────────────────
export const getScenarios = () => http.get('/scenarios')
export const getTopics = (scenarioId) => http.get('/topics', { params: { scenarioId } })
export const getTopicDetail = (id) => http.get(`/topics/${id}`)
export const getRecentTopics = () => http.get('/recent-topics')

// ── 话题下对话 ────────────────────────────────────────
export const getTopicChatMessages = (scenarioKey, topicKey) =>
  http.get('/chat/messages', { params: { scenarioKey, topicKey } })
export const postTopicChatMessage = (data) => http.post('/chat/messages', data)
export const getLinkableUsers = () => http.get('/chat/linkable-users')
/** 调用 AI 生成一条引导性回复并保存，参数: { scenarioKey, topicKey, topicTitle } */
export const postAiReply = (data) => http.post('/chat/ai-reply', data)

// ── H5 家庭成员自管理 ─────────────────────────────────
export const getMyFamilyMembers = () => http.get('/family/members')
export const addMyFamilyMember = (data) => http.post('/family/members', data)
export const updateMyFamilyMember = (id, data) => http.put(`/family/members/${id}`, data)
export const deleteMyFamilyMember = (id) => http.delete(`/family/members/${id}`)

// ── 情绪 ──────────────────────────────────────────────
export const getMoodTypes = () => http.get('/mood/types')
export const getFamilyMoods = () => http.get('/mood/family')
export const getWeeklyMoods = () => http.get('/mood/weekly')
export const checkinMood = (data) => http.post('/mood/checkin', data)

// ── 报告 ──────────────────────────────────────────────
export const getTimeline = () => http.get('/report/timeline')
/** 登录用户新增一条时间线（需带 token） */
export const postReportTimeline = (data) => http.post('/report/timeline', data)

// ── 自定义场景 ────────────────────────────────────────
export const getCustomScenarios = () => http.get('/custom/scenarios')
export const createCustomScenario = (data) => http.post('/custom/scenarios', data)
export const deleteCustomScenario = (id) => http.delete(`/custom/scenarios/${id}`)
