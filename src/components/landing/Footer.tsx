import { ShoppingCart } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="border-t border-slate-200 dark:border-slate-800 py-12 px-4 sm:px-6">
      <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 gradient-teal rounded-lg flex items-center justify-center">
            <ShoppingCart size={16} className="text-white" />
          </div>
          <span className="font-bold text-slate-900 dark:text-white">Finpro<span className="gradient-text">POS</span></span>
        </div>
        <p className="text-sm text-slate-500">2026 FinproPOS. Built for retail businesses.</p>
      </div>
    </footer>
  )
}
