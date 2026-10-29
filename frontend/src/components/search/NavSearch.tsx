import { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'

const navItems = [
  { title: 'Ana Sayfa', path: '/', group: 'Menü' },
  { title: 'Bursiyerler', path: '/bursiyerler', group: 'Menü' },
  { title: 'Başvurular', path: '/basvurular', group: 'Menü' },
  { title: 'Mezunlar', path: '/mezunlar', group: 'Menü' },
  { title: 'Program Katılım', path: '/program-katilim', group: 'Menü' },
  { title: 'Muhasebe', path: '/muhasebe', group: 'Menü' },
  { title: 'Ödeme Geçmişi', path: '/muhasebe/odeme-gecmisi', group: 'Muhasebe' },
]

export function NavSearch() {
  const navigate = useNavigate()
  const [open, setOpen] = useState(false)
  const [query, setQuery] = useState('')

  const results = useMemo(() => {
    const normalized = query.trim().toLowerCase()
    if (!normalized) {
      return navItems
    }

    return navItems.filter((item) =>
      [item.title, item.path, item.group].some((field) => field.toLowerCase().includes(normalized)),
    )
  }, [query])

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
        event.preventDefault()
        setOpen((value) => !value)
        setQuery('')
      }
      if (event.key === 'Escape') {
        setOpen(false)
      }
    }

    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [])

  return (
    <>
      <button type="button" className="nav-search-trigger" onClick={() => setOpen(true)}>
        <span aria-hidden>⌕</span>
        Ara…
        <kbd>⌘K</kbd>
      </button>

      {open && (
        <div className="nav-search-overlay" role="presentation" onClick={() => setOpen(false)}>
          <div
            className="nav-search-dialog"
            role="dialog"
            aria-label="Sayfa ara"
            onClick={(event) => event.stopPropagation()}
          >
            <div className="nav-search-dialog__input-wrap">
              <span aria-hidden>⌕</span>
              <input
                autoFocus
                value={query}
                onChange={(event) => setQuery(event.target.value)}
                placeholder="Sayfa veya menü ara…"
              />
              <kbd>esc</kbd>
            </div>

            <ul className="nav-search-results">
              {results.length === 0 && query && (
                <li className="nav-search-results__empty">"{query}" için sonuç bulunamadı</li>
              )}
              {results.map((item) => (
                <li key={item.path}>
                  <button
                    type="button"
                    onClick={() => {
                      navigate(item.path)
                      setOpen(false)
                      setQuery('')
                    }}
                  >
                    <strong>{item.title}</strong>
                    <span>{item.group}</span>
                  </button>
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}
    </>
  )
}
