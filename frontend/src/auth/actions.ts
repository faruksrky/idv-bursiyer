import { clearSession, setSession, userFromToken } from './session'

interface TokenResponse {
  access_token: string
}

export async function signInWithPassword(username: string, password: string): Promise<void> {
  const response = await fetch('/api/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  })

  if (!response.ok) {
    let message = 'Giriş yapılırken bir hata oluştu. Lütfen tekrar deneyin.'
    const text = await response.text()

    try {
      const data = JSON.parse(text) as { message?: string; error_description?: string }
      message = data.message ?? data.error_description ?? message
    } catch {
      if (text) {
        message = text
      }
    }

    if (response.status === 404) {
      throw new Error(
        'Giriş servisi bulunamadı. Backend\'i IntelliJ\'den yeniden başlatın (profil: local).',
      )
    }

    if (response.status === 401) {
      message = message.includes('hatalı') ? message : 'Kullanıcı adı veya şifre hatalı.'
    }

    throw new Error(message)
  }

  const data = (await response.json()) as TokenResponse
  if (!data.access_token) {
    throw new Error('Access token alınamadı')
  }

  setSession(data.access_token, userFromToken(data.access_token))
}

export function signOut() {
  clearSession()
}
