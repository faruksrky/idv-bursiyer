import { useEffect, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api, type ApplicationDetail } from '../../api/client'
import { canEvaluateApplication } from '../../utils/applications'
import { getQueryErrorMessage } from '../../utils/apiError'

type Invite = 'AUTO' | 'INVITE' | 'SKIP' | 'PRESIDENT_QUOTA'

type Props = {
  application: ApplicationDetail
  archived: boolean
}

export function ApplicationInterviewDecision({ application, archived }: Props) {
  const queryClient = useQueryClient()
  const evaluationQuery = useQuery({
    queryKey: ['interview-evaluation', application.id],
    queryFn: () => api.interviewEvaluation(application.id),
    enabled: !archived && application.interviewInvite !== 'PRESIDENT_QUOTA',
  })
  const [invite, setInvite] = useState<Invite>(application.interviewInvite ?? 'AUTO')
  const [staffNote, setStaffNote] = useState(application.staffNote ?? '')

  useEffect(() => {
    setInvite(application.interviewInvite ?? 'AUTO')
    const saved = application.staffNote ?? ''
    const fromScore = evaluationQuery.data?.myEvaluation?.note?.trim() ?? ''
    setStaffNote(saved || fromScore)
  }, [application.id, application.interviewInvite, application.staffNote, evaluationQuery.data?.myEvaluation?.note])

  const saveMutation = useMutation({
    mutationFn: () =>
      api.updateApplicationInterview(application.id, {
        interviewInvite: invite,
        staffNote: staffNote.trim() ? staffNote : null,
      }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['application', application.id] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
    },
  })

  const [decisionMessage, setDecisionMessage] = useState<string | null>(null)
  const decisionMutation = useMutation({
    mutationFn: (decision: 'ACCEPTED' | 'REJECTED') =>
      api.applicationDecision(application.id, decision),
    onSuccess: (result) => {
      setDecisionMessage(
        result.status === 'ACCEPTED'
          ? `Kontenjandan kabul edildi. Bursiyer kaydı oluşturuldu (#${result.scholarId}).`
          : 'Aday reddedildi.',
      )
      void queryClient.invalidateQueries({ queryKey: ['application', application.id] })
      void queryClient.invalidateQueries({ queryKey: ['applications'] })
      void queryClient.invalidateQueries({ queryKey: ['scholars'] })
    },
  })

  return (
    <div className="interview-decision">
      <h3>Mülakat çağrısı</h3>
      <p className="panel-subtitle">
        İnceleme notunu buraya yazın. Çağırma derseniz bu aday mülakat listesine girmez; puan formu da açılmaz.
        Başkan kontenjanı mülakatsız burs içindir — çağrı listesine düşmez, amber etiketlenir.
        Otomatik eleme yalnızca gelir eşiğine göredir; GNO yenilemede değerlendirilir.
      </p>

      <fieldset className="interview-decision__invite" disabled={archived}>
        <legend>Mülakat</legend>
        <label>
          <input
            type="radio"
            name={`invite-${application.id}`}
            checked={invite === 'AUTO'}
            onChange={() => setInvite('AUTO')}
          />
          Gelir kuralına bırak
        </label>
        <label>
          <input
            type="radio"
            name={`invite-${application.id}`}
            checked={invite === 'INVITE'}
            onChange={() => setInvite('INVITE')}
          />
          Çağır
        </label>
        <label>
          <input
            type="radio"
            name={`invite-${application.id}`}
            checked={invite === 'SKIP'}
            onChange={() => setInvite('SKIP')}
          />
          Çağırma
        </label>
        <label>
          <input
            type="radio"
            name={`invite-${application.id}`}
            checked={invite === 'PRESIDENT_QUOTA'}
            onChange={() => setInvite('PRESIDENT_QUOTA')}
          />
          Başkan kontenjanı (mülakatsız burs)
        </label>
      </fieldset>

      <label className="evaluation-note-field">
        <span className="filter-select__label">İnceleme notu</span>
        <textarea
          rows={4}
          value={staffNote}
          disabled={archived}
          placeholder="Eksik belge, gelir, referans… mülakat puanı değil."
          onChange={(event) => setStaffNote(event.target.value)}
        />
      </label>

      {saveMutation.isError && (
        <p className="error">{getQueryErrorMessage(saveMutation.error, 'Not kaydedilemedi.')}</p>
      )}
      {saveMutation.isSuccess && <p className="success">Ön eleme kaydedildi.</p>}
      {decisionMutation.isError && (
        <p className="error">{getQueryErrorMessage(decisionMutation.error, 'Karar kaydedilemedi.')}</p>
      )}
      {decisionMessage && <p className="success">{decisionMessage}</p>}

      {!archived && (
        <div className="toolbar-actions" style={{ marginTop: 12 }}>
          <button
            type="button"
            className="btn-primary"
            disabled={saveMutation.isPending}
            onClick={() => saveMutation.mutate()}
          >
            {saveMutation.isPending ? 'Kaydediliyor…' : 'Notu kaydet'}
          </button>
          {application.interviewInvite === 'PRESIDENT_QUOTA' &&
            canEvaluateApplication(application.status) && (
              <button
                type="button"
                className="btn-secondary"
                disabled={decisionMutation.isPending}
                onClick={() => decisionMutation.mutate('ACCEPTED')}
              >
                {decisionMutation.isPending ? 'Kaydediliyor…' : 'Kontenjandan kabul et'}
              </button>
            )}
        </div>
      )}
    </div>
  )
}
