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
