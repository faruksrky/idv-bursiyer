import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useMemo, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { api, type AccountingExportRow } from '../api/client'
import { AccountingSubNav } from '../components/accounting/AccountingSubNav'
import { ColumnFilterHeader, filterHeaderProps } from '../components/search/ColumnFilterHeader'
import { FilterChips } from '../components/search/FilterChips'
import { FilterSelect } from '../components/search/FilterSelect'
import { TableSearchBar } from '../components/search/TableSearchBar'
import { useColumnFilters } from '../hooks/useColumnFilters'
import { useDebouncedValue } from '../hooks/useDebouncedValue'
import { buildMonthOptions, buildYearOptions } from '../utils/attendance'
import {
  parsePayableAmount,
  payableAmountDraft,
  paymentStatusBadgeClass,
  paymentStatusLabel,
} from '../utils/accounting'
import { formatTry } from '../utils/applications'
import { getQueryErrorMessage } from '../utils/apiError'
import { matchesQuery, monthLabels } from '../utils/search'

type PaymentMark = 'ODENDI' | 'ODENMEDI'

const now = new Date()

const ACCOUNTING_COLUMNS = {
  name: (row: AccountingExportRow) => `${row.firstName} ${row.lastName}`,
  gender: (row: AccountingExportRow) =>
    row.gender === 'KIZ' ? 'Kız' : row.gender === 'ERKEK' ? 'Erkek' : '',
  iban: (row: AccountingExportRow) => row.iban || 'Eksik',
  period: (row: AccountingExportRow) => row.periodLabel,
  amount: (row: AccountingExportRow) => (row.amount != null ? formatTry(row.amount) : '—'),
  status: (row: AccountingExportRow) => paymentStatusLabel(row.paymentStatus),
}

