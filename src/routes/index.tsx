import { useRoutes } from 'react-router-dom'
import landingRoutes from '../modules/landing/routes'
import authRoutes from '../modules/auth/routes'
import dashboardRoutes from '../modules/dashboard/routes'

export default function AppRoutes() {
  return useRoutes([...landingRoutes, ...authRoutes, ...dashboardRoutes])
}
