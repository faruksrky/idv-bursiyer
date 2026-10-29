import { useEffect, useMemo, useRef, useState, type ChangeEvent } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api, type ApplicationSummary, type EvaluationQueueItem, type InterviewResult } from '../api/client'
import { ApplicationDetailPanel } from '../components/applications/ApplicationDetailPanel'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterChips } from '../components/search/FilterChips'
import { FilterSelect } from '../components/search/FilterSelect'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import {
  applicationDocumentCount,
  formatTry,
  interviewResultBadgeClass,
  interviewResultLabel,
  interviewTrackBadgeClass,
  interviewTrackLabel,
  officialInterviewResult,
  tracksInterviewResult,
} from '../utils/applications'
import { getQueryErrorMessage } from '../utils/apiError'
import { formatDate, matchesQuery } from '../utils/search'

type ApplicationsTab = 'intake' | 'interview'
type InterviewTrackFilter = 'all' | 'invite' | 'skip' | 'quota'

const INTAKE_COLUMNS = {
  name: (row: ApplicationSummary) => row.fullName,
  phone: (row: ApplicationSummary) => row.phone,
  income: (row: ApplicationSummary) => formatTry(row.familyMonthlyIncome),
  prescreen: (row: ApplicationSummary) => interviewTrackLabel(row),
  docs: (row: ApplicationSummary) => {
    const docs = applicationDocumentCount(row)
    return docs > 0 ? String(docs) : 'Yok'
  },
  note: (row: ApplicationSummary) => (row.staffNote ? 'Var' : '—'),
  submitted: (row: ApplicationSummary) => formatDate(row.submittedAt?.slice(0, 10) ?? null),
}

