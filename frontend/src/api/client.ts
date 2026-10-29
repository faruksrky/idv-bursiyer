export type ScholarStatus = 'OGRENCI' | 'MEZUN'
export type ScholarIntake = 'RENEWAL' | 'INTERVIEW' | 'PRESIDENT_QUOTA'

export interface Scholar {
  id: number
  firstName: string
  lastName: string
  tcNo: string | null
  email: string | null
  phone: string | null
  iban: string | null
  university: string | null
  faculty: string | null
  department: string | null
  classYear: string | null
  status: ScholarStatus
  graduationDate: string | null
  scholarshipStart: string | null
  active: boolean
  programsAttendedCount: number
  gender: GenderFilter | null
  intake: ScholarIntake | null
}

export type AttendanceStatus = 'KATILDI' | 'KATILMADI'
export type ExcuseStatus = 'YOK' | 'KABUL' | 'RED'

export interface Attendance {
  id: number
  scholarId: number
  scholarName: string
  programId: number
  programName: string
  programDate: string | null
  attendanceStatus: AttendanceStatus
  excuseText: string | null
  excuseStatus: ExcuseStatus | null
  paymentEligible: boolean
}

export interface ProgramEvent {
  id: number
  year: number
  month: number
  name: string
  programDate: string | null
}

export type GenderFilter = 'KIZ' | 'ERKEK'

export interface AccountingExportRow {
  rowNumber: number
  scholarId: number
  firstName: string
  lastName: string
  gender: GenderFilter | null
  iban: string | null
  periodLabel: string
  amount: number | null
  paymentStatus: string
  university: string | null
  suggestedAmount: number | null
}

export interface ScholarImportResult {
  created: number
  updated: number
  skipped: number
  errors: string[]
}

export type ScholarReviewDecision = 'PENDING' | 'CONTINUE' | 'STOP'

export interface ScholarReview {
  id: number
  academicYear: number
  periodLabel: string
  fullName: string
  tcNo: string
  submittedAt: string | null
  scholarId: number | null
  scholarMatched: boolean
  studentCertUrl: string | null
  photoUrl: string | null
  transcriptUrl: string | null
  familyIncomeUrl: string | null
  fatherStatus: string | null
  motherStatus: string | null
  programAttendanceAnswer: string | null
  suggestions: string | null
  classYear: string | null
  fourthYear: boolean
  graduating: boolean
  gpa: number | null
  gpaBelowTwo: boolean
  decision: ScholarReviewDecision
  note: string | null
  studentCertAvailable?: boolean
  photoAvailable?: boolean
  transcriptAvailable?: boolean
  familyIncomeAvailable?: boolean
}

export interface ScholarMissingRenewal {
  scholarId: number
  firstName: string
  lastName: string
  tcNo: string | null
  university: string | null
  department: string | null
}

export interface ScholarRenewalList {
  academicYear: number
  periodLabel: string
  responses: ScholarReview[]
  missingScholars: ScholarMissingRenewal[]
}

export interface ScholarPaymentHistoryRow {
  year: number
  month: number
  periodLabel: string
  paymentStatus: string
  amount: number | null
  paymentEligible: boolean
  programExists: boolean
  note: string | null
}

export interface HealthResponse {
  status: string
  application: string
  interviewPassThreshold: number
  committeeMemberCount: number
  familyIncomeInterviewMax: number
}

export interface ScholarProgramAttendance {
  attendanceId: number
  year: number
  month: number
  programName: string
  programDate: string | null
  attendanceStatus: AttendanceStatus
  excuseStatus: ExcuseStatus | null
  excuseText: string | null
  paymentEligible: boolean
}

export interface ScholarSeasonAttendance {
  year: number
  month: number
  periodLabel: string
  programName: string | null
  attendanceStatus: AttendanceStatus | null
  excuseStatus: ExcuseStatus | null
  excuseText: string | null
  paymentEligible: boolean
  programExists: boolean
  recordExists: boolean
}

export type ApplicationSeasonStatus = 'DRAFT' | 'OPEN' | 'CLOSED' | 'ARCHIVED'
export type ApplicationStatus =
  | 'SUBMITTED'
  | 'INTERVIEW_SCHEDULED'
  | 'EVALUATION_IN_PROGRESS'
  | 'EVALUATION_COMPLETE'
  | 'ACCEPTED'
  | 'REJECTED'
