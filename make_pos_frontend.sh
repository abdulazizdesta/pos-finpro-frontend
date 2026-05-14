#!/bin/bash
set -e
echo "🚀 POS Finpro Frontend — Full Setup"

# ============================================================
# 1. CLEAN OLD FILES
# ============================================================
rm -rf src/modules src/components src/contexts src/hooks src/services src/store src/types src/routes src/assets
rm -f src/App.tsx src/App.css src/main.tsx src/index.css
echo "✅ Old files cleaned"

# ============================================================
# 2. INSTALL DEPENDENCIES
# ============================================================
npm install framer-motion --save 2>/dev/null | tail -1
echo "✅ framer-motion installed"

# ============================================================
# 3. CREATE FOLDERS
# ============================================================
mkdir -p src/components/ui
mkdir -p src/components/landing
mkdir -p src/contexts
mkdir -p src/hooks
mkdir -p src/modules/auth/pages
mkdir -p src/modules/dashboard/pages
mkdir -p src/modules/landing/pages
mkdir -p src/routes
mkdir -p src/services
mkdir -p src/store
mkdir -p src/types
echo "✅ Folders created"

# ============================================================
# 4. INDEX.CSS
# ============================================================
cat > src/index.css << 'EOF'
@import "tailwindcss";
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

@theme {
  --font-sans: 'Plus Jakarta Sans', sans-serif;
  --color-teal-primary: #0D9488;
  --color-teal-secondary: #14B8A6;
  --color-cyan-accent: #06B6D4;
}

html {
  scroll-behavior: smooth;
}

body {
  font-family: 'Plus Jakarta Sans', sans-serif;
}

.gradient-teal {
  background: linear-gradient(135deg, #0D9488, #06B6D4);
}

.gradient-text {
  background: linear-gradient(135deg, #0D9488, #06B6D4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.glass {
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}
EOF
echo "✅ src/index.css"

# ============================================================
# 5. THEME CONTEXT
# ============================================================
cat > src/contexts/ThemeContext.tsx << 'EOF'
import { createContext, useEffect, useState, type ReactNode } from 'react'

interface ThemeContextType {
  dark: boolean
  toggle: () => void
}

export const ThemeContext = createContext<ThemeContextType>({ dark: false, toggle: () => {} })

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [dark, setDark] = useState(() => localStorage.getItem('theme') === 'dark')

  useEffect(() => {
    document.documentElement.classList.toggle('dark', dark)
    localStorage.setItem('theme', dark ? 'dark' : 'light')
  }, [dark])

  return (
    <ThemeContext.Provider value={{ dark, toggle: () => setDark(d => !d) }}>
      {children}
    </ThemeContext.Provider>
  )
}
EOF
echo "✅ src/contexts/ThemeContext.tsx"

cat > src/hooks/useTheme.tsx << 'EOF'
import { useContext } from 'react'
import { ThemeContext } from '../contexts/ThemeContext'

export const useTheme = () => useContext(ThemeContext)
EOF
echo "✅ src/hooks/useTheme.tsx"

# ============================================================
# 6. AUTH STORE + CONTEXT + HOOKS
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

cat > src/store/authStore.ts << 'EOF'
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  token: string | null
  name: string | null
  role: string | null
  business: string | null
  outlet: string | null
  setAuth: (d: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null, name: null, role: null, business: null, outlet: null,
      setAuth: (d) => set(d),
      clearAuth: () => set({ token: null, name: null, role: null, business: null, outlet: null }),
    }),
    { name: 'pos-auth' }
  )
)
EOF
echo "✅ src/store/authStore.ts"

cat > src/contexts/AuthContext.tsx << 'EOF'
import { createContext, type ReactNode } from 'react'
import { useAuthStore } from '../store/authStore'

interface AuthContextType {
  token: string | null
  role: string | null
  name: string | null
  business: string | null
  outlet: string | null
  login: (d: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  logout: () => void
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const { token, role, name, business, outlet, setAuth, clearAuth } = useAuthStore()
  return (
    <AuthContext.Provider value={{ token, role, name, business, outlet, login: setAuth, logout: clearAuth }}>
      {children}
    </AuthContext.Provider>
  )
}

export default AuthContext
EOF
echo "✅ src/contexts/AuthContext.tsx"

cat > src/hooks/useAuth.tsx << 'EOF'
import { useContext } from 'react'
import AuthContext from '../contexts/AuthContext'

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be inside AuthProvider')
  return ctx
}
EOF
echo "✅ src/hooks/useAuth.tsx"

cat > src/services/api.tsx << 'EOF'
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
EOF
echo "✅ src/services/api.tsx"

# ============================================================
# 7. REUSABLE UI COMPONENTS
# ============================================================
cat > src/components/ui/Button.tsx << 'EOF'
import type { ButtonHTMLAttributes, ReactNode } from 'react'

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'outline' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  children: ReactNode
  loading?: boolean
}

