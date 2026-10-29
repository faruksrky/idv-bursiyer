export function matchesQuery(query: string, ...fields: Array<string | null | undefined>): boolean {
  const normalized = query.trim().toLowerCase()
  if (!normalized) {
    return true
  }

  return fields.some((field) => field?.toLowerCase().includes(normalized))
}

export const monthLabels = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
]

export function formatPeriod(year: number, month: number): string {
  return `${monthLabels[month - 1] ?? month} ${year}`
}

export function formatIsoDate(value: string | null | undefined): string {
  if (!value) {
    return '—'
  }

  const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value)
  if (!match) {
    return value
  }

  const month = Number(match[2])
  const day = Number(match[3])
  const label = monthLabels[month - 1]
  return label ? `${day} ${label} ${match[1]}` : value
}

export function formatDate(value: string | null | undefined): string {
  if (!value) {
    return '—'
  }

  const date = new Date(value)
  if (Number.isNaN(date.getTime())) {
    return value
  }

  return date.toLocaleDateString('tr-TR')
}

function parseLocalDate(value: string): Date | null {
  const date = new Date(value.includes('T') ? value : `${value}T12:00:00`)
  return Number.isNaN(date.getTime()) ? null : date
}

export function formatScholarshipPeriod(
  scholarshipStart: string | null | undefined,
  graduationDate: string | null | undefined,
): string {
  const start = scholarshipStart ? parseLocalDate(scholarshipStart) : null
  const end = graduationDate ? parseLocalDate(graduationDate) : null

  if (start && end) {
    const startLabel = `${monthLabels[start.getMonth()]} ${start.getFullYear()}`
    const endLabel = `${monthLabels[end.getMonth()]} ${end.getFullYear()}`
    return `${startLabel} – ${endLabel}`
  }
  if (start) {
    return `${monthLabels[start.getMonth()]} ${start.getFullYear()} –`
  }
  if (end) {
    return `– ${monthLabels[end.getMonth()]} ${end.getFullYear()}`
  }
  return '—'
}

export function attendanceLabel(status: 'KATILDI' | 'KATILMADI'): string {
  return status === 'KATILDI' ? 'Katıldı' : 'Katılmadı'
}

export function currentAcademicYear(): number {
  const now = new Date()
  const month = now.getMonth() + 1
  const year = now.getFullYear()
  return month >= 10 ? year : year - 1
}

export function formatAcademicYearLabel(academicYear: number): string {
  return `${academicYear}–${academicYear + 1} (Ekim–Temmuz)`
}

export type SeasonDisplayStatus = 'KATILDI' | 'KATILMADI' | 'PROGRAM_YOK'

export function seasonDisplayStatus(row: {
  programExists: boolean
  recordExists: boolean
  attendanceStatus: 'KATILDI' | 'KATILMADI' | null
}): SeasonDisplayStatus {
  if (!row.programExists) {
    return 'PROGRAM_YOK'
  }
  if (row.attendanceStatus === 'KATILDI') {
    return 'KATILDI'
  }
  return 'KATILMADI'
}

export function seasonStatusLabel(status: SeasonDisplayStatus): string {
  if (status === 'KATILDI') return 'Katıldı'
  if (status === 'KATILMADI') return 'Katılmadı'
  return 'Program yok'
}
