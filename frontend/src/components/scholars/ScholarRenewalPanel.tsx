import { useEffect, useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { api, type ScholarReview, type ScholarReviewDecision } from '../../api/client'
import { googleDriveOpenUrl, googleDrivePreviewUrl, isHttpUrl } from '../../utils/applications'
import { getQueryErrorMessage } from '../../utils/apiError'

type Props = {
  review: ScholarReview
  onClose: () => void
}

type Preview = { key: string; label: string; src: string; driveUrl?: string }

export function ScholarRenewalPanel({ review, onClose }: Props) {
  const queryClient = useQueryClient()
  const [decision, setDecision] = useState<ScholarReviewDecision>(review.decision)
  const [note, setNote] = useState(review.note ?? '')
  const [graduating, setGraduating] = useState(review.graduating)
  const [gpaBelowTwo, setGpaBelowTwo] = useState(review.gpaBelowTwo)
  const [preview, setPreview] = useState<Preview | null>(null)
  const [previewError, setPreviewError] = useState<string | null>(null)

  useEffect(() => {
    setDecision(review.decision)
    setNote(review.note ?? '')
    setGraduating(review.graduating)
    setGpaBelowTwo(review.gpaBelowTwo)
    setPreview(null)
    setPreviewError(null)
  }, [review])

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

  const saveMutation = useMutation({
    mutationFn: () =>
      api.updateScholarReview(review.id, {
        decision,
        note: note.trim() ? note : null,
        graduating,
        gpaBelowTwo,
      }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['scholar-reviews'] })
      void queryClient.invalidateQueries({ queryKey: ['scholars'] })
    },
  })

  const docs: Array<{
    key: 'student' | 'photo' | 'transcript' | 'income'
    label: string
    url: string | null
    available?: boolean
  }> = [
    { key: 'student', label: 'Öğrenci belgesi', url: review.studentCertUrl, available: review.studentCertAvailable },
    { key: 'transcript', label: 'Transkript (GNO)', url: review.transcriptUrl, available: review.transcriptAvailable },
    { key: 'income', label: 'Aile geliri / maaş', url: review.familyIncomeUrl, available: review.familyIncomeAvailable },
    { key: 'photo', label: 'Fotoğraf', url: review.photoUrl, available: review.photoAvailable },
  ]

  function showDrivePreview(key: string, label: string, url: string) {
    if (preview?.src.startsWith('blob:')) URL.revokeObjectURL(preview.src)
    setPreview({
      key,
      label,
      src: googleDrivePreviewUrl(url),
      driveUrl: googleDriveOpenUrl(url),
    })
  }

  async function openDoc(
    key: 'student' | 'photo' | 'transcript' | 'income',
    label: string,
    url: string | null,
    available?: boolean,
  ) {
    setPreviewError(null)
    if (available) {
      try {
        const blob = await api.downloadScholarReviewFile(review.id, key)
        if (preview?.src.startsWith('blob:')) URL.revokeObjectURL(preview.src)
        setPreview({ key, label, src: URL.createObjectURL(blob) })
        return
      } catch {
        if (!isHttpUrl(url)) {
          setPreviewError('Belge henüz kopyalanmadı veya açılamadı.')
          return
        }
      }
    }
    if (isHttpUrl(url)) {
      showDrivePreview(key, label, url)
      return
    }
  }

  return (
    <div className="application-review-overlay" role="presentation" onClick={onClose}>
      <section
        className="application-review-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="renewal-review-title"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="scholar-history__header">
          <div>
            <h2 id="renewal-review-title">{review.fullName}</h2>
            <p className="scholar-history__subtitle">
              {review.periodLabel} burs yenileme · TC {review.tcNo}
              {review.classYear ? ` · Sınıf ${review.classYear}` : ''}
              {review.scholarMatched ? ' · kayıtlı bursiyer' : ' · bursiyer kaydı eşleşmedi'}
            </p>
          </div>
          <button type="button" className="btn-secondary" onClick={onClose}>
            Kapat
          </button>
        </div>

        <div className="application-review-dialog__body">
          <div className="interview-decision">
            <h3>Devam kararı</h3>
            <p className="panel-subtitle">
              Transkript 4’lük sistemde 2’nin veya 100’lük sistemde 70’in altındaysa işaretleyin; burs yenilemede
              devam edilmez. Yeni başvuruların mülakat çağrısı buradan etkilenmez.
            </p>
            <fieldset className="interview-decision__invite">
              <legend>Karar</legend>
              <label>
                <input
                  type="radio"
                  name={`renewal-${review.id}`}
                  checked={decision === 'PENDING'}
                  onChange={() => setDecision('PENDING')}
                />
                Beklemede
              </label>
              <label>
                <input
                  type="radio"
                  name={`renewal-${review.id}`}
                  checked={decision === 'CONTINUE'}
                  onChange={() => setDecision('CONTINUE')}
                />
                Devam
              </label>
              <label>
                <input
                  type="radio"
                  name={`renewal-${review.id}`}
                  checked={decision === 'STOP'}
                  onChange={() => setDecision('STOP')}
                />
                Bursu kes
              </label>
            </fieldset>
            <label className="interview-decision__invite" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <input
                type="checkbox"
                checked={gpaBelowTwo}
                onChange={(event) => {
                  const checked = event.target.checked
                  setGpaBelowTwo(checked)
                  if (checked) setDecision('STOP')
                }}
              />
              4’lükte 2 / 100’lükte 70 altı — yenilemede devam edilmez
            </label>
            {(review.fourthYear || review.graduating) && (
              <label className="interview-decision__invite" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <input
                  type="checkbox"
                  checked={graduating}
                  onChange={(event) => setGraduating(event.target.checked)}
                />
                Mezun (4. sınıf)
              </label>
            )}
            <label className="evaluation-note-field">
              <span className="filter-select__label">İnceleme notu</span>
              <textarea
                rows={3}
                value={note}
                placeholder="GNO, öğrencilik, gelir…"
                onChange={(event) => setNote(event.target.value)}
              />
            </label>
            {saveMutation.isError && (
              <p className="error">{getQueryErrorMessage(saveMutation.error, 'Karar kaydedilemedi.')}</p>
            )}
            {saveMutation.isSuccess && <p className="success">Karar kaydedildi.</p>}
            <div className="toolbar-actions" style={{ marginTop: 12 }}>
              <button
                type="button"
                className="btn-primary"
                disabled={saveMutation.isPending}
                onClick={() => saveMutation.mutate()}
              >
                {saveMutation.isPending ? 'Kaydediliyor…' : 'Kararı kaydet'}
              </button>
            </div>
          </div>

          <div className="application-detail-grid">
            <div><strong>Baba:</strong> {review.fatherStatus ?? '—'}</div>
            <div><strong>Anne:</strong> {review.motherStatus ?? '—'}</div>
            <div>
              <strong>GNO:</strong>{' '}
              {review.gpa != null ? review.gpa : review.gpaBelowTwo ? 'eşik altı (işaretli)' : '—'}
            </div>
            <div className="application-detail-grid__full">
              <strong>Program katılımı:</strong> {review.programAttendanceAnswer ?? '—'}
            </div>
            <div className="application-detail-grid__full">
              <strong>Öneriler / açıklama:</strong> {review.suggestions ?? '—'}
            </div>
          </div>

          <h3>Belgeler</h3>
          <p className="panel-subtitle">
            Formdaki GNO çoğu zaman transkript dosyasıdır; sayı yoksa belgede durur. Maaş/gelir de belgede. Drive
            dosyası Google hesabı isteyebilir.
          </p>
          <div className="application-doc-actions">
            {docs.map((doc) => {
              const canOpen = Boolean(doc.available) || isHttpUrl(doc.url)
              return (
                <button
                  key={doc.key}
                  type="button"
                  className={`btn-secondary${preview?.key === doc.key ? ' is-active-doc' : ''}`}
                  disabled={!canOpen}
                  onClick={() => void openDoc(doc.key, doc.label, doc.url, doc.available)}
                >
                  {doc.label}
                  {!isHttpUrl(doc.url) && !doc.available ? ' (yok)' : ''}
                </button>
              )
            })}
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
        </div>
      </section>
    </div>
  )
}
