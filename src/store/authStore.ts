import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  token: string | null
  name: string | null
  role: string | null
  business: string | null
  outlet: string | null
  setAuth: (data: { token: string; name: string; role: string; business: string | null; outlet: string | null }) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      name: null,
      role: null,
      business: null,
      outlet: null,
      setAuth: (data) => set(data),
      clearAuth: () => set({ token: null, name: null, role: null, business: null, outlet: null }),
    }),
    { name: 'pos-auth' }
  )
)
