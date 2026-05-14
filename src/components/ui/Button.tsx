import type { ButtonHTMLAttributes, ReactNode } from 'react'

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'outline' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  children: ReactNode
  loading?: boolean
}

export default function Button({ variant = 'primary', size = 'md', children, loading, className = '', ...props }: Props) {
  const base = 'inline-flex items-center justify-center font-medium rounded-xl transition-all duration-200 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed'
  const sizes = { sm: 'px-4 py-2 text-sm', md: 'px-6 py-2.5 text-sm', lg: 'px-8 py-3 text-base' }
  const variants = {
    primary: 'gradient-teal text-white hover:opacity-90 hover:shadow-lg hover:shadow-teal-500/25 active:scale-[0.98]',
    outline: 'border border-teal-500 text-teal-600 dark:text-teal-400 hover:bg-teal-50 dark:hover:bg-teal-950/50',
    ghost: 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800',
  }
  return (
    <button className={`${base} ${sizes[size]} ${variants[variant]} ${className}`} disabled={loading} {...props}>
      {loading ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2" /> : null}
      {children}
    </button>
  )
}
