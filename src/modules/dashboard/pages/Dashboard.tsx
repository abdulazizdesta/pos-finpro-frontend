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
