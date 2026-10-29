import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthGuard } from './auth/AuthGuard'
import { AuthProvider } from './auth/AuthProvider'
import { GuestGuard } from './auth/GuestGuard'
import { Layout } from './components/Layout'
import { AccountingPage } from './pages/AccountingPage'
import { PaymentHistoryPage } from './pages/PaymentHistoryPage'
import { ApplicationFormPage } from './pages/ApplicationFormPage'
import { ApplicationsPage } from './pages/ApplicationsPage'
import { GraduatesPage } from './pages/GraduatesPage'
import { HomePage } from './pages/HomePage'
import { LoginPage } from './pages/LoginPage'
import { ProgramAttendancePage } from './pages/ProgramAttendancePage'
import { ScholarRenewalsPage } from './pages/ScholarRenewalsPage'
import { ScholarsPage } from './pages/ScholarsPage'

const queryClient = new QueryClient()

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            <Route
              path="/login"
              element={
                <GuestGuard>
                  <LoginPage />
                </GuestGuard>
              }
            />
            <Route
              path="/basvuru/:slug"
              element={<ApplicationFormPage />}
            />
            <Route
              element={
                <AuthGuard>
                  <Layout />
                </AuthGuard>
              }
            >
              <Route index element={<HomePage />} />
              <Route path="bursiyerler" element={<ScholarsPage />} />
              <Route path="yenileme" element={<ScholarRenewalsPage />} />
              <Route path="mezunlar" element={<GraduatesPage />} />
              <Route path="basvurular" element={<ApplicationsPage />} />
              <Route path="program-katilim" element={<ProgramAttendancePage />} />
              <Route path="muhasebe" element={<AccountingPage />} />
              <Route path="muhasebe/odeme-gecmisi" element={<PaymentHistoryPage />} />
            </Route>
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </QueryClientProvider>
  )
}
