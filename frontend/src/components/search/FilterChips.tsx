import type { ReactNode } from 'react'

interface FilterChipsProps {
  count: number
  canReset: boolean
  onReset: () => void
  children?: ReactNode
}

export function FilterChips({ count, canReset, onReset, children }: FilterChipsProps) {
  if (!canReset && !children) {
    return null
  }

  return (
    <div className="filter-chips">
      <span className="filter-chips__count">{count} kayıt</span>
      {children}
      {canReset && (
        <button type="button" className="filter-chips__reset" onClick={onReset}>
          Temizle
        </button>
      )}
    </div>
  )
}
