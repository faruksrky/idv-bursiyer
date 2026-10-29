import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useMemo, useState } from 'react'
import { api, type EvaluationCriterion } from '../../api/client'
import {
  applicationStatusLabel,
  canEvaluateApplication,
  evaluationResultBadgeClass,
  evaluationResultLabel,
} from '../../utils/applications'
import { getQueryErrorMessage } from '../../utils/apiError'

function parseCriterionScore(raw: string, maxScore: number): number {
  const parsed = Number(raw)
  if (!Number.isFinite(parsed)) {
    return 0
  }
  return Math.min(maxScore, Math.max(0, Math.round(parsed)))
}

function initialScores(
  criteria: EvaluationCriterion[],
  existing?: { criterionId: number; score: number }[],
): Record<number, number> {
  const map: Record<number, number> = {}
  for (const criterion of criteria) {
    const found = existing?.find((score) => score.criterionId === criterion.id)
    map[criterion.id] = parseCriterionScore(String(found?.score ?? 0), criterion.maxScore)
  }
  return map
}

interface ApplicationEvaluationSectionProps {
  applicationId: number
  interviewEligible?: boolean
}

export function ApplicationEvaluationSection({
  applicationId,
  interviewEligible = true,
}: ApplicationEvaluationSectionProps) {
  const queryClient = useQueryClient()

  const evaluationQuery = useQuery({
    queryKey: ['interview-evaluation', applicationId],
    queryFn: () => api.interviewEvaluation(applicationId),
  })

  const [scores, setScores] = useState<Record<number, number>>({})
  const [note, setNote] = useState('')
  const [formError, setFormError] = useState<string | null>(null)
  const [saveMessage, setSaveMessage] = useState<string | null>(null)
  const [decisionMessage, setDecisionMessage] = useState<string | null>(null)

  const data = evaluationQuery.data
  const criteria = data?.criteria ?? []
  const hasSavedScore = Boolean(data?.myEvaluation)

  useEffect(() => {
    if (data) {
      setScores(initialScores(data.criteria, data.myEvaluation?.scores))
      setNote(data.myEvaluation?.note ?? '')
    }
  }, [data])

  const totalScore = useMemo(
    () => Object.values(scores).reduce((sum, value) => sum + value, 0),
    [scores],
  )

  const submitMutation = useMutation({
    mutationFn: () => {
      if (criteria.length === 0) {
        throw new Error('Değerlendirme kriterleri yüklenemedi.')
      }
      return api.submitInterviewEvaluation(
        applicationId,
        criteria.map((criterion) => ({
          criterionId: criterion.id,
          score: parseCriterionScore(String(scores[criterion.id] ?? 0), criterion.maxScore),
        })),
        note,
        hasSavedScore,
      )
    },
    onSuccess: () => {
      setFormError(null)
      setSaveMessage(
        hasSavedScore
          ? 'Puanlarınız güncellendi. Önceki kaydı silmenize gerek yok; aynı üye puanı üzerine yazıldı.'
          : 'Puanlarınız kaydedildi. Deneme puanını daha sonra silmeden güncelleyebilirsiniz.',
      )
      void queryClient.invalidateQueries({ queryKey: ['interview-evaluation', applicationId] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
      void queryClient.invalidateQueries({ queryKey: ['application', applicationId] })
    },
    onError: (error) => {
      setSaveMessage(null)
      setFormError(getQueryErrorMessage(error, 'Puan kaydedilemedi.'))
    },
  })

  const decisionMutation = useMutation({
    mutationFn: (decision: 'ACCEPTED' | 'REJECTED') =>
      api.applicationDecision(applicationId, decision),
    onSuccess: (result) => {
      setDecisionMessage(
        result.status === 'ACCEPTED'
          ? `Aday kabul edildi. Bursiyer kaydı oluşturuldu (#${result.scholarId}).`
          : 'Aday reddedildi.',
      )
      void queryClient.invalidateQueries({ queryKey: ['interview-evaluation', applicationId] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
      void queryClient.invalidateQueries({ queryKey: ['application', applicationId] })
      void queryClient.invalidateQueries({ queryKey: ['scholars'] })
    },
    onError: (error) => {
      setFormError(getQueryErrorMessage(error, 'Karar kaydedilemedi.'))
    },
  })

  if (evaluationQuery.isLoading) {
    return <p>Mülakat değerlendirmesi yükleniyor…</p>
  }

  if (evaluationQuery.error || !data) {
    return (
      <p className="error">
        {getQueryErrorMessage(evaluationQuery.error, 'Değerlendirme bilgisi alınamadı.')}
      </p>
    )
  }

  const averageLabel =
    data.committeeAverage != null ? data.committeeAverage.toFixed(1) : null
  const averagePasses =
    data.committeeAverage != null && data.committeeAverage >= data.passThreshold

  return (
    <div className="application-evaluation">
      <h3>Mülakat değerlendirme</h3>
      <p className="panel-subtitle">
        Eşik: {data.passThreshold}/105 · {applicationStatusLabel(data.applicationStatus)}.
        Puan denemesi yapabilirsiniz; kaydettikten sonra önceki puanı silmeden güncelleyebilirsiniz.
      </p>

      <div
        className={`evaluation-summary-grid${
          data.evaluationComplete ? ' evaluation-summary-grid--complete' : ''
        }`}
      >
        <div>
          <strong>Puan veren</strong>
          <div className="evaluation-summary-value">
            {data.submittedEvaluationCount}/{data.committeeMemberCount}
          </div>
          <span className="evaluation-summary-hint">komite üyesi</span>
        </div>
        <div>
          <strong>Komite ortalaması</strong>
          <div className="evaluation-summary-value">
            {averageLabel != null ? `${averageLabel} / 105` : '—'}
          </div>
          <span className="evaluation-summary-hint">
            {data.submittedEvaluationCount === 0
              ? 'Henüz puan yok'
              : data.evaluationComplete
                ? `Geçme eşiği ${data.passThreshold}`
                : `Geçici · eşik ${data.passThreshold}`}
          </span>
        </div>
        <div>
          <strong>Nihai öneri</strong>
          <div>
            <span className={evaluationResultBadgeClass(data.recommendedResult)}>
              {data.recommendedResult
                ? evaluationResultLabel(data.recommendedResult)
                : 'Bekliyor'}
            </span>
          </div>
          <span className="evaluation-summary-hint">
            {data.recommendedResult
              ? `Ortalama ${averageLabel} ${averagePasses ? '≥' : '<'} ${data.passThreshold}${
                  data.evaluationComplete ? '' : ' · geçici'
                }`
              : `${data.committeeMemberCount - data.submittedEvaluationCount} üye kaldı`}
          </span>
        </div>
      </div>

      {averageLabel != null && data.recommendedResult && (
        <div
          className={`evaluation-final-result ${
            averagePasses ? 'evaluation-final-result--positive' : 'evaluation-final-result--negative'
          }`}
        >
          <h4>{data.evaluationComplete ? 'Komite sonucu' : 'Geçici komite önerisi'}</h4>
          <p>
            {data.submittedEvaluationCount}/{data.committeeMemberCount} üye puan verdi. Ortalama{' '}
            <strong>{averageLabel}</strong> — geçme eşiği {data.passThreshold}. Öneri:{' '}
            <span className={evaluationResultBadgeClass(data.recommendedResult)}>
              {evaluationResultLabel(data.recommendedResult)}
            </span>
          </p>
        </div>
      )}

      {canEvaluateApplication(data.applicationStatus) && interviewEligible && (
        <>
          <h4>{hasSavedScore ? 'Puanımı güncelle' : 'Puanlama formu'}</h4>
          {hasSavedScore ? (
            <p className="panel-subtitle">
              Kayıtlı puanınız {data.myEvaluation?.totalScore}/105. Formdaki değerler son kaydınızdır;
              değiştirip tekrar kaydedebilirsiniz. Önceki puanı silmeniz gerekmez.
            </p>
          ) : (
            <p className="panel-subtitle">
              Puan denemesi kaydedilir. Daha sonra aynı formdan güncelleyebilirsiniz.
            </p>
          )}
          <table className="data-table evaluation-score-table">
            <thead>
              <tr>
                <th>Kriter</th>
                <th>Maks.</th>
                <th>Puan</th>
              </tr>
            </thead>
            <tbody>
              {criteria.map((criterion) => (
                <tr key={criterion.id}>
                  <td>{criterion.label}</td>
                  <td>{criterion.maxScore}</td>
                  <td>
                    <input
                      type="number"
                      min={0}
                      max={criterion.maxScore}
                      step={1}
                      value={scores[criterion.id] ?? 0}
                      onChange={(event) =>
                        setScores((current) => ({
                          ...current,
                          [criterion.id]: parseCriterionScore(
                            event.target.value,
                            criterion.maxScore,
                          ),
                        }))
                      }
                    />
                  </td>
                </tr>
              ))}
              <tr>
                <td><strong>Puan toplamı</strong></td>
                <td>105</td>
                <td><strong>{totalScore}</strong></td>
              </tr>
            </tbody>
          </table>

          <label className="evaluation-note-field">
            <span className="filter-select__label">Mülakat notu</span>
            <textarea
              rows={4}
              value={note}
              placeholder="Mülakat gözlemi, komite gerekçesi…"
              onChange={(event) => setNote(event.target.value)}
            />
          </label>

          {formError && <p className="error">{formError}</p>}
          {saveMessage && <p className="success">{saveMessage}</p>}

          <div className="toolbar-actions" style={{ marginTop: 12 }}>
            <button
              type="button"
              className="btn-primary"
              disabled={submitMutation.isPending}
              onClick={() => submitMutation.mutate()}
            >
              {submitMutation.isPending
                ? 'Kaydediliyor…'
                : hasSavedScore
                  ? 'Puanımı güncelle'
                  : 'Puanımı kaydet'}
            </button>
          </div>
        </>
      )}

      {data.committeeEvaluations.length > 0 && (
        <>
          <h4>Komite puanları</h4>
          <p className="panel-subtitle">
            Her üyenin son kaydı gösterilir. Güncelleme yeni satır açmaz; aynı değerlendiricinin puanı
            değişir.
          </p>
          <table className="data-table">
            <thead>
              <tr>
                <th>Değerlendirici</th>
                <th>Toplam</th>
                <th>Not</th>
                <th>Son kayıt</th>
              </tr>
            </thead>
            <tbody>
              {data.committeeEvaluations.map((member) => (
                <tr key={member.evaluatorSub}>
                  <td>{member.evaluatorName}</td>
                  <td>{member.totalScore}</td>
                  <td>{member.note ?? '—'}</td>
                  <td>{new Date(member.submittedAt).toLocaleString('tr-TR')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      {data.evaluationComplete && canEvaluateApplication(data.applicationStatus) && interviewEligible && (
        <div className="evaluation-decision-panel">
          <h4>Nihai karar</h4>
          <p className="panel-subtitle">
            Komite ortalaması {averageLabel} — öneri:{' '}
            {evaluationResultLabel(data.recommendedResult)} ({averagePasses ? 'eşiğin üzerinde' : 'eşiğin altında'})
          </p>
          <div className="toolbar-actions">
            <button
              type="button"
              className="btn-primary"
              disabled={decisionMutation.isPending}
              onClick={() => decisionMutation.mutate('ACCEPTED')}
            >
              Kabul Et
            </button>
            <button
              type="button"
              className="btn-secondary"
              disabled={decisionMutation.isPending}
              onClick={() => decisionMutation.mutate('REJECTED')}
            >
              Reddet
            </button>
          </div>
        </div>
      )}

      {decisionMessage && <p className="success">{decisionMessage}</p>}
    </div>
  )
}
