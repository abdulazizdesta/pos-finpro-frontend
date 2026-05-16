#!/bin/bash
set -e
echo "🚀 Updating Landing Page..."

# ============================================================
# HERO.TSX — Full teal gradient + floating mockup cards
# ============================================================
cat > src/components/landing/Hero.tsx << 'EOF'
import { motion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import { ArrowRight, TrendingUp, ShoppingCart, Package, CheckCircle } from 'lucide-react'
import Button from '../ui/Button'

const float = {
  animate: { y: [0, -10, 0], transition: { duration: 4, repeat: Infinity, ease: 'easeInOut' } }
}
const floatDelay = (delay: number) => ({
  animate: { y: [0, -8, 0], transition: { duration: 4, repeat: Infinity, ease: 'easeInOut', delay } }
})

export default function Hero() {
  const nav = useNavigate()
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center pt-16 overflow-hidden">

      {/* Teal gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-teal-700 via-teal-600 to-cyan-500 dark:from-teal-900 dark:via-teal-800 dark:to-cyan-900" />

      {/* Subtle overlay shapes */}
      <div className="absolute inset-0">
        <div className="absolute top-0 left-0 w-full h-full bg-[radial-gradient(ellipse_80%_60%_at_50%_-10%,rgba(255,255,255,0.12),transparent)]" />
        <div className="absolute bottom-0 left-0 right-0 h-48 bg-gradient-to-t from-white/10 dark:from-black/20 to-transparent" />
      </div>

      {/* Floating bg rectangles (like Rampay) */}
      <div className="absolute left-8 top-1/3 w-40 h-48 rounded-3xl bg-white/5 border border-white/10" />
      <div className="absolute left-4 top-1/2 w-32 h-36 rounded-3xl bg-white/5 border border-white/10" />
      <div className="absolute right-8 top-1/3 w-40 h-48 rounded-3xl bg-white/5 border border-white/10" />
      <div className="absolute right-4 top-1/2 w-32 h-36 rounded-3xl bg-white/5 border border-white/10" />

      {/* Hero text */}
      <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 text-center mb-16">
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6 }}>
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/15 border border-white/20 text-white/90 text-sm mb-8 backdrop-blur-sm">
            <CheckCircle size={14} /> Platform POS Modern untuk Bisnis Anda
          </div>
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.1 }}
          className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white leading-tight mb-6"
        >
          Kelola Bisnis Retail<br />
          <span className="text-teal-100">Lebih Cerdas</span> dan Efisien
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.2 }}
          className="text-lg text-white/70 max-w-2xl mx-auto mb-10"
        >
          Transaksi, stok, laporan, dan multi-outlet — semua dalam satu platform.
          Dibangun untuk skala bisnis yang terus tumbuh.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, delay: 0.3 }}
          className="flex flex-col sm:flex-row gap-4 justify-center"
        >
          <button
            onClick={() => nav('/register')}
            className="inline-flex items-center justify-center gap-2 px-8 py-3 bg-white text-teal-700 font-semibold rounded-full hover:bg-teal-50 transition-all hover:shadow-xl hover:shadow-black/20 active:scale-[0.98] cursor-pointer text-sm"
          >
            Mulai Gratis — Gratis <ArrowRight size={16} />
          </button>
          <button
            onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}
            className="inline-flex items-center justify-center gap-2 px-8 py-3 bg-white/10 text-white font-medium rounded-full border border-white/20 hover:bg-white/20 transition-all cursor-pointer text-sm backdrop-blur-sm"
          >
            Lihat Fitur
          </button>
        </motion.div>
      </div>

      {/* Floating mockup cards */}
      <div className="relative z-10 w-full max-w-5xl mx-auto px-4 sm:px-6">
        <div className="flex items-end justify-center gap-4 sm:gap-6">

          {/* Left card — Stok */}
          <motion.div {...floatDelay(0.5)} className="hidden sm:block w-56 bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-4 mb-0 flex-shrink-0">
            <p className="text-xs text-slate-400 mb-3">Stok Real-time</p>
            <div className="space-y-2.5">
              {[
                { name: 'Kaos Polos', qty: 84, color: 'bg-teal-400' },
                { name: 'Celana Chino', qty: 32, color: 'bg-cyan-400' },
                { name: 'Hoodie Fleece', qty: 11, color: 'bg-amber-400' },
              ].map(item => (
                <div key={item.name} className="flex items-center gap-2">
                  <div className={`w-2 h-2 rounded-full ${item.color}`} />
                  <span className="text-xs text-slate-600 dark:text-slate-300 flex-1">{item.name}</span>
                  <span className="text-xs font-semibold text-slate-800 dark:text-white">{item.qty}</span>
                </div>
              ))}
            </div>
            <div className="mt-3 pt-3 border-t border-slate-100 dark:border-slate-700 flex items-center gap-1.5">
              <Package size={12} className="text-teal-500" />
              <span className="text-xs text-teal-600 dark:text-teal-400">3 produk aktif</span>
            </div>
          </motion.div>

          {/* Center card — Transaksi (bigger) */}
          <motion.div {...float} className="w-72 sm:w-80 bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-5 flex-shrink-0">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
                <ShoppingCart size={16} className="text-white" />
              </div>
              <div>
                <p className="text-xs text-slate-400">Transaksi Hari Ini</p>
                <p className="text-sm font-semibold text-slate-800 dark:text-white">Outlet Pusat</p>
              </div>
            </div>

            <p className="text-3xl font-bold text-slate-900 dark:text-white mb-1">Rp 4.280.000</p>
            <div className="flex items-center gap-1.5 mb-4">
              <span className="text-xs bg-teal-100 dark:bg-teal-900/50 text-teal-700 dark:text-teal-400 px-2 py-0.5 rounded-full">+18%</span>
              <span className="text-xs text-slate-400">vs kemarin</span>
            </div>

            <div className="space-y-2">
              {[
                { label: 'Total Transaksi', val: '24' },
                { label: 'Produk Terjual', val: '67 pcs' },
                { label: 'Metode QRIS', val: '58%' },
              ].map(r => (
                <div key={r.label} className="flex justify-between text-xs">
                  <span className="text-slate-400">{r.label}</span>
                  <span className="font-medium text-slate-700 dark:text-slate-300">{r.val}</span>
                </div>
              ))}
            </div>

            {/* Mini bar chart */}
            <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-700">
              <div className="flex items-end gap-1 h-10">
                {[40, 65, 45, 80, 55, 90, 70].map((h, i) => (
                  <div key={i} className="flex-1 rounded-sm bg-teal-500/20 dark:bg-teal-400/20 relative overflow-hidden">
                    <div className="absolute bottom-0 left-0 right-0 gradient-teal rounded-sm" style={{ height: `${h}%` }} />
                  </div>
                ))}
              </div>
              <div className="flex justify-between mt-1">
                {['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].map(d => (
                  <span key={d} className="text-[9px] text-slate-400 flex-1 text-center">{d}</span>
                ))}
              </div>
            </div>
          </motion.div>

          {/* Right card — Shift */}
          <motion.div {...floatDelay(1)} className="hidden sm:block w-56 bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-4 flex-shrink-0">
            <p className="text-xs text-slate-400 mb-3">Shift Aktif</p>
            <div className="flex items-center gap-2 mb-3">
              <div className="w-2 h-2 rounded-full bg-teal-400 animate-pulse" />
              <span className="text-xs font-medium text-slate-700 dark:text-slate-300">Shift Pagi</span>
            </div>
            <p className="text-lg font-bold text-slate-900 dark:text-white mb-1">08:00 — 16:00</p>
            <p className="text-xs text-slate-400 mb-3">Kasir: Budi Santoso</p>
            <div className="space-y-1.5">
              <div className="flex justify-between text-xs">
                <span className="text-slate-400">Modal Awal</span>
                <span className="text-slate-700 dark:text-slate-300">Rp 500K</span>
              </div>
              <div className="flex justify-between text-xs">
                <span className="text-slate-400">Transaksi</span>
                <span className="font-semibold text-teal-600 dark:text-teal-400">24 trx</span>
              </div>
            </div>
            <div className="mt-3 pt-3 border-t border-slate-100 dark:border-slate-700 flex items-center gap-1.5">
              <TrendingUp size={12} className="text-teal-500" />
              <span className="text-xs text-teal-600 dark:text-teal-400">Performa baik</span>
            </div>
          </motion.div>

        </div>
      </div>

      {/* Bottom fade to white */}
      <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-white dark:from-slate-950 to-transparent" />
    </section>
  )
}
EOF
echo "✅ src/components/landing/Hero.tsx"

