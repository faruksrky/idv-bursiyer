import { useQuery, useQueryClient, useMutation } from '@tanstack/react-query'
import { useMemo, useRef, useState, type ChangeEvent } from 'react'
import { Link } from 'react-router-dom'
import { api, type Scholar } from '../api/client'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterChips } from '../components/search/FilterChips'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { ScholarProgramHistory } from '../components/scholars/ScholarProgramHistory'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import { matchesQuery } from '../utils/search'

const SCHOLAR_COLUMNS = {
  name: (row: Scholar) => `${row.firstName} ${row.lastName}`,
  university: (row: Scholar) => row.university,
  department: (row: Scholar) => row.department,
  classYear: (row: Scholar) => row.classYear,
  programs: (row: Scholar) => row.programsAttendedCount,
  email: (row: Scholar) => row.email,
  phone: (row: Scholar) => row.phone,
}

export function ScholarsPage() {
  const [search, setSearch] = useState('')
  const [genderFilter, setGenderFilter] = useState<'all' | 'KIZ' | 'ERKEK'>('all')
  const [quotaOnly, setQuotaOnly] = useState(false)
  const [selectedScholar, setSelectedScholar] = useState<Scholar | null>(null)
  const [importMessage, setImportMessage] = useState<string | null>(null)
  const [importError, setImportError] = useState<string | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const queryClient = useQueryClient()
  const debouncedSearch = useDebouncedValue(search)

  const { data, isLoading, error } = useQuery({
    queryKey: ['scholars', 'OGRENCI'],
    queryFn: () => api.scholars({ status: 'OGRENCI' }),
  })
  const graduatesQuery = useQuery({
    queryKey: ['graduates'],
    queryFn: api.graduates,
  })

  const activeScholars = useMemo(
    () =>
      (data ?? []).filter(
        (scholar) => scholar.status === 'OGRENCI' && scholar.active && !scholar.graduationDate,
      ),
    [data],
  )

  const rosterCounts = useMemo(() => {
    let renewal = 0
    let interview = 0
    let quota = 0
    for (const scholar of activeScholars) {
      if (scholar.intake === 'RENEWAL') renewal += 1
      else if (scholar.intake === 'INTERVIEW') interview += 1
      else if (scholar.intake === 'PRESIDENT_QUOTA') quota += 1
    }
    return { renewal, interview, quota, roster: renewal + interview }
  }, [activeScholars])

  const genderCounts = useMemo(
    () => ({
      girl: activeScholars.filter(
        (scholar) => scholar.intake !== 'PRESIDENT_QUOTA' && scholar.gender === 'KIZ',
      ).length,
      boy: activeScholars.filter(
        (scholar) => scholar.intake !== 'PRESIDENT_QUOTA' && scholar.gender === 'ERKEK',
      ).length,
    }),
    [activeScholars],
  )

  const columns = useColumnFilters(data ? activeScholars : undefined, SCHOLAR_COLUMNS)

  const filtered = useMemo(() => {
    return columns.filtered.filter((scholar) => {
      if (quotaOnly && scholar.intake !== 'PRESIDENT_QUOTA') return false
      if (genderFilter !== 'all' && scholar.intake === 'PRESIDENT_QUOTA') return false
      if (genderFilter === 'KIZ' && scholar.gender !== 'KIZ') return false
      if (genderFilter === 'ERKEK' && scholar.gender !== 'ERKEK') return false
      return matchesQuery(
        debouncedSearch,
        scholar.firstName,
        scholar.lastName,
        scholar.email,
        scholar.university,
        scholar.department,
        scholar.tcNo,
      )
    })
  }, [columns.filtered, debouncedSearch, genderFilter, quotaOnly])

  const canReset = search.length > 0 || genderFilter !== 'all' || quotaOnly || columns.active

  const importMutation = useMutation({
    mutationFn: (file: File) => api.scholarsImport(file),
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ['scholars'] })
      const errorSummary =
        result.errors.length > 0 ? ` ${result.errors.length} satırda hata var.` : ''
      setImportMessage(
        `${result.created} yeni kayıt, ${result.updated} güncelleme.${errorSummary}`,
      )
      setImportError(result.errors.length > 0 ? result.errors.join(' ') : null)
    },
    onError: (error) => {
      setImportMessage(null)
      setImportError(error instanceof Error ? error.message : 'Excel yüklenemedi.')
    },
  })

  async function handleExcelDownload() {
    try {
      await api.scholarsExportExcel('OGRENCI')
    } catch {
      setImportError('Excel indirilemedi.')
    }
  }

  function handleImportClick() {
    fileInputRef.current?.click()
  }

  function handleFileSelected(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file) return
    setImportMessage(null)
    setImportError(null)
    importMutation.mutate(file)
  }

  return (
    <div className="page-stack">
      <section className="panel">
        <h2>Bursiyerler</h2>
        <p className="panel-subtitle">
          {data && (
            <>
              {rosterCounts.renewal + rosterCounts.interview + rosterCounts.quota} bursiyer (
              {rosterCounts.renewal} yenileme + {rosterCounts.interview} mülakat + {rosterCounts.quota}{' '}
              başkan kontenjanı).{' '}
            </>
          )}
          Başkan kontenjanı burs alır ve bu listededir; satırda etiketlenir. Mezunlar ayrı sayfadadır.
        </p>

        {data && (
          <div className="prescreen-stats" aria-label="Bursiyer sayıları">
            <button
              type="button"
              className={`prescreen-stat${genderFilter === 'ERKEK' ? ' prescreen-stat--active' : ''}`}
              onClick={() => {
                setQuotaOnly(false)
                setGenderFilter(genderFilter === 'ERKEK' ? 'all' : 'ERKEK')
              }}
            >
              <span className="prescreen-stat__value">{genderCounts.boy}</span>
              <span className="prescreen-stat__label">Takip erkek</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--invite${genderFilter === 'KIZ' ? ' prescreen-stat--active' : ''}`}
              onClick={() => {
                setQuotaOnly(false)
                setGenderFilter(genderFilter === 'KIZ' ? 'all' : 'KIZ')
              }}
            >
              <span className="prescreen-stat__value">{genderCounts.girl}</span>
              <span className="prescreen-stat__label">Takip kız</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--quota${quotaOnly ? ' prescreen-stat--active' : ''}`}
              onClick={() => {
                setGenderFilter('all')
                setQuotaOnly((current) => !current)
              }}
            >
              <span className="prescreen-stat__value">{rosterCounts.quota}</span>
              <span className="prescreen-stat__label">Başkan kontenjanı</span>
            </button>
            <Link to="/mezunlar" className="prescreen-stat" style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className="prescreen-stat__value">{graduatesQuery.data?.length ?? '—'}</span>
              <span className="prescreen-stat__label">Mezun (ayrı liste)</span>
            </Link>
          </div>
        )}

        <div className="toolbar">
          <TableSearchBar
            value={search}
            onChange={setSearch}
            placeholder="Ad, e-posta, üniversite ara…"
            resultCount={filtered.length}
          />
          <div className="toolbar-actions">
            <button type="button" className="btn-secondary" onClick={() => void api.scholarsImportTemplate()}>
              Şablon İndir
            </button>
            <button type="button" className="btn-secondary" onClick={() => void handleExcelDownload()}>
              Excel İndir
            </button>
            <button
              type="button"
              className="btn-primary"
              onClick={handleImportClick}
              disabled={importMutation.isPending}
            >
              {importMutation.isPending ? 'Yükleniyor…' : 'Excel Yükle'}
            </button>
            <input
              ref={fileInputRef}
              type="file"
              accept=".xlsx,.xls"
              hidden
              onChange={handleFileSelected}
            />
          </div>
        </div>

        {importMessage && <p className="success">{importMessage}</p>}
        {importError && <p className="error">{importError}</p>}

        <FilterChips
          count={filtered.length}
          canReset={canReset}
          onReset={() => {
            setSearch('')
            setGenderFilter('all')
            setQuotaOnly(false)
            columns.reset()
          }}
        />

        {isLoading && <p>Yükleniyor…</p>}
        {error && <p className="error">Bursiyer listesi alınamadı.</p>}

        {data && (
          <div className="table-scroll">
          <table className="data-table data-table--clickable data-table--nowrap">
            <thead>
              <tr>
                <ColumnFilterHeader {...filterHeaderProps(columns, 'name', 'Ad Soyad')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'university', 'Üniversite')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'department', 'Bölüm')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'classYear', 'Sınıf')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'programs', 'Program')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'email', 'E-posta')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'phone', 'Telefon')} />
              </tr>
            </thead>
            <tbody>
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={7}>Arama kriterlerine uygun bursiyer bulunamadı.</td>
                </tr>
              )}
              {filtered.map((scholar) => {
                const isSelected = selectedScholar?.id === scholar.id
                return (
                  <tr
                    key={scholar.id}
                    className={isSelected ? 'row-selected' : undefined}
                    onClick={() => setSelectedScholar(isSelected ? null : scholar)}
                  >
                    <td>
                      {scholar.intake === 'PRESIDENT_QUOTA' ? (
                        <span className="name-with-badge">
                          {scholar.firstName} {scholar.lastName}
                          <span className="badge badge--quota">Başkan kontenjanı</span>
                        </span>
                      ) : (
                        <>
                          {scholar.firstName} {scholar.lastName}
                        </>
                      )}
                    </td>
                    <td className="cell-clip" title={scholar.university ?? undefined}>
                      {scholar.university ?? '—'}
                    </td>
                    <td className="cell-clip" title={scholar.department ?? undefined}>
                      {scholar.department ?? '—'}
                    </td>
                    <td>{scholar.classYear ?? '—'}</td>
                    <td>{scholar.programsAttendedCount}</td>
                    <td>{scholar.email ?? '—'}</td>
                    <td>{scholar.phone ?? '—'}</td>
                  </tr>
                )
              })}
            </tbody>
          </table>
          </div>
        )}
      </section>

      {selectedScholar && (
        <ScholarProgramHistory scholar={selectedScholar} onClose={() => setSelectedScholar(null)} />
      )}
    </div>
  )
}
