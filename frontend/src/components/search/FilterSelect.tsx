interface FilterSelectOption {
  value: string
  label: string
}

interface FilterSelectProps {
  label: string
  value: string
  onChange: (value: string) => void
  options: FilterSelectOption[]
  id?: string
}

export function FilterSelect({ label, value, onChange, options, id }: FilterSelectProps) {
  const selectId = id ?? label.toLowerCase().replace(/\s+/g, '-')

  return (
    <div className="filter-select">
      <label className="filter-select__label" htmlFor={selectId}>
        {label}
      </label>
      <div className="filter-select__field">
        <select
          id={selectId}
          className="filter-select__control"
          value={value}
          onChange={(event) => onChange(event.target.value)}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
      </div>
    </div>
  )
}
