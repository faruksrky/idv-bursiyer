import { useQuery } from '@tanstack/react-query'
import { api } from '../api/client'

export function HomePage() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['health'],
    queryFn: api.health,
  })

  return (
    <div className="page-stack">
      <section className="panel">
        <h2>Sistem</h2>
        {isLoading && <p>Backend bağlantısı kontrol ediliyor…</p>}
        {error && (
          <p className="error">Backend bağlantısı kurulamadı. PostgreSQL ve backend servisini başlatın.</p>
        )}
        {data && (
          <ul className="info-list">
            <li>
              <strong>Durum:</strong> {data.status}
            </li>
            <li>
              <strong>Uygulama:</strong> {data.application}
            </li>
            <li>
              <strong>Mülakat eşiği:</strong> {data.interviewPassThreshold} / 105
            </li>
            <li>
              <strong>Komite üye sayısı:</strong> {data.committeeMemberCount}
            </li>
            <li>
              <strong>Mülakat gelir eşiği:</strong> {data.familyIncomeInterviewMax.toLocaleString('tr-TR')} TL
            </li>
          </ul>
        )}
      </section>
    </div>
  )
}