export function AccountingPage() {
  const queryClient = useQueryClient()
  const currentYear = now.getFullYear()
  const [year, setYear] = useState(String(currentYear))
  const [month, setMonth] = useState(String(now.getMonth() + 1))
  const [search, setSearch] = useState('')
  const [genderFilter, setGenderFilter] = useState<'all' | 'KIZ' | 'ERKEK'>('all')
  const debouncedSearch = useDebouncedValue(search)

  const yearNumber = Number(year)
  const monthNumber = Number(month)
  const [excelError, setExcelError] = useState<string | null>(null)
  const [paymentError, setPaymentError] = useState<string | null>(null)
  const [amountError, setAmountError] = useState<string | null>(null)
  const [bulkAmount, setBulkAmount] = useState('')
  const [bulkTouched, setBulkTouched] = useState(false)
  const [selected, setSelected] = useState<Set<number>>(() => new Set())
  const selectAllRef = useRef<HTMLInputElement>(null)

  const { data, isLoading, error } = useQuery({
    queryKey: ['accounting-export', yearNumber, monthNumber],
    queryFn: () => api.accountingExport(yearNumber, monthNumber),
    enabled: Number.isFinite(yearNumber) && Number.isFinite(monthNumber),
  })

  const genderCounts = useMemo(() => {
    const rows = data ?? []
    return {
      girl: rows.filter((row) => row.gender === 'KIZ').length,
      boy: rows.filter((row) => row.gender === 'ERKEK').length,
    }
  }, [data])

  const columns = useColumnFilters(data, ACCOUNTING_COLUMNS)

  const filtered = useMemo(() => {
    return columns.filtered.filter((row) => {
      if (genderFilter === 'KIZ' && row.gender !== 'KIZ') return false
      if (genderFilter === 'ERKEK' && row.gender !== 'ERKEK') return false
      return matchesQuery(
        debouncedSearch,
        row.firstName,
        row.lastName,
        row.iban,
        row.university,
        row.periodLabel,
      )
    })
  }, [columns.filtered, debouncedSearch, genderFilter])

  const missingIbanCount = useMemo(
    () => (data ?? []).filter((row) => !row.iban).length,
    [data],
  )

  const sharedSuggestion = useMemo(() => {
    const rows = data ?? []
    if (rows.length === 0) return null
    const first = rows[0].suggestedAmount
    if (first == null || !rows.every((row) => row.suggestedAmount === first)) return null
    return first
  }, [data])

  const selectedIds = useMemo(
    () => (data ?? []).filter((row) => selected.has(row.scholarId)).map((row) => row.scholarId),
    [data, selected],
  )

  const visibleIds = useMemo(() => filtered.map((row) => row.scholarId), [filtered])
  const allVisibleSelected = visibleIds.length > 0 && visibleIds.every((id) => selected.has(id))
  const someVisibleSelected = visibleIds.some((id) => selected.has(id))

  useEffect(() => {
    setSelected(new Set())
    setPaymentError(null)
    setAmountError(null)
    setBulkAmount('')
    setBulkTouched(false)
  }, [yearNumber, monthNumber])

  useEffect(() => {
    if (!bulkTouched && sharedSuggestion != null) {
      setBulkAmount(payableAmountDraft(sharedSuggestion))
    }
  }, [bulkTouched, sharedSuggestion])

  useEffect(() => {
    if (selectAllRef.current) {
      selectAllRef.current.indeterminate = someVisibleSelected && !allVisibleSelected
    }
  }, [someVisibleSelected, allVisibleSelected])

  const paymentMutation = useMutation({
    mutationFn: (body: { scholarIds: number[]; paymentStatus: PaymentMark }) =>
      api.updateAccountingPaymentStatus({
        year: yearNumber,
        month: monthNumber,
        scholarIds: body.scholarIds,
        paymentStatus: body.paymentStatus,
      }),
    onSuccess: () => {
      setPaymentError(null)
      void queryClient.invalidateQueries({ queryKey: ['accounting-export'] })
      void queryClient.invalidateQueries({ queryKey: ['scholar-payment-history'] })
    },
    onError: (error: Error) => {
      setPaymentError(getQueryErrorMessage(error, 'Ödeme durumu kaydedilemedi.'))
    },
  })

  const amountMutation = useMutation({
    mutationFn: (body: { scholarIds: number[]; amount: number }) =>
      api.updateAccountingPaymentAmount({
        year: yearNumber,
        month: monthNumber,
        scholarIds: body.scholarIds,
        amount: body.amount,
      }),
    onSuccess: () => {
      setAmountError(null)
      void queryClient.invalidateQueries({ queryKey: ['accounting-export'] })
      void queryClient.invalidateQueries({ queryKey: ['scholar-payment-history'] })
    },
    onError: (error: Error) => {
      setAmountError(getQueryErrorMessage(error, 'Tutar kaydedilemedi.'))
    },
  })

  function toggleScholar(scholarId: number) {
    setSelected((current) => {
      const next = new Set(current)
      if (next.has(scholarId)) next.delete(scholarId)
      else next.add(scholarId)
      return next
    })
  }

  function toggleVisible() {
    setSelected((current) => {
      const next = new Set(current)
      if (allVisibleSelected) {
        visibleIds.forEach((id) => next.delete(id))
      } else {
        visibleIds.forEach((id) => next.add(id))
      }
      return next
    })
  }

  function markPayment(scholarIds: number[], paymentStatus: PaymentMark) {
    if (scholarIds.length === 0 || paymentMutation.isPending || amountMutation.isPending) return
    setPaymentError(null)
    paymentMutation.mutate({ scholarIds, paymentStatus })
  }

  function applyBulkAmount() {
    const amount = parsePayableAmount(bulkAmount)
    if (selectedIds.length === 0 || amount == null || amountMutation.isPending || paymentMutation.isPending) return
    setAmountError(null)
    amountMutation.mutate({ scholarIds: selectedIds, amount })
  }

  const parsedBulkAmount = parsePayableAmount(bulkAmount)
  const bulkAmountInvalid = bulkAmount.trim() !== '' && parsedBulkAmount == null
  const actionsPending = paymentMutation.isPending || amountMutation.isPending

  return (
    <section className="panel">
      <AccountingSubNav />

      <h2>Muhasebe IBAN Listesi</h2>
      <p className="panel-subtitle">
        Yalnızca Yenileme’de <strong>Devam</strong> kararı verilen bursiyerler listededir. Seçili yıl ve ay
        için ödenecek ücreti satırdan veya seçili bursiyerlere yazabilirsiniz; kayıtlı tutarı sonra
        değiştirebilirsiniz. Satırı veya seçimi <strong>Ödendi</strong> / <strong>Ödenmedi</strong> olarak
        işaretleyebilirsiniz. IBAN’ı boş olanlara muhasebe kaydı eklenebilir. Kişi bazlı geçmiş için{' '}
        <Link to="/muhasebe/odeme-gecmisi">Ödeme Geçmişi</Link> sekmesine geçin.
      </p>

      {data && (
        <div className="prescreen-stats" role="tablist" aria-label="IBAN özeti">
          <button
            type="button"
            className={`prescreen-stat${genderFilter === 'all' ? ' prescreen-stat--active' : ''}`}
            onClick={() => setGenderFilter('all')}
          >
            <span className="prescreen-stat__value">{data.length}</span>
            <span className="prescreen-stat__label">Aktif bursiyer</span>
          </button>
          <button
            type="button"
            className={`prescreen-stat prescreen-stat--invite${genderFilter === 'KIZ' ? ' prescreen-stat--active' : ''}`}
            onClick={() => setGenderFilter(genderFilter === 'KIZ' ? 'all' : 'KIZ')}
          >
            <span className="prescreen-stat__value">{genderCounts.girl}</span>
            <span className="prescreen-stat__label">Kız</span>
          </button>
          <button
            type="button"
            className={`prescreen-stat${genderFilter === 'ERKEK' ? ' prescreen-stat--active' : ''}`}
            onClick={() => setGenderFilter(genderFilter === 'ERKEK' ? 'all' : 'ERKEK')}
          >
            <span className="prescreen-stat__value">{genderCounts.boy}</span>
            <span className="prescreen-stat__label">Erkek</span>
          </button>
          <div className="prescreen-stat" style={{ cursor: 'default' }}>
            <span className="prescreen-stat__value">{missingIbanCount}</span>
            <span className="prescreen-stat__label">IBAN eksik</span>
          </div>
        </div>
      )}

      <div className="filter-toolbar">
        <FilterSelect
          label="Yıl"
          value={year}
          onChange={setYear}
          options={buildYearOptions(currentYear)}
        />
        <FilterSelect
          label="Ay"
          value={month}
          onChange={setMonth}
          options={buildMonthOptions(monthLabels)}
        />
        <button
          type="button"
          className="btn-primary"
          onClick={() => {
            setExcelError(null)
            void api.accountingExportExcel(yearNumber, monthNumber).catch(() => {
              setExcelError('Excel indirilemedi.')
            })
          }}
        >
          Excel İndir
        </button>
      </div>

      {excelError && <p className="error">{excelError}</p>}

      <div className="toolbar">
        <TableSearchBar
          value={search}
          onChange={setSearch}
          placeholder="Ad, soyad, IBAN ara…"
          resultCount={filtered.length}
        />
      </div>

      <FilterChips
        count={filtered.length}
        canReset={search.length > 0 || genderFilter !== 'all' || columns.active}
        onReset={() => {
          setSearch('')
          setGenderFilter('all')
          columns.reset()
        }}
      />

      {isLoading && <p>Yükleniyor…</p>}
      {error && (
        <p className="error">{getQueryErrorMessage(error, 'Muhasebe listesi alınamadı.')}</p>
      )}

      {data && (
        <div className="payment-actions">
          <span className="payment-actions__count">
            {selectedIds.length === 0
              ? 'Seçim yok'
              : `${selectedIds.length} bursiyer seçili`}
          </span>
          <label className="payment-actions__amount">
            <input
              className={`inline-field${bulkAmountInvalid ? ' inline-field--error' : ''}`}
              value={bulkAmount}
              onChange={(event) => {
                setBulkTouched(true)
                setBulkAmount(event.target.value)
                setAmountError(null)
              }}
              inputMode="decimal"
              placeholder="Tutar"
              autoComplete="off"
              aria-label="Seçilenlere yazılacak tutar"
              disabled={actionsPending}
            />
            <span>TL</span>
          </label>
          <button
            type="button"
            className="btn-secondary"
            disabled={selectedIds.length === 0 || parsedBulkAmount == null || actionsPending}
            onClick={applyBulkAmount}
          >
            Seçilenlere tutar yaz
          </button>
          <button
            type="button"
            className="btn-primary"
            disabled={selectedIds.length === 0 || actionsPending}
            onClick={() => markPayment(selectedIds, 'ODENDI')}
          >
            Ödendi işaretle
          </button>
          <button
            type="button"
            className="btn-secondary"
            disabled={selectedIds.length === 0 || actionsPending}
            onClick={() => markPayment(selectedIds, 'ODENMEDI')}
          >
            Ödenmedi yap
          </button>
          {actionsPending && <span className="payment-actions__pending">Kaydediliyor…</span>}
        </div>
      )}
      {bulkAmountInvalid && <p className="error">Tutar sıfırdan büyük bir TL tutarı olmalı.</p>}
      {amountError && <p className="error">{amountError}</p>}
      {paymentError && <p className="error">{paymentError}</p>}

      {data && (
        <div className="table-scroll">
        <table className="data-table data-table--nowrap">
          <thead>
            <tr>
              <th className="select-col">
                <input
                  ref={selectAllRef}
                  type="checkbox"
                  checked={allVisibleSelected}
                  disabled={filtered.length === 0 || actionsPending}
                  onChange={toggleVisible}
                  aria-label="Görünen bursiyerlerin tümünü seç"
                />
              </th>
              <th>#</th>
              <ColumnFilterHeader {...filterHeaderProps(columns, 'name', 'Ad Soyad')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'gender', 'Cinsiyet')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'iban', 'IBAN')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'period', 'Dönem')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'amount', 'Tutar')} />
              <ColumnFilterHeader {...filterHeaderProps(columns, 'status', 'Durum')} />
              <th></th>
            </tr>
          </thead>
          <tbody>
            {filtered.length === 0 && (
              <tr>
                <td colSpan={9}>Bu ay için arama kriterlerine uygun kayıt yok.</td>
              </tr>
            )}
            {filtered.map((row) => {
              const fullName = `${row.firstName} ${row.lastName}`
              const paid = row.paymentStatus === 'ODENDI'
              return (
                <tr key={row.scholarId} className={selected.has(row.scholarId) ? 'row-selected' : undefined}>
                  <td>
                    <input
                      type="checkbox"
                      checked={selected.has(row.scholarId)}
                      disabled={actionsPending}
                      onChange={() => toggleScholar(row.scholarId)}
                      aria-label={`${fullName} seç`}
                    />
                  </td>
                  <td>{row.rowNumber}</td>
                  <td className="cell-clip" title={fullName}>
                    {fullName}
                  </td>
                  <td>{row.gender === 'KIZ' ? 'Kız' : row.gender === 'ERKEK' ? 'Erkek' : ''}</td>
                  <td>
                    <IbanEditor
                      scholarId={row.scholarId}
                      iban={row.iban}
                      onSaved={() => {
                        void queryClient.invalidateQueries({ queryKey: ['accounting-export'] })
                        void queryClient.invalidateQueries({ queryKey: ['scholars'] })
                      }}
                    />
                  </td>
                  <td>{row.periodLabel}</td>
                  <td>
                    <AmountEditor
                      scholarId={row.scholarId}
                      year={yearNumber}
                      month={monthNumber}
                      amount={row.amount}
                      suggestedAmount={row.suggestedAmount}
                      disabled={actionsPending}
                      onSaved={() => {
                        void queryClient.invalidateQueries({ queryKey: ['accounting-export'] })
                        void queryClient.invalidateQueries({ queryKey: ['scholar-payment-history'] })
                      }}
                    />
                  </td>
                  <td>
                    <span className={paymentStatusBadgeClass(row.paymentStatus)}>
                      {paymentStatusLabel(row.paymentStatus)}
                    </span>
                  </td>
                  <td>
                    <div className="row-actions">
                      <button
                        type="button"
                        className="btn-secondary btn-secondary--compact"
                        disabled={actionsPending}
                        onClick={() => markPayment([row.scholarId], paid ? 'ODENMEDI' : 'ODENDI')}
                      >
                        {paid ? 'Ödenmedi yap' : 'Ödendi işaretle'}
                      </button>
                      <Link
                        className="btn-secondary btn-secondary--compact"
                        to={`/muhasebe/odeme-gecmisi?scholarId=${row.scholarId}`}
                      >
                        Geçmiş
                      </Link>
                    </div>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
        </div>
      )}
    </section>
  )
}