export default function Button({ variant = 'primary', size = 'md', children, loading, className = '', ...props }: Props) {
  const base = 'inline-flex items-center justify-center font-medium rounded-xl transition-all duration-200 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed'
  const sizes = { sm: 'px-4 py-2 text-sm', md: 'px-6 py-2.5 text-sm', lg: 'px-8 py-3 text-base' }
  const variants = {
    primary: 'gradient-teal text-white hover:opacity-90 hover:shadow-lg hover:shadow-teal-500/25 active:scale-[0.98]',
    outline: 'border border-teal-500 text-teal-600 dark:text-teal-400 hover:bg-teal-50 dark:hover:bg-teal-950/50',
    ghost: 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800',
  }
  return (
    <button className={`${base} ${sizes[size]} ${variants[variant]} ${className}`} disabled={loading} {...props}>
      {loading ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2" /> : null}
      {children}
    </button>
  )
}
EOF
echo "✅ src/components/ui/Button.tsx"

cat > src/components/ui/Input.tsx << 'EOF'
import type { InputHTMLAttributes } from 'react'

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  label?: string
  error?: string
}

export default function Input({ label, error, className = '', ...props }: Props) {
  return (
    <div className="flex flex-col gap-1.5">
      {label && <label className="text-sm font-medium text-slate-600 dark:text-slate-400">{label}</label>}
      <input
        className={`w-full px-4 py-2.5 text-sm rounded-xl border bg-white dark:bg-slate-800/50 text-slate-900 dark:text-white placeholder:text-slate-400 dark:placeholder:text-slate-500 focus:outline-none focus:ring-2 transition-all duration-200 ${
          error ? 'border-red-400 focus:ring-red-300' : 'border-slate-200 dark:border-slate-700 focus:ring-teal-400/50 focus:border-teal-400'
        } ${className}`}
        {...props}
      />
      {error && <p className="text-xs text-red-500">{error}</p>}
    </div>
  )
}
EOF
echo "✅ src/components/ui/Input.tsx"

cat > src/components/ui/Card.tsx << 'EOF'
import type { HTMLAttributes, ReactNode } from 'react'

interface Props extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode
  hover?: boolean
}

export default function Card({ children, hover = false, className = '', ...props }: Props) {
  return (
    <div
      className={`bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50 rounded-2xl p-6 ${
        hover ? 'hover:border-teal-400/50 hover:shadow-lg hover:shadow-teal-500/5 transition-all duration-300' : ''
      } ${className}`}
      {...props}
    >
      {children}
    </div>
  )
}
EOF
echo "✅ src/components/ui/Card.tsx"

cat > src/components/ui/ThemeToggle.tsx << 'EOF'
import { Moon, Sun } from 'lucide-react'
import { useTheme } from '../../hooks/useTheme'

export default function ThemeToggle({ className = '' }: { className?: string }) {
  const { dark, toggle } = useTheme()
  return (
    <button
      onClick={toggle} aria-label="Toggle theme"
      className={`p-2 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer ${className}`}
    >
      {dark ? <Sun size={18} /> : <Moon size={18} />}
    </button>
  )
}
EOF
echo "✅ src/components/ui/ThemeToggle.tsx"

# ============================================================
# 8. LANDING PAGE COMPONENTS
# ============================================================
cat > src/components/landing/Navbar.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, Menu, X } from 'lucide-react'
import Button from '../ui/Button'
import ThemeToggle from '../ui/ThemeToggle'

const links = [
  { label: 'Features', href: '#features' },
  { label: 'About', href: '#about' },
  { label: 'Benefits', href: '#benefits' },
  { label: 'Pricing', href: '#pricing' },
]

export default function Navbar() {
  const [open, setOpen] = useState(false)
  const nav = useNavigate()

  return (
    <motion.nav
      initial={{ y: -20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.5 }}
      className="fixed top-0 left-0 right-0 z-50 glass bg-white/80 dark:bg-slate-900/80 border-b border-slate-200/50 dark:border-slate-700/50"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <a href="/" className="flex items-center gap-2.5">
            <div className="w-9 h-9 gradient-teal rounded-xl flex items-center justify-center">
              <ShoppingCart size={18} className="text-white" />
            </div>
            <span className="font-bold text-lg text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
          </a>

          <div className="hidden md:flex items-center gap-8">
            {links.map(l => (
              <a key={l.href} href={l.href} className="text-sm text-slate-600 dark:text-slate-400 hover:text-teal-600 dark:hover:text-teal-400 transition-colors">
                {l.label}
              </a>
            ))}
          </div>

          <div className="hidden md:flex items-center gap-3">
            <ThemeToggle />
            <Button variant="ghost" size="sm" onClick={() => nav('/login')}>Masuk</Button>
            <Button size="sm" onClick={() => nav('/register')}>Daftar Gratis</Button>
          </div>

          <button onClick={() => setOpen(!open)} className="md:hidden p-2 text-slate-600 dark:text-slate-300 cursor-pointer">
            {open ? <X size={22} /> : <Menu size={22} />}
          </button>
        </div>
      </div>

      {open && (
        <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} className="md:hidden border-t border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 pb-4">
          {links.map(l => (
            <a key={l.href} href={l.href} onClick={() => setOpen(false)} className="block py-3 text-sm text-slate-600 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
              {l.label}
            </a>
          ))}
          <div className="flex gap-3 mt-4">
            <Button variant="outline" size="sm" className="flex-1" onClick={() => nav('/login')}>Masuk</Button>
            <Button size="sm" className="flex-1" onClick={() => nav('/register')}>Daftar</Button>
          </div>
        </motion.div>
      )}
    </motion.nav>
  )
}
EOF
echo "✅ src/components/landing/Navbar.tsx"

