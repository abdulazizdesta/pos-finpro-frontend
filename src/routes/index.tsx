import { useRoutes } from 'react-router-dom'
import authRoutes from '../modules/auth/routes'
import dashboardRoutes from '../modules/dashboard/routes'

export default function AppRoutes() {
  return useRoutes([...authRoutes, ...dashboardRoutes])
}
