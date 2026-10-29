import { useEffect, useRef } from 'react'

interface SnackbarProps {
  message: string
  severity?: 'success' | 'error'
  onClose: () => void
  autoHideDuration?: number
}

export function Snackbar({
  message,
  severity = 'success',
  onClose,
  autoHideDuration = severity === 'success' ? 6000 : 8000,
}: SnackbarProps) {
  const onCloseRef = useRef(onClose)
  onCloseRef.current = onClose

  useEffect(() => {
    const timer = window.setTimeout(() => onCloseRef.current(), autoHideDuration)
    return () => window.clearTimeout(timer)
  }, [message, autoHideDuration])

  return (
    <div className={`snackbar snackbar--${severity}`} role="status">
      <span className="snackbar__icon" aria-hidden>
        {severity === 'success' ? '✓' : '!'}
      </span>
      <span className="snackbar__message">{message}</span>
      <button type="button" className="snackbar__close" onClick={onClose} aria-label="Kapat">
        ×
      </button>
    </div>
  )
}
