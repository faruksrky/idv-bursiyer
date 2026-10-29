import { Navigate, useLocation } from 'react-router-dom'
import { authEnabled } from './constants'
import { useAuth } from './AuthProvider'

export function GuestGuard({ children }: { children: React.ReactNode }) {
  const { authenticated, ready } = useAuth()
  const location = useLocation()
  const returnTo = (location.state as { returnTo?: string } | null)?.returnTo ?? '/'

  if (!authEnabled) {
    return <Navigate to="/" replace />
  }

  if (!ready) {
    return null
  }

  if (authenticated) {
    return <Navigate to={returnTo} replace />
  }

  return <>{children}</>
}