export type InterviewResult = 'PENDING' | 'PASSED' | 'FAILED'
export type InterviewAttendance = 'GELDI' | 'GELMEDI' | null

export interface InterviewCalendarSlot {
  applicationId: number
  sessionId: number
  fullName: string
  scheduledAt: string | null
  attendance: InterviewAttendance
}

export interface InterviewCalendarDay {
  date: string
  weekday: string
  label: string
  slots: InterviewCalendarSlot[]
}

export interface InterviewCalendar {
  location: string
  days: InterviewCalendarDay[]
  unscheduled: InterviewCalendarSlot[]
}
export type ApplicationDocumentType =
  | 'PHOTO'
  | 'ID_COPY'
  | 'FATHER_SALARY'
  | 'MOTHER_SALARY'
  | 'SIBLING_STUDENT'
  | 'STUDENT_CERT'
  | 'TRANSCRIPT'

export interface ApplicationSeason {
  id: number
  code: string
  title: string
  publicSlug: string
  status: ApplicationSeasonStatus
  opensAt: string | null
  closesAt: string | null
  familyIncomeInterviewMax: number
}

export interface ApplicationSummary {
  id: number
  seasonCode: string
  status: ApplicationStatus
  submittedAt: string | null
  fullName: string
  tcNo: string
  email: string | null
  phone: string | null
  university: string | null
  department: string | null
  gpa: number | null
  acceptedScholarLinked: boolean
  familyMonthlyIncome: number | null
  interviewEligible: boolean
  interviewScreenReason: 'INCOME' | 'MANUAL' | 'QUOTA' | null
  interviewInvite: 'AUTO' | 'INVITE' | 'SKIP' | 'PRESIDENT_QUOTA'
  interviewResult: InterviewResult
  staffNote: string | null
  highSchool: string | null
  documents: ApplicationDocument[]
}

export interface ApplicationDocument {
  id: number
  documentType: ApplicationDocumentType
  fileName: string | null
  contentType: string | null
  fileSize: number | null
  uploaded: boolean
  externalUrl: string | null
}

export interface ApplicationDetail extends Omit<ApplicationSummary, 'acceptedScholarLinked' | 'gpa'> {
  birthPlace: string | null
  birthDate: string | null
  address: string | null
  fatherStatus: string | null
  fatherName: string | null
  fatherJob: string | null
  motherStatus: string | null
  motherJob: string | null
  familyMonthlyIncome: number | null
  siblingCount: number | null
  studyingSiblingCount: number | null
  faculty: string | null
  classYear: string | null
  gpa: number | null
  highSchool: string | null
  referenceName: string | null
  referenceOrganization: string | null
  referencePhone: string | null
  associations: string | null
  interests: string | null
  languages: string | null
  interviewEligible: boolean
  interviewScreenReason: 'INCOME' | 'MANUAL' | 'QUOTA' | null
  familyIncomeInterviewMax: number
  highSchoolAvailable?: boolean
  documents: ApplicationDocument[]
}

export interface EvaluationCriterion {
  id: number
  code: string
  label: string
  maxScore: number
}

export interface CriterionScore {
  criterionId: number
  code: string
  label: string
  maxScore: number
  score: number
}

export interface MemberEvaluation {
  evaluatorSub: string
  evaluatorName: string
  totalScore: number
  submittedAt: string
  note: string | null
  scores: CriterionScore[]
}

export interface InterviewEvaluation {
  applicationId: number
  fullName: string
  seasonCode: string
  applicationStatus: ApplicationStatus
  scheduledAt: string | null
  passThreshold: number
  committeeMemberCount: number
  submittedEvaluationCount: number
  evaluationComplete: boolean
  committeeAverage: number | null
  recommendedResult: 'OLUMLU' | 'OLUMSUZ' | null
  criteria: EvaluationCriterion[]
  myEvaluation: MemberEvaluation | null
  committeeEvaluations: MemberEvaluation[]
}

export interface EvaluationQueueItem {
  applicationId: number
  fullName: string
  tcNo: string
  university: string | null
  department: string | null
  applicationStatus: ApplicationStatus
  scheduledAt: string | null
  submittedEvaluationCount: number
  committeeMemberCount: number
  committeeAverage: number | null
  recommendedResult: 'OLUMLU' | 'OLUMSUZ' | null
}

