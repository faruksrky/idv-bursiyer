import { useMemo, useState } from 'react'

const DROPDOWN_LIMIT = 80

export type ColumnGetter<T> = (row: T) => string | number | null | undefined

export function cellText(value: string | number | null | undefined): string {
  if (value == null) return '—'
  const text = String(value).trim()
  return text.length === 0 ? '—' : text
}

export function uniqueColumnValues<T>(rows: T[], get: ColumnGetter<T>): string[] {
  const values = new Set<string>()
  for (const row of rows) {
    values.add(cellText(get(row)))
  }
  return [...values].sort((left, right) => left.localeCompare(right, 'tr'))
}

export function matchesColumnFilter(filter: string, cell: string, dropdown: boolean): boolean {
  if (!filter) return true
  if (dropdown) return cell === filter
  return cell.toLowerCase().includes(filter.trim().toLowerCase())
}

export function useColumnFilters<T>(rows: T[] | undefined, getters: Record<string, ColumnGetter<T>>) {
  const [filters, setFilters] = useState<Record<string, string>>({})
  const source = rows ?? []

  const options = useMemo(() => {
    const next: Record<string, string[]> = {}
    for (const [key, get] of Object.entries(getters)) {
      next[key] = uniqueColumnValues(source, get)
    }
    return next
  }, [source, getters])

  const dropdown = useMemo(() => {
    const next: Record<string, boolean> = {}
    for (const [key, values] of Object.entries(options)) {
      next[key] = values.length <= DROPDOWN_LIMIT
    }
    return next
  }, [options])

  const filtered = useMemo(() => {
    return source.filter((row) =>
      Object.entries(getters).every(([key, get]) =>
        matchesColumnFilter(filters[key] ?? '', cellText(get(row)), dropdown[key] !== false),
      ),
    )
  }, [source, getters, filters, dropdown])

  const active = Object.values(filters).some((value) => value.trim().length > 0)

  function setFilter(key: string, value: string) {
    setFilters((current) => {
      if (!value) {
        const { [key]: _removed, ...rest } = current
        return rest
      }
      return { ...current, [key]: value }
    })
  }

  function reset() {
    setFilters({})
  }

  return { filters, setFilter, reset, filtered, options, dropdown, active }
}
