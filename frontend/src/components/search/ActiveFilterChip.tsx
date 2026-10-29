interface ActiveFilterChipProps {
  label: string
  value: string
  onRemove: () => void
}

export function ActiveFilterChip({ label, value, onRemove }: ActiveFilterChipProps) {
  return (
    <div className="active-filter-block">
      <span className="active-filter-block__label">{label}</span>
      <button type="button" className="active-filter-chip" onClick={onRemove}>
        {value}
        <span className="active-filter-chip__remove" aria-hidden>
          ×
        </span>
      </button>
    </div>
  )
}
