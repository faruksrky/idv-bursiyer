import { useMemo, useRef, useState, type ChangeEvent } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api, type ScholarMissingRenewal, type ScholarReview, type ScholarReviewDecision } from '../api/client'
import { ScholarRenewalPanel } from '../components/scholars/ScholarRenewalPanel'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { FilterChips } from '../components/search/FilterChips'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import { isHttpUrl } from '../utils/applications'
import { isGpaBelowContinuation } from '../utils/gpa'
import { getQueryErrorMessage } from '../utils/apiError'
import { formatDate, matchesQuery } from '../utils/search'

const ACADEMIC_YEAR = 2026

function isGpaBelowThreshold(row: ScholarReview) {
  return row.gpaBelowTwo || isGpaBelowContinuation(row.gpa)
}

function decisionLabel(decision: ScholarReviewDecision) {
  if (decision === 'CONTINUE') return 'Devam'
  if (decision === 'STOP') return 'Kesilecek'
  return 'Beklemede'
}

function docMark(url: string | null) {
  return isHttpUrl(url) ? 'Var' : 'Yok'
}

const RENEWAL_COLUMNS = {
  name: (row: ScholarReview) => row.fullName,
  cert: (row: ScholarReview) => docMark(row.studentCertUrl),
  transcript: (row: ScholarReview) => docMark(row.transcriptUrl),
  income: (row: ScholarReview) => docMark(row.familyIncomeUrl),
  program: (row: ScholarReview) => row.programAttendanceAnswer,
  classYear: (row: ScholarReview) => row.classYear,
  decision: (row: ScholarReview) => decisionLabel(row.decision),
  submitted: (row: ScholarReview) => formatDate(row.submittedAt?.slice(0, 10) ?? null),
}

const MISSING_COLUMNS = {
  name: (row: ScholarMissingRenewal) => `${row.firstName} ${row.lastName}`,
  tcNo: (row: ScholarMissingRenewal) => row.tcNo,
  university: (row: ScholarMissingRenewal) => row.university,
  department: (row: ScholarMissingRenewal) => row.department,
}

