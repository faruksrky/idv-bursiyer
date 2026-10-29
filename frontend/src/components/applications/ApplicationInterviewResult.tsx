import { useEffect, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api, type ApplicationDetail, type InterviewResult } from '../../api/client'
import {
  evaluationResultLabel,
  interviewResultBadgeClass,
  interviewResultLabel,
  officialInterviewResult,
  tracksInterviewResult,
} from '../../utils/applications'
import { getQueryErrorMessage } from '../../utils/apiError'

type Props = {
  application: ApplicationDetail
  archived: boolean
}

export function ApplicationInterviewResult({ application, archived }: Props) {
  const queryClient = useQueryClient()
  const tracked = tracksInterviewResult(application)
  const [result, setResult] = useState<InterviewResult>(officialInterviewResult(application))

  const evaluationQuery = useQuery({
    queryKey: ['interview-evaluation', application.id],
    queryFn: () => api.interviewEvaluation(application.id),
    enabled: tracked && !archived,
  })

  useEffect(() => {
    setResult(officialInterviewResult(application))
  }, [application.id, application.interviewResult])

  const saveMutation = useMutation({
    mutationFn: () => api.updateApplicationInterviewResult(application.id, result),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['application', application.id] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
    },
  })

  if (application.interviewInvite === 'PRESIDENT_QUOTA') {
    return (
      <div className="interview-result-card">
        <h3>Mülakat sonucu</h3>
        <p className="panel-subtitle">
          Başkan kontenjanı mülakata girmez. Bu aday kalmış sayılmaz; burs bu kottan verilir.
        </p>
      </div>
    )
  }

  if (!tracked) {
    return (
      <div className="interview-result-card">
        <h3>Mülakat sonucu</h3>
        <p className="panel-subtitle">
          Bu aday mülakata çağrılmıyor. Geçti / kaldı takibi yalnızca mülakat listesindeki adaylar içindir.
        </p>
      </div>
    )
  }

  const evaluation = evaluationQuery.data
  const averageLabel =
    evaluation?.committeeAverage != null ? evaluation.committeeAverage.toFixed(1) : null
  const recommendedFromAverage =
    evaluation?.recommendedResult === 'OLUMLU'
      ? 'PASSED'
      : evaluation?.recommendedResult === 'OLUMSUZ'
        ? 'FAILED'
        : null

  return (
    <div className="interview-result-card">
      <h3>Mülakat sonucu</h3>
      <p className="panel-subtitle">
        Komite ortalaması ≥ 80 ise Geçti, 80’in altı Kaldı (eşik 80/105, dahil). Ortalama oluşunca
        resmi sonuç otomatik işaretlenir; 5/5 tamamlanınca ortalama değişirse yenilenir. Personel
        sonra değiştirebilir. Başkan kontenjanı kalma sayılmaz.
      </p>

      <div className="interview-result-card__summary">
        <div>
          <strong>Resmi sonuç</strong>
          <div>
            <span className={interviewResultBadgeClass(officialInterviewResult(application))}>
              {interviewResultLabel(officialInterviewResult(application))}
            </span>
          </div>
        </div>
        <div>
          <strong>Komite ortalaması</strong>
          <div className="evaluation-summary-value">
            {averageLabel != null ? `${averageLabel} / 105` : '—'}
          </div>
          <span className="evaluation-summary-hint">
            {evaluation
              ? `${evaluation.submittedEvaluationCount}/${evaluation.committeeMemberCount} üye`
              : evaluationQuery.isLoading
                ? 'Yükleniyor…'
                : '—'}
          </span>
        </div>
        <div>
          <strong>Komite önerisi</strong>
          <div>
            <span className={interviewResultBadgeClass(
              evaluation?.recommendedResult === 'OLUMLU'
                ? 'PASSED'
                : evaluation?.recommendedResult === 'OLUMSUZ'
                  ? 'FAILED'
                  : 'PENDING',
            )}>
              {evaluation?.recommendedResult
                ? evaluationResultLabel(evaluation.recommendedResult)
                : 'Bekliyor'}
            </span>
          </div>
        </div>
      </div>

      {recommendedFromAverage && officialInterviewResult(application) === 'PENDING' && (
        <p className="panel-subtitle">
          Komite ortalaması {evaluationResultLabel(evaluation?.recommendedResult)} öneriyor — kayıt
          sonrası resmi sonuç buna çekilir; şimdi de kaydedebilirsiniz.
        </p>
      )}

      <fieldset className="interview-decision__invite" disabled={archived}>
        <legend>Resmi sonuç</legend>
        <label>
          <input
            type="radio"
            name={`interview-result-${application.id}`}
            checked={result === 'PENDING'}
            onChange={() => setResult('PENDING')}
          />
          Beklemede
        </label>
        <label>
          <input
            type="radio"
            name={`interview-result-${application.id}`}
            checked={result === 'PASSED'}
            onChange={() => setResult('PASSED')}
          />
          Geçti
        </label>
        <label>
          <input
            type="radio"
            name={`interview-result-${application.id}`}
            checked={result === 'FAILED'}
            onChange={() => setResult('FAILED')}
          />
          Kaldı
        </label>
      </fieldset>

      {saveMutation.isError && (
        <p className="error">{getQueryErrorMessage(saveMutation.error, 'Mülakat sonucu kaydedilemedi.')}</p>
      )}
      {saveMutation.isSuccess && <p className="success">Mülakat sonucu kaydedildi.</p>}

      {!archived && (
        <div className="toolbar-actions" style={{ marginTop: 12 }}>
          <button
            type="button"
            className="btn-primary"
            disabled={saveMutation.isPending}
            onClick={() => saveMutation.mutate()}
          >
            {saveMutation.isPending ? 'Kaydediliyor…' : 'Sonucu kaydet'}
          </button>
        </div>
      )}
    </div>
  )
}
