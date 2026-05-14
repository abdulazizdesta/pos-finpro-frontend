import { createContext, type ReactNode } from 'react'
import { useAuthStore } from '../store/authStore'

interface AuthContextType {
  token: string | null
  role: string | null
  name: string | null
  business: string | null
  outlet: string | null
  login: (d: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  logout: () => void
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const { token, role, name, business, outlet, setAuth, clearAuth } = useAuthStore()
  return (
    <AuthContext.Provider value={{ token, role, name, business, outlet, login: setAuth, logout: clearAuth }}>
      {children}
    </AuthContext.Provider>
  )
}

export default AuthContext
