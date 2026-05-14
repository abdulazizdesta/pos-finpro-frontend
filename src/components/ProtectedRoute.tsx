import type React from 'react'
import { useAuth } from '../hooks/useAuth'
import { Navigate } from 'react-router-dom'

interface Props {
  children: React.ReactNode
  requiredRole?: string | string[]
}

export default function ProtectedRoute({ children, requiredRole }: Props) {
  const { token, role } = useAuth()

  if (!token) return <Navigate to="/" replace />

  if (requiredRole) {
    const allowed = Array.isArray(requiredRole) ? requiredRole : [requiredRole]
    if (!allowed.includes(role ?? '')) return <Navigate to="/dashboard" replace />
  }

  return <>{children}</>
}
