import { STORAGE_KEY } from './constants'

export interface AuthUser {
  email: string
  name: string
  roles: string[]
}

interface JwtPayload {
  exp?: number
  email?: string
  preferred_username?: string
  given_name?: string
  family_name?: string
  name?: string
  realm_access?: { roles?: string[] }
}

export function jwtDecode(token: string): JwtPayload {
  const parts = token.split('.')
  if (parts.length < 2) {
    throw new Error('Geçersiz token')
  }

  const base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/')
  return JSON.parse(atob(base64)) as JwtPayload
}

export function isValidToken(token: string | null): boolean {
  if (!token) {
    return false
  }

  try {
    const decoded = jwtDecode(token)
    return typeof decoded.exp === 'number' && decoded.exp > Date.now() / 1000
  } catch {
    return false
  }
}

export function getAccessToken(): string | null {
  try {
    return sessionStorage.getItem(STORAGE_KEY)
  } catch {
    return null
  }
}

export function getStoredUser(): AuthUser | null {
  try {
    const raw = sessionStorage.getItem('user')
    return raw ? (JSON.parse(raw) as AuthUser) : null
  } catch {
    return null
  }
}

export function userFromToken(token: string): AuthUser {
  const decoded = jwtDecode(token)
  const roles = decoded.realm_access?.roles ?? []
  const name =
    decoded.name ??
    (`${decoded.given_name ?? ''} ${decoded.family_name ?? ''}`.trim() ||
      decoded.preferred_username ||
      decoded.email ||
      'Kullanıcı')

  return {
    email: decoded.email ?? decoded.preferred_username ?? '',
    name,
    roles,
  }
}

export function setSession(accessToken: string, user: AuthUser) {
  sessionStorage.setItem(STORAGE_KEY, accessToken)
  sessionStorage.setItem('user', JSON.stringify(user))
}

export function clearSession() {
  sessionStorage.removeItem(STORAGE_KEY)
  sessionStorage.removeItem('user')
}

export function getUserDisplayName(): string {
  return getStoredUser()?.name ?? 'Kullanıcı'
}
