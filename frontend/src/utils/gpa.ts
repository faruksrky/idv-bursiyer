/** 4'lük ≤4: 2 altı; 100'lük >4: 70 altı. */
export function isGpaBelowContinuation(gpa: number | null | undefined): boolean {
  if (gpa == null) return false
  const value = Number(gpa)
  if (!Number.isFinite(value)) return false
  if (value <= 4) return value < 2
  return value < 70
}
