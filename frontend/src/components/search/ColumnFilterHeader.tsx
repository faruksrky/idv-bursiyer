export function filterHeaderProps(
  columns: {
    filters: Record<string, string>
    options: Record<string, string[]>
    dropdown: Record<string, boolean>
    setFilter: (key: string, value: string) => void
  },
  key: string,
  label: string,
) {
  return {
    label,
    value: columns.filters[key] ?? '',
    options: columns.options[key] ?? [],
    dropdown: columns.dropdown[key] !== false,
    onChange: (value: string) => columns.setFilter(key, value),
  }
}

interface ColumnFilterHeaderProps {
  label: string
  value: string
  options: string[]
  dropdown?: boolean
  onChange: (value: string) => void
}

export function ColumnFilterHeader({
  label,
  value,
  options,
  dropdown = true,
  onChange,
}: ColumnFilterHeaderProps) {
  const active = value.trim().length > 0

  return (
    <th className={`col-filter-th${active ? ' col-filter-th--active' : ''}`}>
      <div className="col-filter">
        <span className="col-filter__label">{label}</span>
        {dropdown ? (
          <select
            className="col-filter__control"
            value={value}
            aria-label={`${label} filtresi`}
            onClick={(event) => event.stopPropagation()}
            onChange={(event) => onChange(event.target.value)}
          >
            <option value="">Tümü</option>
            {options.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
        ) : (
          <input
            className="col-filter__control"
            value={value}
            placeholder="Filtrele…"
            aria-label={`${label} filtresi`}
            onClick={(event) => event.stopPropagation()}
            onChange={(event) => onChange(event.target.value)}
          />
        )}
      </div>
    </th>
  )
}
