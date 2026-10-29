import { NavLink, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '../auth/AuthProvider'
import { LogoBrand } from './Logo'
import { NavSearch } from './search/NavSearch'

const navItems = [
  { to: '/', label: 'Ana Sayfa', icon: '⌂' },
  { to: '/bursiyerler', label: 'Bursiyerler', icon: '👥' },
  { to: '/yenileme', label: 'Yenileme', icon: '↻' },
  { to: '/basvurular', label: 'Başvurular', icon: '📝' },
  { to: '/mezunlar', label: 'Mezunlar', icon: '🎓' },
  { to: '/program-katilim', label: 'Program Katılım', icon: '✓' },
  { to: '/muhasebe', label: 'Muhasebe', icon: '₺' },
]

export function Layout() {
  const auth = useAuth()
  const location = useLocation()

  return (
    <div className="dashboard-layout">
      <aside className="dashboard-nav">
        <div className="dashboard-nav__brand">
          <LogoBrand />
        </div>

        <nav className="dashboard-nav__menu">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) =>
                `dashboard-nav__link${isActive ? ' dashboard-nav__link--active' : ''}`
              }
            >
              <span className="dashboard-nav__icon" aria-hidden>
                {item.icon}
              </span>
              {item.label}
            </NavLink>
          ))}
        </nav>
      </aside>

      <div className="dashboard-body">
        <nav className="mobile-nav" aria-label="Ana menü">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) =>
                `mobile-nav__link${isActive ? ' mobile-nav__link--active' : ''}`
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <header className="dashboard-header">
          <div>
            <p className="dashboard-header__eyebrow">Yönetim paneli</p>
            <h1 className="dashboard-header__title">
              {location.pathname.startsWith('/muhasebe/odeme-gecmisi')
                ? 'Ödeme Geçmişi'
                : (navItems.find((item) =>
                    item.to === '/'
                      ? location.pathname === '/'
                      : location.pathname.startsWith(item.to),
                  )?.label ?? 'IDV Bursiyer Takip')}
            </h1>
          </div>

          <div className="dashboard-header__actions">
            <NavSearch />
            <div className="dashboard-header__user">
              <div className="user-chip">
                <span className="user-chip__avatar">{auth.userName.charAt(0).toUpperCase()}</span>
                <span>{auth.userName}</span>
              </div>
              {auth.authenticated && (
                <button type="button" className="btn-secondary" onClick={auth.logout}>
                  Çıkış
                </button>
              )}
            </div>
          </div>
        </header>

        <main className="dashboard-content">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
