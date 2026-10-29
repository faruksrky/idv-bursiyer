import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import { signOut as clearAuthSession } from './actions'
import { authEnabled } from './constants'
import {
  clearSession,
  getAccessToken,
  getStoredUser,
  getUserDisplayName,
  isValidToken,
  type AuthUser,
} from './session'

interface AuthContextValue {
  ready: boolean
  authenticated: boolean
  user: AuthUser | null
  userName: string
  checkUserSession: () => Promise<void>
  logout: () => void
}

const AuthContext = createContext<AuthContextValue | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [ready, setReady] = useState(!authEnabled)
  const [authenticated, setAuthenticated] = useState(!authEnabled)
  const [user, setUser] = useState<AuthUser | null>(null)

  const checkUserSession = useCallback(async () => {
    if (!authEnabled) {
      setAuthenticated(true)
      setUser(null)
      setReady(true)
      return
    }

    const token = getAccessToken()
    if (token && isValidToken(token)) {
      setUser(getStoredUser())
      setAuthenticated(true)
    } else {
      clearSession()
      setUser(null)
      setAuthenticated(false)
    }
    setReady(true)
  }, [])

  useEffect(() => {
    void checkUserSession()
  }, [checkUserSession])

  const logout = useCallback(() => {
    if (!authEnabled) {
      return
    }
    clearAuthSession()
    setUser(null)
    setAuthenticated(false)
    window.location.href = '/login'
  }, [])

  const value = useMemo(
    () => ({
      ready,
      authenticated,
      user,
      userName: user?.name ?? getUserDisplayName(),
      checkUserSession,
      logout,
    }),
    [ready, authenticated, user, checkUserSession, logout],
  )

  if (!ready) {
    return (
      <div className="panel" style={{ margin: '2rem auto', maxWidth: 480 }}>
        <h2>Yükleniyor…</h2>
      </div>
    )
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) {
    throw new Error('useAuth AuthProvider içinde kullanılmalı')
  }
  return ctx
}
