import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, ArrowLeft, Package, BarChart3, Users, Zap, Star } from 'lucide-react'
import { useAuth } from '../../../hooks/useAuth'
import api from '../../../services/api'
import Button from '../../../components/ui/Button'
import Input from '../../../components/ui/Input'
import ThemeToggle from '../../../components/ui/ThemeToggle'
import type { RegisterPayload } from '../../../types/auth'

type FormErrors = Partial<Record<keyof RegisterPayload, string>>

const features = [
  { icon: Package, label: 'Multi-outlet', desc: 'Kelola banyak outlet' },
  { icon: BarChart3, label: 'Auto report', desc: 'Laporan real-time' },
  { icon: Users, label: 'Role access', desc: 'Kasir, admin, owner' },
  { icon: Zap, label: 'Stok otomatis', desc: 'Update tiap transaksi' },
]

const avatars = ['BW', 'SR', 'AJ', 'DK', 'MR']

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
    { name: 'owner_name', label: 'Nama', type: 'text', placeholder: 'John Doe' },
    { name: 'email', label: 'Email', type: 'email', placeholder: 'owner@bisnis.com' },
    { name: 'password', label: 'Password', type: 'password', placeholder: 'Min. 8 karakter' },
    { name: 'password_confirmation', label: 'Konfirmasi Password', type: 'password', placeholder: 'Konfirmasi password' },
  ]

  return (
    <div className="h-screen flex bg-slate-50 dark:bg-slate-950 transition-colors overflow-hidden">

      {/* ── LEFT PANEL ── */}
      <div className="hidden lg:flex flex-1 relative overflow-hidden">

        {/* Background */}
        <div className="absolute inset-0 bg-gradient-to-br from-teal-700 via-teal-600 to-cyan-500" />
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_80%_at_20%_20%,rgba(255,255,255,0.08),transparent)]" />

        {/* Dot grid pattern */}
        <div className="absolute inset-0 opacity-20"
          style={{ backgroundImage: 'radial-gradient(circle, rgba(255,255,255,0.4) 1px, transparent 1px)', backgroundSize: '28px 28px' }}
        />

        <div className="relative z-10 flex flex-col justify-between h-full px-12 py-12 w-full">

          {/* Top — Logo */}
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <ShoppingCart size={18} className="text-white" />
            </div>
            <span className="font-bold text-white text-lg">FinproPOS</span>
          </div>

          {/* Middle — Main content */}
          <motion.div
            initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
            className="flex flex-col gap-8"
          >
            {/* Headline */}
            <div>
              <p className="text-teal-200 text-sm font-medium mb-3 uppercase tracking-wider">Bergabung sekarang</p>
              <h2 className="text-4xl font-bold text-white leading-tight mb-4">
                Bisnis Anda,<br />
                <span className="text-teal-100">Lebih Terorganisir</span>
              </h2>
              <p className="text-teal-100/80 text-sm leading-relaxed max-w-xs">
                Dari transaksi kasir hingga laporan bulanan — semua otomatis, semua terpusat.
              </p>
            </div>

            {/* Feature cards grid */}
            <div className="grid grid-cols-2 gap-3">
              {features.map((f, i) => (
                <motion.div
                  key={f.label}
                  initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.4 + i * 0.1 }}
                  className="bg-white/10 backdrop-blur-sm border border-white/15 rounded-2xl p-4 hover:bg-white/15 transition-colors"
                >
                  <div className="w-8 h-8 bg-white/15 rounded-lg flex items-center justify-center mb-3">
                    <f.icon size={16} className="text-white" />
                  </div>
                  <p className="text-white font-semibold text-sm">{f.label}</p>
                  <p className="text-teal-100/70 text-xs mt-0.5">{f.desc}</p>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* Bottom — Social proof */}
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.7 }}
            className="flex flex-col gap-4"
          >
            {/* Rating */}
            <div className="flex items-center gap-2">
              <div className="flex gap-0.5">
                {[...Array(5)].map((_, i) => <Star key={i} size={14} className="text-amber-300 fill-amber-300" />)}
              </div>
              <span className="text-white/70 text-xs">4.9 dari 500+ ulasan</span>
            </div>

            {/* Avatar stack + text */}
            <div className="flex items-center gap-3">
              <div className="flex -space-x-2">
                {avatars.map((a, i) => (
                  <div key={i} className="w-8 h-8 rounded-full bg-white/20 border-2 border-teal-600 flex items-center justify-center text-[10px] font-bold text-white">
                    {a}
                  </div>
                ))}
                <div className="w-8 h-8 rounded-full bg-white/10 border-2 border-teal-600 flex items-center justify-center text-[10px] text-white/70">
                  +
                </div>
              </div>
              <p className="text-teal-100/80 text-xs">
                <span className="text-white font-semibold">500+ bisnis</span> sudah bergabung
              </p>
            </div>
          </motion.div>

        </div>
      </div>

      {/* ── RIGHT PANEL — Form ── */}
      <motion.div
        initial={{ opacity: 0, x: 40 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 40 }}
        transition={{ duration: 0.4, ease: 'easeOut' }}
        className="flex flex-1 flex-col justify-center items-center px-6 py-6 overflow-y-auto"
      >
        <div className="w-full max-w-sm py-12">
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

          <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-4">Buat akun bisnis</h1>

          {globalError && (
            <div className="bg-red-50 dark:bg-red-950/50 border border-red-200 dark:border-red-800 text-red-600 dark:text-red-400 text-sm px-4 py-2.5 rounded-xl mb-4">{globalError}</div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-2">
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