export function ScholarRenewalsPage() {
  const [view, setView] = useState<'submitted' | 'missing' | 'gpa'>('submitted')
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState<ScholarReview | null>(null)
  const [importMessage, setImportMessage] = useState<string | null>(null)
  const [importError, setImportError] = useState<string | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const rosterInputRef = useRef<HTMLInputElement>(null)
  const queryClient = useQueryClient()
  const debouncedSearch = useDebouncedValue(search)

  const query = useQuery({
    queryKey: ['scholar-reviews', ACADEMIC_YEAR],
    queryFn: () => api.scholarReviews(ACADEMIC_YEAR),
  })

  const sourceRows = useMemo(() => {
    const rows = query.data?.responses ?? []
    return view === 'gpa' ? rows.filter(isGpaBelowThreshold) : rows
  }, [query.data?.responses, view])

  const columns = useColumnFilters(sourceRows, RENEWAL_COLUMNS)

  const filtered = useMemo(() => {
    const rows = columns.filtered.filter((row) =>
      matchesQuery(debouncedSearch, row.fullName, row.tcNo, row.programAttendanceAnswer, row.note),
    )
    return [...rows].sort((a, b) => Number(isGpaBelowThreshold(b)) - Number(isGpaBelowThreshold(a)))
  }, [columns.filtered, debouncedSearch])

  const importMutation = useMutation({
    mutationFn: (file: File) => api.scholarReviewsImport(file, ACADEMIC_YEAR),
    onSuccess: (result) => {
      setImportError(result.errors.length > 0 ? result.errors.join(' ') : null)
      setImportMessage(
        `${result.created} yeni, ${result.updated} güncellendi` +
          (result.skipped ? `, ${result.skipped} boş satır` : '') +
          '.',
      )
      void queryClient.invalidateQueries({ queryKey: ['scholar-reviews'] })
    },
    onError: (error: Error) => {
      setImportMessage(null)
      setImportError(getQueryErrorMessage(error, 'Yenileme Excel’i yüklenemedi.'))
    },
  })

  const rosterMutation = useMutation({
    mutationFn: (file: File) => api.scholarsImport(file),
    onSuccess: (result) => {
      setImportError(result.errors.length > 0 ? result.errors.join(' ') : null)
      setImportMessage(
        `Bursiyer listesi: ${result.created} yeni, ${result.updated} güncellendi.` +
          (result.skipped ? ` ${result.skipped} boş satır.` : ''),
      )
      void queryClient.invalidateQueries({ queryKey: ['scholar-reviews'] })
      void queryClient.invalidateQueries({ queryKey: ['scholars'] })
    },
    onError: (error: Error) => {
      setImportMessage(null)
      setImportError(getQueryErrorMessage(error, 'Bursiyer listesi yüklenemedi.'))
    },
  })

  function handleFileSelected(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file) return
    setImportMessage(null)
    setImportError(null)
    importMutation.mutate(file)
  }

  function handleRosterSelected(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file) return
    setImportMessage(null)
    setImportError(null)
    rosterMutation.mutate(file)
  }

  const missing = query.data?.missingScholars ?? []
  const submittedCount = query.data?.responses.length ?? 0
  const missingCount = missing.length
  const scholarCount = submittedCount + missingCount
  const gpaLowCount = (query.data?.responses ?? []).filter(isGpaBelowThreshold).length

  const missingColumns = useColumnFilters(missing, MISSING_COLUMNS)

  const missingFiltered = useMemo(() => {
    return missingColumns.filtered.filter((row) =>
      matchesQuery(debouncedSearch, row.firstName, row.lastName, row.tcNo, row.university, row.department),
    )
  }, [missingColumns.filtered, debouncedSearch])

  return (
    <div className="page-stack">
      <section className="panel">
        <h2>Burs yenileme</h2>
        <p className="panel-subtitle">
          Formdaki GNO çoğu zaman dosya linkidir. 4’lükte 2’nin, 100’lükte 70’in altı kırmızı rozetle ve listenin
          üstünde görünür; kartı açıp kutuyu işaretleyince bu karta düşerler.
        </p>

        {query.data && (
          <div className="prescreen-stats" role="tablist" aria-label="Yenileme sayıları">
            <button
              type="button"
              className={`prescreen-stat${view === 'submitted' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setView('submitted')}
            >
              <span className="prescreen-stat__value">{scholarCount}</span>
              <span className="prescreen-stat__label">Toplam (form + eksik)</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--invite${view === 'submitted' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setView('submitted')}
            >
              <span className="prescreen-stat__value">{submittedCount}</span>
              <span className="prescreen-stat__label">Formu dolduran</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--skip${view === 'missing' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setView('missing')}
            >
              <span className="prescreen-stat__value">{missingCount}</span>
              <span className="prescreen-stat__label">Formu doldurmayan</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--skip${view === 'gpa' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setView('gpa')}
            >
              <span className="prescreen-stat__value">{gpaLowCount}</span>
              <span className="prescreen-stat__label">GNO eşiğin altında</span>
            </button>
          </div>
        )}

        <div className="toolbar">
          <TableSearchBar
            value={search}
            onChange={setSearch}
            placeholder="Ad, TC ara…"
            resultCount={view === 'missing' ? missingFiltered.length : filtered.length}
          />
          <div className="toolbar-actions">
            <button
              type="button"
              className="btn-secondary"
              onClick={() => rosterInputRef.current?.click()}
              disabled={rosterMutation.isPending}
            >
              {rosterMutation.isPending ? 'Yükleniyor…' : 'Bursiyer listesi Excel'}
            </button>
            <button
              type="button"
              className="btn-primary"
              onClick={() => fileInputRef.current?.click()}
              disabled={importMutation.isPending}
            >
              {importMutation.isPending ? 'Yükleniyor…' : 'Yenileme Formu Excel'}
            </button>
            <input
              ref={rosterInputRef}
              type="file"
              accept=".xlsx,.xls"
              hidden
              onChange={handleRosterSelected}
            />
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
          count={view === 'missing' ? missingFiltered.length : filtered.length}
          canReset={search.length > 0 || (view === 'missing' ? missingColumns.active : columns.active)}
          onReset={() => {
            setSearch('')
            columns.reset()
            missingColumns.reset()
          }}
        />

        {query.isLoading && <p>Yükleniyor…</p>}
        {query.error && <p className="error">Yenileme listesi alınamadı.</p>}

        {query.data && view !== 'missing' && (
          <div className="table-scroll">
          <table className="data-table data-table--clickable data-table--nowrap">
            <thead>
              <tr>
                <ColumnFilterHeader {...filterHeaderProps(columns, 'name', 'Ad Soyad')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'cert', 'Belge')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'transcript', 'Transkript')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'income', 'Gelir')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'program', 'Program')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'classYear', 'Sınıf')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'decision', 'Karar')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'submitted', 'Form tarihi')} />
              </tr>
            </thead>
            <tbody>
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={8}>
                    {view === 'gpa'
                      ? 'Henüz eşiğin altında GNO işaretlenmedi. 4’lükte 2, 100’lükte 70 altı. Satıra tıklayıp kutuyu işaretleyin; form Excel’inde çoğu zaman yalnızca transkript dosyası var.'
                      : 'Henüz yenileme formu yok. Excel’i yükleyin.'}
                  </td>
                </tr>
              )}
              {filtered.map((row) => {
                const isSelected = selected?.id === row.id
                return (
                  <tr
                    key={row.id}
                    className={`${isSelected ? 'row-selected' : ''}${row.decision === 'STOP' || isGpaBelowThreshold(row) ? ' row-screened-out' : ''}`}
                    onClick={() => setSelected(isSelected ? null : row)}
                  >
                    <td>{row.fullName}</td>
                    <td>{docMark(row.studentCertUrl)}</td>
                    <td>{docMark(row.transcriptUrl)}</td>
                    <td>{docMark(row.familyIncomeUrl)}</td>
                    <td className="cell-clip" title={row.programAttendanceAnswer ?? undefined}>
                      {row.programAttendanceAnswer ?? '—'}
                    </td>
                    <td>{row.classYear ?? '—'}</td>
                    <td>
                      <span
                        className={
                          row.decision === 'CONTINUE'
                            ? 'badge badge--success'
                            : row.decision === 'STOP'
                              ? 'badge badge--danger'
                              : 'badge badge--muted'
                        }
                      >
                        {decisionLabel(row.decision)}
                      </span>
                    </td>
                    <td>{formatDate(row.submittedAt?.slice(0, 10) ?? null)}</td>
                  </tr>
                )
              })}
            </tbody>
          </table>
          </div>
        )}

        {query.data && view === 'missing' && (
          <div className="table-scroll">
          <table className="data-table data-table--nowrap">
            <thead>
              <tr>
                <ColumnFilterHeader {...filterHeaderProps(missingColumns, 'name', 'Ad Soyad')} />
                <ColumnFilterHeader {...filterHeaderProps(missingColumns, 'tcNo', 'TC')} />
                <ColumnFilterHeader {...filterHeaderProps(missingColumns, 'university', 'Üniversite')} />
                <ColumnFilterHeader {...filterHeaderProps(missingColumns, 'department', 'Bölüm')} />
              </tr>
            </thead>
            <tbody>
              {missingFiltered.length === 0 && (
                <tr>
                  <td colSpan={4}>Formu doldurmayan bursiyer yok veya aramaya uymuyor.</td>
                </tr>
              )}
              {missingFiltered.map((row) => (
                <tr key={row.scholarId}>
                  <td>
                    {row.firstName} {row.lastName}
                  </td>
                  <td>{row.tcNo ?? '—'}</td>
                  <td>{row.university ?? '—'}</td>
                  <td>{row.department ?? '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
          </div>
        )}
      </section>

      {selected && <ScholarRenewalPanel review={selected} onClose={() => setSelected(null)} />}
    </div>
  )
}
