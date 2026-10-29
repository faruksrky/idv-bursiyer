export function getQueryErrorMessage(error: unknown, fallback: string): string {
  if (!(error instanceof Error)) {
    return fallback
  }

  const message = error.message
  const lower = message.toLowerCase()
  if (
    lower.includes('failed to fetch') ||
    lower.includes('network') ||
    lower.includes('econnrefused') ||
    lower.includes('proxy error')
  ) {
    return `${fallback} Backend çalışmıyor olabilir — IntelliJ'de backend'i 8081 portunda başlatın.`
  }

  const json = extractSpringError(message)
  if (json?.status === 404 || lower.includes('no static resource') || lower.includes('not found')) {
    return `${fallback} 404: çalışan Java süreci eski. IntelliJ'deki uygulamayı tamamen durdurup Run edin (8081).`
  }
  if (json?.message) {
    return `${fallback} ${json.message}`
  }
  if (json?.error) {
    return `${fallback} ${json.error}`
  }

  const snippet = message.replace(/\s+/g, ' ').trim().slice(0, 180)
  if (snippet && !snippet.startsWith('<')) {
    return `${fallback} ${snippet}`
  }

  return fallback
}

function extractSpringError(raw: string): { status?: number; error?: string; message?: string } | null {
  const start = raw.indexOf('{')
  if (start < 0) {
    return null
  }
  try {
    const parsed = JSON.parse(raw.slice(start)) as { status?: number; error?: string; message?: string }
    return parsed
  } catch {
    return null
  }
}