# ============================================================
# FEATURES.TSX — add "how it works" style numbering
# ============================================================
cat > src/components/landing/Features.tsx << 'EOF'
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
EOF
echo "✅ src/components/landing/Features.tsx"

# ============================================================
# ABOUT.TSX — "How it works" dengan numbered steps + mockup
# ============================================================
cat > src/components/landing/About.tsx << 'EOF'
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
EOF
echo "✅ src/components/landing/About.tsx"

# ============================================================
# TESTIMONIALS COMPONENT (NEW)
# ============================================================
mkdir -p src/components/landing
cat > src/components/landing/Testimonials.tsx << 'EOF'
import { motion } from 'framer-motion'
import { Star } from 'lucide-react'

const testimonials = [
  { name: 'Andi Wijaya', role: 'Owner, Toko Fashion Maju', text: 'FinproPOS mengubah cara saya kelola bisnis. Stok tidak pernah salah lagi dan laporan harian langsung tersedia.', rating: 5 },
  { name: 'Siti Rahayu', role: 'Manager, Beauty Store', text: 'Multi-outlet management yang sangat mudah. 3 outlet saya sekarang terkelola dari satu dashboard.', rating: 5 },
  { name: 'Budi Santoso', role: 'Owner, Elektronik Jaya', text: 'Kasir saya langsung bisa pakai tanpa training panjang. Interface-nya intuitif banget.', rating: 5 },
  { name: 'Dewi Kusuma', role: 'Admin, Minimarket Sejahtera', text: 'Fitur diskon dan pajak otomatis sangat membantu. Tidak ada lagi salah hitung di kasir.', rating: 5 },
]

