import Login from './pages/Login'
import Register from './pages/Register'

const authRoutes = [
  { path: '/', element: <Login /> },
  { path: '/register', element: <Register /> },
]

export default authRoutes