cat > src/components/landing/Hero.tsx << 'EOF'
import { motion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import { ArrowRight, Sparkles } from 'lucide-react'
import Button from '../ui/Button'

export default function Hero() {
  const nav = useNavigate()
  return (
    <section className="relative min-h-screen flex items-center justify-center pt-16 overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-teal-50/50 via-transparent to-transparent dark:from-teal-950/20 dark:via-transparent" />
      <div className="absolute top-32 left-1/4 w-72 h-72 bg-teal-400/10 rounded-full blur-3xl" />
      <div className="absolute bottom-32 right-1/4 w-96 h-96 bg-cyan-400/10 rounded-full blur-3xl" />

      <div className="relative max-w-4xl mx-auto px-4 sm:px-6 text-center">
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-teal-200 dark:border-teal-800 bg-teal-50 dark:bg-teal-950/50 text-teal-700 dark:text-teal-400 text-sm mb-8">
            <Sparkles size={14} /> Platform POS Modern untuk Bisnis Anda
          </div>
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.1 }}
          className="text-4xl sm:text-5xl lg:text-6xl font-bold text-slate-900 dark:text-white leading-tight mb-6"
        >
          Kelola Bisnis Retail{' '}
          <span className="gradient-text">Lebih Cerdas</span>
          <br />dan Efisien
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.2 }}
          className="text-lg text-slate-600 dark:text-slate-400 max-w-2xl mx-auto mb-10"
        >
          Transaksi, stok, laporan, dan multi-outlet — semua dalam satu platform.
          Dibangun untuk skala bisnis yang terus tumbuh.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.3 }}
          className="flex flex-col sm:flex-row gap-4 justify-center"
        >
          <Button size="lg" onClick={() => nav('/register')}>
            Mulai Gratis <ArrowRight size={18} className="ml-2" />
          </Button>
          <Button variant="outline" size="lg" onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}>
            Lihat Fitur
          </Button>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6, duration: 1 }}
          className="mt-16 grid grid-cols-3 gap-8 max-w-md mx-auto"
        >
          {[['500+', 'Bisnis aktif'], ['50K+', 'Transaksi/hari'], ['99.9%', 'Uptime']].map(([val, label]) => (
            <div key={label}>
              <p className="text-2xl font-bold gradient-text">{val}</p>
              <p className="text-xs text-slate-500 dark:text-slate-500 mt-1">{label}</p>
            </div>
          ))}
        </motion.div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/Hero.tsx"

cat > src/components/landing/Features.tsx << 'EOF'
import { motion } from 'framer-motion'
import { ShoppingCart, Package, BarChart3, Users, Zap, Shield } from 'lucide-react'
import Card from '../ui/Card'

const features = [
  { icon: ShoppingCart, title: 'Transaksi Instan', desc: 'Proses penjualan cepat dengan support cash, QRIS, dan kartu. Auto-calculate tax & diskon.' },
  { icon: Package, title: 'Stok Real-time', desc: 'Monitor stok per outlet, alert minimum, dan log mutasi otomatis setiap transaksi.' },
  { icon: BarChart3, title: 'Laporan Analytics', desc: 'Dashboard penjualan, produk terlaris, dan trend bisnis dengan visualisasi interaktif.' },
  { icon: Users, title: 'Multi-Role Access', desc: 'Superadmin, owner, admin, kasir — setiap role dengan akses yang tepat.' },
  { icon: Zap, title: 'Multi-Outlet', desc: 'Kelola banyak outlet dalam satu dashboard. Data terpisah, laporan terpusat.' },
  { icon: Shield, title: 'Aman & Reliable', desc: 'Shift management, audit trail lengkap, dan data terenkripsi end-to-end.' },
]

export default function Features() {
  return (
    <section id="features" className="py-24 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
          className="text-center mb-16"
        >
          <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">Features</p>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">Semua yang bisnis Anda butuhkan</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-4 max-w-xl mx-auto">Fitur lengkap POS modern yang dirancang untuk retail — dari transaksi hingga laporan.</p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {features.map((f, i) => (
            <motion.div key={f.title} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }}>
              <Card hover>
                <div className="w-11 h-11 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center mb-4">
                  <f.icon size={22} className="text-teal-600 dark:text-teal-400" />
                </div>
                <h3 className="font-semibold text-slate-900 dark:text-white mb-2">{f.title}</h3>
                <p className="text-sm text-slate-500 dark:text-slate-400 leading-relaxed">{f.desc}</p>
              </Card>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/Features.tsx"

