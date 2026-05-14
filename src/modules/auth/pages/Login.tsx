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
