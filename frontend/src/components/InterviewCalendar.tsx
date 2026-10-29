import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useMemo, useState } from 'react'
import {
  api,
  type InterviewAttendance,
  type InterviewCalendar,
  type InterviewCalendarDay,
  type InterviewCalendarSlot,
} from '../api/client'
import { Snackbar } from './ui/Snackbar'
import { getQueryErrorMessage } from '../utils/apiError'

function istanbulToday(): string {
  return new Date().toLocaleDateString('en-CA', { timeZone: 'Europe/Istanbul' })
}

function formatSlotTime(iso: string | null): string {
  if (!iso) {
    return 'Saat yok'
  }
  return new Date(iso).toLocaleTimeString('tr-TR', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
    timeZone: 'Europe/Istanbul',
  })
}

function dayCounts(slots: InterviewCalendarSlot[]) {
  return {
    total: slots.length,
    geldi: slots.filter((slot) => slot.attendance === 'GELDI').length,
    gelmedi: slots.filter((slot) => slot.attendance === 'GELMEDI').length,
  }
}

function patchCalendar(
  calendar: InterviewCalendar,
  applicationId: number,
  attendance: InterviewAttendance,
): InterviewCalendar {
  const patch = (slots: InterviewCalendarSlot[]) =>
    slots.map((slot) => (slot.applicationId === applicationId ? { ...slot, attendance } : slot))
  return {
    ...calendar,
    days: calendar.days.map((day) => ({ ...day, slots: patch(day.slots) })),
    unscheduled: patch(calendar.unscheduled),
  }
}

function AttendanceToggle({
  slot,
  pending,
  onChange,
}: {
  slot: InterviewCalendarSlot
  pending: boolean
  onChange: (attendance: InterviewAttendance) => void
}) {
  return (
    <div className="interview-cal-toggle" role="group" aria-label={`${slot.fullName} yoklama`}>
      <button
        type="button"
        className={`interview-cal-toggle__btn interview-cal-toggle__btn--geldi${
          slot.attendance === 'GELDI' ? ' is-active' : ''
        }`}
        disabled={pending}
        onClick={() => onChange(slot.attendance === 'GELDI' ? null : 'GELDI')}
      >
        Geldi
      </button>
      <button
        type="button"
        className={`interview-cal-toggle__btn interview-cal-toggle__btn--gelmedi${
          slot.attendance === 'GELMEDI' ? ' is-active' : ''
        }`}
        disabled={pending}
        onClick={() => onChange(slot.attendance === 'GELMEDI' ? null : 'GELMEDI')}
      >
        Gelmedi
      </button>
    </div>
  )
}

function SlotRow({
  slot,
  pending,
  onChange,
}: {
  slot: InterviewCalendarSlot
  pending: boolean
  onChange: (attendance: InterviewAttendance) => void
}) {
  return (
    <li className={`interview-cal-slot${slot.attendance ? ` interview-cal-slot--${slot.attendance.toLowerCase()}` : ''}`}>
      <span className="interview-cal-slot__time">{formatSlotTime(slot.scheduledAt)}</span>
      <span className="interview-cal-slot__name">{slot.fullName}</span>
      <AttendanceToggle slot={slot} pending={pending} onChange={onChange} />
    </li>
  )
}

function DayColumn({
  day,
  pendingId,
  onChange,
}: {
  day: InterviewCalendarDay
  pendingId: number | null
  onChange: (applicationId: number, attendance: InterviewAttendance) => void
}) {
  const counts = dayCounts(day.slots)
  return (
    <section className="interview-cal-day" aria-labelledby={`cal-day-${day.date}`}>
      <header className="interview-cal-day__header">
        <h3 id={`cal-day-${day.date}`}>{day.label}</h3>
        <p>
          {counts.total} kişi
          {counts.geldi ? ` · ${counts.geldi} geldi` : ''}
          {counts.gelmedi ? ` · ${counts.gelmedi} gelmedi` : ''}
        </p>
      </header>
      {day.slots.length === 0 ? (
        <p className="interview-cal-empty">Bu güne randevu yok.</p>
      ) : (
        <ul className="interview-cal-list">
          {day.slots.map((slot) => (
            <SlotRow
              key={slot.applicationId}
              slot={slot}
              pending={pendingId === slot.applicationId}
              onChange={(attendance) => onChange(slot.applicationId, attendance)}
            />
          ))}
        </ul>
      )}
    </section>
  )
}