cat > src/components/landing/About.tsx << 'EOF'
import { motion } from 'framer-motion'
import { Target, TrendingUp, Globe } from 'lucide-react'

const items = [
  { icon: Target, title: 'Fokus Retail', desc: 'Dibangun khusus untuk kebutuhan retail modern — fashion, elektronik, FMCG, dan lainnya.' },
  { icon: TrendingUp, title: 'Scalable', desc: 'Dari 1 outlet sampai 100+ outlet, arsitektur kami siap tumbuh bersama bisnis Anda.' },
  { icon: Globe, title: 'Cloud-Based', desc: 'Akses dari mana saja, kapan saja. Data tersinkronisasi real-time di semua perangkat.' },
]

export default function About() {
  return (
    <section id="about" className="py-24 px-4 sm:px-6 bg-slate-50 dark:bg-slate-800/20">
      <div className="max-w-6xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <motion.div initial={{ opacity: 0, x: -30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}>
            <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">About</p>
            <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white mb-6">
              POS yang <span className="gradient-text">memahami</span> bisnis retail
            </h2>
            <p className="text-slate-600 dark:text-slate-400 leading-relaxed mb-8">
              FinproPOS lahir dari kebutuhan nyata pebisnis retail yang lelah dengan sistem POS yang rumit dan mahal.
              Kami merancang solusi yang simpel, powerful, dan affordable untuk semua skala bisnis.
            </p>
            <div className="flex gap-8">
              {[['3+', 'Tahun'], ['500+', 'Client'], ['15+', 'Kota']].map(([v, l]) => (
                <div key={l}>
                  <p className="text-2xl font-bold text-teal-600 dark:text-teal-400">{v}</p>
                  <p className="text-sm text-slate-500">{l}</p>
                </div>
              ))}
            </div>
          </motion.div>

          <div className="flex flex-col gap-5">
            {items.map((it, i) => (
              <motion.div
                key={it.title} initial={{ opacity: 0, x: 30 }} whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }} transition={{ delay: i * 0.15 }}
                className="flex gap-4 p-5 rounded-2xl bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50"
              >
                <div className="w-11 h-11 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center flex-shrink-0">
                  <it.icon size={22} className="text-teal-600 dark:text-teal-400" />
                </div>
                <div>
                  <h3 className="font-semibold text-slate-900 dark:text-white mb-1">{it.title}</h3>
                  <p className="text-sm text-slate-500 dark:text-slate-400">{it.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/About.tsx"

cat > src/components/landing/Benefits.tsx << 'EOF'
import { motion } from 'framer-motion'
import { Clock, TrendingDown, Smile, Layers } from 'lucide-react'

const benefits = [
  { icon: Clock, title: 'Hemat Waktu 70%', desc: 'Otomasi proses harian — stok opname, laporan, dan rekap kasir berjalan otomatis.' },
  { icon: TrendingDown, title: 'Kurangi Human Error', desc: 'Kalkulasi pajak, diskon, dan stok sepenuhnya otomatis. Tidak ada lagi salah hitung.' },
  { icon: Smile, title: 'Mudah Digunakan', desc: 'Interface intuitif yang bisa langsung dipakai tanpa training berhari-hari.' },
  { icon: Layers, title: 'Integrasi Lengkap', desc: 'Dari kasir sampai laporan, semua terhubung dalam satu ekosistem.' },
]

export default function Benefits() {
  return (
    <section id="benefits" className="py-24 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto">
        <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="text-center mb-16">
          <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">Benefits</p>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">Kenapa bisnis memilih FinproPOS</h2>
        </motion.div>

        <div className="grid sm:grid-cols-2 gap-6">
          {benefits.map((b, i) => (
            <motion.div
              key={b.title} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.1 }}
              className="relative group p-8 rounded-2xl border border-slate-200 dark:border-slate-700/50 bg-white dark:bg-slate-800/50 hover:border-teal-400/50 transition-all duration-300"
            >
              <div className="absolute inset-0 rounded-2xl bg-gradient-to-br from-teal-400/5 to-cyan-400/5 opacity-0 group-hover:opacity-100 transition-opacity" />
              <div className="relative">
                <div className="w-12 h-12 rounded-xl gradient-teal flex items-center justify-center mb-5">
                  <b.icon size={24} className="text-white" />
                </div>
                <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-2">{b.title}</h3>
                <p className="text-slate-500 dark:text-slate-400 leading-relaxed">{b.desc}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/Benefits.tsx"

cat > src/components/landing/Pricing.tsx << 'EOF'
import { motion } from 'framer-motion'
import { Check } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import Button from '../ui/Button'

const plans = [
  {
    name: 'Starter', price: 'Gratis', period: 'selamanya',
    desc: 'Untuk bisnis yang baru mulai',
    features: ['1 Outlet', 'Maks 100 transaksi/bulan', '2 User', 'Laporan dasar'],
    cta: 'Mulai Gratis', highlighted: false,
  },
  {
    name: 'Business', price: 'Rp 199K', period: '/bulan',
    desc: 'Untuk bisnis yang tumbuh',
    features: ['5 Outlet', 'Transaksi unlimited', '10 User', 'Laporan lengkap', 'Diskon & pajak', 'Export PDF/Excel'],
    cta: 'Pilih Business', highlighted: true,
  },
  {
    name: 'Enterprise', price: 'Custom', period: '',
    desc: 'Untuk jaringan besar',
    features: ['Unlimited outlet', 'Unlimited semua', 'API access', 'Dedicated support', 'Custom integration', 'SLA 99.9%'],
    cta: 'Hubungi Sales', highlighted: false,
  },
]

export default function Pricing() {
  const nav = useNavigate()
  return (
    <section id="pricing" className="py-24 px-4 sm:px-6 bg-slate-50 dark:bg-slate-800/20">
      <div className="max-w-6xl mx-auto">
        <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="text-center mb-16">
          <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">Pricing</p>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">Harga yang masuk akal</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-4">Mulai gratis, upgrade sesuai kebutuhan.</p>
        </motion.div>

        <div className="grid md:grid-cols-3 gap-6 items-start">
          {plans.map((p, i) => (
            <motion.div
              key={p.name} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.15 }}
              className={`rounded-2xl p-8 ${
                p.highlighted
                  ? 'bg-gradient-to-b from-teal-600 to-teal-700 text-white ring-2 ring-teal-400 shadow-xl shadow-teal-500/20 scale-[1.03]'
                  : 'bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50'
              }`}
            >
              <p className={`font-semibold mb-1 ${p.highlighted ? 'text-teal-100' : 'text-teal-600 dark:text-teal-400'}`}>{p.name}</p>
              <div className="flex items-baseline gap-1 mb-2">
                <span className={`text-3xl font-bold ${p.highlighted ? 'text-white' : 'text-slate-900 dark:text-white'}`}>{p.price}</span>
                {p.period && <span className={`text-sm ${p.highlighted ? 'text-teal-200' : 'text-slate-500'}`}>{p.period}</span>}
              </div>
              <p className={`text-sm mb-6 ${p.highlighted ? 'text-teal-100' : 'text-slate-500 dark:text-slate-400'}`}>{p.desc}</p>
              <ul className="space-y-3 mb-8">
                {p.features.map(f => (
                  <li key={f} className="flex items-center gap-2.5 text-sm">
                    <Check size={16} className={p.highlighted ? 'text-teal-200' : 'text-teal-500'} />
                    <span className={p.highlighted ? 'text-white' : 'text-slate-600 dark:text-slate-400'}>{f}</span>
                  </li>
                ))}
              </ul>
              <Button
                variant={p.highlighted ? 'ghost' : 'outline'} size="md"
                className={`w-full ${p.highlighted ? 'bg-white text-teal-700 hover:bg-teal-50' : ''}`}
                onClick={() => nav('/register')}
              >{p.cta}</Button>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/Pricing.tsx"

cat > src/components/landing/Footer.tsx << 'EOF'
import { ShoppingCart } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="border-t border-slate-200 dark:border-slate-800 py-12 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
            <ShoppingCart size={16} className="text-white" />
          </div>
          <span className="font-bold text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
        </div>
        <p className="text-sm text-slate-500">2026 FinproPOS. Built for retail businesses.</p>
      </div>
    </footer>
  )
}
EOF
echo "✅ src/components/landing/Footer.tsx"

# ============================================================
# 9. LANDING PAGE
# ============================================================
cat > src/modules/landing/pages/LandingPage.tsx << 'EOF'
import Navbar from '../../../components/landing/Navbar'
import Hero from '../../../components/landing/Hero'
import Features from '../../../components/landing/Features'
import About from '../../../components/landing/About'
import Benefits from '../../../components/landing/Benefits'
import Pricing from '../../../components/landing/Pricing'
import Footer from '../../../components/landing/Footer'

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white dark:bg-slate-950 transition-colors duration-300">
      <Navbar />
      <Hero />
      <Features />
      <About />
      <Benefits />
      <Pricing />
      <Footer />
    </div>
  )
}
EOF
echo "✅ src/modules/landing/pages/LandingPage.tsx"

cat > src/modules/landing/routes.tsx << 'EOF'
import LandingPage from './pages/LandingPage'

const landingRoutes = [{ path: '/', element: <LandingPage /> }]
export default landingRoutes
EOF
echo "✅ src/modules/landing/routes.tsx"

# ============================================================
# 10. AUTH PAGES — WITH MOTION TRANSITION
# ============================================================
cat > src/modules/auth/pages/Login.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, ArrowLeft } from 'lucide-react'
import { useAuth } from '../../../hooks/useAuth'
import api from '../../../services/api'
import Button from '../../../components/ui/Button'
import Input from '../../../components/ui/Input'
import ThemeToggle from '../../../components/ui/ThemeToggle'
import type { LoginPayload } from '../../../types/auth'

export default function Login() {
  const [form, setForm] = useState<LoginPayload>({ email: '', password: '' })
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const nav = useNavigate()
  const { login } = useAuth()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value })
    setError(null)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    try {
      const { data } = await api.post('/auth/login', form)
      const d = data.data
      login({ token: d.token, name: d.name, role: d.role, business: d.business ?? null, outlet: d.outlet ?? null })
      nav('/dashboard')
    } catch (err: any) {
      setError(err.response?.data?.message ?? 'Terjadi kesalahan')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex bg-slate-50 dark:bg-slate-950 transition-colors">
      <motion.div
        initial={{ opacity: 0, x: -40 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -40 }}
        transition={{ duration: 0.4, ease: 'easeOut' }}
        className="flex flex-1 flex-col justify-center items-center px-6 py-8"
      >
        <div className="w-full max-w-sm">
          <div className="flex items-center justify-between mb-8">
            <button onClick={() => nav('/')} className="flex items-center gap-1.5 text-sm text-slate-500 hover:text-teal-600 dark:hover:text-teal-400 transition-colors cursor-pointer">
              <ArrowLeft size={16} /> Kembali
            </button>
            <ThemeToggle />
          </div>

          <div className="flex items-center gap-2.5 mb-8">
            <div className="w-10 h-10 gradient-teal rounded-xl flex items-center justify-center">
              <ShoppingCart size={20} className="text-white" />
            </div>
            <span className="font-bold text-xl text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
          </div>

          <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-2">Selamat datang kembali</h1>
          <p className="text-sm text-slate-500 dark:text-slate-400 mb-6">Masuk ke akun bisnis Anda</p>

          {error && (
            <div className="bg-red-50 dark:bg-red-950/50 border border-red-200 dark:border-red-800 text-red-600 dark:text-red-400 text-sm px-4 py-2.5 rounded-xl mb-4">{error}</div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <Input label="Email" name="email" type="email" value={form.email} onChange={handleChange} placeholder="owner@bisnis.com" required />
            <Input label="Password" name="password" type="password" value={form.password} onChange={handleChange} placeholder="Min. 8 karakter" required />
            <Button type="submit" loading={loading} className="w-full mt-2">Masuk</Button>
          </form>

          <p className="text-slate-500 text-sm text-center mt-6">
            Belum punya akun?{' '}
            <span onClick={() => nav('/register')} className="text-teal-600 dark:text-teal-400 font-medium cursor-pointer hover:underline">Daftar bisnis</span>
          </p>
        </div>
      </motion.div>

      <div className="hidden lg:flex flex-1 gradient-teal items-center justify-center relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          {[...Array(5)].map((_, i) => (
            <div key={i} className="absolute rounded-full border border-white/20" style={{ width: `${200 + i * 120}px`, height: `${200 + i * 120}px`, top: '50%', left: '50%', transform: 'translate(-50%, -50%)' }} />
          ))}
        </div>
        <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.3 }} className="relative text-center text-white px-12">
          <h2 className="text-3xl font-bold mb-4">Sistem POS Modern</h2>
          <p className="text-teal-100 max-w-sm">Kelola transaksi, stok, dan laporan bisnis Anda dari satu platform yang powerful.</p>
        </motion.div>
      </div>
    </div>
  )
}
EOF
echo "✅ src/modules/auth/pages/Login.tsx"

