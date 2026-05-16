import { motion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import { ArrowRight, TrendingUp, ShoppingCart, Package, CheckCircle } from 'lucide-react'

export default function Hero() {
  const nav = useNavigate()
  return (
    <section className="relative min-h-screen flex items-center pt-16 overflow-hidden">

      <div className="absolute inset-0 bg-gradient-to-br from-teal-300 via-teal-200 to-cyan-200 dark:from-teal-900 dark:via-teal-800 dark:to-cyan-900" />
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_80%_60%_at_50%_-10%,rgba(255,255,255,0.12),transparent)]" />

      <div className="relative z-10 w-full max-w-7xl mx-auto px-5 sm:px-8 lg:px-12 pt-0 pb-24 lg:py-16">
        <div className="flex flex-col lg:flex-row items-center gap-10 lg:gap-16">

          {/* ── TEXT SECTION ── */}
          <div className="flex-1 w-full text-left lg:text-left">

            {/* Heading */}
            <motion.h1
              initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5, delay: 0.1 }}
              className="text-5xl sm:text-6xl lg:text-7xl font-bold text-teal-900 leading-tight mb-4 dark:text-white"
            >
              Transformasi<br />
              Bisnis Retail<br className="hidden sm:block" />
              <span className="text-teal-900 dark:text-white"> Anda</span>
            </motion.h1>

            {/* Subheading */}
            <motion.p
              initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5, delay: 0.2 }}
              className="text-base text-teal-800 max-w-sm mb-7 leading-relaxed dark:text-teal-200"
            >
              Kelola stok, penjualan, dan laporan bisnis Anda dalam satu platform modern.
            </motion.p>

            {/* CTA Button — full width mobile, auto desktop */}
            <motion.div
              initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.5, delay: 0.3 }}
              className="flex flex-col sm:flex-row gap-3 mb-8"
            >
              <button
                onClick={() => nav('/register')}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-7 py-3 gradient-teal-btn font-semibold rounded-xl sm:rounded-full hover:opacity-90 hover:shadow-xl hover:shadow-teal-900/30 active:scale-[0.98] cursor-pointer text-sm transition-all"
              >
                Coba Gratis Sekarang <ArrowRight size={15} />
              </button>
              <button
                onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}
                className="hidden sm:inline-flex items-center justify-center gap-2 px-7 py-3 bg-white/20 text-teal-500 dark:text-white font-medium rounded-full border border-white/20 hover:bg-white/20 transition-all cursor-pointer text-sm"
              >
                Lihat Fitur
              </button>
            </motion.div>

            {/* Stats — hidden mobile */}
            <motion.div
              initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.5 }}
              className="hidden sm:flex gap-8"
            >
              {[['500+', 'Bisnis aktif'], ['50K+', 'Transaksi/hari'], ['99.9%', 'Uptime']].map(([val, label]) => (
                <div key={label}>
                  <p className="text-xl font-bold text-teal-800 dark:text-white">{val}</p>
                  <p className="text-[11px] text-teal-800 dark:text-white mt-0.5">{label}</p>
                </div>
              ))}
            </motion.div>
          </div>

          {/* ── DESKTOP CARDS ── */}
          <div className="hidden lg:flex flex-1 w-full">
            <div className="relative flex flex-col gap-4 items-end w-full">
              <motion.div
                initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.6, delay: 0.2 }}
                className="w-full max-w-sm bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-5 [animation:float_4s_ease-in-out_infinite]"
              >
                <div className="flex items-center gap-2 mb-4">
                  <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
                    <ShoppingCart size={16} className="text-white" />
                  </div>
                  <div>
                    <p className="text-xs text-slate-400">Transaksi Hari Ini</p>
                    <p className="text-sm font-semibold text-slate-800 dark:text-white">Outlet</p>
                  </div>
                  <span className="ml-auto text-xs bg-teal-100 dark:bg-teal-900/50 text-teal-700 dark:text-teal-400 px-2 py-0.5 rounded-full">+18%</span>
                </div>
                <p className="text-3xl font-bold text-slate-900 dark:text-white mb-4">Rp 4.280.000</p>
                <div className="flex items-end gap-1 h-12 mb-1">
                  {[40, 65, 45, 80, 55, 90, 70].map((h, i) => (
                    <div key={i} className="flex-1 rounded-sm bg-teal-500/15 relative overflow-hidden">
                      <div className="absolute bottom-0 left-0 right-0 gradient-teal rounded-sm" style={{ height: `${h}%` }} />
                    </div>
                  ))}
                </div>
                <div className="flex justify-between">
                  {['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].map(d => (
                    <span key={d} className="text-[9px] text-slate-400 flex-1 text-center">{d}</span>
                  ))}
                </div>
              </motion.div>

              <div className="flex gap-4 w-full max-w-sm">
                <motion.div
                  initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.35 }}
                  className="flex-1 bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-4 [animation:float_4s_ease-in-out_0.7s_infinite]"
                >
                  <div className="flex items-center gap-1.5 mb-3">
                    <Package size={13} className="text-teal-500" />
                    <p className="text-xs text-slate-400">Stok</p>
                  </div>
                  <div className="space-y-2">
                    {[
                      { name: 'Kaos Polos', qty: 84, color: 'bg-teal-400' },
                      { name: 'Celana Chino', qty: 32, color: 'bg-cyan-400' },
                      { name: 'Hoodie', qty: 11, color: 'bg-amber-400' },
                    ].map(item => (
                      <div key={item.name} className="flex items-center gap-1.5">
                        <div className={`w-1.5 h-1.5 rounded-full flex-shrink-0 ${item.color}`} />
                        <span className="text-[11px] text-slate-600 dark:text-slate-300 flex-1 truncate">{item.name}</span>
                        <span className="text-[11px] font-semibold text-slate-800 dark:text-white">{item.qty}</span>
                      </div>
                    ))}
                  </div>
                </motion.div>

                <motion.div
                  initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.45 }}
                  className="flex-1 bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-4 [animation:float_4s_ease-in-out_1.4s_infinite]"
                >
                  <div className="flex items-center gap-1.5 mb-3">
                    <div className="w-1.5 h-1.5 rounded-full bg-teal-400 animate-pulse" />
                    <p className="text-xs text-slate-400">Shift Aktif</p>
                  </div>
                  <p className="text-sm font-bold text-slate-900 dark:text-white mb-1">08:00–16:00</p>
                  <p className="text-[11px] text-slate-400 mb-3">Budi Santoso</p>
                  <div className="space-y-1.5">
                    <div className="flex justify-between text-[11px]">
                      <span className="text-slate-400">Modal</span>
                      <span className="text-slate-700 dark:text-slate-300">Rp 500K</span>
                    </div>
                    <div className="flex justify-between text-[11px]">
                      <span className="text-slate-400">Trx</span>
                      <span className="font-semibold text-teal-600 dark:text-teal-400">24</span>
                    </div>
                  </div>
                  <div className="mt-3 pt-2 border-t border-slate-100 dark:border-slate-700 flex items-center gap-1">
                    <TrendingUp size={11} className="text-teal-500" />
                    <span className="text-[10px] text-teal-600 dark:text-teal-400">Performa baik</span>
                  </div>
                </motion.div>
              </div>
            </div>
          </div>

          {/* ── MOBILE CARD (satu card + slogan) ── */}
          <div className="flex lg:hidden flex-col items-center w-full gap-5">

            {/* Single bounce card */}
            <motion.div
              initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.4 }}
              className="w-full max-w-xs bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-5 [animation:float_4s_ease-in-out_infinite]"
            >
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
                  <ShoppingCart size={16} className="text-white" />
                </div>
                <div>
                  <p className="text-xs text-slate-400">Transaksi Hari Ini</p>
                  <p className="text-sm font-semibold text-slate-800 dark:text-white">Outlet </p>
                </div>
                <span className="ml-auto text-xs bg-teal-100 dark:bg-teal-900/50 text-teal-700 dark:text-teal-400 px-2 py-0.5 rounded-full">+18%</span>
              </div>
              <p className="text-2xl font-bold text-slate-900 dark:text-white mb-3">Rp 4.280.000</p>
              <div className="flex items-end gap-1 h-10 mb-1">
                {[40, 65, 45, 80, 55, 90, 70].map((h, i) => (
                  <div key={i} className="flex-1 rounded-sm bg-teal-500/15 relative overflow-hidden">
                    <div className="absolute bottom-0 left-0 right-0 gradient-teal rounded-sm" style={{ height: `${h}%` }} />
                  </div>
                ))}
              </div>
              <div className="flex justify-between">
                {['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].map(d => (
                  <span key={d} className="text-[9px] text-slate-400 flex-1 text-center">{d}</span>
                ))}
              </div>
            </motion.div>

            {/* Mobile slogan */}
            <motion.p
              initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.6 }}
              className="text-center text-teal-600 dark:text-white text-sm tracking-widest uppercase"
            >
              Dipercaya 500+ merchant di Indonesia
            </motion.p>

          </div>

        </div>
      </div>
    </section>
  )
}