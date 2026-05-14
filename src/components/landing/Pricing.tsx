import { motion } from 'framer-motion'
import { Check } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import Button from '../ui/Button'

const plans = [
  {
    name: 'Starter', price: 'Gratis', period: 'selamanya',
    desc: 'Untuk bisnis yang baru mulai',
    features: ['1 Outlet', 'Maks 100 transaksi/bulan', '2 User', 'Laporan dasar'],
    cta: 'Mulai Gratis', highlighted: false,
  },
  {
    name: 'Business', price: 'Rp 199K', period: '/bulan',
    desc: 'Untuk bisnis yang tumbuh',
    features: ['5 Outlet', 'Transaksi unlimited', '10 User', 'Laporan lengkap', 'Diskon & pajak', 'Export PDF/Excel'],
    cta: 'Pilih Business', highlighted: true,
  },
  {
    name: 'Enterprise', price: 'Custom', period: '',
    desc: 'Untuk jaringan besar',
    features: ['Unlimited outlet', 'Unlimited semua', 'API access', 'Dedicated support', 'Custom integration', 'SLA 99.9%'],
    cta: 'Hubungi Sales', highlighted: false,
  },
]

export default function Pricing() {
  const nav = useNavigate()
  return (
    <section id="pricing" className="py-24 px-4 sm:px-6 bg-slate-50 dark:bg-slate-800/20">
      <div className="max-w-6xl mx-auto">
        <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="text-center mb-16">
          <p className="text-sm font-semibold text-teal-600 dark:text-teal-400 mb-3 uppercase tracking-wider">Pricing</p>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">Harga yang masuk akal</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-4">Mulai gratis, upgrade sesuai kebutuhan.</p>
        </motion.div>

        <div className="grid md:grid-cols-3 gap-6 items-start">
          {plans.map((p, i) => (
            <motion.div
              key={p.name} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.15 }}
              className={`rounded-2xl p-8 ${
                p.highlighted
                  ? 'bg-gradient-to-b from-teal-600 to-teal-700 text-white ring-2 ring-teal-400 shadow-xl shadow-teal-500/20 scale-[1.03]'
                  : 'bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50'
              }`}
            >
              <p className={`font-semibold mb-1 ${p.highlighted ? 'text-teal-100' : 'text-teal-600 dark:text-teal-400'}`}>{p.name}</p>
              <div className="flex items-baseline gap-1 mb-2">
                <span className={`text-3xl font-bold ${p.highlighted ? 'text-white' : 'text-slate-900 dark:text-white'}`}>{p.price}</span>
                {p.period && <span className={`text-sm ${p.highlighted ? 'text-teal-200' : 'text-slate-500'}`}>{p.period}</span>}
              </div>
              <p className={`text-sm mb-6 ${p.highlighted ? 'text-teal-100' : 'text-slate-500 dark:text-slate-400'}`}>{p.desc}</p>
              <ul className="space-y-3 mb-8">
                {p.features.map(f => (
                  <li key={f} className="flex items-center gap-2.5 text-sm">
                    <Check size={16} className={p.highlighted ? 'text-teal-200' : 'text-teal-500'} />
                    <span className={p.highlighted ? 'text-white' : 'text-slate-600 dark:text-slate-400'}>{f}</span>
                  </li>
                ))}
              </ul>
              <Button
                variant={p.highlighted ? 'ghost' : 'outline'} size="md"
                className={`w-full ${p.highlighted ? 'bg-white text-teal-700 hover:bg-teal-50' : ''}`}
                onClick={() => nav('/register')}
              >{p.cta}</Button>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