export function InterviewCalendarPanel() {
  const queryClient = useQueryClient()
  const today = istanbulToday()
  const [mobileDay, setMobileDay] = useState(today)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  const { data, isLoading, error } = useQuery({
    queryKey: ['interview-calendar'],
    queryFn: api.interviewCalendar,
  })

  const mutation = useMutation({
    mutationFn: ({ applicationId, attendance }: { applicationId: number; attendance: InterviewAttendance }) =>
      api.updateInterviewAttendance(applicationId, attendance),
    onMutate: async ({ applicationId, attendance }) => {
      await queryClient.cancelQueries({ queryKey: ['interview-calendar'] })
      const previous = queryClient.getQueryData<InterviewCalendar>(['interview-calendar'])
      if (previous) {
        queryClient.setQueryData(['interview-calendar'], patchCalendar(previous, applicationId, attendance))
      }
      return { previous }
    },
    onError: (err, _vars, context) => {
      if (context?.previous) {
        queryClient.setQueryData(['interview-calendar'], context.previous)
      }
      setMessage({
        type: 'error',
        text: getQueryErrorMessage(err, 'Yoklama kaydedilemedi.'),
      })
    },
    onSuccess: () => setMessage(null),
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: ['interview-calendar'] })
    },
  })

  const selectedDay = useMemo(() => {
    if (!data?.days.length) {
      return mobileDay
    }
    if (data.days.some((day) => day.date === mobileDay)) {
      return mobileDay
    }
    const todayMatch = data.days.find((day) => day.date === today)
    return todayMatch?.date ?? data.days[0].date
  }, [data, mobileDay, today])

  if (isLoading) {
    return <p>Mülakat takvimi yükleniyor…</p>
  }
  if (error) {
    return <p className="error">{getQueryErrorMessage(error, 'Takvim yüklenemedi.')}</p>
  }
  if (!data) {
    return null
  }

  const visibleDays = data.days.filter((day) => day.date === selectedDay)

  return (
    <div className="interview-cal">
      <p className="panel-subtitle">
        Yer: {data.location}. Dilimler 10 dakika. Geldi / gelmedi işaretleyin; tekrar basınca boşalır.
      </p>

      <div className="interview-cal-tabs" role="tablist" aria-label="Mülakat günleri">
        {data.days.map((day) => {
          const counts = dayCounts(day.slots)
          return (
            <button
              key={day.date}
              type="button"
              role="tab"
              aria-selected={selectedDay === day.date}
              className={`interview-cal-tab${selectedDay === day.date ? ' is-active' : ''}`}
              onClick={() => setMobileDay(day.date)}
            >
              <strong>{day.weekday}</strong>
              <span>
                {day.date === '2026-10-05' ? '5 Ekim' : day.date === '2026-10-06' ? '6 Ekim' : '7 Ekim'}
                {' · '}
                {counts.total} kişi
              </span>
            </button>
          )
        })}
      </div>

      <div className="interview-cal-grid interview-cal-grid--desktop">
        {data.days.map((day) => (
          <DayColumn
            key={day.date}
            day={day}
            pendingId={mutation.isPending ? mutation.variables?.applicationId ?? null : null}
            onChange={(applicationId, attendance) => mutation.mutate({ applicationId, attendance })}
          />
        ))}
      </div>

      <div className="interview-cal-grid interview-cal-grid--mobile">
        {visibleDays.map((day) => (
          <DayColumn
            key={day.date}
            day={day}
            pendingId={mutation.isPending ? mutation.variables?.applicationId ?? null : null}
            onChange={(applicationId, attendance) => mutation.mutate({ applicationId, attendance })}
          />
        ))}
      </div>

      {data.unscheduled.length > 0 && (
        <section className="interview-cal-day interview-cal-day--unscheduled" aria-label="Saati olmayanlar">
          <header className="interview-cal-day__header">
            <h3>Saati yok</h3>
            <p>{data.unscheduled.length} kişi — randevu yazılmadan listede</p>
          </header>
          <ul className="interview-cal-list">
            {data.unscheduled.map((slot) => (
              <SlotRow
                key={slot.applicationId}
                slot={slot}
                pending={mutation.isPending && mutation.variables?.applicationId === slot.applicationId}
                onChange={(attendance) => mutation.mutate({ applicationId: slot.applicationId, attendance })}
              />
            ))}
          </ul>
        </section>
      )}

      {message && (
        <Snackbar message={message.text} severity={message.type} onClose={() => setMessage(null)} />
      )}
    </div>
  )
}
