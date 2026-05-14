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