export function ApplicationsPage() {
  const seasonsQuery = useQuery({
    queryKey: ['application-seasons'],
    queryFn: api.applicationSeasons,
  })

  const [tab, setTab] = useState<ApplicationsTab>('intake')
  const [seasonId, setSeasonId] = useState<number | null>(null)
  const [interviewTrack, setInterviewTrack] = useState<InterviewTrackFilter>('all')
  const [interviewResultFilter, setInterviewResultFilter] = useState<'all' | InterviewResult>('all')
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState<ApplicationSummary | null>(null)
  const [importMessage, setImportMessage] = useState<string | null>(null)
  const [importError, setImportError] = useState<string | null>(null)
  const [incomeMaxDraft, setIncomeMaxDraft] = useState('')
  const fileInputRef = useRef<HTMLInputElement>(null)
  const queryClient = useQueryClient()
  const debouncedSearch = useDebouncedValue(search)

  const activeSeasonId = seasonId ?? seasonsQuery.data?.[0]?.id ?? null
  const activeSeason = seasonsQuery.data?.find((season) => season.id === activeSeasonId)
  const incomeMax = activeSeason?.familyIncomeInterviewMax ?? 100000
  const isArchivedSeason = activeSeason?.status === 'ARCHIVED'

  useEffect(() => {
    setIncomeMaxDraft(String(incomeMax))
  }, [activeSeasonId, incomeMax])

  const applicationsQuery = useQuery({
    queryKey: ['applications', activeSeasonId],
    queryFn: () => api.applications(activeSeasonId!),
    enabled: activeSeasonId != null,
  })

  const queueQuery = useQuery({
    queryKey: ['evaluation-queue', activeSeasonId],
    queryFn: () => api.evaluationQueue(activeSeasonId!),
    enabled: activeSeasonId != null && tab === 'interview',
  })

  const queueById = useMemo(() => {
    const map = new Map<number, EvaluationQueueItem>()
    for (const item of queueQuery.data ?? []) {
      map.set(item.applicationId, item)
    }
    return map
  }, [queueQuery.data])

  const stats = useMemo(() => {
    const rows = applicationsQuery.data ?? []
    const tracked = rows.filter(tracksInterviewResult)
    return {
      total: rows.length,
      invite: rows.filter((row) => row.interviewEligible).length,
      quota: rows.filter((row) => row.interviewInvite === 'PRESIDENT_QUOTA').length,
      skip: rows.filter((row) => !row.interviewEligible && row.interviewInvite !== 'PRESIDENT_QUOTA').length,
      passed: tracked.filter((row) => officialInterviewResult(row) === 'PASSED').length,
      failed: tracked.filter((row) => officialInterviewResult(row) === 'FAILED').length,
      pending: tracked.filter((row) => officialInterviewResult(row) === 'PENDING').length,
    }
  }, [applicationsQuery.data])

  const intakeSource = useMemo(() => {
    const rows = applicationsQuery.data ?? []
    return rows.filter((row) => {
      if (interviewTrack === 'invite' && !row.interviewEligible) return false
      if (interviewTrack === 'quota' && row.interviewInvite !== 'PRESIDENT_QUOTA') return false
      if (interviewTrack === 'skip' && (row.interviewEligible || row.interviewInvite === 'PRESIDENT_QUOTA')) {
        return false
      }
      return true
    })
  }, [applicationsQuery.data, interviewTrack])

  const interviewSource = useMemo(() => {
    const rows = applicationsQuery.data ?? []
    return rows.filter((row) => {
      if (!tracksInterviewResult(row)) return false
      if (interviewResultFilter !== 'all' && officialInterviewResult(row) !== interviewResultFilter) {
        return false
      }
      return true
    })
  }, [applicationsQuery.data, interviewResultFilter])

  const intakeColumns = useColumnFilters(intakeSource, INTAKE_COLUMNS)

  const interviewGetters = useMemo(
    () => ({
      name: (row: ApplicationSummary) => row.fullName,
      phone: (row: ApplicationSummary) => row.phone,
      university: (row: ApplicationSummary) => row.university,
      scores: (row: ApplicationSummary) => {
        const item = queueById.get(row.id)
        if (!item) return '—'
        return `${item.submittedEvaluationCount}/${item.committeeMemberCount}`
      },
      average: (row: ApplicationSummary) => {
        const average = queueById.get(row.id)?.committeeAverage
        if (average == null) return '—'
        return average.toFixed(1)
      },
      result: (row: ApplicationSummary) => interviewResultLabel(officialInterviewResult(row)),
      submitted: (row: ApplicationSummary) => formatDate(row.submittedAt?.slice(0, 10) ?? null),
    }),
    [queueById],
  )

  const interviewColumns = useColumnFilters(interviewSource, interviewGetters)

  const filtered = useMemo(() => {
    const rows = tab === 'intake' ? intakeColumns.filtered : interviewColumns.filtered
    return rows.filter((row) =>
      matchesQuery(
        debouncedSearch,
        row.fullName,
        row.tcNo,
        row.email,
        row.phone,
        row.university,
        row.department,
      ),
    )
  }, [debouncedSearch, intakeColumns.filtered, interviewColumns.filtered, tab])

  useEffect(() => {
    if (selected && !filtered.some((row) => row.id === selected.id)) {
      setSelected(null)
    }
  }, [filtered, selected])

  const seasonOptions =
    seasonsQuery.data?.map((season) => ({
      value: String(season.id),
      label: `${season.title} (${season.status})`,
    })) ?? []

  const openFormSlug = seasonsQuery.data?.find((season) => season.status === 'OPEN')?.publicSlug

  const prescreenMutation = useMutation({
    mutationFn: (familyIncomeInterviewMax: number) =>
      api.updateSeasonPrescreen(activeSeasonId!, familyIncomeInterviewMax),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['application-seasons'] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
      void queryClient.invalidateQueries({ queryKey: ['evaluation-queue'] })
    },
  })

  const importMutation = useMutation({
    mutationFn: (file: File) => api.applicationsImport(activeSeasonId!, file),
    onSuccess: (result) => {
      setImportError(result.errors.length > 0 ? result.errors.join(' ') : null)
      setImportMessage(
        `${result.created} başvuru içeri alındı` +
          (result.skipped ? `, ${result.skipped} satır atlandı` : '') +
          '.',
      )
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
    },
    onError: (error: Error) => {
      setImportMessage(null)
      setImportError(error.message || 'Excel yüklenemedi.')
    },
  })

  function handleImportClick() {
    fileInputRef.current?.click()
  }

  function handleFileSelected(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file || activeSeasonId == null) return
    setImportMessage(null)
    setImportError(null)
    importMutation.mutate(file)
  }

  function scoreLabel(row: ApplicationSummary) {
    const item = queueById.get(row.id)
    if (!item) return '—'
    return `${item.submittedEvaluationCount}/${item.committeeMemberCount}`
  }

  function averageLabel(row: ApplicationSummary) {
    const average = queueById.get(row.id)?.committeeAverage
    if (average == null) return '—'
    return average.toFixed(1)
  }

  return (
    <div className="page-stack">
      <section className="panel">
        <nav className="page-subnav" role="tablist" aria-label="Başvuru ve mülakat">
          <button
            type="button"
            role="tab"
            aria-selected={tab === 'intake'}
            className={`page-subnav__link${tab === 'intake' ? ' page-subnav__link--active' : ''}`}
            onClick={() => setTab('intake')}
          >
            Başvurular
          </button>
          <button
            type="button"
            role="tab"
            aria-selected={tab === 'interview'}
            className={`page-subnav__link${tab === 'interview' ? ' page-subnav__link--active' : ''}`}
            onClick={() => setTab('interview')}
          >
            Mülakat
          </button>
        </nav>

        <h2>{tab === 'intake' ? 'Başvurular' : 'Mülakat'}</h2>
        {tab === 'intake' ? (
          <p className="panel-subtitle">
            Ön eleme ve çağrı listesi. Aile geliri eşiğin üzerindeki adaylar mülakata çağrılmaz.
            Başkan kontenjanı ayrı tutulur: mülakat yok, burs bu kottan verilir (amber etiket).
            GNO bu ekranda elenmez; yenilemede bakılır.
            Bu dönemin eşiği {formatTry(incomeMax)} — yarın farklı bir tutar kaydedebilirsiniz.
            {isArchivedSeason
              ? ' Arşiv döneminde yalnızca özet bilgiler görüntülenir; belge linki yoktur.'
              : ' Satıra tıklayınca inceleme penceresi açılır: belgeler ve çağrı kararı.'}
            {openFormSlug && (
              <>
                {' '}
                Aktif form: <a href={`/basvuru/${openFormSlug}`}>/basvuru/{openFormSlug}</a>
              </>
            )}
          </p>
        ) : (
          <p className="panel-subtitle">
            Yalnızca mülakata çağrılan adaylar. Komite ortalaması ≥ 80 Geçti, altı Kaldı; personel
            sonra değiştirebilir. Başkan kontenjanı ve çağrılmayanlar bu listede yoktur.
            {isArchivedSeason
              ? ' Arşiv döneminde yalnızca özet bilgiler görüntülenir.'
              : ' Satıra tıklayınca puan formu ve resmi sonuç açılır.'}
          </p>
        )}

        {applicationsQuery.data && tab === 'intake' && (
          <div className="prescreen-stats" role="tablist" aria-label="Ön eleme özeti">
            <button
              type="button"
              className={`prescreen-stat${interviewTrack === 'all' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewTrack('all')}
            >
              <span className="prescreen-stat__value">{stats.total}</span>
              <span className="prescreen-stat__label">Toplam başvuru</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--invite${interviewTrack === 'invite' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewTrack('invite')}
            >
              <span className="prescreen-stat__value">{stats.invite}</span>
              <span className="prescreen-stat__label">Mülakata çağrılacak</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--skip${interviewTrack === 'skip' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewTrack('skip')}
            >
              <span className="prescreen-stat__value">{stats.skip}</span>
              <span className="prescreen-stat__label">Çağrılmayacak</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--quota${interviewTrack === 'quota' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewTrack('quota')}
            >
              <span className="prescreen-stat__value">{stats.quota}</span>
              <span className="prescreen-stat__label">Başkan kontenjanı</span>
            </button>
          </div>
        )}

        {applicationsQuery.data && tab === 'interview' && (
          <div className="prescreen-stats prescreen-stats--results" role="tablist" aria-label="Mülakat sonucu özeti">
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--pass${interviewResultFilter === 'PASSED' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewResultFilter((current) => (current === 'PASSED' ? 'all' : 'PASSED'))}
            >
              <span className="prescreen-stat__value">{stats.passed}</span>
              <span className="prescreen-stat__label">Geçti</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--fail${interviewResultFilter === 'FAILED' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewResultFilter((current) => (current === 'FAILED' ? 'all' : 'FAILED'))}
            >
              <span className="prescreen-stat__value">{stats.failed}</span>
              <span className="prescreen-stat__label">Kaldı</span>
            </button>
            <button
              type="button"
              className={`prescreen-stat prescreen-stat--pending${interviewResultFilter === 'PENDING' ? ' prescreen-stat--active' : ''}`}
              onClick={() => setInterviewResultFilter((current) => (current === 'PENDING' ? 'all' : 'PENDING'))}
            >
              <span className="prescreen-stat__value">{stats.pending}</span>
              <span className="prescreen-stat__label">Sonuç bekliyor</span>
            </button>
          </div>
        )}

        <div className="filter-toolbar">
          <FilterSelect
            label="Başvuru dönemi"
            value={activeSeasonId ? String(activeSeasonId) : ''}
            onChange={(value) => setSeasonId(Number(value))}
            options={seasonOptions}
          />
          {tab === 'intake' && (
            <label className="filter-select">
              <span className="filter-select__label">Mülakat gelir eşiği (TL)</span>
              <span className="prescreen-threshold">
                <input
                  type="number"
                  min={0}
                  step={1000}
                  value={incomeMaxDraft}
                  onChange={(event) => setIncomeMaxDraft(event.target.value)}
                />
                <button
                  type="button"
                  className="btn-secondary"
                  disabled={prescreenMutation.isPending || activeSeasonId == null || isArchivedSeason}
                  onClick={() => {
                    const value = Number(incomeMaxDraft)
                    if (!Number.isFinite(value) || value < 0) return
                    prescreenMutation.mutate(Math.round(value))
                  }}
                >
                  {prescreenMutation.isPending ? 'Kaydediliyor…' : 'Eşiği kaydet'}
                </button>
              </span>
            </label>
          )}
        </div>
        {tab === 'intake' && prescreenMutation.isError && (
          <p className="error">{getQueryErrorMessage(prescreenMutation.error, 'Gelir eşiği kaydedilemedi.')}</p>
        )}
        {tab === 'intake' && prescreenMutation.isSuccess && (
          <p className="success">Gelir eşiği bu dönem için güncellendi. Liste yeni kurala göre yenilendi.</p>
        )}

        <div className="toolbar">
          <TableSearchBar
            value={search}
            onChange={setSearch}
            placeholder="Ad, TC, telefon, üniversite ara…"
            resultCount={filtered.length}
          />
          {tab === 'intake' && (
            <div className="toolbar-actions">
              <button
                type="button"
                className="btn-primary"
                onClick={handleImportClick}
                disabled={importMutation.isPending || activeSeasonId == null}
              >
                {importMutation.isPending ? 'Yükleniyor…' : 'Google Form Excel'}
              </button>
              <input
                ref={fileInputRef}
                type="file"
                accept=".xlsx,.xls"
                hidden
                onChange={handleFileSelected}
              />
            </div>
          )}
        </div>

        <FilterChips
          count={filtered.length}
          canReset={
            search.length > 0 ||
            (tab === 'intake' ? intakeColumns.active : interviewColumns.active)
          }
          onReset={() => {
            setSearch('')
            intakeColumns.reset()
            interviewColumns.reset()
          }}
        />

        {tab === 'intake' && importMessage && <p className="success">{importMessage}</p>}
        {tab === 'intake' && importError && <p className="error">{importError}</p>}

        {seasonsQuery.isLoading && <p>Dönemler yükleniyor…</p>}
        {applicationsQuery.isLoading && <p>Başvurular yükleniyor…</p>}
        {applicationsQuery.error && <p className="error">Başvuru listesi alınamadı.</p>}

        {applicationsQuery.data && tab === 'intake' && (
          <div className="table-scroll">
            <table className="data-table data-table--clickable data-table--nowrap">
              <thead>
                <tr>
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'name', 'Ad Soyad')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'phone', 'Telefon')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'income', 'Gelir')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'prescreen', 'Ön eleme')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'docs', 'Belge')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'note', 'Not')} />
                  <ColumnFilterHeader {...filterHeaderProps(intakeColumns, 'submitted', 'Tarih')} />
                </tr>
              </thead>
              <tbody>
                {filtered.length === 0 && (
                  <tr>
                    <td colSpan={7}>Kayıt bulunamadı.</td>
                  </tr>
                )}
                {filtered.map((row) => {
                  const isSelected = selected?.id === row.id
                  const docs = applicationDocumentCount(row)
                  return (
                    <tr
                      key={row.id}
                      className={`${isSelected ? 'row-selected' : ''}${
                        row.interviewInvite === 'PRESIDENT_QUOTA'
                          ? ' row-quota'
                          : row.interviewEligible
                            ? ''
                            : ' row-screened-out'
                      }`}
                      onClick={() => setSelected(isSelected ? null : row)}
                    >
                      <td>{row.fullName}</td>
                      <td>
                        {row.phone ? (
                          <a href={`tel:${row.phone}`} onClick={(event) => event.stopPropagation()}>
                            {row.phone}
                          </a>
                        ) : (
                          '—'
                        )}
                      </td>
                      <td>{formatTry(row.familyMonthlyIncome)}</td>
                      <td>
                        <span className={interviewTrackBadgeClass(row)}>{interviewTrackLabel(row)}</span>
                      </td>
                      <td>{docs > 0 ? docs : 'Yok'}</td>
                      <td>{row.staffNote ? 'Var' : '—'}</td>
                      <td>{formatDate(row.submittedAt?.slice(0, 10) ?? null)}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}

        {applicationsQuery.data && tab === 'interview' && (
          <div className="table-scroll">
            <table className="data-table data-table--clickable data-table--nowrap">
              <thead>
                <tr>
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'name', 'Ad Soyad')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'phone', 'Telefon')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'university', 'Üniversite')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'scores', 'Puanlar')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'average', 'Ort.')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'result', 'Sonuç')} />
                  <ColumnFilterHeader {...filterHeaderProps(interviewColumns, 'submitted', 'Tarih')} />
                </tr>
              </thead>
              <tbody>
                {filtered.length === 0 && (
                  <tr>
                    <td colSpan={7}>Mülakata çağrılan aday yok.</td>
                  </tr>
                )}
                {filtered.map((row) => {
                  const isSelected = selected?.id === row.id
                  const result = officialInterviewResult(row)
                  return (
                    <tr
                      key={row.id}
                      className={isSelected ? 'row-selected' : ''}
                      onClick={() => setSelected(isSelected ? null : row)}
                    >
                      <td>{row.fullName}</td>
                      <td>
                        {row.phone ? (
                          <a href={`tel:${row.phone}`} onClick={(event) => event.stopPropagation()}>
                            {row.phone}
                          </a>
                        ) : (
                          '—'
                        )}
                      </td>
                      <td className="cell-clip" title={row.university ?? undefined}>
                        {row.university ?? '—'}
                      </td>
                      <td>{scoreLabel(row)}</td>
                      <td>{averageLabel(row)}</td>
                      <td>
                        <span className={interviewResultBadgeClass(result)}>{interviewResultLabel(result)}</span>
                      </td>
                      <td>{formatDate(row.submittedAt?.slice(0, 10) ?? null)}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {selected && (
        <ApplicationDetailPanel
          applicationId={selected.id}
          summary={{
            fullName: selected.fullName,
            seasonCode: selected.seasonCode,
            status: selected.status,
          }}
          archived={isArchivedSeason}
          onClose={() => setSelected(null)}
        />
      )}
    </div>
  )
}
