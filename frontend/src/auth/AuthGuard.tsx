import { Navigate, useLocation } from 'react-router-dom'
import { authEnabled } from './constants'
import { useAuth } from './AuthProvider'

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const { authenticated, ready } = useAuth()
  const location = useLocation()

  if (!authEnabled) {
    return <>{children}</>
  }

  if (!ready) {
    return null
  }

  if (!authenticated) {
    return <Navigate to="/login" replace state={{ returnTo: location.pathname }} />
  }

  return <>{children}</>
}
