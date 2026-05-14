import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? 'http://localhost:8000/api/v1',
})

api.interceptors.request.use((c) => {
  const token = JSON.parse(localStorage.getItem('pos-auth') || '{}')?.state?.token
  if (token) c.headers.Authorization = `Bearer ${token}`
  return c
})

api.interceptors.response.use(
  (r) => r,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('pos-auth')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

export default api
