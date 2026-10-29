import { useState } from 'react'

const LOGO_CANDIDATES = ['/logo/idv.png', '/logo/idv.svg', '/logo/logo-idv.png']

interface LogoProps {
  compact?: boolean
}

export function Logo({ compact = false }: LogoProps) {
  const [logoIndex, setLogoIndex] = useState(0)
  const [failed, setFailed] = useState(false)

  if (failed || logoIndex >= LOGO_CANDIDATES.length) {
    return (
      <div className={`logo-mark${compact ? ' logo-mark--compact' : ''}`} aria-hidden>
        IDV
      </div>
    )
  }

  return (
    <img
      className={`logo-image${compact ? ' logo-image--compact' : ''}`}
      src={LOGO_CANDIDATES[logoIndex]}
      alt="İstanbul Dostluk Vakfı"
      onError={() => {
        if (logoIndex < LOGO_CANDIDATES.length - 1) {
          setLogoIndex((value) => value + 1)
          return
        }
        setFailed(true)
      }}
    />
  )
}

export function LogoBrand({ compact = false }: LogoProps) {
  if (compact) {
    return <Logo compact />
  }

  return (
    <div className="logo-brand">
      <Logo />
      <p className="logo-title logo-title--app">Bursiyer Takip</p>
    </div>
  )
}
