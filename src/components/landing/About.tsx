import { motion } from 'framer-motion'
import { Target, TrendingUp, Globe } from 'lucide-react'

const items = [
  { icon: Target, title: 'Fokus Retail', desc: 'Dibangun khusus untuk kebutuhan retail modern — fashion, elektronik, FMCG, dan lainnya.' },
  { icon: TrendingUp, title: 'Scalable', desc: 'Dari 1 outlet sampai 100+ outlet, arsitektur kami siap tumbuh bersama bisnis Anda.' },
  { icon: Globe, title: 'Cloud-Based', desc: 'Akses dari mana saja, kapan saja. Data tersinkronisasi real-time di semua perangkat.' },
]

export default function About() {
  return (
    <section id="about" className="py-24 px-4 sm:px-6 bg-slate-50 dark:bg-slate-800/20">
      <div className="max-w-6xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <motion.div initial={{ opacity: 0, x: -30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}>
            <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">About</p>
            <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white mb-6">
              POS yang <span className="gradient-text">memahami</span> bisnis retail
            </h2>
            <p className="text-slate-600 dark:text-slate-400 leading-relaxed mb-8">
              FinproPOS lahir dari kebutuhan nyata pebisnis retail yang lelah dengan sistem POS yang rumit dan mahal.
              Kami merancang solusi yang simpel, powerful, dan affordable untuk semua skala bisnis.
            </p>
            <div className="flex gap-8">
              {[['3+', 'Tahun'], ['500+', 'Client'], ['15+', 'Kota']].map(([v, l]) => (
                <div key={l}>
                  <p className="text-2xl font-bold text-teal-600 dark:text-teal-400">{v}</p>
                  <p className="text-sm text-slate-500">{l}</p>
                </div>
              ))}
            </div>
          </motion.div>

          <div className="flex flex-col gap-5">
            {items.map((it, i) => (
              <motion.div
                key={it.title} initial={{ opacity: 0, x: 30 }} whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }} transition={{ delay: i * 0.15 }}
                className="flex gap-4 p-5 rounded-2xl bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50"
              >
                <div className="w-11 h-11 rounded-xl bg-teal-50 dark:bg-teal-900/30 flex items-center justify-center flex-shrink-0">
                  <it.icon size={22} className="text-teal-600 dark:text-teal-400" />
                </div>
                <div>
                  <h3 className="font-semibold text-slate-900 dark:text-white mb-1">{it.title}</h3>
                  <p className="text-sm text-slate-500 dark:text-slate-400">{it.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
