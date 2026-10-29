import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useMemo, useState, type FormEvent } from 'react'
import { api } from '../api/client'
import type { Attendance, AttendanceStatus, ExcuseStatus, ProgramEvent } from '../api/client'
import { ActiveFilterChip } from '../components/search/ActiveFilterChip'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterChips } from '../components/search/FilterChips'
import { FilterSelect } from '../components/search/FilterSelect'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { LoadingButton } from '../components/ui/LoadingButton'
import { Snackbar } from '../components/ui/Snackbar'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import {
  buildAttendanceUpdatePayload,
  buildMonthOptions,
  buildYearOptions,
  isPaymentEligible,
  needsExcuseText,
  parseApiErrorMessage,
  validateAttendanceDraft,
  type AttendanceDraft,
} from '../utils/attendance'
import { attendanceLabel, formatIsoDate, formatPeriod, matchesQuery, monthLabels } from '../utils/search'

const now = new Date()

const attendanceFilterOptions = [
  { value: '', label: 'Tümü' },
  { value: 'KATILDI', label: 'Katıldı' },
  { value: 'KATILMADI', label: 'Katılmadı' },
]

const excuseStatusOptions = [
  { value: 'YOK', label: 'Yok' },
  { value: 'KABUL', label: 'Kabul' },
  { value: 'RED', label: 'Red' },
]

type ProgramDraft = {
  name: string
  programDate: string
}

function draftFromRow(row: Attendance): AttendanceDraft {
  return {
    attendanceStatus: row.attendanceStatus,
    excuseText: row.excuseText ?? '',
    excuseStatus: row.excuseStatus ?? 'YOK',
  }
}

function draftsEqual(left: AttendanceDraft, right: AttendanceDraft): boolean {
  return (
    left.attendanceStatus === right.attendanceStatus &&
    left.excuseText === right.excuseText &&
    left.excuseStatus === right.excuseStatus
  )
}

function programDraftFrom(program: ProgramEvent): ProgramDraft {
  return {
    name: program.name,
    programDate: program.programDate ?? '',
  }
}

function programDraftsEqual(left: ProgramDraft, right: ProgramDraft): boolean {
  return left.name === right.name && left.programDate === right.programDate
}