function AmountEditor({
  scholarId,
  year,
  month,
  amount,
  suggestedAmount,
  disabled,
  onSaved,
}: {
  scholarId: number
  year: number
  month: number
  amount: number | null
  suggestedAmount: number | null
  disabled: boolean
  onSaved: () => void
}) {
  const [value, setValue] = useState(payableAmountDraft(amount))
  const [message, setMessage] = useState<string | null>(null)

  useEffect(() => {
    setValue(payableAmountDraft(amount))
    setMessage(null)
  }, [amount])

  const mutation = useMutation({
    mutationFn: (next: number) =>
      api.updateAccountingPaymentAmount({
        year,
        month,
        scholarIds: [scholarId],
        amount: next,
      }),
    onSuccess: () => {
      setMessage(null)
      onSaved()
    },
    onError: (error: Error) => {
      setMessage(getQueryErrorMessage(error, 'Tutar kaydedilemedi.'))
    },
  })

  const parsed = parsePayableAmount(value)
  const stored = amount == null ? null : Number(amount)
  const dirty = parsed != null && (stored == null || Math.abs(parsed - stored) >= 0.001)
  const invalid = value.trim() !== '' && parsed == null
  const canSave = dirty && !invalid

  return (
    <div className="amount-cell">
      <input
        className={`inline-field amount-cell__input${message || invalid ? ' inline-field--error' : ''}`}
        value={value}
        onChange={(event) => {
          setValue(event.target.value)
          setMessage(null)
        }}
        onKeyDown={(event) => {
          if (event.key === 'Enter' && canSave && !mutation.isPending && !disabled) {
            event.preventDefault()
            mutation.mutate(parsed as number)
          }
        }}
        inputMode="decimal"
        placeholder={suggestedAmount != null ? payableAmountDraft(suggestedAmount) : 'Tutar'}
        autoComplete="off"
        aria-label="Ödenecek ücret"
        title={amount != null ? formatTry(amount) : 'Ödenecek ücret girilmedi'}
        disabled={disabled || mutation.isPending}
      />
      <span className="amount-cell__suffix">TL</span>
      <button
        type="button"
        className="btn-secondary btn-secondary--compact"
        disabled={!canSave || mutation.isPending || disabled}
        onClick={() => {
          if (parsed == null) return
          mutation.mutate(parsed)
        }}
      >
        {amount == null ? 'Ekle' : 'Güncelle'}
      </button>
      {message && <span className="amount-cell__error">{message}</span>}
    </div>
  )
}

