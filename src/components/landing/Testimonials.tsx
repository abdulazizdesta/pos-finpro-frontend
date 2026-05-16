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