export interface ApplicationDecisionResult {
  applicationId: number
  status: ApplicationStatus
  scholarId: number | null
}

export interface ApplicationSubmitPayload {
  fullName: string
  tcNo: string
  birthPlace: string
  birthDate: string
  email: string
  address: string
  phone: string
  fatherStatus: string
  fatherName?: string
  fatherJob: string
  motherStatus: string
  motherJob: string
  familyMonthlyIncome: number
  siblingCount: number
  studyingSiblingCount: number
  university: string
  faculty: string
  department: string
  classYear: string
  gpa: number
  highSchool: string
  referenceName: string
  referenceOrganization: string
  referencePhone: string
  associations?: string
  interests: string
  languages: string
  consentAccuracy: boolean
  consentTerms: boolean
  consentRejection: boolean
  consentKvkk: boolean
}

import { getAccessToken } from '../auth/session'

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(init?.headers as Record<string, string> | undefined),
  }

  const token = getAccessToken()
  if (token) {
    headers.Authorization = `Bearer ${token}`
  }
  const response = await fetch(path, {
    ...init,
    headers,
  })
  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || `HTTP ${response.status}`)
  }
  return response.json() as Promise<T>
}

async function downloadFile(path: string, filename: string) {
  const headers: Record<string, string> = {}
  const token = getAccessToken()
  if (token) {
    headers.Authorization = `Bearer ${token}`
  }
  const response = await fetch(path, { headers })
  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || `HTTP ${response.status}`)
  }
  const blob = await response.blob()
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  link.click()
  URL.revokeObjectURL(url)
}

async function downloadBlob(path: string) {
  const headers: Record<string, string> = {}
  const token = getAccessToken()
  if (token) {
    headers.Authorization = `Bearer ${token}`
  }
  const response = await fetch(path, { headers })
  if (!response.ok) {
    throw new Error('Belge indirilemedi')
  }
  return response.blob()
}

async function uploadFile<T>(path: string, file: File): Promise<T> {
  const formData = new FormData()
  formData.append('file', file)
  const headers: Record<string, string> = {}
  const token = getAccessToken()
  if (token) {
    headers.Authorization = `Bearer ${token}`
  }
  const response = await fetch(path, {
    method: 'POST',
    body: formData,
    headers,
  })
  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || `HTTP ${response.status}`)
  }
  return response.json() as Promise<T>
}

