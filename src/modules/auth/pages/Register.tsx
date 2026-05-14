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
