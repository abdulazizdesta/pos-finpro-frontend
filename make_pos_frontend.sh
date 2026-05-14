#!/bin/bash
# Jalankan dari ROOT project React lo (folder yang ada package.json)
set -e

echo "🚀 Setup POS Frontend..."

# ============================================================
# RENAME package.json name
# ============================================================
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json','utf8'));
pkg.name = 'pos-finpro-frontend';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"
echo "✅ package.json updated"

# ============================================================
# ZUSTAND
# ============================================================
npm install zustand --save 2>/dev/null | tail -1
echo "✅ zustand installed"

# ============================================================
# STRUKTUR FOLDER
# ============================================================
mkdir -p src/modules/auth/pages
mkdir -p src/modules/dashboard/pages
mkdir -p src/modules/pos/pages
mkdir -p src/store
mkdir -p src/types
echo "✅ Folders created"

# ============================================================
# src/types/auth.ts
# ============================================================
cat > src/types/auth.ts << 'EOF'
export interface LoginPayload {
  email: string
  password: string
}

export interface RegisterPayload {
  business_name: string
  business_code: string
  owner_name: string
  email: string
  password: string
  password_confirmation: string
}

export interface AuthUser {
  token: string
  name: string
  role: string
  business: string | null
  outlet: string | null
}
EOF
echo "✅ src/types/auth.ts"

# ============================================================
# src/services/api.tsx  (update baseURL ke v1)
# ============================================================
cat > src/services/api.tsx << 'EOF'
import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? 'http://localhost:8000/api/v1',
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.clear()
      window.location.href = '/'
    }
    return Promise.reject(err)
  }
)

export default api
EOF
echo "✅ src/services/api.tsx"

# ============================================================
# src/store/authStore.ts  (Zustand)
# ============================================================
cat > src/store/authStore.ts << 'EOF'
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  token: string | null
  name: string | null
  role: string | null
  business: string | null
  outlet: string | null
  setAuth: (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      name: null,
      role: null,
      business: null,
      outlet: null,
      setAuth: (data) => set(data),
      clearAuth: () => set({ token: null, name: null, role: null, business: null, outlet: null }),
    }),
    { name: 'pos-auth' }
  )
)
EOF
echo "✅ src/store/authStore.ts"

# ============================================================
# src/contexts/AuthContext.tsx  (bridge Zustand → Context lama)
# ============================================================
cat > src/contexts/AuthContext.tsx << 'EOF'
import React, { createContext } from 'react'
import { useAuthStore } from '../store/authStore'

