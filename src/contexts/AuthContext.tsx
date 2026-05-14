import React, { createContext } from 'react'
import { useAuthStore } from '../store/authStore'

interface AuthContextType {
  token: string | null
  role: string | null
  name: string | null
  business: string | null
  outlet: string | null
  login: (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  logout: () => void
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const { token, role, name, business, outlet, setAuth, clearAuth } = useAuthStore()

  const login = (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => {
    setAuth(data)
  }

  const logout = () => {
    clearAuth()
  }

  return (
    <AuthContext.Provider value={{ token, role, name, business, outlet, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export default AuthContext
