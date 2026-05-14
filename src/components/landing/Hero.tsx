import { motion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import { ArrowRight, Sparkles } from 'lucide-react'
import Button from '../ui/Button'

export default function Hero() {
  const nav = useNavigate()
  return (
    <section className="relative min-h-screen flex items-center justify-center pt-16 overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-teal-50/50 via-transparent to-transparent dark:from-teal-950/20 dark:via-transparent" />
      <div className="absolute top-32 left-1/4 w-72 h-72 bg-teal-400/10 rounded-full blur-3xl" />
      <div className="absolute bottom-32 right-1/4 w-96 h-96 bg-cyan-400/10 rounded-full blur-3xl" />

      <div className="relative max-w-4xl mx-auto px-4 sm:px-6 text-center">
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-teal-200 dark:border-teal-800 bg-teal-50 dark:bg-teal-950/50 text-teal-700 dark:text-teal-400 text-sm mb-8">
            <Sparkles size={14} /> Platform POS Modern untuk Bisnis Anda
          </div>
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.1 }}
          className="text-4xl sm:text-5xl lg:text-6xl font-bold text-slate-900 dark:text-white leading-tight mb-6"
        >
          Kelola Bisnis Retail{' '}
          <span className="gradient-text">Lebih Cerdas</span>
          <br />dan Efisien
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.2 }}
          className="text-lg text-slate-600 dark:text-slate-400 max-w-2xl mx-auto mb-10"
        >
          Transaksi, stok, laporan, dan multi-outlet — semua dalam satu platform.
          Dibangun untuk skala bisnis yang terus tumbuh.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.3 }}
          className="flex flex-col sm:flex-row gap-4 justify-center"
        >
          <Button size="lg" onClick={() => nav('/register')}>
            Mulai Gratis <ArrowRight size={18} className="ml-2" />
          </Button>
          <Button variant="outline" size="lg" onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}>
            Lihat Fitur
          </Button>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6, duration: 1 }}
          className="mt-16 grid grid-cols-3 gap-8 max-w-md mx-auto"
        >
          {[['500+', 'Bisnis aktif'], ['50K+', 'Transaksi/hari'], ['99.9%', 'Uptime']].map(([val, label]) => (
            <div key={label}>
              <p className="text-2xl font-bold gradient-text">{val}</p>
              <p className="text-xs text-slate-500 dark:text-slate-500 mt-1">{label}</p>
            </div>
          ))}
        </motion.div>
      </div>
    </section>
  )
}
