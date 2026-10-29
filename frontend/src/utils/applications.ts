import type { ApplicationStatus, InterviewResult } from '../api/client'

export function applicationStatusLabel(status: ApplicationStatus): string {
  switch (status) {
    case 'ACCEPTED':
      return 'Kabul edildi'
    case 'REJECTED':
      return 'Reddedildi'
    case 'INTERVIEW_SCHEDULED':
      return 'Mülakat planlandı'
    case 'EVALUATION_IN_PROGRESS':
      return 'Değerlendirme devam ediyor'
    case 'EVALUATION_COMPLETE':
      return 'Değerlendirme tamamlandı'
    default:
      return 'Başvuru tamamlandı'
  }
}

export function evaluationResultLabel(result: 'OLUMLU' | 'OLUMSUZ' | null | undefined): string {
  if (result === 'OLUMLU') return 'Olumlu'
  if (result === 'OLUMSUZ') return 'Olumsuz'
  return '—'
}

export function evaluationResultBadgeClass(result: 'OLUMLU' | 'OLUMSUZ' | null | undefined): string {
  if (result === 'OLUMLU') return 'badge badge--success'
  if (result === 'OLUMSUZ') return 'badge badge--danger'
  return 'badge badge--muted'
}

export function applicationDocumentLabel(type: string): string {
  const labels: Record<string, string> = {
    PHOTO: 'Fotoğraf',
    ID_COPY: 'Kimlik fotokopisi',
    FATHER_SALARY: 'Baba maaş belgesi',
    MOTHER_SALARY: 'Anne maaş belgesi',
    SIBLING_STUDENT: 'Kardeş öğrenci belgesi',
    STUDENT_CERT: 'Öğrenci belgesi',
    TRANSCRIPT: 'Transkript',
  }
  return labels[type] ?? type
}

export function canEvaluateApplication(status: ApplicationStatus): boolean {
  return status !== 'ACCEPTED' && status !== 'REJECTED'
}

export function formatTry(amount: number | null | undefined): string {
  if (amount == null || Number.isNaN(Number(amount))) {
    return '—'
  }
  return `${new Intl.NumberFormat('tr-TR').format(Number(amount))} TL`
}

export type InterviewInvite = 'AUTO' | 'INVITE' | 'SKIP' | 'PRESIDENT_QUOTA'

export function interviewTrackLabel(row: {
  interviewEligible: boolean
  interviewInvite?: InterviewInvite | string | null
  interviewScreenReason?: string | null
}): string {
  if (row.interviewInvite === 'PRESIDENT_QUOTA' || row.interviewScreenReason === 'QUOTA') {
    return 'Başkan kontenjanı'
  }
  return row.interviewEligible ? 'Mülakata çağrılacak' : 'Mülakata çağrılmayacak'
}

export function interviewTrackBadgeClass(row: {
  interviewEligible: boolean
  interviewInvite?: InterviewInvite | string | null
}): string {
  if (row.interviewInvite === 'PRESIDENT_QUOTA') return 'badge badge--quota'
  return row.interviewEligible ? 'badge badge--success' : 'badge badge--danger'
}

export function officialInterviewResult(row: {
  interviewResult?: InterviewResult | string | null
}): InterviewResult {
  if (row.interviewResult === 'PASSED' || row.interviewResult === 'FAILED') {
    return row.interviewResult
  }
  return 'PENDING'
}

export function tracksInterviewResult(row: {
  interviewEligible: boolean
  interviewInvite?: InterviewInvite | string | null
}): boolean {
  return row.interviewEligible && row.interviewInvite !== 'PRESIDENT_QUOTA'
}

export function interviewResultLabel(result: InterviewResult | string | null | undefined): string {
  if (result === 'PASSED') return 'Geçti'
  if (result === 'FAILED') return 'Kaldı'
  if (result === 'PENDING') return 'Beklemede'
  return '—'
}

export function interviewResultBadgeClass(result: InterviewResult | string | null | undefined): string {
  if (result === 'PASSED') return 'badge badge--success'
  if (result === 'FAILED') return 'badge badge--danger'
  if (result === 'PENDING') return 'badge badge--muted'
  return 'badge badge--muted'
}

export function isHttpUrl(value: string | null | undefined): value is string {
  return Boolean(value && /^https?:\/\//i.test(value.trim()))
}

export function applicationDocumentCount(row: {
  highSchool?: string | null
  documents?: { uploaded?: boolean; externalUrl?: string | null }[]
}): number {
  const files = (row.documents ?? []).filter((document) => document.uploaded || isHttpUrl(document.externalUrl)).length
  return files + (isHttpUrl(row.highSchool) ? 1 : 0)
}

function driveResourceId(url: string): string | null {
  const trimmed = url.trim()
  const fromQuery = trimmed.match(/[?&]id=([a-zA-Z0-9_-]+)/)
  if (fromQuery) return fromQuery[1]
  const fromPath = trimmed.match(/\/(?:file|folders)\/d\/([a-zA-Z0-9_-]+)/)
  if (fromPath) return fromPath[1]
  return null
}

export function googleDriveOpenUrl(url: string): string {
  const id = driveResourceId(url)
  if (!id) return url.trim()
  return `https://drive.google.com/open?id=${id}`
}

export function googleDrivePreviewUrl(url: string): string {
  const id = driveResourceId(url)
  if (!id) return url.trim()
  return `https://drive.google.com/file/d/${id}/preview`
}