interface AuthContextType {
  token: string | null
  role: string | null
  name: string | null
  business: string | null
  outlet: string | null
  login: (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  logout: () => void
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const { token, role, name, business, outlet, setAuth, clearAuth } = useAuthStore()

  const login = (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => {
    setAuth(data)
  }

  const logout = () => {
    clearAuth()
  }

  return (
    <AuthContext.Provider value={{ token, role, name, business, outlet, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export default AuthContext
EOF
echo "✅ src/contexts/AuthContext.tsx"

# ============================================================
# src/hooks/useAuth.tsx
# ============================================================
cat > src/hooks/useAuth.tsx << 'EOF'
import { useContext } from 'react'
import AuthContext from '../contexts/AuthContext'

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) throw new Error('useAuth must be used inside AuthProvider')
  return context
}
EOF
echo "✅ src/hooks/useAuth.tsx"

# ============================================================
# src/modules/auth/pages/Login.tsx
# ============================================================
cat > src/modules/auth/pages/Login.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../../hooks/useAuth'
import api from '../../../services/api'
import type { LoginPayload } from '../../../types/auth'

export default function Login() {
  const [form, setForm] = useState<LoginPayload>({ email: '', password: '' })
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const { login } = useAuth()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value })
    setError(null)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    try {
      const res = await api.post('/auth/login', form)
      const d = res.data.data
      login({ token: d.token, name: d.name, role: d.role, business: d.business ?? null, outlet: d.outlet ?? null })
      navigate('/dashboard')
    } catch (err: any) {
      setError(err.response?.data?.message ?? 'Terjadi kesalahan')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex h-screen bg-slate-950 text-white">
      {/* Kiri — form */}
      <div className="flex flex-1 flex-col justify-center items-center px-8">
        <div className="w-full max-w-sm">
          <p className="text-slate-500 text-xs tracking-widest uppercase mb-2">Welcome back</p>
          <h1 className="text-slate-100 text-4xl font-semibold mb-1">POS Finpro</h1>
          <p className="text-slate-500 text-sm mb-8">Masuk ke akun bisnis Anda</p>

          {error && (
            <div className="bg-red-950 border border-red-800 text-red-400 text-sm px-4 py-2.5 rounded-lg mb-4">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="flex flex-col gap-1">
              <label className="text-slate-400 text-sm">Email</label>
              <input
                type="email" name="email" value={form.email} onChange={handleChange}
                placeholder="owner@bisnis.com" required
                className="bg-slate-900 border border-slate-700 text-white text-sm px-4 py-2.5 rounded-lg focus:outline-none focus:border-blue-500 transition-colors"
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-slate-400 text-sm">Password</label>
              <input
                type="password" name="password" value={form.password} onChange={handleChange}
                placeholder="••••••••" required
                className="bg-slate-900 border border-slate-700 text-white text-sm px-4 py-2.5 rounded-lg focus:outline-none focus:border-blue-500 transition-colors"
              />
            </div>

            <button
              type="submit" disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 disabled:opacity-50 text-white text-sm font-medium py-2.5 rounded-lg transition-colors cursor-pointer mt-2"
            >
              {loading ? 'Masuk...' : 'Masuk'}
            </button>
          </form>

          <p className="text-slate-600 text-xs text-center mt-6">
            Belum punya akun?{' '}
            <span onClick={() => navigate('/register')} className="text-blue-400 cursor-pointer hover:text-blue-300 transition-colors">
              Daftar bisnis
            </span>
          </p>
        </div>
      </div>

      {/* Kanan — branding */}
      <div className="hidden md:flex flex-1 bg-slate-900 justify-center items-center relative overflow-hidden">
        <div className="text-center px-8">
          <div className="w-16 h-16 bg-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-6">
            <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-2 5h14M7 13l-2-5" />
            </svg>
          </div>
          <h2 className="text-slate-200 text-2xl font-semibold mb-2">Sistem POS Modern</h2>
          <p className="text-slate-500 text-sm max-w-xs leading-relaxed mx-auto">
            Kelola transaksi, stok, dan laporan bisnis Anda dari satu platform.
          </p>
          <div className="mt-8 flex gap-4 justify-center">
            {['Transaksi', 'Stok', 'Laporan', 'Multi-outlet'].map((f) => (
              <span key={f} className="text-xs bg-slate-800 text-slate-400 px-3 py-1 rounded-full border border-slate-700">
                {f}
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
EOF
echo "✅ src/modules/auth/pages/Login.tsx"

# ============================================================
# src/modules/auth/pages/Register.tsx
# ============================================================
cat > src/modules/auth/pages/Register.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../../hooks/useAuth'
import api from '../../../services/api'
import type { RegisterPayload } from '../../../types/auth'

type FormErrors = Partial<Record<keyof RegisterPayload, string>>

export default function Register() {
  const [form, setForm] = useState<RegisterPayload>({
    business_name: '', business_code: '', owner_name: '',
    email: '', password: '', password_confirmation: '',
  })
  const [errors, setErrors] = useState<FormErrors>({})
  const [globalError, setGlobalError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const { login } = useAuth()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    setForm({ ...form, [name]: name === 'business_code' ? value.toUpperCase() : value })
    setErrors({ ...errors, [name]: undefined })
    setGlobalError(null)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setErrors({})
    setGlobalError(null)
    try {
      const res = await api.post('/auth/register', form)
      const d = res.data.data
      login({ token: d.token, name: d.name, role: d.role, business: d.business ?? null, outlet: d.outlet ?? null })
      navigate('/dashboard')
    } catch (err: any) {
      const data = err.response?.data
      if (data?.errors) {
        setErrors(data.errors)
      } else {
        setGlobalError(data?.message ?? 'Terjadi kesalahan')
      }
    } finally {
      setLoading(false)
    }
  }

  const fields: { name: keyof RegisterPayload; label: string; type: string; placeholder: string }[] = [
    { name: 'business_name',         label: 'Nama Bisnis',             type: 'text',     placeholder: 'Toko Pakaian Maju' },
    { name: 'business_code',         label: 'Kode Bisnis',             type: 'text',     placeholder: 'TMAJU (huruf & angka)' },
    { name: 'owner_name',            label: 'Nama Owner',              type: 'text',     placeholder: 'John Doe' },
    { name: 'email',                 label: 'Email',                   type: 'email',    placeholder: 'owner@bisnis.com' },
    { name: 'password',              label: 'Password',                type: 'password', placeholder: 'Min. 8 karakter' },
    { name: 'password_confirmation', label: 'Konfirmasi Password',     type: 'password', placeholder: 'Ulangi password' },
  ]

  return (
    <div className="flex h-screen bg-slate-950 text-white">
      {/* Kiri — branding */}
      <div className="hidden md:flex flex-1 bg-slate-900 justify-center items-center">
        <div className="text-center px-8">
          <div className="w-16 h-16 bg-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-6">
            <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
          <h2 className="text-slate-200 text-2xl font-semibold mb-2">Daftar Bisnis Baru</h2>
          <p className="text-slate-500 text-sm max-w-xs leading-relaxed mx-auto">
            Buat akun dan mulai kelola bisnis Anda dalam hitungan menit.
          </p>
          <div className="mt-8 grid grid-cols-2 gap-3 max-w-xs mx-auto text-left">
            {['Multi-outlet support', 'Real-time stock', 'Laporan otomatis', 'Role-based access'].map((f) => (
              <div key={f} className="flex items-center gap-2">
                <div className="w-1.5 h-1.5 rounded-full bg-blue-500 flex-shrink-0" />
                <span className="text-slate-400 text-xs">{f}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Kanan — form */}
      <div className="flex flex-1 flex-col justify-center items-center px-8 overflow-y-auto py-8">
        <div className="w-full max-w-sm">
          <p className="text-slate-500 text-xs tracking-widest uppercase mb-2">Mulai sekarang</p>
          <h1 className="text-slate-100 text-3xl font-semibold mb-1">Buat Akun Bisnis</h1>
          <p className="text-slate-500 text-sm mb-6">Gratis, tidak perlu kartu kredit</p>

          {globalError && (
            <div className="bg-red-950 border border-red-800 text-red-400 text-sm px-4 py-2.5 rounded-lg mb-4">
              {globalError}
            </div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-3">
            {fields.map(({ name, label, type, placeholder }) => (
              <div key={name} className="flex flex-col gap-1">
                <label className="text-slate-400 text-sm">{label}</label>
                <input
                  type={type} name={name}
                  value={form[name]} onChange={handleChange}
                  placeholder={placeholder} required
                  className={`bg-slate-900 border text-white text-sm px-4 py-2.5 rounded-lg focus:outline-none transition-colors ${
                    errors[name] ? 'border-red-600 focus:border-red-500' : 'border-slate-700 focus:border-blue-500'
                  }`}
                />
                {errors[name] && (
                  <p className="text-red-400 text-xs mt-0.5">{errors[name]}</p>
                )}
              </div>
            ))}

            <button
              type="submit" disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 disabled:opacity-50 text-white text-sm font-medium py-2.5 rounded-lg transition-colors cursor-pointer mt-2"
            >
              {loading ? 'Mendaftar...' : 'Daftar & Masuk'}
            </button>
          </form>

          <p className="text-slate-600 text-xs text-center mt-5">
            Sudah punya akun?{' '}
            <span onClick={() => navigate('/')} className="text-blue-400 cursor-pointer hover:text-blue-300 transition-colors">
              Masuk
            </span>
          </p>
        </div>
      </div>
    </div>
  )
}
EOF
echo "✅ src/modules/auth/pages/Register.tsx"

# ============================================================
# src/modules/auth/routes.tsx
# ============================================================
cat > src/modules/auth/routes.tsx << 'EOF'
import Login from './pages/Login'
import Register from './pages/Register'

const authRoutes = [
  { path: '/', element: <Login /> },
  { path: '/register', element: <Register /> },
]

export default authRoutes
EOF
echo "✅ src/modules/auth/routes.tsx"

# ============================================================
# src/modules/dashboard/pages/Dashboard.tsx
# ============================================================
cat > src/modules/dashboard/pages/Dashboard.tsx << 'EOF'
import { useAuth } from '../../../hooks/useAuth'
import { useNavigate } from 'react-router-dom'

export default function Dashboard() {
  const { name, business, role, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    logout()
    navigate('/')
  }

  return (
    <div className="min-h-screen bg-slate-950 text-white flex flex-col">
      {/* Navbar */}
      <header className="border-b border-slate-800 px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
            <svg className="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4" />
            </svg>
          </div>
          <span className="font-semibold text-slate-100">POS Finpro</span>
          {business && <span className="text-slate-500 text-sm">— {business}</span>}
        </div>
        <div className="flex items-center gap-4">
          <span className="text-slate-400 text-sm">{name}</span>
          <span className="text-xs bg-blue-900 text-blue-300 px-2.5 py-1 rounded-full border border-blue-800 capitalize">{role}</span>
          <button onClick={handleLogout} className="text-slate-500 hover:text-white text-sm transition-colors cursor-pointer">
            Keluar
          </button>
        </div>
      </header>

      {/* Content */}
      <main className="flex-1 p-6 max-w-6xl mx-auto w-full">
        <div className="mb-8">
          <h1 className="text-2xl font-semibold text-slate-100">Dashboard</h1>
          <p className="text-slate-500 text-sm mt-1">Selamat datang kembali, {name}</p>
        </div>

        {/* Stats placeholder */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          {[
            { label: 'Transaksi Hari Ini', value: '—' },
            { label: 'Pendapatan',         value: '—' },
            { label: 'Produk Aktif',       value: '—' },
            { label: 'Stok Menipis',       value: '—' },
          ].map((s) => (
            <div key={s.label} className="bg-slate-900 border border-slate-800 rounded-xl p-4">
              <p className="text-slate-500 text-xs mb-1">{s.label}</p>
              <p className="text-slate-200 text-2xl font-semibold">{s.value}</p>
            </div>
          ))}
        </div>

        {/* Coming soon modules */}
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {[
            { icon: '🛒', label: 'Transaksi', desc: 'Proses penjualan kasir', path: '/pos' },
            { icon: '📦', label: 'Produk', desc: 'Kelola produk & kategori', path: '/products' },
            { icon: '📊', label: 'Stok', desc: 'Monitor & adjust stok', path: '/stocks' },
            { icon: '📋', label: 'Shift', desc: 'Buka & tutup shift', path: '/shifts' },
            { icon: '📈', label: 'Laporan', desc: 'Analitik penjualan', path: '/reports' },
            { icon: '👥', label: 'Users', desc: 'Manajemen pengguna', path: '/users' },
          ].map((m) => (
            <div
              key={m.label}
              className="bg-slate-900 border border-slate-800 rounded-xl p-5 hover:border-slate-600 transition-colors cursor-pointer group"
              onClick={() => navigate(m.path)}
            >
              <div className="text-2xl mb-3">{m.icon}</div>
              <p className="text-slate-200 font-medium text-sm group-hover:text-white transition-colors">{m.label}</p>
              <p className="text-slate-500 text-xs mt-1">{m.desc}</p>
            </div>
          ))}
        </div>
      </main>
    </div>
  )
}
EOF
echo "✅ src/modules/dashboard/pages/Dashboard.tsx"

# ============================================================
# src/modules/dashboard/routes.tsx
# ============================================================
mkdir -p src/modules/dashboard
cat > src/modules/dashboard/routes.tsx << 'EOF'
import ProtectedRoute from '../../components/ProtectedRoute'
import Dashboard from './pages/Dashboard'

const dashboardRoutes = [
  {
    path: '/dashboard',
    element: (
      <ProtectedRoute>
        <Dashboard />
      </ProtectedRoute>
    ),
  },
]

export default dashboardRoutes
EOF
echo "✅ src/modules/dashboard/routes.tsx"

# ============================================================
# src/components/ProtectedRoute.tsx  (update — support multi role)
# ============================================================
cat > src/components/ProtectedRoute.tsx << 'EOF'
import type React from 'react'
import { useAuth } from '../hooks/useAuth'
import { Navigate } from 'react-router-dom'

interface Props {
  children: React.ReactNode
  requiredRole?: string | string[]
}

export default function ProtectedRoute({ children, requiredRole }: Props) {
  const { token, role } = useAuth()

  if (!token) return <Navigate to="/" replace />

  if (requiredRole) {
    const allowed = Array.isArray(requiredRole) ? requiredRole : [requiredRole]
    if (!allowed.includes(role ?? '')) return <Navigate to="/dashboard" replace />
  }

  return <>{children}</>
}
EOF
echo "✅ src/components/ProtectedRoute.tsx"

# ============================================================
# src/routes/index.tsx  (update — tambah dashboard)
# ============================================================
cat > src/routes/index.tsx << 'EOF'
import { useRoutes } from 'react-router-dom'
import authRoutes from '../modules/auth/routes'
import dashboardRoutes from '../modules/dashboard/routes'

export default function AppRoutes() {
  return useRoutes([...authRoutes, ...dashboardRoutes])
}
EOF
echo "✅ src/routes/index.tsx"

# ============================================================
# src/main.tsx  (pastikan ToastContainer ada)
# ============================================================
cat > src/main.tsx << 'EOF'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { AuthProvider } from './contexts/AuthContext.tsx'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

createRoot(document.getElementById('root')!).render(
  <AuthProvider>
    <App />
    <ToastContainer position="top-right" theme="dark" />
  </AuthProvider>
)
EOF
echo "✅ src/main.tsx"

# ============================================================
# .env  (buat kalau belum ada)
# ============================================================
if [ ! -f .env ]; then
cat > .env << 'EOF'
VITE_API_URL=http://localhost:8000/api/v1
EOF
echo "✅ .env created"
fi

echo ""
echo "✅ Selesai! File yang dibuat/diupdate:"
echo "   src/types/auth.ts"
echo "   src/services/api.tsx"
echo "   src/store/authStore.ts"
echo "   src/contexts/AuthContext.tsx"
echo "   src/hooks/useAuth.tsx"
echo "   src/components/ProtectedRoute.tsx"
echo "   src/modules/auth/pages/Login.tsx"
echo "   src/modules/auth/pages/Register.tsx"
echo "   src/modules/auth/routes.tsx"
echo "   src/modules/dashboard/pages/Dashboard.tsx"
echo "   src/modules/dashboard/routes.tsx"
echo "   src/routes/index.tsx"
echo "   src/main.tsx"
echo ""
echo "▶  Jalankan: npm run dev"