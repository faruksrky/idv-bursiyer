import { type FormEvent, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { signInWithPassword } from '../auth/actions'
import { useAuth } from '../auth/AuthProvider'
import { AuthSplitLayout } from '../components/auth/AuthSplitLayout'

export function LoginPage() {
  const navigate = useNavigate()
  const { checkUserSession } = useAuth()
  const isLocalHost =
    typeof window !== 'undefined' &&
    (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1')
  const [username, setUsername] = useState(import.meta.env.DEV && isLocalHost ? 'admin@idv.org' : '')
  const [password, setPassword] = useState(import.meta.env.DEV && isLocalHost ? '123456' : '')
  const [showPassword, setShowPassword] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(event: FormEvent) {
    event.preventDefault()
    setError('')
    setLoading(true)

    try {
      if (!username.trim() || !password) {
        throw new Error('Kullanıcı adı ve şifre zorunludur.')
      }

      await signInWithPassword(username.trim(), password)
      await checkUserSession()
      navigate('/', { replace: true })
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Giriş yapılamadı.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <AuthSplitLayout
      title="Bursiyer yönetim platformu"
      subtitle="Burs başvuruları, program katılımı ve muhasebe süreçlerini tek panelden yönetin."
    >
      <div className="auth-form-card">
        <div className="form-head">
          <h3>Kullanıcı Girişi</h3>
          <p>Hesabınızla giriş yapın</p>
        </div>

        {error && <div className="alert alert--error">{error}</div>}

        <form className="login-form" onSubmit={handleSubmit}>
          <label>
            Kullanıcı adı veya e-posta
            <input
              type="text"
              autoComplete="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="admin@idv.org"
            />
          </label>

          <label>
            Şifre
            <div className="password-field">
              <input
                type={showPassword ? 'text' : 'password'}
                autoComplete="current-password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
              />
              <button
                type="button"
                className="password-toggle"
                onClick={() => setShowPassword((value) => !value)}
                aria-label={showPassword ? 'Şifreyi gizle' : 'Şifreyi göster'}
              >
                {showPassword ? 'Gizle' : 'Göster'}
              </button>
            </div>
          </label>

          <button type="submit" className="btn-primary btn-primary--large" disabled={loading}>
            {loading ? 'Giriş yapılıyor…' : 'Giriş Yap'}
          </button>
        </form>
      </div>
    </AuthSplitLayout>
  )
}
