import axios from 'axios'
import { getAdminApiBase } from '../config/apiEnv.js'

const http = axios.create({
  baseURL: getAdminApiBase(),
  timeout: 10000,
})

// Request interceptor: attach admin token
http.interceptors.request.use(config => {
  const token = localStorage.getItem('admin_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Response interceptor: redirect to login on 401
http.interceptors.response.use(
  res => res.data,
  err => {
    if (err.response?.status === 401) {
      localStorage.removeItem('admin_token')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

// Auth
export const adminLogin = (data) => http.post('/admin/login', data)
export const adminLogout = () => http.post('/admin/logout')
export const getAdminProfile = () => http.get('/admin/profile')

// H5 users
export const getH5Users = () => http.get('/admin/h5-users')
export const updateH5UserStatus = (id, status) => http.put(`/admin/h5-users/${id}/status`, { status })
export const deleteH5User = (id) => http.delete(`/admin/h5-users/${id}`)
export const getAdminStats = () => http.get('/admin/stats')

// Admin accounts
export const getAdmins = () => http.get('/admin/admins')
export const addAdmin = (data) => http.post('/admin/admins', data)
export const updateAdmin = (id, data) => http.put(`/admin/admins/${id}`, data)
export const deleteAdmin = (id) => http.delete(`/admin/admins/${id}`)

// Scenarios
export const getScenarios = () => http.get('/admin/scenarios')
export const addScenario = (data) => http.post('/admin/scenarios', data)
export const updateScenario = (id, data) => http.put(`/admin/scenarios/${id}`, data)
export const toggleScenario = (id, enabled) => http.put(`/admin/scenarios/${id}/enabled`, { enabled })
export const deleteScenario = (id) => http.delete(`/admin/scenarios/${id}`)

// Topics
export const getTopics = (scenarioId) => http.get('/admin/topics', { params: scenarioId ? { scenarioId } : {} })
export const getTopic = (id) => http.get(`/admin/topics/${id}`)
export const addTopic = (data) => http.post('/admin/topics', data)
export const updateTopic = (id, data) => http.put(`/admin/topics/${id}`, data)
export const deleteTopic = (id) => http.delete(`/admin/topics/${id}`)

// Family members (H5)
export const getFamilyMembers = (userId) =>
  http.get('/admin/family/members', { params: userId ? { userId } : {} })
export const addFamilyMember = (data) => http.post('/admin/family/members', data)
export const updateFamilyMember = (id, data) => http.put(`/admin/family/members/${id}`, data)
export const deleteFamilyMember = (id) => http.delete(`/admin/family/members/${id}`)

// Mood types
export const getMoodTypes = () => http.get('/admin/mood/types')

// Image upload
export const uploadImage = (file) => {
  const form = new FormData()
  form.append('file', file)
  return http.post('/admin/upload/image', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}
