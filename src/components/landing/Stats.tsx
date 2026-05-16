import { motion } from 'framer-motion'
import { Users, ShoppingCart, Star, TrendingUp } from 'lucide-react'

const stats = [
  { icon: Users, value: '2.500+', label: 'Bisnis aktif' },
  { icon: ShoppingCart, value: '50K+', label: 'Transaksi/hari' },
  { icon: Star, value: '4.9/5.0', label: 'Customer review' },
  { icon: TrendingUp, value: '99.9%', label: 'Uptime SLA' },
]

export default function Stats() {
  return (
    <section className="py-12 px-4 sm:px-6 bg-white dark:bg-slate-950 border-b border-slate-100 dark:border-slate-800">
      <div className="max-w-5xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
          className="grid grid-cols-2 lg:grid-cols-4 gap-4"
        >
          {stats.map((s, i) => (
            <motion.div
              key={s.label} initial={{ opacity: 0, y: 15 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.1 }}
              className="flex items-center gap-3 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900"
            >
              <div className="w-10 h-10 rounded-xl gradient-teal flex items-center justify-center flex-shrink-0">
                <s.icon size={18} className="text-white" />
              </div>
              <div>
                <p className="font-bold text-slate-900 dark:text-white text-lg leading-tight">{s.value}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">{s.label}</p>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  )
}
