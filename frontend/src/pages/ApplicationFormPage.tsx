import { useMutation, useQuery } from '@tanstack/react-query'
import { type FormEvent, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { api, type ApplicationSubmitPayload } from '../api/client'

const emptyForm: ApplicationSubmitPayload = {
  fullName: '',
  tcNo: '',
  birthPlace: '',
  birthDate: '',
  email: '',
  address: '',
  phone: '',
  fatherStatus: 'Sağ',
  fatherName: '',
  fatherJob: '',
  motherStatus: 'Sağ',
  motherJob: '',
  familyMonthlyIncome: 0,
  siblingCount: 0,
  studyingSiblingCount: 0,
  university: '',
  faculty: '',
  department: '',
  classYear: '',
  gpa: 0,
  highSchool: '',
  referenceName: '',
  referenceOrganization: '',
  referencePhone: '',
  associations: '',
  interests: '',
  languages: '',
  consentAccuracy: false,
  consentTerms: false,
  consentRejection: false,
  consentKvkk: false,
}

export function ApplicationFormPage() {
  const { slug = '2627' } = useParams()
  const [form, setForm] = useState<ApplicationSubmitPayload>(emptyForm)
  const [files, setFiles] = useState<Record<string, File | undefined>>({})
  const [success, setSuccess] = useState(false)

  const seasonQuery = useQuery({
    queryKey: ['public-application-season', slug],
    queryFn: () => api.publicApplicationSeason(slug!),
    enabled: Boolean(slug),
  })

  const mutation = useMutation({
    mutationFn: () =>
      api.submitApplication(slug!, form, {
        photo: files.photo!,
        idCopy: files.idCopy!,
        fatherSalary: files.fatherSalary!,
        motherSalary: files.motherSalary!,
        siblingStudent: files.siblingStudent,
        studentCert: files.studentCert!,
        transcript: files.transcript!,
      }),
    onSuccess: () => setSuccess(true),
  })

  function updateField<K extends keyof ApplicationSubmitPayload>(key: K, value: ApplicationSubmitPayload[K]) {
    setForm((current) => ({ ...current, [key]: value }))
  }

  function handleSubmit(event: FormEvent) {
    event.preventDefault()
    mutation.mutate()
  }

  if (success) {
    return (
      <section className="panel application-public">
        <h2>Başvurunuz alındı</h2>
        <p>Bilgi ve belgeleriniz kaydedildi. Ön eleme sonrası sizinle iletişime geçilecektir.</p>
        <Link to="/login" className="btn-secondary">
          Yönetim paneline dön
        </Link>
      </section>
    )
  }

  return (
    <div className="application-public">
      <section className="panel">
        <h2>{seasonQuery.data?.title ?? 'Burs Başvuru Formu'}</h2>
        <p className="panel-subtitle">
          İstanbul Dostluk Vakfı burs başvuru formu. Tüm alanları eksiksiz doldurun ve belgeleri yükleyin.
        </p>

        {seasonQuery.isLoading && <p>Form yükleniyor…</p>}
        {seasonQuery.error && <p className="error">Başvuru dönemi şu an açık değil.</p>}

        {seasonQuery.data && (
          <form className="application-form" onSubmit={handleSubmit}>
            <fieldset>
              <legend>Kişisel bilgiler</legend>
              <div className="application-form__grid">
                <label>
                  Adı-soyadı
                  <input required value={form.fullName} onChange={(e) => updateField('fullName', e.target.value)} />
                </label>
                <label>
                  T.C. kimlik no
                  <input required pattern="\d{11}" value={form.tcNo} onChange={(e) => updateField('tcNo', e.target.value)} />
                </label>
                <label>
                  Doğum yeri
                  <input required value={form.birthPlace} onChange={(e) => updateField('birthPlace', e.target.value)} />
                </label>
                <label>
                  Doğum tarihi
                  <input required type="date" value={form.birthDate} onChange={(e) => updateField('birthDate', e.target.value)} />
                </label>
                <label>
                  E-posta
                  <input required type="email" value={form.email} onChange={(e) => updateField('email', e.target.value)} />
                </label>
                <label>
                  Cep telefon
                  <input required value={form.phone} onChange={(e) => updateField('phone', e.target.value)} />
                </label>
                <label className="application-form__full">
                  İkamet adresi
                  <textarea required rows={3} value={form.address} onChange={(e) => updateField('address', e.target.value)} />
                </label>
              </div>
            </fieldset>

            <fieldset>
              <legend>Aile bilgileri</legend>
              <div className="application-form__grid">
                <label>
                  Baba sağ/vefat
                  <select value={form.fatherStatus} onChange={(e) => updateField('fatherStatus', e.target.value)}>
                    <option value="Sağ">Sağ</option>
                    <option value="Vefat">Vefat</option>
                  </select>
                </label>
                <label>
                  Baba adı soyadı
                  <input value={form.fatherName ?? ''} onChange={(e) => updateField('fatherName', e.target.value)} />
                </label>
                <label>
                  Baba meslek
                  <input required value={form.fatherJob} onChange={(e) => updateField('fatherJob', e.target.value)} />
                </label>
                <label>
                  Anne sağ/vefat
                  <select value={form.motherStatus} onChange={(e) => updateField('motherStatus', e.target.value)}>
                    <option value="Sağ">Sağ</option>
                    <option value="Vefat">Vefat</option>
                  </select>
                </label>
                <label>
                  Anne meslek
                  <input required value={form.motherJob} onChange={(e) => updateField('motherJob', e.target.value)} />
                </label>
                <label>
                  Aile aylık net gelir (TL)
                  <input required type="number" min={0} value={form.familyMonthlyIncome} onChange={(e) => updateField('familyMonthlyIncome', Number(e.target.value))} />
                </label>
                <label>
                  Kardeş sayısı
                  <input required type="number" min={0} value={form.siblingCount} onChange={(e) => updateField('siblingCount', Number(e.target.value))} />
                </label>
                <label>
                  Okuyan kardeş sayısı
                  <input required type="number" min={0} value={form.studyingSiblingCount} onChange={(e) => updateField('studyingSiblingCount', Number(e.target.value))} />
                </label>
              </div>
            </fieldset>

            <fieldset>
              <legend>Eğitim bilgileri</legend>
              <div className="application-form__grid">
                <label>
                  Üniversite
                  <input required value={form.university} onChange={(e) => updateField('university', e.target.value)} />
                </label>
                <label>
                  Fakülte
                  <input required value={form.faculty} onChange={(e) => updateField('faculty', e.target.value)} />
                </label>
                <label>
                  Bölüm
                  <input required value={form.department} onChange={(e) => updateField('department', e.target.value)} />
                </label>
                <label>
                  Sınıf
                  <input required value={form.classYear} onChange={(e) => updateField('classYear', e.target.value)} />
                </label>
                <label>
                  GNO
                  <input required type="number" min={0} max={4} step="0.01" value={form.gpa} onChange={(e) => updateField('gpa', Number(e.target.value))} />
                </label>
                <label>
                  Mezun olunan lise
                  <input required value={form.highSchool} onChange={(e) => updateField('highSchool', e.target.value)} />
                </label>
              </div>
            </fieldset>

            <fieldset>
              <legend>Referans</legend>
              <div className="application-form__grid">
                <label>
                  Referans adı soyadı
                  <input required value={form.referenceName} onChange={(e) => updateField('referenceName', e.target.value)} />
                </label>
                <label>
                  Çalıştığı kurum
                  <input required value={form.referenceOrganization} onChange={(e) => updateField('referenceOrganization', e.target.value)} />
                </label>
                <label>
                  Referans cep tel
                  <input required value={form.referencePhone} onChange={(e) => updateField('referencePhone', e.target.value)} />
                </label>
                <label className="application-form__full">
                  Üye olunan dernek/vakıf
                  <input value={form.associations ?? ''} onChange={(e) => updateField('associations', e.target.value)} />
                </label>
                <label className="application-form__full">
                  İlgi alanları
                  <textarea required rows={3} value={form.interests} onChange={(e) => updateField('interests', e.target.value)} />
                </label>
                <label className="application-form__full">
                  Yabancı diller
                  <input required value={form.languages} onChange={(e) => updateField('languages', e.target.value)} />
                </label>
              </div>
            </fieldset>

            <fieldset>
              <legend>Belgeler (PDF veya JPG/PNG, en fazla 10 MB)</legend>
              <div className="application-form__grid">
                {(
                  [
                    { key: 'photo', label: 'Fotoğraf', required: true },
                    { key: 'idCopy', label: 'Kimlik fotokopisi', required: true },
                    { key: 'fatherSalary', label: 'Baba maaş belgesi', required: true },
                    { key: 'motherSalary', label: 'Anne maaş belgesi', required: true },
                    { key: 'studentCert', label: 'Öğrenci belgesi', required: true },
                    { key: 'transcript', label: 'Transkript', required: true },
                    {
                      key: 'siblingStudent',
                      label: 'Okuyan kardeş öğrenci belgesi',
                      required: form.studyingSiblingCount > 0,
                    },
                  ] as const
                )
                  .filter((item) => item.required)
                  .map((item) => (
                    <label key={item.key}>
                      {item.label}
                      <input
                        required
                        type="file"
                        accept=".pdf,.jpg,.jpeg,.png"
                        onChange={(e) =>
                          setFiles((current) => ({ ...current, [item.key]: e.target.files?.[0] }))
                        }
                      />
                    </label>
                  ))}
              </div>
            </fieldset>

            <fieldset>
              <legend>Onaylar</legend>
              <label className="application-form__check">
                <input type="checkbox" checked={form.consentAccuracy} onChange={(e) => updateField('consentAccuracy', e.target.checked)} />
                Başvuru bilgi ve belgelerimin doğru olduğunu kabul ederim.
              </label>
              <label className="application-form__check">
                <input type="checkbox" checked={form.consentTerms} onChange={(e) => updateField('consentTerms', e.target.checked)} />
                Başvuru koşullarını okudum ve onaylıyorum.
              </label>
              <label className="application-form__check">
                <input type="checkbox" checked={form.consentRejection} onChange={(e) => updateField('consentRejection', e.target.checked)} />
                Eksik/yanlış bilgi durumunda başvurumun iptal edilebileceğini kabul ediyorum.
              </label>
              <label className="application-form__check">
                <input type="checkbox" checked={form.consentKvkk} onChange={(e) => updateField('consentKvkk', e.target.checked)} />
                KVKK kapsamında verilerimin işlenmesine muvafakat ediyorum.
              </label>
            </fieldset>

            {mutation.error && <p className="error">{mutation.error.message}</p>}

            <button type="submit" className="btn-primary btn-primary--large" disabled={mutation.isPending}>
              {mutation.isPending ? 'Gönderiliyor…' : 'Başvuruyu gönder'}
            </button>
          </form>
        )}
      </section>
    </div>
  )
}
