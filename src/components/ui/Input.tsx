import type { InputHTMLAttributes } from 'react'

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  label?: string
  error?: string
}

export default function Input({ label, error, className = '', ...props }: Props) {
  return (
    <div className="flex flex-col gap-1.5">
      {label && <label className="text-sm font-medium text-slate-600 dark:text-slate-400">{label}</label>}
      <input
        className={`w-full px-4 py-2.5 text-sm rounded-xl border bg-white dark:bg-slate-800/50 text-slate-900 dark:text-white placeholder:text-slate-400 dark:placeholder:text-slate-500 focus:outline-none focus:ring-2 transition-all duration-200 ${
          error ? 'border-red-400 focus:ring-red-300' : 'border-slate-200 dark:border-slate-700 focus:ring-teal-400/50 focus:border-teal-400'
        } ${className}`}
        {...props}
      />
      {error && <p className="text-xs text-red-500">{error}</p>}
    </div>
  )
}
