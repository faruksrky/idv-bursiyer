export type PaymentHistoryStatus = 'ODENDI' | 'ODENECEK' | 'ODENMEDI' | 'YOK'

export function paymentStatusLabel(status: string): string {
  switch (status) {
    case 'ODENDI':
      return 'Ödendi'
    case 'ODENECEK':
      return 'Ödenecek'
    case 'ODENMEDI':
      return 'Ödenmedi'
    case 'YOK':
      return '—'
    default:
      return status
  }
}

export function parsePayableAmount(raw: string): number | null {
  const trimmed = raw.trim().replace(/\s/g, '')
  if (!trimmed) return null
  const normalized = trimmed.replace(',', '.')
  if (!/^\d+(\.\d{1,2})?$/.test(normalized)) return null
  const value = Number(normalized)
  if (!Number.isFinite(value) || value <= 0 || value > 9_999_999_999.99) return null
  return value
}

export function payableAmountDraft(amount: number | null | undefined): string {
  if (amount == null || Number.isNaN(Number(amount))) return ''
  const value = Number(amount)
  if (Number.isInteger(value)) return String(value)
  return value.toFixed(2).replace(/\.?0+$/, '')
}

export function paymentStatusBadgeClass(status: string): string {
  switch (status) {
    case 'ODENDI':
      return 'badge badge--success'
    case 'ODENECEK':
      return 'badge badge--muted'
    case 'ODENMEDI':
      return 'badge badge--danger'
    default:
      return 'badge badge--muted'
  }
}

export function buildAcademicYearOptions(currentYear: number) {
  return [currentYear, currentYear - 1, currentYear - 2].map((year) => ({
    value: String(year),
    label: `${year}–${year + 1}`,
  }))
}