export default function Testimonials() {
  return (
    <section className="py-24 px-4 sm:px-6 bg-white dark:bg-slate-950">
      <div className="max-w-6xl mx-auto">
        <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} className="text-center mb-16">
          <span className="inline-block px-4 py-1.5 rounded-full bg-teal-50 dark:bg-teal-900/30 text-teal-700 dark:text-teal-400 text-xs font-semibold uppercase tracking-wider mb-4">Testimonials</span>
          <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 dark:text-white">
            Apa kata <span className="text-teal-600 dark:text-teal-400">klien kami</span>
          </h2>
        </motion.div>

        <div className="grid sm:grid-cols-2 gap-5">
          {testimonials.map((t, i) => (
            <motion.div
              key={t.name} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }} transition={{ delay: i * 0.1 }}
              className="p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:border-teal-200 dark:hover:border-teal-800 transition-colors"
            >
              <div className="flex gap-1 mb-3">
                {[...Array(t.rating)].map((_, j) => <Star key={j} size={14} className="text-amber-400 fill-amber-400" />)}
              </div>
              <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed mb-4">"{t.text}"</p>
              <div className="flex items-center gap-3 pt-3 border-t border-slate-100 dark:border-slate-800">
                <div className="w-9 h-9 rounded-full gradient-teal flex items-center justify-center text-white text-xs font-bold flex-shrink-0">
                  {t.name.split(' ').map(n => n[0]).join('')}
                </div>
                <div>
                  <p className="text-sm font-semibold text-slate-900 dark:text-white">{t.name}</p>
                  <p className="text-xs text-slate-400">{t.role}</p>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
EOF
echo "✅ src/components/landing/Testimonials.tsx"

# ============================================================
# STATS BAR (NEW) — after hero
# ============================================================
cat > src/components/landing/Stats.tsx << 'EOF'
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
EOF
echo "✅ src/components/landing/Stats.tsx"

# ============================================================
# LANDING PAGE — update imports
# ============================================================
cat > src/modules/landing/pages/LandingPage.tsx << 'EOF'
import Navbar from '../../../components/landing/Navbar'
import Hero from '../../../components/landing/Hero'
import Stats from '../../../components/landing/Stats'
import Features from '../../../components/landing/Features'
import About from '../../../components/landing/About'
import Benefits from '../../../components/landing/Benefits'
import Testimonials from '../../../components/landing/Testimonials'
import Pricing from '../../../components/landing/Pricing'
import Footer from '../../../components/landing/Footer'

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white dark:bg-slate-950 transition-colors duration-300">
      <Navbar />
      <Hero />
      <Stats />
      <Features />
      <About />
      <Benefits />
      <Testimonials />
      <Pricing />
      <Footer />
    </div>
  )
}
EOF
echo "✅ src/modules/landing/pages/LandingPage.tsx"

echo ""
echo "✅ Done! File yang diupdate:"
echo "   Hero.tsx     — teal gradient + floating mockup cards"
echo "   Features.tsx — clean card grid"
echo "   About.tsx    — how it works steps"
echo "   Stats.tsx    — stats bar (NEW)"
echo "   Testimonials.tsx — review section (NEW)"
echo "   LandingPage.tsx  — updated imports"