import { useEffect, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { api, type ApplicationDocument } from '../../api/client'
import type { ApplicationSummary } from '../../api/client'
import { ApplicationEvaluationSection } from './ApplicationEvaluationSection'
import { ApplicationInterviewDecision } from './ApplicationInterviewDecision'
import { ApplicationInterviewResult } from './ApplicationInterviewResult'
import {
  applicationDocumentLabel,
  applicationStatusLabel,
  formatTry,
  googleDriveOpenUrl,
  googleDrivePreviewUrl,
  interviewResultBadgeClass,
  interviewResultLabel,
  interviewTrackLabel,
  isHttpUrl,
  officialInterviewResult,
  tracksInterviewResult,
} from '../../utils/applications'
import { formatDate } from '../../utils/search'

interface ApplicationDetailPanelProps {
  applicationId: number
  summary?: { fullName: string; seasonCode: string; status: ApplicationSummary['status'] }
  archived?: boolean
  onClose: () => void
}

type Preview = {
  key: string
  label: string
  src: string
  driveUrl?: string
}

export function ApplicationDetailPanel({
  applicationId,
  summary,
  archived = false,
  onClose,
}: ApplicationDetailPanelProps) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['application', applicationId],
    queryFn: () => api.application(applicationId),
  })
  const [preview, setPreview] = useState<Preview | null>(null)
  const [previewError, setPreviewError] = useState<string | null>(null)

  useEffect(() => {
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    document.addEventListener('keydown', onKey)
    const previous = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => {
      document.removeEventListener('keydown', onKey)
      document.body.style.overflow = previous
    }
  }, [onClose])

  useEffect(() => {
    return () => {
      if (preview?.src.startsWith('blob:')) URL.revokeObjectURL(preview.src)
    }
  }, [preview])

  useEffect(() => {
    setPreview(null)
    setPreviewError(null)
  }, [applicationId])

  function showDrivePreview(key: string, label: string, url: string) {
    setPreview({
      key,
      label,
      src: googleDrivePreviewUrl(url),
      driveUrl: googleDriveOpenUrl(url),
    })
  }

  async function showDocument(document: ApplicationDocument) {
    setPreviewError(null)
    if (archived) return
    if (document.uploaded) {
      try {
        const blob = await api.downloadApplicationDocument(applicationId, document.id)
        setPreview({
          key: `doc-${document.id}`,
          label: applicationDocumentLabel(document.documentType),
          src: URL.createObjectURL(blob),
        })
        return
      } catch {
        if (!isHttpUrl(document.externalUrl)) {
          setPreviewError('Belge henüz kopyalanmadı veya açılamadı.')
          return
        }
      }
    }
    if (isHttpUrl(document.externalUrl)) {
      showDrivePreview(`doc-${document.id}`, applicationDocumentLabel(document.documentType), document.externalUrl)
      return
    }
  }

  async function showDiploma() {
    setPreviewError(null)
    if (data?.highSchoolAvailable) {
      try {
        const blob = await api.downloadHighSchool(applicationId)
        setPreview({ key: 'diploma', label: 'Lise diploması', src: URL.createObjectURL(blob) })
        return
      } catch {
        if (!isHttpUrl(data.highSchool)) {
          setPreviewError('Belge henüz kopyalanmadı veya açılamadı.')
          return
        }
      }
    }
    if (isHttpUrl(data?.highSchool)) {
      showDrivePreview('diploma', 'Lise diploması', data.highSchool)
    }
  }

  return (
    <div className="application-review-overlay" role="presentation" onClick={onClose}>
      <section
        className="application-review-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="application-review-title"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="scholar-history__header">
          <div>
            <h2 id="application-review-title">{data?.fullName ?? summary?.fullName ?? 'Başvuru detayı'}</h2>
            <p className="scholar-history__subtitle">
              {data
                ? `${data.seasonCode} · ${applicationStatusLabel(data.status)} · ${interviewTrackLabel(data)}${
                    tracksInterviewResult(data)
                      ? ` · ${interviewResultLabel(officialInterviewResult(data))}`
                      : ''
                  }`
                : summary
                  ? `${summary.seasonCode} · ${applicationStatusLabel(summary.status)}`
                  : 'Yükleniyor…'}
            </p>
          </div>
          <div className="scholar-history__header-actions">
            {data && tracksInterviewResult(data) && (
              <span className={interviewResultBadgeClass(officialInterviewResult(data))}>
                {interviewResultLabel(officialInterviewResult(data))}
              </span>
            )}
            <button type="button" className="btn-secondary" onClick={onClose}>
              Kapat
            </button>
          </div>
        </div>

        <div className="application-review-dialog__body">
          {isLoading && <p>Yükleniyor…</p>}
          {error && <p className="error">Başvuru detayı alınamadı.</p>}

          {data && (
            <>
              {data.interviewInvite === 'PRESIDENT_QUOTA' && (
                <div className="alert alert--quota">
                  Başkan kontenjanı: mülakata çağrılmaz. Burs bu kottan verilir; kabul edince bursiyer kaydı açılır.
                </div>
              )}
              {data.interviewInvite !== 'PRESIDENT_QUOTA' && !data.interviewEligible && (
                <div className="alert alert--error">
                  {data.interviewScreenReason === 'MANUAL'
                    ? 'Bu aday incelemede mülakata çağrılmayacak olarak işaretlendi.'
                    : `Aile geliri ${formatTry(data.familyMonthlyIncome)} — eşik ${formatTry(data.familyIncomeInterviewMax)}. Gelir kuralına göre mülakata çağrılmaz.`}
                </div>
              )}
              {data.interviewInvite !== 'PRESIDENT_QUOTA' && data.interviewEligible && (
                <div className="alert alert--success">
                  {data.interviewInvite === 'INVITE'
                    ? 'İncelemede mülakata çağrılacak olarak işaretlendi.'
                    : `Ön eleme: mülakata çağrılabilir (gelir ${formatTry(data.familyMonthlyIncome)}).`}
                </div>
              )}

              {!archived && <ApplicationInterviewDecision application={data} archived={archived} />}
              {!archived && <ApplicationInterviewResult application={data} archived={archived} />}

              <div className="application-detail-grid">
                <div><strong>TC:</strong> {data.tcNo}</div>
                <div><strong>E-posta:</strong> {data.email ?? '—'}</div>
                <div><strong>Telefon:</strong> {data.phone ?? '—'}</div>
                <div><strong>Doğum:</strong> {formatDate(data.birthDate)} · {data.birthPlace ?? '—'}</div>
                <div><strong>Üniversite:</strong> {data.university ?? '—'}</div>
                <div><strong>Fakülte:</strong> {data.faculty ?? '—'}</div>
                <div><strong>Bölüm / Sınıf:</strong> {data.department ?? '—'} / {data.classYear ?? '—'}</div>
                <div><strong>GNO:</strong> {data.gpa ?? '—'}</div>
                <div><strong>Aile geliri:</strong> {formatTry(data.familyMonthlyIncome)}</div>
                <div><strong>Referans:</strong> {data.referenceName ?? '—'} ({data.referenceOrganization ?? '—'})</div>
                <div className="application-detail-grid__full"><strong>Adres:</strong> {data.address ?? '—'}</div>
                <div className="application-detail-grid__full"><strong>İlgi alanları:</strong> {data.interests ?? '—'}</div>
              </div>

              {!archived && (
                <>
                  <h3>Belgeler</h3>
                  <p className="panel-subtitle">Belge bu pencerede açılır. Drive dosyası Google hesabı isteyebilir.</p>
                  <div className="application-doc-actions">
                    {isHttpUrl(data.highSchool) && (
                      <button
                        type="button"
                        className={`btn-secondary${preview?.key === 'diploma' ? ' is-active-doc' : ''}`}
                        onClick={() => void showDiploma()}
                      >
                        Lise diploması
                      </button>
                    )}
                    {data.documents.map((document) => {
                      const canOpen = Boolean(document.uploaded) || isHttpUrl(document.externalUrl)
                      return (
                        <button
                          key={document.id}
                          type="button"
                          className={`btn-secondary${preview?.key === `doc-${document.id}` ? ' is-active-doc' : ''}`}
                          disabled={!canOpen}
                          onClick={() => void showDocument(document)}
                        >
                          {applicationDocumentLabel(document.documentType)}
                        </button>
                      )
                    })}
                    {data.documents.length === 0 && !isHttpUrl(data.highSchool) && (
                      <span>Henüz belge yok.</span>
                    )}
                  </div>
                  {previewError && <p className="error">{previewError}</p>}
                  {preview && (
                    <div className="application-doc-preview">
                      <div className="application-doc-preview__bar">
                        <strong>{preview.label}</strong>
                        {preview.driveUrl && (
                          <a href={preview.driveUrl} target="_blank" rel="noreferrer">
                            Drive’da yeni sekme
                          </a>
                        )}
                      </div>
                      <iframe title={preview.label} src={preview.src} />
                    </div>
                  )}
                </>
              )}

              {archived && (
                <p className="panel-subtitle">Arşiv kaydı — eski dönem belgeleri sistemde tutulmuyor.</p>
              )}

              {!archived && data.interviewInvite !== 'PRESIDENT_QUOTA' && (
                <ApplicationEvaluationSection
                  applicationId={applicationId}
                  interviewEligible={data.interviewEligible}
                />
              )}
            </>
          )}
        </div>
      </section>
    </div>
  )
}
