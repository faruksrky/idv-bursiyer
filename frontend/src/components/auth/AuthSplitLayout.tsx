import type { ReactNode } from 'react'

interface AuthSplitLayoutProps {
  title: string
  subtitle: string
  children: ReactNode
}

export function AuthSplitLayout({ title, subtitle, children }: AuthSplitLayoutProps) {
  return (
    <div className="auth-layout">
      <main className="auth-main">
        <section className="auth-section">
          <div className="auth-section__content">
            <h2>{title}</h2>
            <p>{subtitle}</p>
          </div>
        </section>

        <section className="auth-content">{children}</section>
      </main>
    </div>
  )
}
