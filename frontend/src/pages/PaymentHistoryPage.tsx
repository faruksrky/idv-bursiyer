import { useQuery } from '@tanstack/react-query'
import { useEffect, useMemo, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { api, type ScholarPaymentHistoryRow } from '../api/client'
import { AccountingSubNav } from '../components/accounting/AccountingSubNav'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterSelect } from '../components/search/FilterSelect'
import { useColumnFilters } from '../hooks/useColumnFilters'
import {
  buildAcademicYearOptions,
  paymentStatusBadgeClass,
  paymentStatusLabel,
} from '../utils/accounting'
import { formatTry } from '../utils/applications'
import { getQueryErrorMessage } from '../utils/apiError'
import { currentAcademicYear, formatAcademicYearLabel } from '../utils/search'

const PAYMENT_COLUMNS = {
  period: (row: ScholarPaymentHistoryRow) => row.periodLabel,
  amount: (row: ScholarPaymentHistoryRow) => formatTry(row.amount),
  status: (row: ScholarPaymentHistoryRow) => paymentStatusLabel(row.paymentStatus),
  note: (row: ScholarPaymentHistoryRow) => row.note,
}

export function PaymentHistoryPage() {
  const [searchParams] = useSearchParams()
  const defaultYear = currentAcademicYear()
  const [scholarId, setScholarId] = useState('')
  const [academicYear, setAcademicYear] = useState(String(defaultYear))

  const scholarsQuery = useQuery({
    queryKey: ['scholars', 'OGRENCI'],
    queryFn: () => api.scholars({ status: 'OGRENCI' }),
  })

  useEffect(() => {
    const fromUrl = searchParams.get('scholarId')
    if (fromUrl) {
      setScholarId(fromUrl)
    }
  }, [searchParams])

  const scholarOptions = useMemo(
    () =>
      scholarsQuery.data?.map((scholar) => ({
        value: String(scholar.id),
        label: `${scholar.firstName} ${scholar.lastName}`,
      })) ?? [],
    [scholarsQuery.data],
  )

  const selectedScholar = scholarsQuery.data?.find((row) => row.id === Number(scholarId))

  const { data, isLoading, error } = useQuery({
    queryKey: ['scholar-payment-history', scholarId, academicYear],
    queryFn: () => api.scholarPaymentHistory(Number(scholarId), Number(academicYear)),
    enabled: scholarId !== '',
  })

  const summary = data?.reduce(
    (acc, row) => {
      if (row.paymentStatus === 'ODENDI') acc.paid += 1
      else if (row.paymentStatus === 'ODENECEK') acc.pending += 1
      else if (row.paymentStatus === 'ODENMEDI') acc.unpaid += 1
      return acc
    },
    { paid: 0, pending: 0, unpaid: 0 },
  )

  const visibleRows = useMemo(
    () => data?.filter((row) => row.paymentStatus !== 'YOK') ?? [],
    [data],
  )
  const columns = useColumnFilters(visibleRows, PAYMENT_COLUMNS)
  const filteredRows = columns.filtered

  return (
    <section className="panel">
      <AccountingSubNav />

      <h2>Ödeme Geçmişi</h2>
      <p className="panel-subtitle">
        Bursiyer bazında eğitim yılı boyunca hangi ayların ödendiğini / ödenmediğini görüntüleyin.
      </p>

      <div className="filter-toolbar">
        <FilterSelect
          label="Bursiyer"
          value={scholarId}
          onChange={setScholarId}
          options={[{ value: '', label: 'Bursiyer seçin…' }, ...scholarOptions]}
        />
        <FilterSelect
          label="Eğitim yılı"
          value={academicYear}
          onChange={setAcademicYear}
          options={buildAcademicYearOptions(defaultYear)}
        />
      </div>

      {!scholarId && (
        <p className="panel-subtitle">Ödeme geçmişini görmek için bir bursiyer seçin.</p>
      )}

      {selectedScholar && (
        <p className="panel-subtitle">
          <strong>
            {selectedScholar.firstName} {selectedScholar.lastName}
          </strong>{' '}
          — {formatAcademicYearLabel(Number(academicYear))}
        </p>
      )}

      {summary && visibleRows.length > 0 && (
        <div className="scholar-history__stats">
          <span className="scholar-history__stats--success">
            <strong>{summary.paid}</strong> ödendi
          </span>
          <span>
            <strong>{summary.pending}</strong> ödenecek
          </span>
          <span className="scholar-history__stats--danger">
            <strong>{summary.unpaid}</strong> ödenmedi
          </span>
        </div>
      )}

      {scholarId && isLoading && <p>Yükleniyor…</p>}
      {scholarId && error && (
        <p className="error">{getQueryErrorMessage(error, 'Ödeme geçmişi alınamadı.')}</p>
      )}

      {scholarId && data && (
        <div className="table-scroll">
          <table className="data-table data-table--nowrap">
            <thead>
              <tr>
                <ColumnFilterHeader {...filterHeaderProps(columns, 'period', 'Dönem')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'amount', 'Tutar')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'status', 'Ödeme')} />
                <ColumnFilterHeader {...filterHeaderProps(columns, 'note', 'Not')} />
              </tr>
            </thead>
            <tbody>
              {filteredRows.length === 0 && (
                <tr>
                  <td colSpan={4}>Bu eğitim yılı için program kaydı yok.</td>
                </tr>
              )}
              {filteredRows.map((row) => (
                <tr key={`${row.year}-${row.month}`}>
                  <td>{row.periodLabel}</td>
                  <td>{formatTry(row.amount)}</td>
                  <td>
                    <span className={paymentStatusBadgeClass(row.paymentStatus)}>
                      {paymentStatusLabel(row.paymentStatus)}
                    </span>
                  </td>
                  <td className="cell-clip" title={row.note ?? undefined}>
                    {row.note ?? '—'}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <p className="panel-subtitle">
        <Link to="/muhasebe">← IBAN listesine dön</Link>
      </p>
    </section>
  )
}