export const api = {
  health: () => request<HealthResponse>('/api/health'),
  scholars: (filters?: { status?: ScholarStatus }) => {
    const params = new URLSearchParams()
    if (filters?.status) params.set('status', filters.status)
    const query = params.toString()
    return request<Scholar[]>(`/api/v1/scholars${query ? `?${query}` : ''}`)
  },
  graduates: () => request<Scholar[]>('/api/v1/scholars?status=MEZUN'),
  scholarProgramAttendance: (
    scholarId: number,
    filters?: { year?: number; month?: number; attendanceStatus?: AttendanceStatus },
  ) => {
    const params = new URLSearchParams()
    if (filters?.year) params.set('year', String(filters.year))
    if (filters?.month) params.set('month', String(filters.month))
    if (filters?.attendanceStatus) params.set('attendanceStatus', filters.attendanceStatus)
    const query = params.toString()
    return request<ScholarProgramAttendance[]>(
      `/api/v1/scholars/${scholarId}/program-attendance${query ? `?${query}` : ''}`,
    )
  },
  scholarSeasonAttendance: (scholarId: number, academicYear: number) =>
    request<ScholarSeasonAttendance[]>(
      `/api/v1/scholars/${scholarId}/season-attendance?academicYear=${academicYear}`,
    ),
  attendance: (year: number, month: number) =>
    request<Attendance[]>(`/api/v1/programs/attendance?year=${year}&month=${month}`),
  programs: (year: number, month: number) =>
    request<ProgramEvent[]>(`/api/v1/programs?year=${year}&month=${month}`),
  createProgram: (body: { name: string; programDate: string }) =>
    request<ProgramEvent>('/api/v1/programs', {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  updateProgram: (id: number, body: { name: string; programDate: string }) =>
    request<ProgramEvent>(`/api/v1/programs/${id}`, {
      method: 'PUT',
      body: JSON.stringify(body),
    }),
  updateAttendance: (id: number, body: {
    attendanceStatus: AttendanceStatus
    excuseText?: string | null
    excuseStatus?: ExcuseStatus | null
  }) =>
    request<Attendance>(`/api/v1/programs/attendance/${id}`, {
      method: 'PUT',
      body: JSON.stringify(body),
    }),
  updateScholarIban: (scholarId: number, iban: string) =>
    request<Scholar>(`/api/v1/scholars/${scholarId}/iban`, {
      method: 'PUT',
      body: JSON.stringify({ iban }),
    }),
  accountingExport: (year: number, month: number) =>
    request<AccountingExportRow[]>(`/api/v1/accounting/export?year=${year}&month=${month}`),
  updateAccountingPaymentStatus: (body: {
    year: number
    month: number
    scholarIds: number[]
    paymentStatus: 'ODENDI' | 'ODENMEDI'
  }) =>
    request<{ updated: number; paymentStatus: string }>('/api/v1/accounting/payments', {
      method: 'PUT',
      body: JSON.stringify(body),
    }),
  updateAccountingPaymentAmount: (body: {
    year: number
    month: number
    scholarIds: number[]
    amount: number
  }) =>
    request<{ updated: number; amount: number }>('/api/v1/accounting/payments/amounts', {
      method: 'PUT',
      body: JSON.stringify(body),
    }),
  accountingExportExcel: (year: number, month: number) =>
    downloadFile(
      `/api/v1/accounting/export/excel?year=${year}&month=${month}`,
      `idv-muhasebe-${year}-${String(month).padStart(2, '0')}.xlsx`,
    ),
  scholarsExportExcel: (status?: ScholarStatus) => {
    const params = new URLSearchParams()
    if (status) params.set('status', status)
    const query = params.toString()
    return downloadFile(
      `/api/v1/scholars/export/excel${query ? `?${query}` : ''}`,
      'idv-bursiyerler.xlsx',
    )
  },
  scholarsImportTemplate: () =>
    downloadFile('/api/v1/scholars/import/template', 'idv-bursiyer-sablon.xlsx'),
  scholarsImport: (file: File) =>
    uploadFile<ScholarImportResult>('/api/v1/scholars/import', file),
  scholarReviews: (academicYear?: number) => {
    const params = new URLSearchParams()
    if (academicYear != null) params.set('academicYear', String(academicYear))
    const query = params.toString()
    return request<ScholarRenewalList>(`/api/v1/scholar-reviews${query ? `?${query}` : ''}`)
  },
  scholarReviewsImport: (file: File, academicYear?: number) => {
    const params = new URLSearchParams()
    if (academicYear != null) params.set('academicYear', String(academicYear))
    const query = params.toString()
    return uploadFile<ScholarImportResult>(
      `/api/v1/scholar-reviews/import${query ? `?${query}` : ''}`,
      file,
    )
  },
  updateScholarReview: (
    id: number,
    body: {
      decision: ScholarReviewDecision
      note: string | null
      graduating?: boolean
      gpaBelowTwo?: boolean
    },
  ) =>
    request<ScholarReview>(`/api/v1/scholar-reviews/${id}`, {
      method: 'PUT',
      body: JSON.stringify(body),
    }),
  applicationsImport: (seasonId: number, file: File) =>
    uploadFile<ScholarImportResult>(`/api/v1/applications/import?seasonId=${seasonId}`, file),
  scholarPaymentHistory: (scholarId: number, academicYear: number) =>
    request<ScholarPaymentHistoryRow[]>(
      `/api/v1/accounting/scholars/${scholarId}/payment-history?academicYear=${academicYear}`,
    ),
  applicationSeasons: () => request<ApplicationSeason[]>('/api/v1/applications/seasons'),
  updateSeasonPrescreen: (seasonId: number, familyIncomeInterviewMax: number) =>
    request<ApplicationSeason>(`/api/v1/applications/seasons/${seasonId}/prescreen`, {
      method: 'PUT',
      body: JSON.stringify({ familyIncomeInterviewMax }),
    }),
  applications: (seasonId: number, status?: ApplicationStatus) => {
    const params = new URLSearchParams({ seasonId: String(seasonId) })
    if (status) params.set('status', status)
    return request<ApplicationSummary[]>(`/api/v1/applications?${params}`)
  },
  application: (id: number) => request<ApplicationDetail>(`/api/v1/applications/${id}`),
  updateApplicationInterview: (
    applicationId: number,
    body: { interviewInvite: 'AUTO' | 'INVITE' | 'SKIP' | 'PRESIDENT_QUOTA'; staffNote: string | null },
  ) =>
    request<ApplicationDetail>(`/api/v1/prescreen/${applicationId}`, {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  updateApplicationInterviewResult: (applicationId: number, interviewResult: InterviewResult) =>
    request<ApplicationDetail>(`/api/v1/applications/${applicationId}/interview-result`, {
      method: 'PUT',
      body: JSON.stringify({ interviewResult }),
    }),
  evaluationQueue: (seasonId: number) =>
    request<EvaluationQueueItem[]>(`/api/v1/evaluations/queue?seasonId=${seasonId}`),
  interviewEvaluation: (applicationId: number) =>
    request<InterviewEvaluation>(`/api/v1/applications/${applicationId}/evaluation`),
  scheduleInterview: (applicationId: number, scheduledAt: string) =>
    request<InterviewEvaluation>(`/api/v1/applications/${applicationId}/interview`, {
      method: 'PUT',
      body: JSON.stringify({ scheduledAt }),
    }),
  submitInterviewEvaluation: (
    applicationId: number,
    scores: { criterionId: number; score: number }[],
    note?: string,
    updateExisting = false,
  ) =>
    request<InterviewEvaluation>(`/api/v1/applications/${applicationId}/evaluation`, {
      method: updateExisting ? 'PUT' : 'POST',
      body: JSON.stringify({ scores, note: note ?? null }),
    }),
  applicationDecision: (applicationId: number, decision: 'ACCEPTED' | 'REJECTED') =>
    request<ApplicationDecisionResult>(`/api/v1/applications/${applicationId}/decision`, {
      method: 'POST',
      body: JSON.stringify({ decision }),
    }),
  publicApplicationSeason: (slug: string) =>
    request<ApplicationSeason>(`/api/public/applications/seasons/${slug}`),
  submitApplication: (
    slug: string,
    payload: ApplicationSubmitPayload,
    files: {
      photo: File
      idCopy: File
      fatherSalary: File
      motherSalary: File
      siblingStudent?: File
      studentCert: File
      transcript: File
    },
  ) => {
    const formData = new FormData()
    formData.append('payload', new Blob([JSON.stringify(payload)], { type: 'application/json' }))
    formData.append('photo', files.photo)
    formData.append('idCopy', files.idCopy)
    formData.append('fatherSalary', files.fatherSalary)
    formData.append('motherSalary', files.motherSalary)
    if (files.siblingStudent) formData.append('siblingStudent', files.siblingStudent)
    formData.append('studentCert', files.studentCert)
    formData.append('transcript', files.transcript)
    return fetch(`/api/public/applications/seasons/${slug}/submit`, {
      method: 'POST',
      body: formData,
    }).then(async (response) => {
      if (!response.ok) {
        const message = await response.text()
        throw new Error(message || `HTTP ${response.status}`)
      }
      return response.json() as Promise<ApplicationDetail>
    })
  },
  downloadApplicationDocument: async (applicationId: number, documentId: number) => {
    return downloadBlob(`/api/v1/applications/${applicationId}/documents/${documentId}/download`)
  },
  downloadHighSchool: async (applicationId: number) => {
    return downloadBlob(`/api/v1/applications/${applicationId}/high-school`)
  },
  downloadScholarReviewFile: async (reviewId: number, slot: 'student' | 'photo' | 'transcript' | 'income') => {
    return downloadBlob(`/api/v1/scholar-reviews/${reviewId}/files/${slot}`)
  },
  interviewCalendar: () => request<InterviewCalendar>('/api/v1/interviews/calendar'),
  updateInterviewAttendance: (applicationId: number, attendance: InterviewAttendance) =>
    request<InterviewCalendarSlot>(`/api/v1/interviews/calendar/${applicationId}/attendance`, {
      method: 'PUT',
      body: JSON.stringify({ attendance }),
    }),
}
