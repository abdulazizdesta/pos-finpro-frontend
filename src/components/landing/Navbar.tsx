import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ShoppingCart, Menu, X } from 'lucide-react'
import Button from '../ui/Button'
import ThemeToggle from '../ui/ThemeToggle'

const links = [
  { label: 'Features', href: '#features' },
  { label: 'About', href: '#about' },
  { label: 'Benefits', href: '#benefits' },
  { label: 'Pricing', href: '#pricing' },
]

export default function Navbar() {
  const [open, setOpen] = useState(false)
  const nav = useNavigate()

  return (
    <motion.nav
      initial={{ y: -20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.5 }}
      className="fixed top-0 left-0 right-0 z-50 glass bg-white/80 dark:bg-slate-900/80 border-b border-slate-200/50 dark:border-slate-700/50"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <a href="/" className="flex items-center gap-2.5">
            <div className="w-9 h-9 gradient-teal rounded-xl flex items-center justify-center">
              <ShoppingCart size={18} className="text-white" />
            </div>
            <span className="font-bold text-lg text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
          </a>

          <div className="hidden md:flex items-center gap-8">
            {links.map(l => (
              <a key={l.href} href={l.href} className="text-sm text-slate-600 dark:text-slate-400 hover:text-teal-600 dark:hover:text-teal-400 transition-colors">
                {l.label}
              </a>
            ))}
          </div>

          <div className="hidden md:flex items-center gap-3">
            <ThemeToggle />
            <Button variant="ghost" size="sm" onClick={() => nav('/login')}>Masuk</Button>
            <Button size="sm" onClick={() => nav('/register')}>Daftar Gratis</Button>
          </div>

          <button onClick={() => setOpen(!open)} className="md:hidden p-2 text-slate-600 dark:text-slate-300 cursor-pointer">
            {open ? <X size={22} /> : <Menu size={22} />}
          </button>
        </div>
      </div>

      {open && (
        <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} className="md:hidden border-t border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 pb-4">
          {links.map(l => (
            <a key={l.href} href={l.href} onClick={() => setOpen(false)} className="block py-3 text-sm text-slate-600 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
              {l.label}
            </a>
          ))}
          <div className="flex gap-3 mt-4">
            <Button variant="outline" size="sm" className="flex-1" onClick={() => nav('/login')}>Masuk</Button>
            <Button size="sm" className="flex-1" onClick={() => nav('/register')}>Daftar</Button>
          </div>
        </motion.div>
      )}
    </motion.nav>
  )
}
