import { NavLink } from 'react-router-dom'

const tabs = [
  { to: '/muhasebe', label: 'IBAN Listesi', end: true },
  { to: '/muhasebe/odeme-gecmisi', label: 'Ödeme Geçmişi', end: false },
]

export function AccountingSubNav() {
  return (
    <nav className="accounting-subnav" aria-label="Muhasebe">
      {tabs.map((tab) => (
        <NavLink
          key={tab.to}
          to={tab.to}
          end={tab.end}
          className={({ isActive }) =>
            `accounting-subnav__link${isActive ? ' accounting-subnav__link--active' : ''}`
          }
        >
          {tab.label}
        </NavLink>
      ))}
    </nav>
  )
}
