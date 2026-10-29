import { useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { api, type AttendanceStatus, type Scholar } from '../../api/client'
import { ActiveFilterChip } from '../search/ActiveFilterChip'
import { FilterChips } from '../search/FilterChips'
import { FilterSelect } from '../search/FilterSelect'
import { attendanceLabel, formatIsoDate, formatPeriod, monthLabels } from '../../utils/search'

interface ScholarProgramHistoryProps {
  scholar: Scholar
  onClose: () => void
}

const SEASON_MONTHS = [10, 11, 12, 1, 2, 3, 4, 5, 6, 7]

function buildYearOptions(currentYear: number) {
  return [
    { value: '', label: 'Tümü' },
    ...[currentYear, currentYear - 1, currentYear - 2].map((year) => ({
      value: String(year),
      label: String(year),
    })),
  ]
}

function buildMonthOptions() {
  return [
    { value: '', label: 'Tümü' },
    ...SEASON_MONTHS.map((month) => ({
      value: String(month),
      label: monthLabels[month - 1],
    })),
  ]
}

const attendanceOptions = [
  { value: '', label: 'Tümü' },
  { value: 'KATILDI', label: 'Katıldı' },
  { value: 'KATILMADI', label: 'Katılmadı' },
]

export function ScholarProgramHistory({ scholar, onClose }: ScholarProgramHistoryProps) {
  const currentYear = new Date().getFullYear()
  const [year, setYear] = useState('')
  const [month, setMonth] = useState('')
  const [attendanceStatus, setAttendanceStatus] = useState<AttendanceStatus | ''>('')

  const { data, isLoading, error } = useQuery({
    queryKey: ['scholar-program-attendance', scholar.id, year, month, attendanceStatus],
    queryFn: () =>
      api.scholarProgramAttendance(scholar.id, {
        year: year === '' ? undefined : Number(year),
        month: month === '' ? undefined : Number(month),
        attendanceStatus: attendanceStatus === '' ? undefined : attendanceStatus,
      }),
  })

  const summary = useMemo(() => {
    if (!data) {
      return null
    }

    const attended = data.filter((row) => row.attendanceStatus === 'KATILDI').length
    return { total: data.length, attended, missed: data.length - attended }
  }, [data])

  const canReset = year !== '' || month !== '' || attendanceStatus !== ''

  const resetFilters = () => {
    setYear('')
    setMonth('')
    setAttendanceStatus('')
  }

  return (
    <section className="panel scholar-history">
      <div className="scholar-history__header">
        <div>
          <h2>
            {scholar.firstName} {scholar.lastName} — Program Geçmişi
          </h2>
          <p className="scholar-history__subtitle">
            Hangi aylık programlara katıldığı / katılmadığı aşağıda listelenir.
          </p>
        </div>
        <button type="button" className="btn-secondary" onClick={onClose}>
          Kapat
        </button>
      </div>

      <div className="filter-toolbar">
        <FilterSelect
          label="Yıl"
          value={year}
          onChange={setYear}
          options={buildYearOptions(currentYear)}
        />
        <FilterSelect
          label="Ay"
          value={month}
          onChange={setMonth}
          options={buildMonthOptions()}
        />
        <FilterSelect
          label="Katılım durumu"
          value={attendanceStatus}
          onChange={(value) => setAttendanceStatus(value as AttendanceStatus | '')}
          options={attendanceOptions}
        />
      </div>

      <FilterChips count={data?.length ?? 0} canReset={canReset} onReset={resetFilters}>
        {year !== '' && (
          <ActiveFilterChip label="Yıl:" value={year} onRemove={() => setYear('')} />
        )}
        {month !== '' && (
          <ActiveFilterChip
            label="Ay:"
            value={monthLabels[Number(month) - 1]}
            onRemove={() => setMonth('')}
          />
        )}
        {attendanceStatus !== '' && (
          <ActiveFilterChip
            label="Katılım:"
            value={attendanceLabel(attendanceStatus)}
            onRemove={() => setAttendanceStatus('')}
          />
        )}
      </FilterChips>

      {summary && data && data.length > 0 && (
        <div className="scholar-history__stats">
          <span>
            <strong>{summary.total}</strong> program
          </span>
          <span className="scholar-history__stats--success">
            <strong>{summary.attended}</strong> katıldı
          </span>
          <span className="scholar-history__stats--danger">
            <strong>{summary.missed}</strong> katılmadı
          </span>
        </div>
      )}

      {isLoading && <p>Yükleniyor…</p>}
      {error && <p className="error">Program geçmişi alınamadı.</p>}

      {data && (
        <table className="data-table">
          <thead>
            <tr>
              <th>Dönem</th>
              <th>Program</th>
              <th>Katılım</th>
              <th>Mazeret</th>
              <th>Ödeme</th>
            </tr>
          </thead>
          <tbody>
            {data.length === 0 && (
              <tr>
                <td colSpan={5}>Seçilen filtrelere uygun program kaydı yok.</td>
              </tr>
            )}
            {data.map((row) => (
              <tr key={row.attendanceId}>
                <td>{formatPeriod(row.year, row.month)}</td>
                <td>
                  {row.programName}
                  {row.programDate ? ` · ${formatIsoDate(row.programDate)}` : ''}
                </td>
                <td>
                  <span
                    className={
                      row.attendanceStatus === 'KATILDI'
                        ? 'badge badge--success'
                        : 'badge badge--danger'
                    }
                  >
                    {attendanceLabel(row.attendanceStatus)}
                  </span>
                </td>
                <td>{row.excuseText ?? '—'}</td>
                <td>{row.paymentEligible ? 'Ödenir' : 'Ödenmez'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  )
}
