import { motion } from 'framer-motion'
import { ShoppingCart, Package, BarChart3, Users, Zap, Shield } from 'lucide-react'

const features = [
  { icon: ShoppingCart, title: 'Transaksi Instan', desc: 'Proses penjualan cepat dengan support cash, QRIS, dan kartu. Auto-calculate tax & diskon stackable.' },
  { icon: Package, title: 'Stok Real-time', desc: 'Monitor stok per outlet, alert minimum, dan log mutasi otomatis setiap transaksi terjadi.' },
  { icon: BarChart3, title: 'Laporan Analytics', desc: 'Dashboard penjualan, produk terlaris, dan trend bisnis dengan visualisasi interaktif.' },
  { icon: Users, title: 'Multi-Role Access', desc: 'Superadmin, owner, admin, kasir — setiap role dengan akses yang tepat dan aman.' },
  { icon: Zap, title: 'Multi-Outlet', desc: 'Kelola banyak outlet dalam satu dashboard. Data terpisah, laporan terpusat.' },
  { icon: Shield, title: 'Aman & Reliable', desc: 'Shift management, audit trail lengkap, dan data terenkripsi end-to-end.' },
]

export default function Features() {
  return (
    <section id="features" className="py-24 px-4 sm:px-6 bg-white dark:bg-slate-950">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
          className="text-center mb-16"
        >
          <span className="inline-block px-4 py-1.5 rounded-full bg-teal-50 dark:bg-teal-900/30 text-teal-700 dark:text-teal-400 text-xs font-semibold uppercase tracking-wider mb-4">Features</span>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">Semua yang bisnis Anda butuhkan</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-4 max-w-xl mx-auto">Fitur lengkap POS modern yang dirancang untuk retail.</p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((f, i) => (
            <motion.div
              key={f.title} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.1 }}
              className="group p-6 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-teal-300 dark:hover:border-teal-700 hover:shadow-lg hover:shadow-teal-500/5 transition-all duration-300 bg-white dark:bg-slate-900"
            >
              <div className="w-11 h-11 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                <f.icon size={22} className="text-teal-600 dark:text-teal-400" />
              </div>
              <h3 className="font-semibold text-slate-900 dark:text-white mb-2">{f.title}</h3>
              <p className="text-sm text-slate-500 dark:text-slate-400 leading-relaxed">{f.desc}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