cat > src/modules/auth/pages/Register.tsx << 'EOF'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, ArrowLeft } from 'lucide-react'
import { useAuth } from '../../../hooks/useAuth'
import api from '../../../services/api'
import Button from '../../../components/ui/Button'
import Input from '../../../components/ui/Input'
import ThemeToggle from '../../../components/ui/ThemeToggle'
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
  const nav = useNavigate()
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
      const { data } = await api.post('/auth/register', form)
      const d = data.data
      login({ token: d.token, name: d.name, role: d.role, business: d.business ?? null, outlet: d.outlet ?? null })
      nav('/dashboard')
    } catch (err: any) {
      const data = err.response?.data
      if (data?.errors) setErrors(data.errors)
      else setGlobalError(data?.message ?? 'Terjadi kesalahan')
    } finally {
      setLoading(false)
    }
  }

  const fields: { name: keyof RegisterPayload; label: string; type: string; placeholder: string }[] = [
    { name: 'business_name', label: 'Nama Bisnis', type: 'text', placeholder: 'Toko Pakaian Maju' },
    { name: 'business_code', label: 'Kode Bisnis', type: 'text', placeholder: 'TMAJU' },
    { name: 'owner_name', label: 'Nama Owner', type: 'text', placeholder: 'John Doe' },
    { name: 'email', label: 'Email', type: 'email', placeholder: 'owner@bisnis.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: 'Min. 8 karakter' },
    { name: 'password_confirmation', label: 'Konfirmasi Password', type: 'password', placeholder: 'Ulangi password' },
  ]

  return (
    <div className="min-h-screen flex bg-slate-50 dark:bg-slate-950 transition-colors">
      <div className="hidden lg:flex flex-1 gradient-teal items-center justify-center relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          {[...Array(5)].map((_, i) => (
            <div key={i} className="absolute rounded-full border border-white/20" style={{ width: `${200 + i * 120}px`, height: `${200 + i * 120}px`, top: '50%', left: '50%', transform: 'translate(-50%, -50%)' }} />
          ))}
        </div>
        <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.3 }} className="relative text-center text-white px-12">
          <h2 className="text-3xl font-bold mb-4">Daftar Bisnis Baru</h2>
          <p className="text-teal-100 max-w-sm">Buat akun dan mulai kelola bisnis retail Anda dalam hitungan menit.</p>
          <div className="grid grid-cols-2 gap-3 mt-8 max-w-xs mx-auto text-left">
            {['Multi-outlet', 'Real-time stock', 'Auto report', 'Role access'].map(f => (
              <div key={f} className="flex items-center gap-2">
                <div className="w-1.5 h-1.5 rounded-full bg-white flex-shrink-0" />
                <span className="text-sm text-teal-100">{f}</span>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      <motion.div
        initial={{ opacity: 0, x: 40 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 40 }}
        transition={{ duration: 0.4, ease: 'easeOut' }}
        className="flex flex-1 flex-col justify-center items-center px-6 py-8 overflow-y-auto"
      >
        <div className="w-full max-w-sm">
          <div className="flex items-center justify-between mb-6">
            <button onClick={() => nav('/login')} className="flex items-center gap-1.5 text-sm text-slate-500 hover:text-teal-600 dark:hover:text-teal-400 transition-colors cursor-pointer">
              <ArrowLeft size={16} /> Kembali
            </button>
            <ThemeToggle />
          </div>

          <div className="flex items-center gap-2.5 mb-6">
            <div className="w-10 h-10 gradient-teal rounded-xl flex items-center justify-center">
              <ShoppingCart size={20} className="text-white" />
            </div>
            <span className="font-bold text-xl text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
          </div>

          <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-1">Buat akun bisnis</h1>
          <p className="text-sm text-slate-500 dark:text-slate-400 mb-6">Gratis, tanpa kartu kredit</p>

          {globalError && (
            <div className="bg-red-50 dark:bg-red-950/50 border border-red-200 dark:border-red-800 text-red-600 dark:text-red-400 text-sm px-4 py-2.5 rounded-xl mb-4">{globalError}</div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-3">
            {fields.map(f => (
              <Input key={f.name} label={f.label} name={f.name} type={f.type} value={form[f.name]} onChange={handleChange} placeholder={f.placeholder} error={errors[f.name]} required />
            ))}
            <Button type="submit" loading={loading} className="w-full mt-2">Daftar & Masuk</Button>
          </form>

          <p className="text-slate-500 text-sm text-center mt-5">
            Sudah punya akun?{' '}
            <span onClick={() => nav('/login')} className="text-teal-600 dark:text-teal-400 font-medium cursor-pointer hover:underline">Masuk</span>
          </p>
        </div>
      </motion.div>
    </div>
  )
}
EOF
echo "✅ src/modules/auth/pages/Register.tsx"

cat > src/modules/auth/routes.tsx << 'EOF'
import Login from './pages/Login'
import Register from './pages/Register'

const authRoutes = [
  { path: '/login', element: <Login /> },
  { path: '/register', element: <Register /> },
]
export default authRoutes
EOF
echo "✅ src/modules/auth/routes.tsx"

# ============================================================
# 11. DASHBOARD (skeleton)
# ============================================================
cat > src/modules/dashboard/pages/Dashboard.tsx << 'EOF'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, Package, BarChart3, Users, Clock, LogOut, LayoutGrid, AlertTriangle } from 'lucide-react'
import { useAuth } from '../../../hooks/useAuth'
import ThemeToggle from '../../../components/ui/ThemeToggle'
import Card from '../../../components/ui/Card'

const stats = [
  { label: 'Transaksi Hari Ini', value: '—', icon: ShoppingCart, color: 'bg-teal-50 dark:bg-teal-900/30 text-teal-600 dark:text-teal-400' },
  { label: 'Pendapatan', value: '—', icon: BarChart3, color: 'bg-cyan-50 dark:bg-cyan-900/30 text-cyan-600 dark:text-cyan-400' },
  { label: 'Produk Aktif', value: '—', icon: Package, color: 'bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400' },
  { label: 'Stok Menipis', value: '—', icon: AlertTriangle, color: 'bg-amber-50 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400' },
]

const modules = [
  { icon: ShoppingCart, label: 'Transaksi', desc: 'Proses penjualan kasir' },
  { icon: Package, label: 'Produk', desc: 'Kelola produk & kategori' },
  { icon: LayoutGrid, label: 'Stok', desc: 'Monitor & adjust stok' },
  { icon: Clock, label: 'Shift', desc: 'Buka & tutup shift' },
  { icon: BarChart3, label: 'Laporan', desc: 'Analitik penjualan' },
  { icon: Users, label: 'Users', desc: 'Manajemen pengguna' },
]

export default function Dashboard() {
  const { name, business, role, logout } = useAuth()
  const nav = useNavigate()

  const handleLogout = () => { logout(); nav('/login') }

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 transition-colors">
      <header className="sticky top-0 z-30 glass bg-white/80 dark:bg-slate-900/80 border-b border-slate-200 dark:border-slate-800 px-4 sm:px-6 py-3">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
              <ShoppingCart size={16} className="text-white" />
            </div>
            <div>
              <span className="font-bold text-slate-900 dark:text-white text-sm">FinproPOS</span>
              {business && <span className="text-slate-400 text-xs ml-2">— {business}</span>}
            </div>
          </div>
          <div className="flex items-center gap-3">
            <span className="hidden sm:inline text-slate-500 dark:text-slate-400 text-sm">{name}</span>
            <span className="text-xs gradient-teal text-white px-2.5 py-1 rounded-full capitalize">{role}</span>
            <ThemeToggle />
            <button onClick={handleLogout} className="p-2 text-slate-400 hover:text-red-500 transition-colors cursor-pointer" title="Keluar">
              <LogOut size={18} />
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 py-8">
        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-1">Dashboard</h1>
          <p className="text-sm text-slate-500 dark:text-slate-400 mb-8">Selamat datang, {name}</p>
        </motion.div>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {stats.map((s, i) => (
            <motion.div key={s.label} initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }}>
              <Card>
                <div className="flex items-center gap-3">
                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${s.color}`}>
                    <s.icon size={20} />
                  </div>
                  <div>
                    <p className="text-xs text-slate-500 dark:text-slate-500">{s.label}</p>
                    <p className="text-xl font-bold text-slate-900 dark:text-white">{s.value}</p>
                  </div>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>

        <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">Menu</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
          {modules.map((m, i) => (
            <motion.div key={m.label} initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 + i * 0.06 }}>
              <Card hover className="cursor-pointer group">
                <div className="w-10 h-10 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <m.icon size={20} className="text-teal-600 dark:text-teal-400" />
                </div>
                <p className="font-medium text-sm text-slate-900 dark:text-white">{m.label}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">{m.desc}</p>
              </Card>
            </motion.div>
          ))}
        </div>
      </main>
    </div>
  )
}
EOF
echo "✅ src/modules/dashboard/pages/Dashboard.tsx"

cat > src/modules/dashboard/routes.tsx << 'EOF'
import ProtectedRoute from '../../components/ProtectedRoute'
import Dashboard from './pages/Dashboard'

const dashboardRoutes = [
  { path: '/dashboard', element: <ProtectedRoute><Dashboard /></ProtectedRoute> },
]
export default dashboardRoutes
EOF
echo "✅ src/modules/dashboard/routes.tsx"

# ============================================================
# 12. PROTECTED ROUTE
# ============================================================
cat > src/components/ProtectedRoute.tsx << 'EOF'
import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'

interface Props { children: ReactNode; requiredRole?: string | string[] }

export default function ProtectedRoute({ children, requiredRole }: Props) {
  const { token, role } = useAuth()
  if (!token) return <Navigate to="/login" replace />
  if (requiredRole) {
    const allowed = Array.isArray(requiredRole) ? requiredRole : [requiredRole]
    if (!allowed.includes(role ?? '')) return <Navigate to="/dashboard" replace />
  }
  return <>{children}</>
}
EOF
echo "✅ src/components/ProtectedRoute.tsx"

# ============================================================
# 13. ROUTES + APP + MAIN
# ============================================================
cat > src/routes/index.tsx << 'EOF'
import { useRoutes } from 'react-router-dom'
import landingRoutes from '../modules/landing/routes'
import authRoutes from '../modules/auth/routes'
import dashboardRoutes from '../modules/dashboard/routes'

export default function AppRoutes() {
  return useRoutes([...landingRoutes, ...authRoutes, ...dashboardRoutes])
}
EOF
echo "✅ src/routes/index.tsx"

cat > src/App.tsx << 'EOF'
import { BrowserRouter } from 'react-router-dom'
import AppRoutes from './routes'

export default function App() {
  return (
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  )
}
EOF
echo "✅ src/App.tsx"

cat > src/main.tsx << 'EOF'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App'
import { AuthProvider } from './contexts/AuthContext'
import { ThemeProvider } from './contexts/ThemeContext'

createRoot(document.getElementById('root')!).render(
  <ThemeProvider>
    <AuthProvider>
      <App />
    </AuthProvider>
  </ThemeProvider>
)
EOF
echo "✅ src/main.tsx"

# ============================================================
# 14. ENV
# ============================================================
cat > .env << 'EOF'
VITE_API_URL=http://localhost:8000/api/v1
EOF
echo "✅ .env"

echo ""
echo "============================================"
echo "✅ Setup selesai! Total file: 25"
echo "============================================"
echo ""
echo "Halaman:"
echo "  /           → Landing page"
echo "  /login      → Login"
echo "  /register   → Register"
echo "  /dashboard  → Dashboard (protected)"
echo ""
echo "▶  Jalankan: npm run dev"