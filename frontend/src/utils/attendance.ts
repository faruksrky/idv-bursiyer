import type { AttendanceStatus, ExcuseStatus } from '../api/client'

export type AttendanceDraft = {
  attendanceStatus: AttendanceStatus
  excuseText: string
  excuseStatus: ExcuseStatus
}

export function isPaymentEligible(
  attendanceStatus: AttendanceStatus,
  excuseStatus: ExcuseStatus,
): boolean {
  if (attendanceStatus === 'KATILDI') return true
  return excuseStatus === 'KABUL'
}

export function needsExcuseText(draft: AttendanceDraft): boolean {
  return (
    draft.attendanceStatus === 'KATILMADI' &&
    (draft.excuseStatus === 'KABUL' || draft.excuseStatus === 'RED')
  )
}

export function validateAttendanceDraft(
  draft: AttendanceDraft,
  scholarName?: string,
): string | null {
  if (needsExcuseText(draft) && !draft.excuseText.trim()) {
    return scholarName
      ? `${scholarName}: Mazeret kabul/red için açıklama zorunlu.`
      : 'Mazeret kabul/red için açıklama zorunlu.'
  }
  return null
}

export function buildAttendanceUpdatePayload(draft: AttendanceDraft): {
  attendanceStatus: AttendanceStatus
  excuseText?: string | null
  excuseStatus?: ExcuseStatus
} {
  if (draft.attendanceStatus === 'KATILDI') {
    return { attendanceStatus: 'KATILDI' }
  }

  return {
    attendanceStatus: 'KATILMADI',
    excuseStatus: draft.excuseStatus ?? 'YOK',
    excuseText: draft.excuseText.trim() || null,
  }
}

export function parseApiErrorMessage(raw: string): string {
  const trimmed = raw.trim()
  if (!trimmed) return 'Kayıt sırasında hata oluştu.'

  try {
    const parsed = JSON.parse(trimmed) as { message?: string }
    if (parsed.message) return parsed.message
  } catch {
    // Spring bazen düz metin döner
  }

  return trimmed
}

export function buildYearOptions(currentYear: number) {
  return [currentYear, currentYear - 1, currentYear - 2].map((year) => ({
    value: String(year),
    label: String(year),
  }))
}

export function buildMonthOptions(monthLabels: string[]) {
  return monthLabels.map((label, index) => ({
    value: String(index + 1),
    label,
  }))
}
