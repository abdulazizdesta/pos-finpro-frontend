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