export function ProgramAttendancePage() {
  const currentYear = now.getFullYear()
  const [year, setYear] = useState(String(currentYear))
  const [month, setMonth] = useState(String(now.getMonth() + 1))
  const [search, setSearch] = useState('')
  const [attendanceFilter, setAttendanceFilter] = useState<AttendanceStatus | ''>('')
  const [drafts, setDrafts] = useState<Record<number, AttendanceDraft>>({})
  const [newName, setNewName] = useState('')
  const [newDate, setNewDate] = useState('')
  const [programDrafts, setProgramDrafts] = useState<Record<number, ProgramDraft>>({})
  const [saveMessage, setSaveMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  const debouncedSearch = useDebouncedValue(search)
  const queryClient = useQueryClient()

  const yearNumber = Number(year)
  const monthNumber = Number(month)
  const periodReady = Number.isFinite(yearNumber) && Number.isFinite(monthNumber)

  const programsQuery = useQuery({
    queryKey: ['programs', yearNumber, monthNumber],
    queryFn: () => api.programs(yearNumber, monthNumber),
    enabled: periodReady,
  })

  const { data, isLoading, error } = useQuery({
    queryKey: ['attendance', yearNumber, monthNumber],
    queryFn: () => api.attendance(yearNumber, monthNumber),
    enabled: periodReady,
  })

  useEffect(() => {
    if (!data) {
      setDrafts({})
      return
    }
    setDrafts(Object.fromEntries(data.map((row) => [row.id, draftFromRow(row)])))
  }, [data])

  useEffect(() => {
    if (!programsQuery.data) {
      setProgramDrafts({})
      return
    }
    setProgramDrafts(
      Object.fromEntries(programsQuery.data.map((program) => [program.id, programDraftFrom(program)])),
    )
  }, [programsQuery.data])

  const attendanceColumns = useMemo(
    () => ({
      name: (row: Attendance) => row.scholarName,
      program: (row: Attendance) => row.programName,
      date: (row: Attendance) => formatIsoDate(row.programDate),
      attendance: (row: Attendance) =>
        attendanceLabel((drafts[row.id] ?? draftFromRow(row)).attendanceStatus),
      excuse: (row: Attendance) => (drafts[row.id] ?? draftFromRow(row)).excuseText,
      excuseStatus: (row: Attendance) => {
        const draft = drafts[row.id] ?? draftFromRow(row)
        return excuseStatusOptions.find((option) => option.value === draft.excuseStatus)?.label ?? draft.excuseStatus
      },
      payment: (row: Attendance) => {
        const draft = drafts[row.id] ?? draftFromRow(row)
        return isPaymentEligible(draft.attendanceStatus, draft.excuseStatus) ? 'Ödenir' : 'Ödenmez'
      },
    }),
    [drafts],
  )
  const columns = useColumnFilters(data, attendanceColumns)

  const filtered = useMemo(() => {
    return columns.filtered.filter((row) => {
      const draft = drafts[row.id] ?? draftFromRow(row)
      const matchesSearchQuery = matchesQuery(
        debouncedSearch,
        row.scholarName,
        row.programName,
        formatIsoDate(row.programDate),
      )
      const matchesAttendance =
        attendanceFilter === '' || draft.attendanceStatus === attendanceFilter
      return matchesSearchQuery && matchesAttendance
    })
  }, [columns.filtered, debouncedSearch, attendanceFilter, drafts])

  const changedRows = useMemo(() => {
    if (!data) return []
    return data.filter((row) => {
      const draft = drafts[row.id]
      if (!draft) return false
      return !draftsEqual(draft, draftFromRow(row))
    })
  }, [data, drafts])

  function refreshPeriod(nextYear: number, nextMonth: number) {
    setYear(String(nextYear))
    setMonth(String(nextMonth))
    void queryClient.invalidateQueries({ queryKey: ['programs'] })
    void queryClient.invalidateQueries({ queryKey: ['attendance'] })
  }

  const attendanceMutation = useMutation({
    mutationFn: async (rows: Attendance[]) => {
      await Promise.all(
        rows.map((row) => {
          const draft = drafts[row.id]!
          return api.updateAttendance(row.id, buildAttendanceUpdatePayload(draft))
        }),
      )
      return rows.length
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['attendance', yearNumber, monthNumber] })
      setSaveMessage({ type: 'success', text: 'Değişiklikler başarıyla kaydedildi.' })
    },
    onError: (mutationError) => {
      const message =
        mutationError instanceof Error
          ? parseApiErrorMessage(mutationError.message)
          : 'Kayıt sırasında hata oluştu.'
      setSaveMessage({ type: 'error', text: message })
    },
  })

  const createProgramMutation = useMutation({
    mutationFn: (body: { name: string; programDate: string }) => api.createProgram(body),
    onSuccess: (created) => {
      setNewName('')
      setNewDate('')
      setSaveMessage({ type: 'success', text: 'Program eklendi.' })
      refreshPeriod(created.year, created.month)
    },
    onError: (mutationError) => {
      const message =
        mutationError instanceof Error
          ? parseApiErrorMessage(mutationError.message)
          : 'Program eklenemedi.'
      setSaveMessage({ type: 'error', text: message })
    },
  })

  const updateProgramMutation = useMutation({
    mutationFn: (program: { id: number; name: string; programDate: string }) =>
      api.updateProgram(program.id, { name: program.name, programDate: program.programDate }),
    onSuccess: (updated) => {
      setSaveMessage({ type: 'success', text: 'Program güncellendi.' })
      refreshPeriod(updated.year, updated.month)
    },
    onError: (mutationError) => {
      const message =
        mutationError instanceof Error
          ? parseApiErrorMessage(mutationError.message)
          : 'Program güncellenemedi.'
      setSaveMessage({ type: 'error', text: message })
    },
  })

  const canReset = search.length > 0 || attendanceFilter !== '' || columns.active
  const hasChanges = changedRows.length > 0
  const programs = programsQuery.data ?? []

  function updateDraft(id: number, patch: Partial<AttendanceDraft>) {
    setDrafts((current) => {
      const previous = current[id]
      if (!previous) return current
      const next = { ...previous, ...patch }
      if (patch.attendanceStatus === 'KATILDI') {
        next.excuseText = ''
        next.excuseStatus = 'YOK'
      }
      return { ...current, [id]: next }
    })
    setSaveMessage(null)
  }

  function handleSave() {
    if (!hasChanges || attendanceMutation.isPending) return

    const validationError = changedRows
      .map((row) => validateAttendanceDraft(drafts[row.id]!, row.scholarName))
      .find(Boolean)

    if (validationError) {
      setSaveMessage({ type: 'error', text: validationError })
      return
    }

    attendanceMutation.mutate(changedRows)
  }

  function handleCreateProgram(event: FormEvent) {
    event.preventDefault()
    const name = newName.trim()
    if (!name) {
      setSaveMessage({ type: 'error', text: 'Program adı zorunlu.' })
      return
    }
    if (!newDate) {
      setSaveMessage({ type: 'error', text: 'Tarih zorunlu.' })
      return
    }
    createProgramMutation.mutate({ name, programDate: newDate })
  }

  function handleUpdateProgram(event: FormEvent, program: ProgramEvent) {
    event.preventDefault()
    const draft = programDrafts[program.id]
    if (!draft) return
    const name = draft.name.trim()
    if (!name) {
      setSaveMessage({ type: 'error', text: 'Program adı zorunlu.' })
      return
    }
    if (!draft.programDate) {
      setSaveMessage({ type: 'error', text: 'Tarih zorunlu.' })
      return
    }
    updateProgramMutation.mutate({ id: program.id, name, programDate: draft.programDate })
  }

  return (
    <section className="panel">
      <h2>Aylık Program Katılım</h2>
      <p className="panel-subtitle">
        {formatPeriod(yearNumber, monthNumber)} döneminde program adı ve tarihini ekleyin. Her bursiyer için
        katıldı veya katılmadı işaretleyin. Tarih, programın görüneceği ayı belirler. Başkan kontenjanı bu listeye
        dahil edilmez.
      </p>

      <form className="program-add-form" onSubmit={handleCreateProgram}>
        <div className="filter-select">
          <label className="filter-select__label" htmlFor="program-name">
            Program adı
          </label>
          <input
            id="program-name"
            className="program-field"
            value={newName}
            maxLength={255}
            onChange={(event) => setNewName(event.target.value)}
            placeholder="Örn. Seminer"
          />
        </div>
        <div className="filter-select">
          <label className="filter-select__label" htmlFor="program-date">
            Tarih
          </label>
          <input
            id="program-date"
            className="program-field"
            type="date"
            value={newDate}
            onChange={(event) => setNewDate(event.target.value)}
          />
        </div>
        <LoadingButton type="submit" loading={createProgramMutation.isPending}>
          Program ekle
        </LoadingButton>
      </form>

      <div className="filter-toolbar">
        <FilterSelect
          label="Yıl"
          value={year}
          onChange={(value) => {
            setYear(value)
            setSaveMessage(null)
          }}
          options={buildYearOptions(currentYear)}
        />
        <FilterSelect
          label="Ay"
          value={month}
          onChange={(value) => {
            setMonth(value)
            setSaveMessage(null)
          }}
          options={buildMonthOptions(monthLabels)}
        />
        <FilterSelect
          label="Katılım"
          value={attendanceFilter}
          onChange={(value) => setAttendanceFilter(value as AttendanceStatus | '')}
          options={attendanceFilterOptions}
        />
      </div>

      <div className="toolbar">
        <TableSearchBar
          value={search}
          onChange={setSearch}
          placeholder="Bursiyer veya program ara…"
          resultCount={filtered.length}
        />
      </div>

      <FilterChips count={filtered.length} canReset={canReset} onReset={() => {
        setSearch('')
        setAttendanceFilter('')
        columns.reset()
      }}>
        {attendanceFilter !== '' && (
          <ActiveFilterChip
            label="Katılım:"
            value={attendanceLabel(attendanceFilter)}
            onRemove={() => setAttendanceFilter('')}
          />
        )}
      </FilterChips>

      <div className="program-event-list">
        <h3>Bu aydaki programlar</h3>
        {programsQuery.isLoading && <p>Programlar yükleniyor…</p>}
        {programsQuery.error && <p className="error">Program listesi alınamadı.</p>}
        {programsQuery.data && programs.length === 0 && (
          <p>Bu ay için program yok. Program adı ve tarihini girip Program ekle ile ekleyin.</p>
        )}
        {programs.map((program) => {
          const draft = programDrafts[program.id] ?? programDraftFrom(program)
          const unchanged = programDraftsEqual(draft, programDraftFrom(program))
          const updating =
            updateProgramMutation.isPending && updateProgramMutation.variables?.id === program.id
          return (
            <form
              key={program.id}
              className="program-event-row"
              onSubmit={(event) => handleUpdateProgram(event, program)}
            >
              <input
                className="program-field"
                type="text"
                aria-label={`${program.name} adı`}
                value={draft.name}
                maxLength={255}
                onChange={(event) =>
                  setProgramDrafts((current) => ({
                    ...current,
                    [program.id]: { ...draft, name: event.target.value },
                  }))
                }
              />
              <input
                className="program-field"
                type="date"
                aria-label={`${program.name} tarihi`}
                value={draft.programDate}
                onChange={(event) =>
                  setProgramDrafts((current) => ({
                    ...current,
                    [program.id]: { ...draft, programDate: event.target.value },
                  }))
                }
              />
              <button type="submit" className="btn-secondary" disabled={unchanged || updating}>
                {updating ? 'Kaydediliyor…' : 'Güncelle'}
              </button>
            </form>
          )
        })}
      </div>

      {(isLoading || programsQuery.isLoading) && <p>Yükleniyor…</p>}
      {error && <p className="error">Katılım listesi alınamadı.</p>}

      {data && programs.length > 0 && data.length === 0 && (
        <p>İşaretlenecek aktif bursiyer yok.</p>
      )}

      {data && data.length > 0 && (
        <div className="table-scroll">
        <table className="data-table data-table--nowrap">
          <thead>
            <tr>
              <ColumnFilterHeader {...filterHeaderProps(columns, 'name', 'Bursiyer')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'program', 'Program')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'date', 'Tarih')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'attendance', 'Katılım')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'excuse', 'Mazeret')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'excuseStatus', 'Maz. dr.')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'payment', 'Ödeme')} />
            </tr>
          </thead>
          <tbody>
            {filtered.length === 0 && (
              <tr>
                <td colSpan={7}>Bu dönem için arama kriterlerine uygun kayıt yok.</td>
              </tr>
            )}
            {filtered.map((row) => {
              const draft = drafts[row.id] ?? draftFromRow(row)
              const attended = draft.attendanceStatus === 'KATILDI'
              const paymentEligible = isPaymentEligible(draft.attendanceStatus, draft.excuseStatus)
              const excuseRequired = needsExcuseText(draft)
              const excuseInvalid = excuseRequired && !draft.excuseText.trim()

              return (
                <tr key={row.id}>
                  <td className="cell-clip" title={row.scholarName}>
                    {row.scholarName}
                  </td>
                  <td className="cell-clip" title={row.programName}>
                    {row.programName}
                  </td>
                  <td>{formatIsoDate(row.programDate)}</td>
                  <td>
                    <div className="attendance-toggle" role="group" aria-label={`${row.scholarName} katılım`}>
                      <button
                        type="button"
                        className={attended ? 'is-attended' : ''}
                        aria-pressed={attended}
                        onClick={() => updateDraft(row.id, { attendanceStatus: 'KATILDI' })}
                      >
                        Katıldı
                      </button>
                      <button
                        type="button"
                        className={!attended ? 'is-missed' : ''}
                        aria-pressed={!attended}
                        onClick={() => updateDraft(row.id, { attendanceStatus: 'KATILMADI' })}
                      >
                        Katılmadı
                      </button>
                    </div>
                  </td>
                  <td>
                    <input
                      type="text"
                      className={`inline-field${excuseInvalid ? ' inline-field--error' : ''}`}
                      value={draft.excuseText}
                      disabled={attended}
                      onChange={(e) => updateDraft(row.id, { excuseText: e.target.value })}
                      placeholder={attended ? '—' : excuseRequired ? 'Açıklama zorunlu' : 'Açıklama'}
                    />
                  </td>
                  <td>
                    <select
                      className="inline-field"
                      value={draft.excuseStatus}
                      disabled={attended}
                      onChange={(e) =>
                        updateDraft(row.id, { excuseStatus: e.target.value as ExcuseStatus })
                      }
                    >
                      {excuseStatusOptions.map((option) => (
                        <option key={option.value} value={option.value}>
                          {option.label}
                        </option>
                      ))}
                    </select>
                  </td>
                  <td>
                    <span className={`badge ${paymentEligible ? 'badge--success' : 'badge--muted'}`}>
                      {paymentEligible ? 'Ödenir' : 'Ödenmez'}
                    </span>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
        </div>
      )}

      {data && data.length > 0 && (
        <div className="form-actions">
          <LoadingButton
            loading={attendanceMutation.isPending}
            disabled={!hasChanges || isLoading}
            onClick={handleSave}
          >
            Değişiklikleri Kaydet
          </LoadingButton>
        </div>
      )}

      {saveMessage && (
        <Snackbar
          message={saveMessage.text}
          severity={saveMessage.type}
          onClose={() => setSaveMessage(null)}
        />
      )}
    </section>
  )
}