function IbanEditor({
  scholarId,
  iban,
  onSaved,
}: {
  scholarId: number
  iban: string | null
  onSaved: () => void
}) {
  const [value, setValue] = useState(iban ?? '')
  const [message, setMessage] = useState<string | null>(null)

  useEffect(() => {
    setValue(iban ?? '')
  }, [iban])

  const mutation = useMutation({
    mutationFn: (next: string) => api.updateScholarIban(scholarId, next),
    onSuccess: () => {
      setMessage(null)
      onSaved()
    },
    onError: (error: Error) => {
      setMessage(getQueryErrorMessage(error, 'IBAN kaydedilemedi.'))
    },
  })

  const compactCurrent = (iban ?? '').replace(/[\s-]/g, '').toUpperCase()
  const compactDraft = value.replace(/[\s-]/g, '').toUpperCase()
  const dirty = compactDraft !== compactCurrent
  const canSave = compactDraft.length > 0 && dirty

  return (
    <div className="iban-cell">
      <input
        className={`inline-field iban-cell__input${message ? ' inline-field--error' : ''}`}
        value={value}
        onChange={(event) => {
          setValue(event.target.value)
          setMessage(null)
        }}
        placeholder="TR…"
        autoComplete="off"
        spellCheck={false}
        aria-label="IBAN"
      />
      <button
        type="button"
        className="btn-secondary btn-secondary--compact"
        disabled={!canSave || mutation.isPending}
        onClick={() => mutation.mutate(value)}
      >
        {iban ? 'Güncelle' : 'Ekle'}
      </button>
      {message && <span className="iban-cell__error">{message}</span>}
    </div>
  )
}
