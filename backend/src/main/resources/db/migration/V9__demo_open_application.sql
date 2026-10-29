-- Demo başvuru: 2026–2027 açık dönem (değerlendirme testi için)

INSERT INTO applications (
    season_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages,
    consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2026-2027'),
    'SUBMITTED',
    NOW(),
    'Elif Demir',
    '11111111111',
    'Kadıköy',
    '2004-03-15'::date,
    'elif.demir.demo@idv.org',
    'Caferağa Mah. Moda Cad. No:12 Kadıköy / İstanbul',
    '05551112233',
    'Sağ', 'Mehmet Demir', 'Emekli öğretmen',
    'Sağ', 'Ev hanımı',
    18500.00, 2, 1,
    'Boğaziçi Üniversitesi', 'Mühendislik Fakültesi', 'Bilgisayar Mühendisliği',
    '2', 3.42, 'İstanbul Anadolu Lisesi',
    'Ayşe Yılmaz', 'İstanbul Dostluk Vakfı', '02161234567',
    'Üniversite gönüllü kulübü', 'Yazılım, yüzme, kitap okuma', 'İngilizce, Almanca',
    TRUE, TRUE, TRUE, TRUE, 'demo-2627'
) ON CONFLICT (season_id, tc_no) DO NOTHING;
