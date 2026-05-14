import ProtectedRoute from '../../components/ProtectedRoute'
import Dashboard from './pages/Dashboard'

const dashboardRoutes = [
  { path: '/dashboard', element: <ProtectedRoute><Dashboard /></ProtectedRoute> },
]
export default dashboardRoutes
