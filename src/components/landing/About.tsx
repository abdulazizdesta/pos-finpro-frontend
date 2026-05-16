import { motion } from 'framer-motion'
import { UserPlus, Settings, TrendingUp } from 'lucide-react'

const steps = [
  {
    num: '01',
    icon: UserPlus,
    title: 'Daftar & Setup Bisnis',
    desc: 'Buat akun bisnis dalam 2 menit. Setup outlet, produk, dan user tanpa perlu training.',
    tags: ['Daftar Gratis', 'Setup Outlet'],
  },
  {
    num: '02',
    icon: Settings,
    title: 'Konfigurasi & Import Data',
    desc: 'Import produk via CSV, set harga, kategori, dan stok awal di semua outlet Anda.',
    tags: ['Import CSV', 'Setup Stok'],
  },
  {
    num: '03',
    icon: TrendingUp,
    title: 'Mulai Transaksi & Pantau',
    desc: 'Kasir mulai berjualan, stok berkurang otomatis, laporan tersedia real-time.',
    tags: ['Go Live', 'Monitor'],
  },
]

export default function About() {
  return (
    <section id="about" className="py-24 px-4 sm:px-6 bg-slate-50 dark:bg-slate-900/50">
      <div className="max-w-6xl mx-auto">
        <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="text-center mb-16">
          <span className="inline-block px-4 py-1.5 rounded-full bg-teal-50 dark:bg-teal-900/30 text-teal-700 dark:text-teal-400 text-xs font-semibold uppercase tracking-wider mb-4">How It Works</span>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">
            Mulai dalam <span className="text-teal-600 dark:text-teal-400">3 langkah mudah</span>
          </h2>
        </motion.div>

        <div className="flex flex-col gap-12">
          {steps.map((step, i) => (
            <motion.div
              key={step.num} initial={{ opacity: 0, x: i % 2 === 0 ? -30 : 30 }}
              whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.1 }}
              className={`flex flex-col ${i % 2 === 0 ? 'lg:flex-row' : 'lg:flex-row-reverse'} gap-8 items-center`}
            >
              {/* Text side */}
              <div className="flex-1">
                <div className="flex items-center gap-4 mb-4">
                  <span className="text-5xl font-bold text-slate-100 dark:text-slate-800">{step.num}</span>
                  <div className="w-10 h-10 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center">
                    <step.icon size={20} className="text-teal-600 dark:text-teal-400" />
                  </div>
                </div>
                <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-3">{step.title}</h3>
                <p className="text-slate-500 dark:text-slate-400 leading-relaxed mb-4">{step.desc}</p>
                <div className="flex gap-2">
                  {step.tags.map(t => (
                    <span key={t} className="text-xs px-3 py-1.5 rounded-full border border-teal-200 dark:border-teal-800 text-teal-700 dark:text-teal-400 bg-teal-50 dark:bg-teal-900/20">
                      {t}
                    </span>
                  ))}
                </div>
              </div>

              {/* Visual side */}
              <div className="flex-1 w-full">
                <div className="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-6 shadow-sm">
                  <div className="flex items-center gap-1.5 mb-4">
                    {['bg-red-400', 'bg-yellow-400', 'bg-green-400'].map(c => (
                      <div key={c} className={`w-2.5 h-2.5 rounded-full ${c}`} />
                    ))}
                  </div>
                  <div className="space-y-2.5">
                    {[80, 60, 90, 45].map((w, j) => (
                      <div key={j} className="flex items-center gap-3">
                        <div className="w-7 h-7 rounded-lg bg-teal-50 dark:bg-teal-900/30" />
                        <div className="flex-1 space-y-1">
                          <div className="h-2 rounded-full bg-slate-100 dark:bg-slate-700" style={{ width: `${w}%` }} />
                          <div className="h-1.5 rounded-full bg-slate-50 dark:bg-slate-800" style={{ width: `${w * 0.6}%` }} />
                        </div>
                        <div className="w-12 h-6 rounded-lg bg-teal-50 dark:bg-teal-900/30" />
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
