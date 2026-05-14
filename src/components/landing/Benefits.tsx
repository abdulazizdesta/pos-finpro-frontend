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
