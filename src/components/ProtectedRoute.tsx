import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'

interface Props { children: ReactNode; requiredRole?: string | string[] }

export default function ProtectedRoute({ children, requiredRole }: Props) {
  const { token, role } = useAuth()
  if (!token) return <Navigate to="/login" replace />
  if (requiredRole) {
    const allowed = Array.isArray(requiredRole) ? requiredRole : [requiredRole]
    if (!allowed.includes(role ?? '')) return <Navigate to="/dashboard" replace />
  }
  return <>{children}</>
}
