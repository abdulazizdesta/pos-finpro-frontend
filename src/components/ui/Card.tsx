import type { HTMLAttributes, ReactNode } from 'react'

interface Props extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode
  hover?: boolean
}

export default function Card({ children, hover = false, className = '', ...props }: Props) {
  return (
    <div
      className={`bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700/50 rounded-2xl p-6 ${
        hover ? 'hover:border-teal-400/50 hover:shadow-lg hover:shadow-teal-500/5 transition-all duration-300' : ''
      } ${className}`}
      {...props}
    >
      {children}
    </div>
  )
}
