import { useDebouncedValue } from '../../hooks/useDebouncedValue'

interface TableSearchBarProps {
  value: string
  onChange: (value: string) => void
  placeholder?: string
  resultCount?: number
}

export function TableSearchBar({
  value,
  onChange,
  placeholder = 'Ara…',
  resultCount,
}: TableSearchBarProps) {
  const debounced = useDebouncedValue(value)

  return (
    <div className="table-search">
      <div className="table-search__input-wrap">
        <span className="table-search__icon" aria-hidden>
          ⌕
        </span>
        <input
          type="search"
          className="table-search__input"
          value={value}
          onChange={(event) => onChange(event.target.value)}
          placeholder={placeholder}
          aria-label={placeholder}
        />
      </div>
      {debounced && typeof resultCount === 'number' && (
        <p className="table-search__meta">{resultCount} sonuç bulundu</p>
      )}
    </div>
  )
}
