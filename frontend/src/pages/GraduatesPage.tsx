import { useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { api, type Scholar } from '../api/client'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterChips } from '../components/search/FilterChips'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import { formatDate, formatScholarshipPeriod, matchesQuery } from '../utils/search'

const GRADUATE_COLUMNS = {
  name: (row: Scholar) => `${row.firstName} ${row.lastName}`,
  university: (row: Scholar) => row.university,
  faculty: (row: Scholar) => row.faculty,
  department: (row: Scholar) => row.department,
  period: (row: Scholar) => formatScholarshipPeriod(row.scholarshipStart, row.graduationDate),
  graduation: (row: Scholar) => formatDate(row.graduationDate),
  email: (row: Scholar) => row.email,
  phone: (row: Scholar) => row.phone,
}

export function GraduatesPage() {
  const [search, setSearch] = useState('')
  const debouncedSearch = useDebouncedValue(search)

  const { data, isLoading, error } = useQuery({
    queryKey: ['graduates'],
    queryFn: api.graduates,
  })

  const columns = useColumnFilters(data, GRADUATE_COLUMNS)

  const filtered = useMemo(() => {
    return columns.filtered.filter((graduate) =>
      matchesQuery(
        debouncedSearch,
        graduate.firstName,
        graduate.lastName,
        graduate.email,
        graduate.phone,
        graduate.university,
        graduate.faculty,
        graduate.department,
        graduate.tcNo,
        formatScholarshipPeriod(graduate.scholarshipStart, graduate.graduationDate),
      ),
    )
  }, [columns.filtered, debouncedSearch])

  const canReset = search.length > 0 || columns.active

  return (
    <section className="panel">
      <h2>Mezunlar</h2>
      <p className="panel-subtitle">
        Mezun bursiyerler. Aktif öğrenciler Bursiyerler sayfasındadır.
      </p>

      {data && (
        <div className="prescreen-stats" aria-label="Mezun sayısı">
          <div className="prescreen-stat prescreen-stat--active">
            <span className="prescreen-stat__value">{data.length}</span>
            <span className="prescreen-stat__label">Mezun bursiyer</span>
          </div>
        </div>
      )}

      <div className="toolbar">
        <TableSearchBar
          value={search}
          onChange={setSearch}
          placeholder="Ad, e-posta, üniversite ara…"
          resultCount={filtered.length}
        />
      </div>

      <FilterChips
        count={filtered.length}
        canReset={canReset}
        onReset={() => {
          setSearch('')
          columns.reset()
        }}
      />

      {isLoading && <p>Yükleniyor…</p>}
      {error && <p className="error">Mezun listesi alınamadı.</p>}

      {data && (
        <div className="table-scroll">
        <table className="data-table data-table--nowrap">
          <thead>
            <tr>
              <ColumnFilterHeader {...filterHeaderProps(columns, 'name', 'Ad Soyad')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'university', 'Üniversite')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'faculty', 'Fakülte')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'department', 'Bölüm')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'period', 'Dönem')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'graduation', 'Mezuniyet')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'email', 'E-posta')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'phone', 'Telefon')} />
            </tr>
          </thead>
          <tbody>
            {filtered.length === 0 && (
              <tr>
                <td colSpan={8}>Arama kriterlerine uygun mezun bulunamadı.</td>
              </tr>
            )}
            {filtered.map((graduate) => (
              <tr key={graduate.id}>
                <td>
                  {graduate.firstName} {graduate.lastName}
                </td>
                <td className="cell-clip" title={graduate.university ?? undefined}>
                  {graduate.university ?? '—'}
                </td>
                <td className="cell-clip" title={graduate.faculty ?? undefined}>
                  {graduate.faculty ?? '—'}
                </td>
                <td className="cell-clip" title={graduate.department ?? undefined}>
                  {graduate.department ?? '—'}
                </td>
                <td>{formatScholarshipPeriod(graduate.scholarshipStart, graduate.graduationDate)}</td>
                <td>{formatDate(graduate.graduationDate)}</td>
                <td>{graduate.email ?? '—'}</td>
                <td>{graduate.phone ?? '—'}</td>
              </tr>
            ))}
          </tbody>
        </table>
        </div>
      )}
    </section>
  )
}
