import { Moon, Sun } from 'lucide-react'
import { useTheme } from '../../hooks/useTheme'

export default function ThemeToggle({ className = '' }: { className?: string }) {
  const { dark, toggle } = useTheme()
  return (
    <button
      onClick={toggle} aria-label="Toggle theme"
      className={`p-2 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer ${className}`}
    >
      {dark ? <Sun size={18} /> : <Moon size={18} />}
    </button>
  )
}
