-- 2024-2025 başvuruları (Excel import) + kabul edilen 37 bursiyer

UPDATE scholars SET iban = 'TR500020500009714203400001', phone = '05322877876', email = 'ikrraunal@gmail.com', university = 'İstanbul medipol üniversitesi', faculty = 'Sağlık bilimleri fakültesi', department = 'Ebelik bölümü', class_year = '4.0', active = TRUE WHERE tc_no = '47887302896';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'İkra hazal', 'ünal', '47887302896', 'ikrraunal@gmail.com', '05322877876', 'TR500020500009714203400001', 'İstanbul medipol üniversitesi', 'Sağlık bilimleri fakültesi', 'Ebelik bölümü', '4.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '47887302896');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '47887302896' LIMIT 1),
    'ACCEPTED',
    '2024-09-04 15:48:01'::timestamptz,
    'İkra hazal ünal', '47887302896', 'Kadıköy', '2002-06-04'::date,
    'ikrraunal@gmail.com', 'Çamlık mah. Piri reis cad. Şehit kerim patoğlu sok. Ayışığı sitesi a blak d 11 kurtköy', '05322877876',
    'Vefat', 'Vefat', 'Vefat',
    'Sağ', 'İnsan kaynakları uzmanı',
    41000.0, 1, 1,
    'İstanbul medipol üniversitesi', 'Sağlık bilimleri fakültesi', 'Ebelik bölümü',
    '4.0', 2.87, 'https://drive.google.com/open?id=1pheO_XU5C7LjvODPFfxsfI91oabvn5XM',
    'Ümit Ünal', 'Çevre ve şehircilik bakanlığı', '05323276339',
    'Dostluk vakfı', 'Kamp yapmak, seyehat etmek', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'PHOTO', 'https://drive.google.com/open?id=1oEMPJtkJZk61uqBU7yI_7S8lsHrgIRZb', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'ID_COPY', 'https://drive.google.com/open?id=1wG3BSrryR42Dd_4wdTdxTWspmdD0sre2', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1-JdBI95TyNbLg6iI_eL8tcGvj1KTDfSB', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1la6QOZO4oqCO4WwgaBKeWuZ9tlBbGnEC', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1B1Vb4azsyhK_UeWH3E2roRrD5NFA8t3H', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1o5nFtQn1WG_q63wlZSt3hElxEZrO1fmA', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '47887302896'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Balwjmm8WbGmAs1iTh2nRK5FV3thyXcx', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-09 18:25:34'::timestamptz,
    'Ahmet Sefa Çetin', '63007427874', 'Osmaniye', '2002-03-01'::date,
    'ahmet80sefa@hotmail.com', 'Mehmet Akif mah. Cami sok. No:8/5 Çekmeköy/İstanbul', '05061627880',
    'Sağ', 'sağ', 'öğretmen',
    'Sağ', 'diyanet 4-6 yaş hocası',
    80000.0, 1, 1,
    'Yıldız Teknik Üniversitesi', 'Elektrik Elektronik Fakültesi', 'Bilgisayar Mühendisliği',
    '3.0', 3.33, 'https://drive.google.com/open?id=1rNedn7_S-ddtHaBVdAqZys2S-LU4jn-u',
    'Ekrem Erdemir', 'Erkam Yayın Sanayi ve Ticaret A.Ş.', '05445012920',
    '-', 'yazılım, algoritmalar, yapay zeka', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'PHOTO', 'https://drive.google.com/open?id=1kBXgJ7PrPsToG9rlV4WK8B84ugKVu8S9', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'ID_COPY', 'https://drive.google.com/open?id=1NQ9AWcLT1PJolxByt3W86MTeUJvcvXJv', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1lODXTGsmtreAGKwwyGy5UEFMzxvpqtDx', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1_Cmbs1Zbw1dcRztVLGeHKViDzN1Rm-52', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=13yDRgj2mC_sseVarQF9e_V5oUwHChjrN', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1kqA3GYCi0lveS1svKNYw5fU_5FMPvHQt', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '63007427874'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1RRCaP8Kbl7FHvVF0oXX6U7iXc1nf7wNB', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-10 08:35:23'::timestamptz,
    'Aleyna Köroğlu', '19901218056', 'İstanbul', '2003-07-25'::date,
    'koroglualeyna63@gmail.com', 'Fevzi çakmak mahallesi Aşiyan sokak no5 d2', '5.528074617E9',
    'Sağ', 'Sağ', 'Fırıncı',
    'Sağ', 'Ev hanımı',
    32500.0, 1, 1,
    'Sabahattin Zaim üniversitesi', 'İnsan ve toplum bilimleri fakültesi', 'Psikoloji',
    '1.0', 3.0, 'https://drive.google.com/open?id=11Ty9XLazPY6Qgtg6j8Mwgb-DUJmbr9kn',
    'Aleyna Köroğlu', 'Çalışmıyor', '5.528074617E9',
    'Yok', 'Resim müzik tiyatro edebiyat insan psikolojisi', 'İngilizce, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'PHOTO', 'https://drive.google.com/open?id=1vG7uiU0nvxTMjDsix6_1vuqrn9NexUj4', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'ID_COPY', 'https://drive.google.com/open?id=1DfltrSWATNWHJsj2WwK32USDHYT6-4Pi', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1E0PKdiV1UovSg66bcFu2QdnLUMTnjjmf', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1fx0GTbyjqVDgrTHnt7zFBEwSRh8YKohq', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1Ye68MJarizB4betjx-QzG-RvpBXf4fQy', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1SqWjvya7QF2vp1WUGQwECGeU1RV5GfZy', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '19901218056'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=11GI7mxrcGwPj8avZv9oOyRkHOB1CKFCq', 'transcript-link'
);

UPDATE scholars SET iban = 'TR070001500158007307751963', phone = '05060991818', email = 'akkuseren1208@gmail.com', university = 'sabahattin zaim ünüversitesi', faculty = 'mühendislik ve doğa bilimleri fakütesi', department = 'yazılım mühendisliği', class_year = '1.0', active = TRUE WHERE tc_no = '22234103906';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Eren', 'Akkuş', '22234103906', 'akkuseren1208@gmail.com', '05060991818', 'TR070001500158007307751963', 'sabahattin zaim ünüversitesi', 'mühendislik ve doğa bilimleri fakütesi', 'yazılım mühendisliği', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '22234103906');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '22234103906' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 20:13:56'::timestamptz,
    'Eren Akkuş', '22234103906', 'adıyaman', '2004-05-26'::date,
    'akkuseren1208@gmail.com', 'konya ereğli fatih mahallesi alparslan türkeş caddesi/119', '05060991818',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'diyanet görevlisi',
    70000.0, 4, 3,
    'sabahattin zaim ünüversitesi', 'mühendislik ve doğa bilimleri fakütesi', 'yazılım mühendisliği',
    '1.0', 3.0, 'https://drive.google.com/open?id=1MJk9Ifl_w3xB3mCaBDUaefNPXEDbMJgf',
    'mehmet yaroğlu', 'agd istanbul il başkanı', '05353140760',
    'agd', 'tenis futbol bilgisayar', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'PHOTO', 'https://drive.google.com/open?id=1qb0oGhnfr4iSkCgUcwyc4EkdOjwm16ij', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'ID_COPY', 'https://drive.google.com/open?id=1NHzFyjX7ui5mB1f6Lxoza5fbQWPR0bBh', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1brE7kzZ0XSJENrT7TL2MWYL_caHAcC3S', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=13toNZZW53-dq8rdZGfnMBZYMXa1F2O5U', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1DbLFrebQNc8cHIduzxrw1zn5sxPL2fOc', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=11fbSngr1J9sPeaIGrkHrsHozfuznoTv3', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22234103906'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=130fsbd6UgwpCn8a4tMXn4dK3Y1r4V4B4', 'transcript-link'
);

UPDATE scholars SET iban = 'TR380020500009735124600001', phone = '5.525601869E9', email = 'power34_69@outlook.com', university = 'Marmara Üniversitesi', faculty = 'İlahiyat Fakültesi', department = 'İlahiyat', class_year = '3.0', active = TRUE WHERE tc_no = '16550926622';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Arif Ömer', 'Duman', '16550926622', 'power34_69@outlook.com', '5.525601869E9', 'TR380020500009735124600001', 'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '16550926622');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '16550926622' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 21:16:54'::timestamptz,
    'Arif Ömer Duman', '16550926622', 'Bayburt/Merkez', '2003-02-04'::date,
    'power34_69@outlook.com', 'Esenler Mah. Rıfat Ilgaz Cad. No:19 Daire:4', '5.525601869E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev Hanımı',
    12500.0, 1, NULL,
    'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat',
    '3.0', 3.06, 'https://drive.google.com/open?id=1hg7kE_phcACUPOKktaEuN_JBQMMsZQ4b',
    'Salih Bulmaz', '.', '5.523527274E9',
    'AGD', 'Edebiyat, Müzik, Spor, Ekonomi', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'PHOTO', 'https://drive.google.com/open?id=1Q899bsJywZlmbT1-MtMxjGR52VgwH4dO', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'ID_COPY', 'https://drive.google.com/open?id=1ZPocIMFhymuRIJ50F4blNg8akxPZK5YF', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1kUk1VHOHckptyeA3CBm1ZliBZU4n57W6', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=116SUjZG_lBIvklilCmvCGjMhb5wiVrip', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1C212olFNCGnmOs9WhnhB8uBWFDEprsId', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Bj7FfXfWtIGKsK9Dp3-4trmCbxDno1Mx', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16550926622'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1yePCREhG4IGozBTPEZigpbJJar_uD3e6', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-10 21:40:28'::timestamptz,
    'Muhammed Sait Demirci', '24427761542', 'Erzurum', '2003-12-16'::date,
    'ssaitdemirci@gmail.com', 'Namık kemal mah 20.sok no:7daire:11 esenler/istanbul', '05050369553',
    'Sağ', NULL, 'Emekli',
    'Sağ', 'En hanımı',
    22000.0, 2, 1,
    'Yıldız teknik', 'Gemi inşaatı fakültesi', 'Gemi makine işletme müh',
    '2.0', 2.63, 'https://drive.google.com/open?id=1bKLj-LiQhK18vJmzYxDIBXl84uCpmC5G',
    'Hasan kocur', 'Öğrenci', '5.071745716E9',
    'Agd ,yeni dünya vakfı', 'Makinecilik , tiyatro , hitabet', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'PHOTO', 'https://drive.google.com/open?id=1BQ6qL3ITIxzh5ozMtFaygh-M5VrMY8Gk', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'ID_COPY', 'https://drive.google.com/open?id=1Zge-KbjY9V2AwjaNkXEwAIFWhwRIte34', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1lubmT-SQUBlOKcWgupp_2raEeUb1sESp', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1SYU9nuL811yc8uszo2sftAAX-uN2CmcQ', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1FQ7H6zOZFtqgpMU9CZdYjVlb71jTgp_F', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=14OnLf55LjAHtn_2Q8OxqbW_McPndots_', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24427761542'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=19SlM_115mROGyujuS4sj2-rJYMcFPB2C', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-10 21:43:31'::timestamptz,
    'Hakan kıranşal', '10075899560', 'Tatvan/ Bitlis', '2004-09-14'::date,
    'hknk140904@gmail.com', 'Pınarbaşı mahallesi lise caddesi Dicle sokak no54 kat5 Tatvan/Bitlis', '05535985441',
    'Sağ', NULL, 'Devlet memuru',
    'Sağ', 'Ev hanımı - el sanatları kurs hocası',
    46200.0, 4, 2,
    'Yıldız Teknik Üniversitesi', 'Gemi inşa ve denizlicik', 'Gemi inşa ve gemi makineleri mühendisliği',
    '2.0', 3.16, 'https://drive.google.com/open?id=1qJtNj_GYqUpqgVPIvL1frxMJYW-XzNa_',
    'Salih Yılmaz', 'Tekder', '5.523527274E9',
    'Üye olduğum bir dernek ya da vakıf yok', 'Denizcilik , yazılım , dinler tarihi , sosyoloji', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'PHOTO', 'https://drive.google.com/open?id=1EqrK9kLaF9d1xsTKuq4RDPSADYrQrLWh', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'ID_COPY', 'https://drive.google.com/open?id=1OiXFvLN0VFZkoitMMyawcUgfevvAWK1y', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1f2cGoaTPGISXyQYM5aIPPs-OgY21v2W7', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1pyiT43cATuuuDsfGvssTAc9nsPxe_sf7', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1J9Dbr4xEytsExJkLtRczsyCXQ_cAihRl', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1aSb7cimjzdqZlei4LsKBYHPWOX84hvxn', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10075899560'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=11IMyLgFKL6kwIR25aIQ1KEi_Mnfg7BTQ', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-10 22:05:18'::timestamptz,
    'Hasan Kocur', '18233036130', 'Gaziantep', '2003-06-21'::date,
    'kocur1027@gmail.com', 'Piyalepaşa Akçay Sokak No:19 BEYOĞLU/İSTANBUL', '5.071745716E9',
    'Sağ', NULL, 'Öğretmen',
    'Sağ', 'Memur',
    75000.0, 2, 1,
    'Yıldız Teknik Üniversitesi', 'Denizcilik Fakültesi', 'Gemi Makineleri İşletme Mühendisliği',
    '2.0', 2.6, 'https://drive.google.com/open?id=1EVBF4uaU9q9e5ZTkbeBlZ6uZaumIW6GN',
    'Salih Bulmaz', 'TEKDER', '05523527274',
    '-', 'Denizcilik Sektörü', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'PHOTO', 'https://drive.google.com/open?id=1FlNen5UDaOj0Xisaffdadrcw7rLPTEuv', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'ID_COPY', 'https://drive.google.com/open?id=1-7b_XBIYMt5wwv7rJ77Xs9Ah8RQ74lQd', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1nbqtnM5o7kttkvMLt7hZ2qmPfcFGM95s', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1VrJBpoz7GX-GqO5nkwlZZVqC5Sah2kBD', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1jsFf1wvR8ljLXwwu5RUHs-mGRugjNF0N', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1MHByhRbJSnHNMsGiwcD34MfdQ6skuCYp', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '18233036130'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ZPX3whSgFWwcTG4zahgrESE0sN4vIEIF', 'transcript-link'
);

UPDATE scholars SET iban = 'TR110004600056888000543640', phone = '05448457509', email = 'rotkun80@gmail.com', university = 'Marmara üniversitesi', faculty = 'Teknoloji fakültesi', department = 'Elektrik elektronik mühendisliği', class_year = '2.0', active = TRUE WHERE tc_no = '10099931956';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'RAMAZAN', 'ÖTKÜN', '10099931956', 'rotkun80@gmail.com', '05448457509', 'TR110004600056888000543640', 'Marmara üniversitesi', 'Teknoloji fakültesi', 'Elektrik elektronik mühendisliği', '2.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '10099931956');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '10099931956' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 22:42:51'::timestamptz,
    'RAMAZAN ÖTKÜN', '10099931956', 'Burdur', '2005-10-30'::date,
    'rotkun80@gmail.com', 'Yokuş mah. Mehmet Rıfat börekçi sok. No:25 Tefenni/Burdur', '05448457509',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Özel sektörde işçi',
    40000.0, 1, NULL,
    'Marmara üniversitesi', 'Teknoloji fakültesi', 'Elektrik elektronik mühendisliği',
    '2.0', 3.22, 'https://drive.google.com/open?id=173f4ORm-pVlkyXVBWhpbfPcicqRJGmVX',
    'Furkan Demirci', 'Marmara üniversitesinde öğrenci', '05337030455',
    'Anadolu Gençlik Derneği', 'Teknoloji gelişim ve inavasyon alanlarına ilgim var
Dini ve fıkhi konularda okuma yapmayı severim,
En sevdiğim hobim müzik dinleyerek yolda yürümek.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'PHOTO', 'https://drive.google.com/open?id=1Y0wnFQsGecWNHKYFdbfffjdIPM4vJu4Z', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'ID_COPY', 'https://drive.google.com/open?id=1S9RdSUpnIDCGbJJDY6909QL1w0T_ApLP', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1MxIeGtuCbWbbkaMxY1Pu1uX5ORGckOlM', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1OnpYAHUYq066L5Lz4cpWDI9i7q-zyphy', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1cp2lNqsVuCDtw9gGTWaAu7mzASUy4N3Q', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1ZPoWmle46NcOJCA-cJIxKhlRqws7A17V', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10099931956'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=14uidoXqZ0_FTEDJS-PTrLC8xBCrhXk23', 'transcript-link'
);

UPDATE scholars SET iban = 'TR420020500009760115600001', phone = '5.511722374E9', email = 'huseyinbilalsenturk@gmail.com', university = 'Marmara Üniversitesi', faculty = 'Mühendislik fakültesi', department = 'Makine Mühendisliği(İngilizce)', class_year = '1.0', active = TRUE WHERE tc_no = '49306870276';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Hüseyin Bilal', 'Şentürk', '49306870276', 'huseyinbilalsenturk@gmail.com', '5.511722374E9', 'TR420020500009760115600001', 'Marmara Üniversitesi', 'Mühendislik fakültesi', 'Makine Mühendisliği(İngilizce)', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '49306870276');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '49306870276' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 23:04:32'::timestamptz,
    'Hüseyin Bilal Şentürk', '49306870276', 'Kars', '2003-04-15'::date,
    'huseyinbilalsenturk@gmail.com', 'burhaniye mahallesi 283 bulvar caddesi manolya konutları b blok daire 5  Düzce/Merkez', '5.511722374E9',
    'Sağ', 'Sağ', 'İmam',
    'Sağ', 'ev hanımı',
    45541.0, 3, NULL,
    'Marmara Üniversitesi', 'Mühendislik fakültesi', 'Makine Mühendisliği(İngilizce)',
    '1.0', 3.03, 'https://drive.google.com/open?id=1uMXwO1X3kp-dp3nNbggvhKAM-CmKMWYI',
    'Salih Bulmaz', 'Tekder', '05523527274',
    'Anadolu Gençlik Derneği', 'Tasarım, Kitap, Güreş', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'PHOTO', 'https://drive.google.com/open?id=1koJGRTYUJuNa8_eRk-elpdDRiLlWvEZq', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'ID_COPY', 'https://drive.google.com/open?id=18G0IowFcqFdhKyIwIsr4nJ5Llaz3G8rZ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1RNuQMvDo44-YwwTI5-hBAdRIre9TvACu', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1YWVd07dLZguH_8fZNBcEpNBaAYGBLwHq', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1hHxBr9j6zQcPb0HFmPQzgOFFTxg6tKqx', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1hfwaGeFFMgbIzPHdwvOdX3xnEMn90vX-', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '49306870276'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1uzXOfYIx-K53SLE0F1YEHeCRts1LlgoS', 'transcript-link'
);

UPDATE scholars SET iban = 'TR450001009010379668305001', phone = '5.37693186E9', email = 'tnumanv2934@gmail.com', university = 'Marmara Üniversitesi', faculty = 'Teknoloji Fakültesi', department = 'Mekatronik Mühendisliği', class_year = '3.0', active = TRUE WHERE tc_no = '28753955408';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Taha Numan', 'Varan', '28753955408', 'tnumanv2934@gmail.com', '5.37693186E9', 'TR450001009010379668305001', 'Marmara Üniversitesi', 'Teknoloji Fakültesi', 'Mekatronik Mühendisliği', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '28753955408');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '28753955408' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 23:10:17'::timestamptz,
    'Taha Numan Varan', '28753955408', 'İserlohn Almanya', '2003-08-20'::date,
    'tnumanv2934@gmail.com', 'Armağanevler Mah. Havuz Sok. 24/3 Ümraniye/İstanbul', '5.37693186E9',
    'Sağ', 'Sağ', 'İşsiz',
    'Sağ', 'Ev hanımı',
    22500.0, 2, NULL,
    'Marmara Üniversitesi', 'Teknoloji Fakültesi', 'Mekatronik Mühendisliği',
    '3.0', 2.67, 'https://drive.google.com/open?id=145OYUwH7NKd9AOYbhou5HqtzB0spT9MW',
    'Salih Bulmaz', 'Tekder', '5.523527274E9',
    'Marmara Üniversitesi AGD', 'Teknoloji, Fitness, Kitap', 'İngilizce, Arapça, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'PHOTO', 'https://drive.google.com/open?id=13XAmxs7zbrFrU0H56u4BR2A8SfkjaVZi', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'ID_COPY', 'https://drive.google.com/open?id=1IaVNRqXVIHpYhrJaQfOnHuU6lUjdGDEA', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1eTy4UIYZ4X1MQxoqF5VRYKoCQMpFH516', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Hnxi7DZyLS0xaNjbujxi1OmpKMzdXfYI', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1J6G8TClXv32rILuPXDZ8DfF8lILkbYMa', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=17vtEr5LFp5zMsup-TGGDyRPgJEMBKsSj', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '28753955408'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1tvgKr2TZvudM84kh5wODEBXTHAdOUrcP', 'transcript-link'
);

UPDATE scholars SET iban = 'TR520020500009373833700002', phone = '05439712682', email = 'muhsinysrkrts@gmail.com', university = 'Marmara Üniversitesi', faculty = 'Teknoloji Fakültesi', department = 'Mekatronik Mühendisliği', class_year = '3.0', active = TRUE WHERE tc_no = '16163550030';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Muhsin Yasir', 'Karataş', '16163550030', 'muhsinysrkrts@gmail.com', '05439712682', 'TR520020500009373833700002', 'Marmara Üniversitesi', 'Teknoloji Fakültesi', 'Mekatronik Mühendisliği', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '16163550030');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '16163550030' LIMIT 1),
    'ACCEPTED',
    '2024-09-10 23:29:11'::timestamptz,
    'Muhsin Yasir Karataş', '16163550030', 'Konya Selçuklu', '2003-11-19'::date,
    'muhsinysrkrts@gmail.com', 'Osmangazi mahallesi çiftlikhisar sokak no 21/2 meram konya', '05439712682',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    30000.0, 4, 2,
    'Marmara Üniversitesi', 'Teknoloji Fakültesi', 'Mekatronik Mühendisliği',
    '3.0', 2.6, 'https://drive.google.com/open?id=1ZPZDB4qMnlzHAjvpFXkfgkQiHiLpBntQ',
    'Salih Bulmaz', 'Tekder', '+905523527274',
    'Agd İHH TEKDER', 'Mühendislik, Fotoğrafçılık Video çekimleri, spor, kitap okumak, gezmek', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'PHOTO', 'https://drive.google.com/open?id=1BF-111_qLsxq59fOITKBVHf1X2vDymsI', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'ID_COPY', 'https://drive.google.com/open?id=1TYoQsxpl8Y9BPsy2FL46a1gU2xHMuji5', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1hla6hmpGapYiUAIv99YR9Gdsq2zEFBhP', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1RVGX6FgXE_0ZYjAKK9u_sS33R8mtD2E_', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1mVM8Z5Awt6z-rNUVeSI_cNFBIxjct3Mw', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1i8ztZZgTBN8hq0yHJ_OFX4Ag3Tkp-Hk1', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16163550030'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1X7cMOCEgDfiXBJCYmM0_3Iq4iKpohw3L', 'transcript-link'
);

UPDATE scholars SET iban = 'TR270001009010552265505003', phone = '5.457381204E9', email = 'Kadirlacinkaya47@gmail.com', university = 'Marmara Üniversitesi', faculty = 'İlahiyat Fakültesi', department = 'İlahiyat', class_year = '1.0', active = TRUE WHERE tc_no = '12863982874';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Abdulkadir', 'Laçinkaya', '12863982874', 'Kadirlacinkaya47@gmail.com', '5.457381204E9', 'TR270001009010552265505003', 'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '12863982874');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '12863982874' LIMIT 1),
    'ACCEPTED',
    '2024-09-11 14:07:23'::timestamptz,
    'Abdulkadir Laçinkaya', '12863982874', 'Şanlıurfa Akçakale', '2004-06-13'::date,
    'Kadirlacinkaya47@gmail.com', 'Şanlıurfa Akçakale Fatih Sultan Mehmet Mahallesi Yağmur Sokak No 7', '5.457381204E9',
    'Sağ', 'Sağ', 'Şöfor yük taşıma',
    'Sağ', 'Ev hanımı',
    20000.0, 4, 4,
    'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat',
    '1.0', 3.0, 'https://drive.google.com/open?id=1G6eDq-3UCu4nlnXcBwqqbPpQEbFE7be_',
    'Halil Laçinkaya', 'Özel limited şirket', '5.42380552E9',
    'Anadolu Gençlik Derneği', 'Spor bilgi öğrenme ve ilim öğrenmek', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'PHOTO', 'https://drive.google.com/open?id=1Xs5NrIlb4ODvbRv19dWiQW6HnoTMZEoX', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'ID_COPY', 'https://drive.google.com/open?id=1p9PuqQ_OGe6Zxoh9aqcBI5QJUA9Mtp0Q', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1wCkph-iGayt3jWczhG9rHMGjnPY2q4ui', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1TO6luNBdnP9Dei93ZNajnkbLL9ipLuXb', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1uanj9Xue_qdlyBqVcz06UtsVkxs1ILtm', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=16zcrpX4OvfHUsHDtCsASGhtJ45BR3jr3', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12863982874'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1EYI_DRLO9wQuVd955-uwEZWtGqPUrQSm', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-11 22:28:11'::timestamptz,
    'Ömer Faruk IŞIK', '10190202702', 'Demirözü', '2005-08-09'::date,
    'faruk_isik_24@hotmail.com', 'Osmanlı Mahallesi 54. Sokak Karaca Evleri Sİtesi No:7 Blok:F Daire:2 Demirkent/Erzincan', '05523322405',
    'Sağ', 'Sağ', 'Öğretmen',
    'Sağ', 'Ev Hanımı',
    57809.0, 1, NULL,
    'İstanbul Sabahattin Zaim Üniversitesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Yazılım Mühendisliği',
    '2.0', 2.57, 'https://drive.google.com/open?id=1vJ7AvW0wkeZPWEEAoaksZRbdXXfxACYT',
    'Mehmet Yaroğlu', 'Anadolu Gençlik Derneği İstanbul İş Başkanı', '5.35314076E9',
    'Bulunmuyor', 'Yazılım, müzik, okuma, spor', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'PHOTO', 'https://drive.google.com/open?id=1oJa-fx3TlqIl6r7APjFhsWiaOpooYlvg', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'ID_COPY', 'https://drive.google.com/open?id=1Rr4wY4GcxCYvPboJEzht1Dx2vt541_HU', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1mJTPI-_SBld4-OcC-cVmYAyxCxYi_Vut', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1plC3rcC5bIeSOTavb7v9RkzKkLlOVcVm', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=13QROpDNcC1hTdvCOFNnmgqix80E3nkhb', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1wWJyC6M83eYjMBgx-JwRTlC2hNIkW6DT', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10190202702'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1yP2mYKfG5CpxCSSsXPHREWjF8xcBBGbZ', 'transcript-link'
);

UPDATE scholars SET iban = 'TR880021000000058640500001', phone = '5.541851045E9', email = 'zeynepguzelarslan@gmail.com', university = 'Yıldız Teknik Üniversitesi', faculty = 'Kimya-Metalürji Fakültesi', department = 'Biyomühendislik', class_year = '1.0', active = TRUE WHERE tc_no = '22652105902';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Zeynep', 'Güzelarslan', '22652105902', 'zeynepguzelarslan@gmail.com', '5.541851045E9', 'TR880021000000058640500001', 'Yıldız Teknik Üniversitesi', 'Kimya-Metalürji Fakültesi', 'Biyomühendislik', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '22652105902');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '22652105902' LIMIT 1),
    'ACCEPTED',
    '2024-09-18 12:59:31'::timestamptz,
    'Zeynep Güzelarslan', '22652105902', 'İstanbul / Bağcılar', '2005-05-04'::date,
    'zeynepguzelarslan@gmail.com', 'İstanbul / Başakşehir / kayabaşı Mahallesi / Rıfat Ilgaz Caddesi / 21. Bölge 1. Kısım / Blok: C-2 /Kat:2 /Daire:10', '5.541851045E9',
    'Sağ', NULL, 'Emekli',
    'Sağ', 'Ev hanımı',
    12500.0, 1, 1,
    'Yıldız Teknik Üniversitesi', 'Kimya-Metalürji Fakültesi', 'Biyomühendislik',
    '1.0', 4.0, 'https://drive.google.com/open?id=1YlPdKmJd8B0uOJJHphPguJYMWc_qXhWf',
    'Şeymanur Karagöz', 'Toki Turgut Özal İmam Hatip Ortaokulu', '5.066516158E9',
    'Yok', 'Kitap okumak, tiyatro, bulmaca çözmek, tarihi yerler görmek, sosyal aktivitelere katılmak', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'PHOTO', 'https://drive.google.com/open?id=1Kgt_FAbg9E6GeYXiGwvkjQMXuj-U33kG', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'ID_COPY', 'https://drive.google.com/open?id=1s07GE69bdUKA28FNjiRhLHctck96rCrf', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1e6nXIWHMG-Jxjj3vhQ4SEeEtJHIvKBKu', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1GomWUYFtpwjUvJDwlFQRo7lr8dItIpOW', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1EK_RJA2q1IMYAxFkwcDqmqyE-PnjclRx', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1lMUmoJH1kdDDkbwPqievlkTyMwQdHHzc', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22652105902'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1qRTWiynrSWGc_rXh5YnqtAXNnJ9LEkfZ', 'transcript-link'
);

UPDATE scholars SET iban = 'TR140020500009910031600001', phone = '05537477137', email = 'tugbayildiz1311@gmail.com', university = 'İstanbul Atlas Üniversitesi', faculty = 'Mühendislik ve Doğa Bilimleri Fakültesi', department = 'Bilgisayar Mühendisliği', class_year = '1.0', active = TRUE WHERE tc_no = '23468078794';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Tuğba Naz', 'Yıldız', '23468078794', 'tugbayildiz1311@gmail.com', '05537477137', 'TR140020500009910031600001', 'İstanbul Atlas Üniversitesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Bilgisayar Mühendisliği', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '23468078794');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '23468078794' LIMIT 1),
    'ACCEPTED',
    '2024-09-20 00:07:35'::timestamptz,
    'Tuğba Naz Yıldız', '23468078794', 'İstanbul Bağcılar', '2005-05-24'::date,
    'tugbayildiz1311@gmail.com', 'Kayaşehir Fenertepe 14.Bölge Başakşehir/İstanbul', '05537477137',
    'Sağ', NULL, 'Serbest Meslek',
    'Sağ', 'Ev Hanımı',
    17002.0, 1, 1,
    'İstanbul Atlas Üniversitesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Bilgisayar Mühendisliği',
    '1.0', 3.0, 'https://drive.google.com/open?id=1RxyvnLZT0IU-fvshABJxke4Jeet2SYla',
    'Şeymanur Karagöz', 'Toki Turgut Özal İmam Hatip Ortaokulu', '5.066516158E9',
    'T3', 'Kitap okumak, yüzme, badminton', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'PHOTO', 'https://drive.google.com/open?id=1i4ty7IQrzyTGb5MbAJUlnOd-2lhzdBOW', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'ID_COPY', 'https://drive.google.com/open?id=163ktiYPirfcYnrQxpA5ySx5ivbv5rCM0', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=17nYwDPgj2jFJ6GKYfs1nCWgOsmWdhtjk', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1PmpLXco5X_kOfJfZ5tJq-ZWTyIkLId_4', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=15N-eTBbJ2a8cOzP27s90yIH7LFi0bq2J', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1wkf8isjwZyt4Qjkm0iOy-77dgyQ-fbKQ', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23468078794'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1oGjG9giDnTvl4yRAc33pTYVW1T_PHM21', 'transcript-link'
);

UPDATE scholars SET iban = 'TR160001002197973931825001', phone = '5.466056195E9', email = 'goralozkan0@gmail.com', university = 'İstanbul Medeniyet Üniversitesi', faculty = 'Hukuk', department = 'Hukuk', class_year = '3.0', active = TRUE WHERE tc_no = '10743081082';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Özkan', 'Göral', '10743081082', 'goralozkan0@gmail.com', '5.466056195E9', 'TR160001002197973931825001', 'İstanbul Medeniyet Üniversitesi', 'Hukuk', 'Hukuk', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '10743081082');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '10743081082' LIMIT 1),
    'ACCEPTED',
    '2024-09-23 01:19:36'::timestamptz,
    'Özkan Göral', '10743081082', 'Van', '2002-01-01'::date,
    'goralozkan0@gmail.com', 'Konya Karatay erler mahallesi pilot sokak', '5.466056195E9',
    'Sağ', NULL, 'Alçı sıva ustası',
    'Sağ', 'Ev hanımı',
    17002.0, 3, 1,
    'İstanbul Medeniyet Üniversitesi', 'Hukuk', 'Hukuk',
    '3.0', 2.49, 'https://drive.google.com/open?id=1_eOkU0saTLNDludSK0rzjSH5DcbreVW1',
    'Mehemet Koç', 'AGD', '5.352947787E9',
    'Yok', 'Kitap okumak, Futbol', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'PHOTO', 'https://drive.google.com/open?id=1t3FHndewaUc8Xg2a4nCR7A1PTiBH2I8D', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'ID_COPY', 'https://drive.google.com/open?id=1yDzQhJYuqCfvkDSBgLfsnQVI9isRs-j8', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=14nLX4GJ4C1Ci12x6XNjUsq8OzD7sH8Qp', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1tO4F4pdh-QKUbNYw26OWZRyGlvyORpst', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1mgjAMT7FaEL_N2QGiIvKPy8andnJGA5x', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=199DmftmL3Hva0_blRdRwZ3QiFGdkD7U7', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10743081082'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1RixhSpHEpdXUhWvJinuttqxUyZRZqGpP', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-23 20:46:11'::timestamptz,
    'FIRAT AĞIR', '23398065062', 'ADIYAMAN', '2003-07-16'::date,
    'Firatagir01@hotmail.com', 'Ünalan mahallesi köse sokak no40 daire 1', '05050455322',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    20000.0, 1, NULL,
    'İstanbul medeniyet Üniversitesi', 'Eğitim bilimleri fakültesi', 'İlköğretim matematik öğretmenliği',
    '3.0', 2.77, 'https://drive.google.com/open?id=13GSneO0MB0X8mHtmgW9gPZ_IH0CfaRjC',
    'Mehmet koç', 'AGD', '05352947787',
    'AGD', 'Spor, sinema, kitap', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'PHOTO', 'https://drive.google.com/open?id=1Eg-5a96C8IaKXHhkVUoK_qRFLISHBSIa', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'ID_COPY', 'https://drive.google.com/open?id=1UbLiBKgkmBHJje8q71imszXLs0c-3X8l', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=10IBnYRVWQOa5gRJ64zaULdNddCROQY5F', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1sF9rXwZjDxbR4SvM4l4-t2vzkmapblDr', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1n8LmBJqly9kX-IrqRoVrDhpKZRuQD4B4', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=12bGR0paUgLoWoMcbPzH65dnqlgt9ow5j', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23398065062'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1hKQHL59Y7GppV1tShygt1ikX-ONRkkPL', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-24 09:06:09'::timestamptz,
    'MAHMUT SAMİ ÇAKIROĞLU', '15038380154', 'fatih İstanbul', '2004-01-20'::date,
    'cakiroglumahmutsami@gmail.com', 'İSTANBUL ESENLER FEVZİ ÇAKMAK MAHALLESİ 1116.SOKAK NO.3', '05315670965',
    'Sağ', 'sağ', 'meyve sebze',
    'Sağ', 'ev hanımı',
    20000.0, 2, 1,
    'SABAHATTİN ZAİM ÜNİVERİTESİ', 'İŞLETME VE YÖNETİM BİLİMLERİ FAKÜLTESİ', 'ULUSLARARASI TİCARET VE FİNANSMAN',
    '1.0', 4.0, 'https://drive.google.com/open?id=1sDQ9W9PsZU5Xj1pRNHvW_bBw7cUrl1Qi',
    'YAVUZ SAYGIN', 'ANADOLU GENÇLİK DERNEĞİ', '5.078639872E9',
    'ÜYE OLDUĞUM DERNEK BAKİMDER . MENSUBU OLDUĞUM DERNEK AGD', 'KOLEKSİYONERLİK VE  MÜZİK', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'PHOTO', 'https://drive.google.com/open?id=1bwPozSVl6mjfaHGZ-M0J55mVdimRRFXg', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'ID_COPY', 'https://drive.google.com/open?id=1KlKJGg_fA7QMphoLhUvnLjA4HCqPi3HZ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1sjT5bgK9LxPg86MunAEX_0ElcSnZ4C5C', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=13GR4acgDoH6ITFJZoYTvJexvMHecRbuy', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1fi12Hfp-uv5rGG6wEqEJaePKFvqft2yT', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1BvFOu1bsHKrqQAU7Un_x3o3JEKgU0KYg', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15038380154'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1kVqUfQ0kb_C_NkR6e8OwU8oF5G0iVH9g', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-24 18:09:36'::timestamptz,
    'Eren Danişmant', '13037472726', 'Sarıyer', '2006-07-03'::date,
    'erendansmand@gmail.com', 'İstanbul Sarıyer maden mah. Egemen sok. Bina 4 Daire 3', '05448083832',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Sağ',
    17002.0, 1, 1,
    'Nişantaşı üniversitesi', 'Meslek yüksekokulu', 'Elektrik',
    '1.0', 3.0, 'https://drive.google.com/open?id=1dUZT72hQGOTkIa6PzVYAphfqkqryfsjL',
    'Eren Danişmant', 'Kolcuoğlu ocakbaşı bomonti', '05448083832',
    'Anadolu Gençlik Derneği (AGD)', 'Elektronik, Futbol', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'PHOTO', 'https://drive.google.com/open?id=15E8_OQcryhCRKcOp5VmZP2aVo5ljkk8c', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'ID_COPY', 'https://drive.google.com/open?id=1KItopQP9Bc60rmp8KQTBMnY385CFSdbZ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1BD4uvDNvzhlRsABpHCd_3nqO25PEjbaL', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1YLFMdXWcy3FY3YAYB7U4bdHlFE8QDeJi', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1BeEcfB7gc2z4u4SAK-WBE-88MAbQxsop', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1NEtRQFc66D-evsCrJ1YwmkN6CiaiTN3M', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13037472726'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1oO4wzGWUYv1PYpMO7MfkU7ADsfWRFDzf', 'transcript-link'
);

UPDATE scholars SET iban = 'TR190020500009711824500003', phone = '5.51151917E9', email = 'yusufsefakoca58@gmail.com', university = 'Haliç Üniversitesi', faculty = 'İşletme', department = 'Yönetim Bilişim Sistemleri', class_year = '1.0', active = TRUE WHERE tc_no = '23381117860';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Yusuf sefa', 'koca', '23381117860', 'yusufsefakoca58@gmail.com', '5.51151917E9', 'TR190020500009711824500003', 'Haliç Üniversitesi', 'İşletme', 'Yönetim Bilişim Sistemleri', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '23381117860');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '23381117860' LIMIT 1),
    'ACCEPTED',
    '2024-09-25 09:27:56'::timestamptz,
    'Yusuf sefa koca', '23381117860', 'İstanbul', '2003-02-19'::date,
    'yusufsefakoca58@gmail.com', 'İnönü mahallesi 438. Sokak no 37 d2 Bağcılar', '5.51151917E9',
    'Sağ', 'Sağ', 'Alüminyum doğrama',
    'Sağ', 'Ev hanımı',
    28500.0, 1, NULL,
    'Haliç Üniversitesi', 'İşletme', 'Yönetim Bilişim Sistemleri',
    '1.0', 3.0, 'https://drive.google.com/open?id=1Kscu_X7WynFjGIz8BrvFFTeCR3PZAL7J',
    'Yavuz saygın', 'Anadolu Gençlik Derneği', '5.078639872E9',
    'Anadolu gençlik derneği', 'Müzik , Basketbol, Okumak , Gezmek', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'PHOTO', 'https://drive.google.com/open?id=1BYmAJwIyWiqd81HYj8MGPWAnTRPapdVX', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'ID_COPY', 'https://drive.google.com/open?id=1LoRF94Oqufzy5R97g3-J3koMdl4Tlq7B', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1Njhjz1jQ_f-vmLmwhbBZtc4093c_Dv43', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1HSuIu79WkOvbJDjYQuvLwRndpo-0tg3F', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1R9UzEDcVONgq-7tVO4AAjvZtDCsxKGXM', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1EyniwbdECLiNJbE8YdDzVHLSRUJ0zTrv', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23381117860'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Kdy3GkQcGNWEmJoIp07mY4D9GfrIW8TF', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-25 12:09:48'::timestamptz,
    'Habbab ÜNALMIŞ', '10412734226', '27/05/2005', '2005-05-27'::date,
    'habbabunalmis@gmail.com', 'Molla Gürani mah. İmam mesut Sk. No:3/4 Fatih İstanbul', '05524321851',
    'Sağ', NULL, 'Yeminli Tercüman',
    'Sağ', 'Ev hanımı',
    30000.0, 4, 3,
    'İstanbul Medeniyet Üniversitesi', 'Hukuk', 'Hukuk',
    '2.0', 3.09, 'https://drive.google.com/open?id=1VkDDWkpX83rAclQCLtyjLUQhdkyPYDu_',
    'Mehmet Koç', 'AGD', '05352947787',
    'Anadolu gençlik derneği', 'islami ilimler ve sosyal ilimler özellikle de Fıkıh ve Hukuk', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'PHOTO', 'https://drive.google.com/open?id=1olC_CoCDQtdEZda22t4ExWEpQECzsLto', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'ID_COPY', 'https://drive.google.com/open?id=1-taThVap8cJvjxdeT573QCf2Qk1VQe9D', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=18aV1fvX9Y5M7B30wXsqowWG250_V_OKA', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1QdNNF6bhxlZSYkbo37aBUIGxPkP3mBI2', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=162CYtGjVgwWMOJUXP8p3WZybmGCQ2IRq', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1UGn3P3blvKZ7LYv9Ojmb5CcA_gHypZWK', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10412734226'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ZBRVqyqLiOMqDXv4EQF_UdbolbrRqNGd', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-25 15:24:15'::timestamptz,
    'Taha Furkan Ekmekçi', '10373560858', 'İSTANBUL/SARIYER', '2002-07-23'::date,
    'ekmekcitahafurkan24@gmail.com', 'Cumhuriyet mahallesi arabayolu caddesi ateş sokak 3/3 Sarıyer İstanbul', '05444851324',
    'Vefat', 'Vefat', 'Esnaftı',
    'Sağ', 'Ev hanımı- babamdan emekli',
    6250.0, 2, 1,
    'Fatih Sultan Mehmet Vakıf Üniversitesi', 'Eğitim Fakültesi', 'Arapça Öğretmenliği',
    '4.0', 2.61, 'https://drive.google.com/open?id=1cfjNTQlEP5TJJDGLNxt9KW3dHp7tswWI',
    'Mehmet KOÇ', 'ANADOLU GENÇLİK DERNEĞİ', '05352947787',
    'Anadolu Gençlik Derneği (MGV)', 'futbol izlemek', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'PHOTO', 'https://drive.google.com/open?id=1-1J9KYgABVcnIL8e5k1RBiovG5p47RMk', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'ID_COPY', 'https://drive.google.com/open?id=1iHaGIBh7layelL4BTm_dDsDBhNi4EsSO', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1BKh7zpWumF0ymWtwirxDXJG6db5x4FBd', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1ubkqRIPh8J-oanr5qYGDik-OwbpSt33d', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1OOVwVn6wLbTKegHx3AT5NWyxiK1lvGYY', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1MvsTHhF0nJJLbVD7dUK7vLHGaLR4cSBh', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10373560858'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ilBE1NvAAekLZbe13CGc7ANsIDae-prw', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-25 16:37:09'::timestamptz,
    'Muhammed Talha Yinitbaş', '38531054728', 'İstanbul', '2000-01-12'::date,
    'talhayinitbas@gmail.com', 'Alikuşçu Mah. Başhoca Sok. No:7/1 Fatih/İSTANBUL', '05545298427',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'ev hanımı',
    17781.0, 3, 1,
    'Fatih Sultan Mehmet Vakıf Üniversitesi', 'Eğitim Fakültesi', 'Arapça Öğretmenliği',
    '4.0', 2.7, 'https://drive.google.com/open?id=1mTCukeumSPGVy3feR5B7No-Uk5NYprCK',
    'Mehmet KOÇ', 'İSTANBUL BÜYÜKŞEHİR BELEDİYESİ', '5.352947787E9',
    'Anadolu Gençlik Derneği', 'El Sanatları', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'PHOTO', 'https://drive.google.com/open?id=1lvbMjNMU-t60IPVbMmUnMo8vVaUnu-Bg', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'ID_COPY', 'https://drive.google.com/open?id=1DH4iundzwcT2F12KvGv48p8pCKmMfK_5', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=17qM-z1vEg6nCgTFN2iJpUJpXCCX50AlX', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Cm3spS3Z38Vvn3jdtWbQlIdkkyZgSnSb', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1T4oz_p4EUT0rBTKOoBBZ5ccYBGyHjP_3', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1zDN4LIkJJfSIFpykJ-ZDWUMYkewfw2OQ', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '38531054728'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Da9h0OKcQ4wriMD15-vJHbhSCcpim6qQ', 'transcript-link'
);

UPDATE scholars SET iban = 'TR320020500009957394400001', phone = '05325889996', email = 'necdemirtas61@gmail.com', university = 'İstanbul Üniversitesi', faculty = 'İletişim Fakültesi', department = 'Gazetecilik', class_year = '1.0', active = TRUE WHERE tc_no = '34378751356';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Necmettin', 'Demirtaş', '34378751356', 'necdemirtas61@gmail.com', '05325889996', 'TR320020500009957394400001', 'İstanbul Üniversitesi', 'İletişim Fakültesi', 'Gazetecilik', '1.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '34378751356');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '34378751356' LIMIT 1),
    'ACCEPTED',
    '2024-09-26 00:00:25'::timestamptz,
    'Necmettin Demirtaş', '34378751356', 'İstanbul/Güngören', '2007-03-08'::date,
    'necdemirtas61@gmail.com', 'Güneştepe mahallesi Bağlar caddesi no 43-45 daire 2 Güngören İstanbul', '05325889996',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev Hanımı',
    45000.0, 2, NULL,
    'İstanbul Üniversitesi', 'İletişim Fakültesi', 'Gazetecilik',
    '1.0', 3.0, 'https://drive.google.com/open?id=1_UFe-FotQEk5A41gWyeOJdSUkzD6FHJf',
    'Yavuz Saygın', 'Anadolu Gençlik Derneği', '5.078639872E9',
    'Anadolu Gençlik Derneği', 'Futbol', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'PHOTO', 'https://drive.google.com/open?id=1ubY2musdpqlm6M9XlV-r9wxjDwF_xEaR', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'ID_COPY', 'https://drive.google.com/open?id=1XoM9L-q33p2GeBIP3VHmQYN_vWUwLJQh', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=11CIjAJUXsFngsmMtqCAsnsGmnHuatzDN', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1WoXjYiiAehX4eNshWQ99K3t5kMtSw2Xt', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1TUiZrXg0aheUE2iyliwzUHYPB4ywESfa', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1vDkPB_EWixBc0oBFqB4qmC2b2jKZQYXS', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34378751356'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1CRNlGm7zVFsAZW8E-NPPIv3DJl9vTZRP', 'transcript-link'
);

UPDATE scholars SET iban = 'TR860006701000000035592506', phone = '5.511818322E9', email = 'kadirztrx@gmail.com', university = 'Istanbul Rumeli üniversitesi', faculty = 'Sanat tasarım ve mimarlık', department = 'Radyo televizyon ve sinema', class_year = '3.0', active = TRUE WHERE tc_no = '15227389074';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'Kadir', 'öztürk', '15227389074', 'kadirztrx@gmail.com', '5.511818322E9', 'TR860006701000000035592506', 'Istanbul Rumeli üniversitesi', 'Sanat tasarım ve mimarlık', 'Radyo televizyon ve sinema', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '15227389074');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '15227389074' LIMIT 1),
    'ACCEPTED',
    '2024-09-26 03:46:49'::timestamptz,
    'Kadir öztürk', '15227389074', 'Istanbul', '2004-08-10'::date,
    'kadirztrx@gmail.com', 'Istanbul Arnavutköy Anadolu mahallesi Zişan Sokak no 9 daire 4', '5.511818322E9',
    'Vefat', 'Vefat', 'Rahmetli',
    'Sağ', 'Ev hanımı',
    20000.0, 4, 2,
    'Istanbul Rumeli üniversitesi', 'Sanat tasarım ve mimarlık', 'Radyo televizyon ve sinema',
    '3.0', 2.3, 'https://drive.google.com/open?id=1XqyKr6Px-oRCn455GcsealmI3ms_N7V0',
    'Salih talas', 'Talas gayrimenkul', '5.445653442E9',
    'Anadolu gençlik derneği', 'İslami dayanışma', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'PHOTO', 'https://drive.google.com/open?id=1fcMtnjhLvecjbEnCObSMgutlaN4rAHjV', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'ID_COPY', 'https://drive.google.com/open?id=1ECvCdSfmQIIJrfkXdw6WlqENEI-kE17C', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1yEUR4qoIEdCGh9b3XUzy5bLGWnFl1Wrc', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Clw01NY9l2Zd0yGNDxhgm2DGQcL8Pi-n', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1yAlt8TzgPU6fUfRgPMdfijeXt7gujhx9', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1g5lKhJbwo9Fu_59dCh5FtC5SwQDrUCxq', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '15227389074'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=10BGNgnaOFmikfzJjPggiYGuhRCS6bLPL', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-09-28 19:49:54'::timestamptz,
    'Ahmet Can Tekgöz', '13643107364', 'Erzurum Horasan', '2003-05-22'::date,
    'ahmtcn.tkgz@gmail.com', 'Arnavutköy merkez mahallesi faruk sokak no 3 daire 5 Arnavutköy / İstanbul', '05376032707',
    'Sağ', 'Sağ', 'Öğretmen',
    'Sağ', 'Ev hanımı',
    51490.0, NULL, NULL,
    'İstanbul Teknik Üniversitesi', 'Elektrik elektronik fakültesi', 'Robotik ve otonom sistemler mühendisliği',
    '2.0', 1.63, 'https://drive.google.com/open?id=1AN6cxbkJ4aZafhvXePspucBAuz1TuykJ',
    'Mehmet Koç', 'İBB', '05352947787',
    'Yok', 'Teknoloji, futbol, müzik', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'PHOTO', 'https://drive.google.com/open?id=1HIwZllxcjUnfwvZGedFzt6fVRUuiCmll', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'ID_COPY', 'https://drive.google.com/open?id=1dnOFaG-zPGMCyz0mjtI1QsCGqFGbMljP', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1lPGpvGVKXQrcyOQSiEIBWbnfQ9LQfQP4', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1iffosCWiYg2jimallmXPzW0cePlHxxsc', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1YOXAnzy5FhBUE-NtOv4raFI_xeiKLETT', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1qtcpxsmHIEFS9Y5ArX8kouAwdFTsjqMs', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '13643107364'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1CQ_h8KLMAZ08JfVoz2TrKMkBBr8NFetm', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-08 12:51:58'::timestamptz,
    'Özge Uzunharman', '42439499598', 'İstanbul', '2007-03-19'::date,
    'ozgeuzunharman@gmail.com', 'Necip Fazıl Mahallesi Münasip Sokak No:15/3 Ümraniye/İstanbul', '05511930418',
    'Sağ', 'Sağ', 'İşçi',
    'Sağ', '4-6 yaş Kuran Kursu Öğreticisi',
    95000.0, NULL, NULL,
    'Yıldız Teknik Üniversitesi', 'Makine Fakültesi', 'Mekatronik Mühendisliği',
    '1.0', 2.5, 'https://drive.google.com/open?id=1oSfX-Qy_Tw8JT-IwCfqLgL4lS24F8g7m',
    'Sümeyye Büyükgüçlü', 'Insider', '05544421834',
    'T3 Vakfı', 'Savunma sanayi, otonom sistemler ve yazılıma ilgi duyuyorum. Bunun yanında fotoğrafçılığa da oldukça ilgiliyim. Hem akademik hem de kişisel gelişimim için katkı sağlayacak alanlarda kendimi geliştirmek istiyorum.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'PHOTO', 'https://drive.google.com/open?id=1H-ylLEhpg4UvlzEVKwynMExzReYCsJo3', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'ID_COPY', 'https://drive.google.com/open?id=1qJ9y-KVRUjGRrm9VYGXu77VOFME-dIu7', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1azFTpAAKMmkZN7v3EYDg77KcIm68JW3y', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=19_x-JlMcBVOR8fRizF30Ul0BK5oG42m4', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1m9vmLphHzkfLwv22ozaEytvVx0EaArLC', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1UgMJog6HRu6sOR0rQaTAsqbTu8SMFvoh', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42439499598'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1BH1qd4UdMbLdHZ7yq_T7Ci06h56mIG17', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-10-03 19:49:02'::timestamptz,
    'Yusuf Alp Kesmen', '31051879116', 'Türkiye, İstanbul, Maltepe', '2005-10-04'::date,
    'yusufalpkesmen3@gmail.com', 'Turkiye İstanbul Ümraniye inkılap mahallesi Zübeyde hanım sokak no:5B B blok kat 10 daire 43', '05078932736',
    'Sağ', 'Sağ', 'Memur',
    'Sağ', 'Ev hanımı',
    56000.0, 3, 3,
    'İstanbul Aydın Üniversitesi', 'Mühendislik', 'Yazılım Mühendisliği',
    '1.0', 4.0, 'https://drive.google.com/open?id=1A8dSc5SOsINL039qiZf5IGjroZaM6l9t',
    'Resul Güzel', 'Milli Egıtım', '05327274343',
    'Yok', 'Bilgisayar ve yazılım', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'PHOTO', 'https://drive.google.com/open?id=1jSGDm7Fs7_lPMMM2fureEUqS2OK47IQs', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'ID_COPY', 'https://drive.google.com/open?id=11lss4W3CttaEdBBgshBdpn157TEfNfPD', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=101rTfABFNOIUVH55xDUXTaqDSW8IFh__', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1OwKtPKlmLDpNSGn_iZDGpBR5IkPHvwtV', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1fMSkeJ5mAPCsCqFRLBBAkWvX2_tj2x0A', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1oYq5yWp-GqQvc7VrFBgzBlLGdPjLFnxO', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31051879116'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=195OvnvurDdub3wcd8m48fTaaju-3fyYV', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-10-06 20:23:18'::timestamptz,
    'Aykut Adıgüzel', '12595390442', 'Adıyaman', '2001-09-04'::date,
    'aykuttr02@gmail.com', 'Esentepe mah. Titizler cad. 11 nolu sok. No:39 Gaziantep/Şahinbey', '05364968697',
    'Sağ', 'Sağ', 'Fabrika işçisi',
    'Sağ', 'Çalışmıyor',
    25000.0, 3, NULL,
    'Marmara üniversitesi', 'İlahiyat fakültesi', 'İlahiyat',
    '4.0', 2.3, 'https://drive.google.com/open?id=1S8NuYZh4ImDffD30e1onLgP0_6GcfsVL',
    'Mehmet Koç', 'Anadolu Gençlik Derneği', '05352947787',
    'Anadolu Gençlik Derneği', 'Tarih
 edebiyat 
Spor', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'PHOTO', 'https://drive.google.com/open?id=1FWQi7ymf2VBq15dyBoNERKW3x_2Qqqno', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'ID_COPY', 'https://drive.google.com/open?id=1ZOCORzSkxAFI0vDlB_cj-bWONeL0I7HN', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1TYh9El7m0UK2Nfc25rW5iyDrZ9bKsytC', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1LCQyMpl4A5F_GS0QIM3MJ0r-kO5CdiE4', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1nUB4WtvC_Zb5j6ob6TFu7pVI_s0U1Znr', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1fbemgpV-4l1nCoPHZpdOlTS5HqaXq-VS', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12595390442'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=199-dOqE15yyFzAGFcqv7_iJl8YYVul7P', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2024-10-08 21:08:31'::timestamptz,
    'Abdullah ömer çerme', '17132325116', 'Gaziosmanpaş', '2004-06-29'::date,
    'abdullah.cerme@hotmail.com', 'İstanbul/sultangazi yunus emre mahallesi 1397/1 sokak no 10 daire 3', '05435877009',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'ev hanımı',
    1.0, 1, NULL,
    'İstanbul yeni yüzyil üniversitesi', 'Fen-Edebiyat Fakültesi', 'İngilizce Mütercim Tercümanlık',
    '2.0', 3.19, 'https://drive.google.com/open?id=1_EiYebaQKT9uI6fJ1lgKD9IWSXCD00Cr',
    'Mehmet Koç', 'İstanbul Büyükşehir Belediyesi', '05352947787',
    'AGD', 'İngilizce, Spor, Kitap okumak, film izlemek, Taekwando', 'İngilizce, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'PHOTO', 'https://drive.google.com/open?id=1BEuf_eogNQlAFRyVHOENmzDf-froRx60', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'ID_COPY', 'https://drive.google.com/open?id=1pImm21axgoU75yxX1OOOIozMiZcYXmAP', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1XvBoD7fqwnkVF1yadrMzNaslAKSpVA1T', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1ZWmkbJkEujlhZIXd8bN3TaDnR6Azjfos', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1nq1ntn4JkVxxKcSgSgCBGMlpz2bo7NR9', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1LygcWCTJqGgGI8U9UwR6O6_ogkj4_ctZ', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1fVqUVPh-OmpXxGmE7dKUXWZgeB_xUDJW', 'transcript-link'
);

UPDATE scholars SET iban = 'TR920020500009816248500001', phone = '05054183407', email = 'recepalibeken07@gmail.com', university = 'BİRUNİ ÜNİVERSİTESİ', faculty = 'ECZACILIK FAKÜLTESİ', department = 'ECZACILIK', class_year = '3.0', active = TRUE WHERE tc_no = '22970123152';
INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)
SELECT 'RECEP ALİ', 'BEKEN', '22970123152', 'recepalibeken07@gmail.com', '05054183407', 'TR920020500009816248500001', 'BİRUNİ ÜNİVERSİTESİ', 'ECZACILIK FAKÜLTESİ', 'ECZACILIK', '3.0', 'OGRENCI', DATE '2024-10-01', 3000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = '22970123152');

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    (SELECT id FROM scholars WHERE tc_no = '22970123152' LIMIT 1),
    'ACCEPTED',
    '2024-10-09 17:00:51'::timestamptz,
    'RECEP ALİ BEKEN', '22970123152', 'FATİH/ İSTANBUL', '2003-05-20'::date,
    'recepalibeken07@gmail.com', 'EV Adres : YENİDOĞAN MAH. 41. SK. NO: 15  İÇ KAPI  NO: 8 ZEYTİNBURNU / İSTANBU', '05054183407',
    'Sağ', 'SAĞ', 'MEMUR',
    'Sağ', 'EV HANIMI',
    50000.0, 2, 1,
    'BİRUNİ ÜNİVERSİTESİ', 'ECZACILIK FAKÜLTESİ', 'ECZACILIK',
    '3.0', 3.0, 'https://drive.google.com/open?id=1RKr_3sp4bTYjnWoZCBiYpX1NIAjnuILa',
    'LATİF COŞAR', 'İSTANBUL BÜYÜKŞEHİR BELEDİYESİ', '05322178590',
    'YOK', 'YENİ YERLER KEŞFETMEK, KİTAP OKUMAK ,SPOR YAPMAK.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'PHOTO', 'https://drive.google.com/open?id=1Iqi9rsRzxUtwMr0yBB1JZTGCa_fJctnR', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'ID_COPY', 'https://drive.google.com/open?id=18UvVsfn3N4a20ubZSIa5knnXPaH4uxhs', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1-gCL7D3wSyF4YmyWKTIg_vVOm2Yfie32', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1DXfGlrlWKyTjXAoCQFwbEg0Kj3oY7OQr', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1OP35nqYewgmytvgYdRE_86ZUPIIvVm1W', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1MUsaIRJyYSMqoXt2hj1v5JH_B7KfNCdn', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22970123152'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=115mxN_tpu9kBhhTHbISnaffDdYDQhrsD', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-08-20 15:44:20'::timestamptz,
    'Şeyma Nur Ceylan', '52198179440', 'Hatay/Kırıkhan', '2008-05-22'::date,
    'seymanrcyln8@gmail.com', 'Örnek mahallesi 1378 sokak No:10 D:1 Esenyurt/İstanbul', '5.067020519E9',
    'Sağ', 'Sağ', 'Belediye temizlik görevlisi',
    'Sağ', 'Fabrika çalışanı',
    29000.0, 2, 1,
    'İstanbul Üniversitesi', 'İletişim', 'Radyo Televizyon ve Sinema',
    '1.0', 3.0, 'https://drive.google.com/open?id=1HgG3jO-1hfBv2vHrFWDbbhdnBTvUlzi6',
    'Zahide Erva Aluç', 'Tenzile Erdoğan Kız Anadolu İmam Hatip Lisesi', '05077628634',
    'Önder Gençlik', 'Yazarlık', 'İngilizce, Arapça, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'PHOTO', 'https://drive.google.com/open?id=17zIsghdTUDTK-133zZFQe2V5AVDdZoUV', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'ID_COPY', 'https://drive.google.com/open?id=1AlCTi8Tq3GRy80caD8Lz-NH_d_XvIXFy', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=17Ynx8lg14do-zKpgQjoeYnmA7sV5p_mE', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1qTM_HeZ5Hsn-vmH_SErpot-mS3f9yy7I', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1A_ION4YMtJtAcDiVHuTag8PDpuPgrdrL', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=15g9tVMcy07yybJkmUVpuYBfRTYuCsP_K', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '52198179440'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1R_yG9MMak-36K6XXWnuyaoyvIdUUYGgL', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-04 00:44:38'::timestamptz,
    'esma narlı', '54907720240', 'istanbul', '2005-05-13'::date,
    'esmanarli00@gmail.com', 'istanbul/başakşehir/4.etap/d4/daire 30', '05524671522',
    'Sağ', 'ömer faruk narlı', 'makine mühendisi',
    'Sağ', 'ev hanımı',
    40000.0, 3, 1,
    'istanbul üniversitesi', 'diş hekimliği fakültesi', 'diş hekimliği',
    '3.0', 2.56, 'https://drive.google.com/open?id=1QIaGWTTGlGyxhr0LCkgTUdVQt35KpoTC',
    'adnan ekinci', 'ecmel tur', '05076966441',
    '-', 'dijital ve geleneksel çizim (karakalem, akrilik, suluboya vb geleneksel sanatlar), piyano, elektro gitar, kitap, müzik, sinema', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'PHOTO', 'https://drive.google.com/open?id=12z6Tov6sAN16F46BGg0C0Yv1H4c9xeiG', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'ID_COPY', 'https://drive.google.com/open?id=1pTdM0H4Psozd_OrajTcT000LrlKSpMm8', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1VRPQxw8hHecLnM5AYyaXEQD5Gr289gUw', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1RgUxqWbrnLbL48nPHy5uw7nA6beB0SkL', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1bLJeJXxppfstqGmmzq69s-A68h7hWtIv', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=119Mk1YnzTW_lmc1pM-TPuzDAS3I-YuQG', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '54907720240'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ZELKwi87yVtvwO18hmI5SAW5dcoKJzgr', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-04 14:01:09'::timestamptz,
    'Ruveyda Aksoy', '11051494410', 'Bayrampaşa', '2005-02-15'::date,
    'ruveydaksoyyy@gmail.com', 'Fevzi çakmak mahallesi 771.sokak no5 kat4 Gaziosmanpaşa/ İstanbul', '5.426093235E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Birim sorumlusu',
    83000.0, 1, 1,
    'Marmara Üniversitesi', 'Hukuk Fakültesi', 'Hukuk',
    '2.0', 2.28, 'https://drive.google.com/open?id=1QqF0wv5ZgfhPnROFr-HIdvGsXabV0IZc',
    'Hasan Tahsin Usta', 'Emekli', '5.322911564E9',
    'Yok', 'Yüzme, kitap okuma vb', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'PHOTO', 'https://drive.google.com/open?id=1OQQ3ZRmtpTqfW8vD-fIXxHldgOwKvfbc', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'ID_COPY', 'https://drive.google.com/open?id=13XnH-1f1U_RHhKgY6XL5IRCrCYcLWBGA', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1tf89-9jI1rRBa-3vYN5aaNZi-MeU_8Xt', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1tUueARNW2oFma8YIx_nX0ZbLDi0juT5_', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1VxFIw4zVKp4BWNgWBNAuu8TwGHlVmRYc', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1cMVZ0bGLsIxvXUFMZqLVW6WKcHH-dZuf', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11051494410'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1_SrzMxrGKNKsZ2uK8_dRi4vs_HA2-zSe', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-04 15:38:42'::timestamptz,
    'Gülfidan Küçük', '10901542608', 'Pendik', '2004-10-05'::date,
    'gulfidankucuk@hotmail.com', 'Çamlık Mahallesi Akasyalı sk Öz Yeşil Yayla Sitesi E/11 Pendik İstanbul', '05511288467',
    'Sağ', NULL, 'Emekli',
    'Sağ', 'ev hanımı',
    21997.0, 4, 2,
    'İstanbul Teknik Üniversitesi', 'Mimarlık Fakültesi', 'Mimarlık',
    '3.0', 2.95, 'https://drive.google.com/open?id=19nPBCxINdZEF33MKHbZQiYYFQblzveMY',
    'Şeyma Şahin', 'Kadıköy Kız Anadolu İmam Hatip Lisesi Müdürü', '05058966556',
    'Hürder, Aysit, Aydostder', 'Yeni şeyler öğrenmeyi, farklı yerler keşfetmeyi ve gözlem yapmayı çok seviyorum. Mimarlık ve tasarım konularına ilgim var; ilham almak için sergi gezmekten ya da ilginç yapıları incelemekten keyif alıyorum. Bunun yanında kitap okumak, fotoğraf çekmek ve arkadaşlarımla beraber sosyal projelerde yer almak hoşuma gidiyor. Vaktim oldukça da dijital tasarım ve farklı programlar denemeyi seviyorum.', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'PHOTO', 'https://drive.google.com/open?id=1Z0r_LeEDdmqKugo6XXdUE0f858rn1Ud8', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'ID_COPY', 'https://drive.google.com/open?id=1gLLxD9F-qgj3SRz5l2erE6HKpdegvj5L', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1v4r0iaD7pBJiJHrTb0v8tLNfOidnYIT8', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=11-TTWB9FFyJvjrDicwdqnQqbLctJjbHl', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1L2AIN90C7ptdUbrVxhKpJNuJSucBDaKE', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1pEwWDx_P7QFCsaIq8euNxAGSEDuyW4Iw', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10901542608'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=198EqHceOlgBORTPm1IJvgHb0Sg6HY23G', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-04 18:25:14'::timestamptz,
    'Ayşe Melisa Çavdar', '26065034972', 'Afyonkarahisar', '2003-06-25'::date,
    'Melisacvdr13@gmail.com', 'Fatih mah. 1556.sok. no:15 kat:3', '05384770879',
    'Sağ', 'Sağ', 'Teknik ressam',
    'Sağ', 'Ev hanımı',
    73000.0, 1, 1,
    'Biruni Üniversitesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Moleküler biyoloji ve genetik',
    '1.0', 4.0, 'https://drive.google.com/open?id=1mqAWZZ12CoO6oYkJImvHQnUb1z3oRJWM',
    'Mus''ab Ensar Ertürk', 'Ofis Özel Eğitim Kursu', '5.447831751E9',
    'Bu sene üniversiteye başlayacağım için üye olduğum dernek veya vakıf henüz yok', 'Dini eğitim ve sohbetler , bocce , badminton , karakalem , edebiyat , biyoloji , psikoloji .', 'İngilizce, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'PHOTO', 'https://drive.google.com/open?id=1YvYy0tznmK2dpSIsIM6RZymnd-7sXRkT', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'ID_COPY', 'https://drive.google.com/open?id=1MzGoAy6vAjmcUJNLjp1XEc6G084x260k', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1U9wglSG0wwbrtGuGY5qKY7VvQeGiY_n4', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1O4yWC7UWwBQE0zeuLOICy1bPXc5fmtKL', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1MosWxh4rGXzXGFDwSwkmx2_b2OU51-kx', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=19PQip5CRM0ebKMwe8zeiyLBf9q7tK5GR', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '26065034972'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1TSaAG2iKvMb4l2CWb9PtXBsMfkmVxWBp', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-04 18:36:19'::timestamptz,
    'zeynep öztürk', '12866471566', 'sultanbeyli', '2004-04-07'::date,
    'ozeynep863@gmail.com', 'istanbul üsküdar cumhuriyet mahallesi libadiye caddesi mesecik sokak no:24', '5.312924578E9',
    'Vefat', '2017 yılında babam vefat etti', 'yok',
    'Sağ', 'ev hanımı',
    40000.0, 4, NULL,
    'istanbul ticaret üniversitesi', 'hukuk fakültesi', 'hukuk',
    '1.0', 4.0, 'https://drive.google.com/open?id=1xFULRLQV_0IenBsIi7kHGZrf5ijxpK1R',
    'kamer öztürk', 'ev hanımı', '5.364413252E9',
    'yok.
Not:mallesefki formunuzda bütün dosyaları yüklemek zorunlu olduğu için, olmayan formları da yüklemek zorunda bırakıyorsunuz.4 kardeşiz ve benim dısında okuyan kardeşim yok oyüzden o kısma kendi ogrenci belgemi koydum.Babam vefat ettiği için emekli aylık bilgisi yok oyüzden anneminkini koydum, üni''ye yeni başlıcağım icin transkiriptimde yok oyüzden onun yazdıgı belgeyi koydum.Formda herseyi zorunlu tutmaktansa açıklama kısmı koyabilirsiniz.', 'dil öğrenmek', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'PHOTO', 'https://drive.google.com/open?id=1QvNidmw2dbOd9QlD2cvSfr4SnuEc-OGN', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'ID_COPY', 'https://drive.google.com/open?id=1xNfVrumhfc0WPW8QvUhI0Xj7R0vDy9nG', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1Zh7aBJyVDh0Zpp_z7QhGhRLlsCBjmnuh', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1rckSMLAqV0lvwM1IC0OXcFpT9eoHxtGX', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1bX5KNtf1k2cmm0Qz1JEvSqek_o0mw8nh', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Hq5gwTqAfPjGWhlQ6HMJz9snEmZQDhaC', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12866471566'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Ncj6a9hcg7EO-p_X0D4QoFNOIVit4foe', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-05 23:11:25'::timestamptz,
    'Murat Hakan Asım', '10400408344', '06.10.2004', '2004-09-06'::date,
    'asimmurathakan@gmail.com', 'Serintepe Mahallesi Kardeşler Caddesi 60065.sokak No:1 Onikişubat Kahramanmaraş', '054345685124',
    'Sağ', 'Sağ', 'İşçi',
    'Sağ', 'Ev Hanımı',
    25000.0, 4, 1,
    'Marmara Üniversitesi', 'İlahiyat', 'Türkçe',
    '2.0', 2.74, 'https://drive.google.com/open?id=1GxKdnaUk0SrR65v9T8ulJ3KIAVrVGD1T',
    'Selim Kılıç', 'Gaye Vakfı Genel Müdürü', '05344984144',
    'Gaye Vakfı', 'Tarih, Arapça , Sanat', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'PHOTO', 'https://drive.google.com/open?id=1K7LFvZdXJtuWkYRcTR9eNJrMzgu9srAi', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'ID_COPY', 'https://drive.google.com/open?id=1kNYqPMvF6VCoWIlU8oyr-ZP8ZMLSRoon', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1t8uuRjh-1smYqyviXinWoIwW43_NgDbm', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1r3RC3pgBd-z6PEkpQHYjFt8LPLoreNZT', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=152uUylphjn02NwN9rqk7AzJwc3tZF_dc', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Ewwchoq8yAKFTditHrE-F2JYB0nn7XBC', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10400408344'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1byfdrBLPpberDDn_hheaPU8zcYvQGr_K', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-05 23:37:44'::timestamptz,
    'Yakub ekinci', '22175166022', 'Pendik', '2007-04-28'::date,
    'ekinciyakub34@gmail.com', 'Nenehatun mahallesi İlknur sokak no 10 daire 4  KOCAELİ/DARICA', '05525620703',
    'Sağ', 'Sağ', 'CNC operatörü',
    'Sağ', 'Ev hanımı',
    66500.0, 1, 1,
    'İstanbul üniversitesi', 'İlahiyat fakültesi', 'Arapça',
    '1.0', 4.0, 'https://drive.google.com/open?id=1j5T8MU4KKV8-Qk3sXg_ALDvWDI9rIrbh',
    'SELİM KILIÇ', 'Gaye vakfı', '5.344984144E9',
    'Gaye vakfı', 'Din, tarih, felsefe', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'PHOTO', 'https://drive.google.com/open?id=1JNQhTlZq-hJfgw_TdkPR99LpcQRsSbBe', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'ID_COPY', 'https://drive.google.com/open?id=1fXMlxWx0fc8AsTNSKF4UWzxvDMIKGySf', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1QJTu3Cj-jhkrXXaE-b13llDuCwYCwYHb', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1YdT_Hu-KVeL3yC9xvjHvA2E-TeHGbOaC', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1NJRtRTT33LlsS19KURHKNaiQF3uxQOcc', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1AxsfEUIHOmS2Vec1MKQaGCtsKTgFgcA3', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '22175166022'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1bijc6iJQnDldPZUcfEzgRUiszr6iI-GJ', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-06 20:52:28'::timestamptz,
    'Abdullah Sami Çalışan', '11778141178', 'Osmaniye', '2005-10-01'::date,
    'samicalisan@hotmail.com', 'YILDIRIM BEYAZIT MAH. 14094 SK. NO: 7 İÇ KAPI NO: 2 MERKEZ / OSMANİYE', '05369757396',
    'Sağ', 'SAĞ', 'Marangoz',
    'Sağ', 'ev hanımı',
    30000.0, 4, 1,
    'istanbul medeniye üniversitesi', 'mühendislik ve doğa bilimleri fakültesi', 'elektrik elektronik mühendisliği',
    '1.0', 4.0, 'https://drive.google.com/open?id=1DbDT673DQ8lmoUnrFXq6LbXPg4HIq5uT',
    'Ekrem Erdemir', 'Erkam yayın san tic AŞ', '+905445012920',
    'Aziz Mahmut Hüdayi Vakfı', 'yazılım,elektronik cihazlar,tarih,futbol', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'PHOTO', 'https://drive.google.com/open?id=1bp7Zf7tHM_lGuXiTZg9gFxfuSlGOElKc', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'ID_COPY', 'https://drive.google.com/open?id=1Kxy5kEdZgzqP8_ghjLIf6WppRiePqdf8', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1ElOrmimZCNj6GT61aW8O2q1MWFyZSMgo', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1_0oEELuNC56cm3RBrw3fwzpH4Idow_tt', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=12He1l1mdauJ00ou7K0gHtuyswJtftWvr', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Y5sVglmAvfYSFicSQleDgBekryOWpNsJ', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11778141178'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Rc0PaUNze7NMuSYQyuJErik0JAVwFZfW', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-07 13:51:26'::timestamptz,
    'Muhammed akdeniz', '12830818922', 'Muş', '2005-08-15'::date,
    'njhgbhf70@gmail.com', 'Üniversite mahallesi sarıgül sokak cerrah Mehmet paşa kyk yurdu avcılar İstanbul', '05336274941',
    'Sağ', 'Sağ', 'Belediye temizlik görevlisi',
    'Sağ', 'Çalışmıyor ev hanımı',
    38000.0, 4, 4,
    'İstanbul üniversitesi Cerrahpaşa', 'Hasan Ali Yücel eğitim fakültesi', 'Özel eğitim öğretmenliği',
    '2.0', 3.29, 'https://drive.google.com/open?id=1H6HotZI7oHYkJEOq5p5YnK-vETNNgspE',
    'Gülten Akdeniz', 'Özel Anadolu lisesi rehberlik danışmanı', '5.304328186E9',
    'AGD Anadolu gençlik derneği, ilim yayma cemiyeti', 'Seslendirmenlik yapmak, at biniciliği, sporun her dalı kitap okumak araştırma yapmak film izlemek ve bunların üzerinden tahlil yapmak.', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'PHOTO', 'https://drive.google.com/open?id=12uUKT7x8Pwv0WyvQK1zultFN1B0WpAw5', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'ID_COPY', 'https://drive.google.com/open?id=1wCwwZv8ktquym0DQ2K38R6fP52LCro3I', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=198ArdOOeEBLoUlRr0nAWW7VsklWAT0PZ', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1W0GjPfPoxaSvYPpMKkPRTGDjmyz23OaP', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1TpTr7VpY66UGP24YJuuEGhUKw9tXPjB9', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=16bUq2IaRRbiO9a--HaS-cPslG-vCEaij', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12830818922'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1KurLaK8IzcSRtR9cCErHeaW2O_lfZ0qw', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-08 18:37:56'::timestamptz,
    'Ayşe Beril Cerit', '10274778130', 'Bahçelievler İstanbul', '2004-07-07'::date,
    'aberilcerit@gmail.com', 'Başak mahallesi Abdülhamithan caddesi 5. etap 2. kısım Beykoz Sitesi A30 blok daire 24 başakşehir İstanbul', '5.459548944E9',
    'Vefat', 'Vefat', 'Yok',
    'Sağ', 'Ev hanımı',
    45000.0, 1, 1,
    'İstanbul Medipol Üniversitesi', 'Tıp fakültesi', 'Tıp bölümü',
    '3.0', 3.25, 'https://drive.google.com/open?id=1o34IZ3-wNHBF7OD24JM_vRTuycmv3Ezh',
    'Ekrem Kızıltaş / Erol Dilaver', 'Takvim gazetesi, Bağcılar belediyesi danışmanı/ Siyasal vakfı', '5.323232863E9',
    'İstanbul Siyasal Vakfı', 'Kitap okumak, müzik dinlemek', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'PHOTO', 'https://drive.google.com/open?id=1v2oJdfPq2-TQolv2zz6ot1VeIZgMtlKr', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'ID_COPY', 'https://drive.google.com/open?id=1O5lAcTSM9c2rxv6Vu2X7lt8A1340_Xzw', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1CU1eanDXKyUG8JJPrC1Ejdnlq1r1Q5ke', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1m_XdKn6mp7OTkdc2cfMmsVzB7yBCF0ce', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1MmMLeueeTCkI1LIla1Xb_HwZSNbNVXg-', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Uhp_5dBCwFnAONav-rRICtvhfuYGM36_', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10274778130'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=15NQGjYhQNDPV20Ymasy__g6HgoreY6Lq', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-09 18:58:43'::timestamptz,
    'Ahmet Salih AKKUŞ', '10345506532', 'Adıyaman', '2006-01-06'::date,
    'salihahmet044@gmail.com', 'Merdivenköy mahallesi imam ramiz sokak no 39/A İstanbul Kadıkööy Gaye Vakfı', '5.543452702E9',
    'Sağ', 'Baba sağ', 'Şube Müdürü',
    'Sağ', 'Çalışmıyor',
    71000.0, 3, 4,
    'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat Türkçe',
    '1.', 4.0, 'https://drive.google.com/open?id=1ghAd4BySZyjyiM6W6zG5gqYjrs3JTlT2',
    'Selim Kılınç', 'Gaye Vakfı', '5.344984144E9',
    'Genç İHH , AGD', 'Kitap okumak ,Kuran okumak, Tasarım yapmak', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'PHOTO', 'https://drive.google.com/open?id=1W7-1vO4yjXz_RRMfdr3qYJc2lyqLnm0P', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'ID_COPY', 'https://drive.google.com/open?id=11TgE8bbTIcxrZUU-Lyy2vQu10Wr7hJsC', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=157IKXi8q-XTeNDhNbfBPlUpULCDegtF3', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=14Jfo6vPxYi1FASUekA8__L4tKyZgpAOg', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1Y2JyveyxKw1rci4ZFOTYh4bjWQD-M5_k', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1dB91edW3g4PFy2qgeYCPyfMgaq0U4s5Z', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10345506532'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1eAN6aYq__EJbOidK6FjjVyYf3yhFlpPS', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-10 12:20:28'::timestamptz,
    'Muhammet ali erafşar', '12563333556', 'Kahramanmaraş', '2004-02-20'::date,
    'Muhammetalierafsar@gmail.com', 'Kahramanmaraş onikişubat kurtlar mahallesi 56034 sokak no 40', '5.469138449E9',
    'Sağ', 'Sağ', 'Müezzin',
    'Sağ', 'Ev hanımı',
    53000.0, 2, 2,
    'Marmara', 'İlahiyat', 'İlahiyat ingilizce',
    '2.0', 3.44, 'https://drive.google.com/open?id=19p6n8ErnOstw2UKTRZD7yzOJ2RhIPnE2',
    'Selim kılıç', 'Gaye vakfı', '+905344984144',
    'Gaye vakfı', 'Ud çalabiliyorum', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'PHOTO', 'https://drive.google.com/open?id=1VCkZtbzuEJkHYvc6-3TDF34yiVg4Ty19', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'ID_COPY', 'https://drive.google.com/open?id=1PwzhIQGkzzgEM6TBcetWzlofwU6vG9hQ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1ccYwNkhlXy1CBJLAIzsTnsUcSqXVcIlD', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Hl8qG9tf5Ay82lU__XyU6S32jBYy7-H3', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1KmfaSara28nzunTcOJfjR4gU7ccj0FsH', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1_Ge-jg9T___TMPi3zRIjXqz0ZYl0bGrE', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '12563333556'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1FLhZbE4kak8umlzSwg14z4AEc2RS6IbC', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-10 17:25:56'::timestamptz,
    'Abdullah Ömer Çerme', '17132325116', 'Gaziosmanpaşa', '2004-06-29'::date,
    'Abdullah.cerme@gmail.com', 'istanbul sultangazi yunus emre mahallesi 1397 taksim1 sokak no 10 daire 3', '05435877009',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    40000.0, 1, NULL,
    'İstanbul yeni yüzyıl üniversite', 'Fen Edebiyat Fakültesi', 'İngilizce mütercim tercümanlık',
    '3.0', 3.22, 'https://drive.google.com/open?id=1xg12XqJDoZO2rzceh_wghr02NAUIcysD',
    'Mehmet Koç', 'İstanbul büyükşehir belediyesi', '05352947787',
    'Agd, İhh', 'Dil öğrenmek, kitap okumak, stratejı oyunları, yapay zeka ve teknoloji, basketbol', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'PHOTO', 'https://drive.google.com/open?id=1NRAGF9L9A0SGD6-fgHBuU-oiVFdQs6xa', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'ID_COPY', 'https://drive.google.com/open?id=1AfosHalC18xdRsJ_CMjS6_Ph2pSPxN09', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1A-zf5PqAcupy5NY0-EaCFEyW2k017KDT', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1jF7WpiR6QVLXKVaQ1vzY-XQTko-j5yv2', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1cj-yUYvXZxR39E-7JfxDkc1Y9D_O_SoX', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1u3fCwomUgwLbh1LHIOC-9gKvxVrWLcXC', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17132325116'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=17zFo5cqPPFe6i8x_KwiUVd2mYLbl5lR4', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-10 21:58:31'::timestamptz,
    'Abdulnasır Hatip', '99922788240', 'Suriye. İdlib', '2002-02-21'::date,
    'abdulnaserhatip@gmail.com', 'Merkez, Ecla Sokağı No:2, 34245 Gaziosmanpaşa/İstanbul', '05343753020',
    'Sağ', 'Sağ', 'çalışan',
    'Sağ', 'ev hanımı',
    10000.0, 4, 2,
    'Fatih Sultan Mehmet üniversitesi', 'İslemi ilimler', 'İslemi ilimler',
    '2.0', 3.85, 'https://drive.google.com/open?id=1kPf3UnARYEB3wKm_2n0tJezahhO6eMUs',
    'Abdulkadir kasap', 'Hüdayi vakfı', '05317851861',
    'Hüdayi vakfı', 'İslami ilimler', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'PHOTO', 'https://drive.google.com/open?id=10fQc2m0kKAWsj93rueTlMfjRvoxqFLpo', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'ID_COPY', 'https://drive.google.com/open?id=1-dF-C0u-Jwz-7W57_g6TN7_o0R-az8Df', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1E9Hx6Arg5Eggfb6DV5hW7RlLMj1rUWI0', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1kPt9Zd8jayJKDuW1hUnGELa1mUkX-r7I', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1i6YM4A_oWkWG0-V2SZLavcnsdkJq8eCH', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1wpJnbnpPjtoYdwl9BXAdkpKzhihTzaa3', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '99922788240'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1iI2vrd8cOFBuS5iaJqE8mhwo84IDZcOb', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-10 23:41:44'::timestamptz,
    'Muhammet İrfan KIRBIYIK', '31241287592', 'Kadıköy', '2002-08-04'::date,
    'irfnkrbyk@gmail.com', 'Çakmak mahallesi Varan Caddesi Bağdat Sokak no:52  daire:25 Ümraniye/İstanbul', '5.452246475E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    60.0, 3, 1,
    'İstanbul Sabahattin Zaim Üniversitesi', 'İslami İlimler', 'İslami İlimler',
    '3.0', 3.03, 'https://drive.google.com/open?id=1e0YlGVsTXwRd5ouWMLlVnilLupBcCFOy',
    'Abdulkadir Kasap', 'Aziz Mahmud Hüdayi Vakfı', '5.317851861E9',
    'Lider Eğitim', 'Geleneksel Okçuluk , Futbol', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'PHOTO', 'https://drive.google.com/open?id=1eSSzCjSd_8Vb91RunGskYalmgfnwVFTk', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'ID_COPY', 'https://drive.google.com/open?id=157bUHvYSy5ir9eX_uSDnWs_VghwpguqS', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1HTt1ziN-fACznNCaOWol7X5kU_uim1Cs', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=16gUjNd1qHhP3AVyMntJp5yyybpz1NVdp', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1gbSZ8GBbq38-UNWePFX5iHHBvcEfrA8k', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1MWD4bfJTJwUayWHt4qGVPN0GjjMaV2k9', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '31241287592'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1jevafeFf3hZ1N8ob-dRVK320M4yv5YF5', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-11 11:05:07'::timestamptz,
    'Şeyma Nur Yüksel', '10121052710', 'Çorum', '2005-06-04'::date,
    'seymanuryuksel05@gmail.com', 'Merzifon/Amasya', '05524608921',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev Hanımı',
    15000.0, 4, 4,
    'Boğaziçi Üniversitesi', 'İnsan ve Toplum Bilimleri Fakültesi', 'Sosyoloji',
    '1.0', 4.0, 'https://drive.google.com/open?id=19uqvqkYl0EqNpBwor1f6tqERRDugLouy',
    'Ali Osman Kaya', 'Anadolu Ajansı', '05458775424',
    'ÖNDER, İHH, Türgev', 'Elektro gitar çalabiliyorum, şan dersi alıyorum, dergicilikle ilgileniyorum lisede Arapça ve Osmanlıca dergiler çıkardım editörlük yaptım. Uluslararası MUN konferanslarına delege olarak katıldım. Türkiye geneli Arapça münazara yarışmasına katıldım lisem ile. Ebru sanatına karşı ilgiliyim.', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'PHOTO', 'https://drive.google.com/open?id=1ABOaTNx-OFKdBbyjMvBcGbtsMcKaaqQ3', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'ID_COPY', 'https://drive.google.com/open?id=1f2IDZfeHvSVDPcOX8bikpTAwfZyXw5qz', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1uO2Fep1w93SVfbpYlDDp-bYVoBUkZ7ps', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1pQGO5wFP0GGvHsQzQchnw2OyHOseGuOU', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1gK2UnC4kWB9MLBVcX2rdurHY2xb2ZQ4Y', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=19n-JPuEhSIagV52oKEvJ7YRZ2wPsr2YO', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10121052710'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1nutk5dLlTZ09bns0-8d22LYVMdoT-vsu', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-11 18:25:43'::timestamptz,
    'Arif Sezer Karayakalı', '48169913854', 'Eflani', '2004-01-31'::date,
    'arifsezerk@gmail.com', 'Şenyurt köyü merkez küme evleri no:37 Eflani/Karabük', '05316153533',
    'Sağ', 'Sağ', 'İmam Hatip',
    'Sağ', 'Ev hanımı',
    23800.0, 1, 1,
    'Marmara üniversitesi', 'İlahiyat fakültesi', 'İlahiyat',
    '3.', 3.09, 'https://drive.google.com/open?id=1lxJ7HiST04sEwZ8iWXlnn_a-RbMgkrG1',
    'Ali İzgi', 'Milli eğitim bakanlığı', '5.46726851E9',
    'Safa vakfı, İhh', 'İslami ilimler. Tefsir ve Hadis ilimlerine özellikle ilgi duyuyorum. Ayrıca sosyal olarakta futbol oynamayi ve izlemeyi severim. Gezmek, farklı yerleri gezmekte ilgi alanlarımdan birisi.', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'PHOTO', 'https://drive.google.com/open?id=1TsyGGqyM6yuAzpZmZ0UEog3mCcsa6JkU', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'ID_COPY', 'https://drive.google.com/open?id=1ZYo0QH8q7XMQhh7sIfIp5cHn2IsJeOjt', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1ZtF6D2w0BQFFoDfnX5L_BQLKX9XZaFRu', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1lgez6MvVEK3hSiFI2rRZe7YFuyUZEJQi', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1jDLPkv0hkOpMxUrMCHFiyyEvqf1Oeo8H', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1kOsLbLsvuXwqN7Y9KOdM5FjiWGO5X7O8', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '48169913854'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1c-pXJpy6tA06B4X2Mh6qdUPsGUT8vT67', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-11 21:29:18'::timestamptz,
    'Mustafa Turab Gediklioğlu', '51796282224', 'Kayseri', '2004-04-12'::date,
    'mustafaturabg@gmail.com', 'Zeyrek mah. Kovacılar sok. no 12 Fatih İstanbul', '05438496829',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'İşsiz',
    16827.0, 2, 2,
    'İstanbul Üniversitesi', 'İlahiyat', 'İlahiyat',
    '3.0', 3.1, 'https://drive.google.com/open?id=1wJ8AjcHGICJnJEN8EYNG9Q2ML39XV4or',
    'Ersin Dursun', 'Milli Eğitim Bakanlığı', '05076790805',
    'Aziz Mahmud Hüdai vakfı', 'Drone Pilotaj, Yazılım, Bilgisayar, Dil', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'PHOTO', 'https://drive.google.com/open?id=10l1Rhz1Q5AD8ELDHfY6vm8saAXAGaaqe', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'ID_COPY', 'https://drive.google.com/open?id=16SeztFR2i4MuZC6b6TzW3SY_5sP_63Al', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1TRo_FxiqDK4QLAAdYdhcTaW6BwnaIzaA', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Ok6e0FPijKjftFheJ-vz2eD2GpOk3PNY', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1XBTeSjf1-4NOGl-NvK1BklwTFX0S7z2A', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1_M72ImrD4895Y4-ceW_BWayehcMMMF8M', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '51796282224'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1aLIxRMo669ndg27Qhy-EQBdDuFaEofwQ', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-11 22:05:58'::timestamptz,
    'Muhammed Furkan YILDIRIM', '10513875538', 'Bitlis/Hizan', '2004-11-24'::date,
    'm.frknyildirim.13@gmail.com', 'Battalgazi mah. Kaptanı derya Cad. Gürsoy sok. No:11  İstanbul/Sultanbeyli', '5.510181577E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    16881.0, 4, 1,
    'İstanbul Gelişim Üniversitesi', 'Mühendislik ve Mimarlık Fakültesi', 'Endüstri Mühendisliği',
    '1.0', 4.0, 'https://drive.google.com/open?id=1Wym06ZsiJQBsPJ0xz82CVawZZIbsWq7v',
    'Muhammet Usama Yıldırım', 'Öğrenci', '5.060597166E9',
    'Yok', 'Fıkıh, teakwando, futbol, yüzme, masa tenisi, mangala', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'PHOTO', 'https://drive.google.com/open?id=1JOXEZp6-wyrEuzJ9nB1HU6fwq1APeJhd', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'ID_COPY', 'https://drive.google.com/open?id=1Zq8Z_tlIzZHdzYsmNfDoOC8R4w_1YA-y', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1yiSkovkL_kaKF3fsSe-rSjv8EpCs7wnQ', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1YPc1lefYf95vUbJNdBwdpwieaevMQezh', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=16jDyFcxk9z-LW1zTi9H5rcEzXwfbRd5b', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=178LD-dcbv0GIfCFMA_dgvu9i2Y-C-SA6', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10513875538'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=18FzEFoMgsRxXga8ICWIoAfNdZ3zLFEsL', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-13 18:33:48'::timestamptz,
    'Tayyib Erkam İPEK', '24847047196', 'Dinar', '2003-08-20'::date,
    'tayyib1402@gmail.com', 'Karaman Mahallesi 1762 Sokak No:1 Kat:2 Daire:4 Merkezefendi/Denizli', '5.510176424E9',
    'Sağ', NULL, 'Apartman görevlisi',
    'Sağ', 'Ev hanımı',
    40000.0, 3, NULL,
    'Sabahattin Zaim Üniversitesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Bilgisayar Mühendisliği',
    '2.0', 3.58, 'https://drive.google.com/open?id=1q1adDKg7fDwuUxXL78cuPmI7K4HJ3Gw-',
    'Ahmet Erdihan', 'İstanbul Sabahattin Zaim Üniversitesi', '+905451727872',
    'Yedihilal, TÜGVA, Kızılay..', 'Yazılım, yabancı dil,  kitap okuma, film izleme', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'PHOTO', 'https://drive.google.com/open?id=1jwc3UQdh4VKcsi-WQgrWqRF6k3yDOTBb', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'ID_COPY', 'https://drive.google.com/open?id=1_iWL_gOrdMPPv8zORjrv17twCX5uMrDw', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1uR6xKMz1Pl7QRz0nmCFcuiaVBKn6Ip2d', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1QLVV-UFXXUt4__5zG8gsZ2Tx7tGhKB41', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1GzCHXQ1ct6B1JtUSH87yBbfVz-vLhrd8', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Brls1Uk9YClp7BHbfpbtdnJaD6k-5aXq', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '24847047196'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Gc0Clx2BSMCifVxjvFbmvmFHGN1a-n6g', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-13 18:47:11'::timestamptz,
    'ebubekir yılmaz', '45499776012', 'rize', '2002-01-08'::date,
    'ebubekiriphone6@hotmail.com', 'ahmediye cad iskender paşa mah no 30 iham derneği fatih istanbul', '05326435569',
    'Sağ', 'sağ', 'memur',
    'Sağ', 'ev hanımı',
    73000.0, 4, NULL,
    'istanbul üniversitesi', 'ilahiyat', 'ilahiyat',
    '2.0', 2.63, 'https://drive.google.com/open?id=160y72elWxSgD3V3XY-Kjqpd-ZncM4kDP',
    'hasan avcı', 'ensar vakfı', '05465353539',
    'iham derneği', 'spor kitap', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'PHOTO', 'https://drive.google.com/open?id=1r-BNhr9tYSitHnObtEKm7UHBMwYkXOTQ', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'ID_COPY', 'https://drive.google.com/open?id=1FyuIZRdZUbe-GpGt-uqhjm5ExWvoteGr', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1FeiGW_-YQsBNjEVnYsyUm0GJcUBXQeE3', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1xoXgEhKw0r_CsfXXYsd4TVd9cNLjIkE_', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1VFB0Rl0tXLmoGB4zQEpF_AX1tGB2z987', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1GYCkOg9bQfBt6aO3MvQY0FRLI6gOKs-9', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '45499776012'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1F1JCBzdtTDEEoPwvJuqJEizXv2JEJMle', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-13 21:54:03'::timestamptz,
    'Sumina koç', '16100360210', '2004.0', '2004-11-26'::date,
    'suminakoc3434@gmail.com', 'Mevlana Mahallesi 869. Sokak Nur Sitesi E blok daire 26 GOP/İST', '5.458674214E9',
    'Sağ', NULL, 'Okul müdürü',
    'Sağ', 'Ücretli Öğretmen',
    86.0, 1, 1,
    'İstanbul Atlas Üniversitesi', 'Tıp Fakültesi', 'Tıp',
    '1.0', 3.0, 'https://drive.google.com/open?id=1hxzrN1lWOMe2KTXDNlHvD9FZV-UlS1Hp',
    'Esma Ertürk', 'Milli Eğitim Bakanlığı', '05377691989',
    'AGD, İHH,Genç Derneği, Yetim Vakfı', 'Yüzmek, sosyal yardım faaliyetlerinde bulunmak, yeni yerler keşfetmek…', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'PHOTO', 'https://drive.google.com/open?id=1xhVShBR3beM4YZIAtQrAAuhx8QFbN8xo', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'ID_COPY', 'https://drive.google.com/open?id=1b-vEV4kttCx68lamXTd4pxCrEnH9XQRp', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1HUaaM6RHNFXnF716JKuYPWmjUbvZ0SIW', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1yXaOBcJN0hcI35yR_zGFtwq49oJ--_w0', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1A9XRo3KPu4V4x1Fmm8rl1MRNUTfQaJx1', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=140iRVgs2Hcxqgo9CvD_Qos-hqgbRmzOm', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '16100360210'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1dPvFcD6gskYi7qcn-Ljy5AT9nTb5Cjcw', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-14 10:53:19'::timestamptz,
    'Vedat Dartan', '14067024442', 'Batman', '2007-07-12'::date,
    'drtn7221@gmail.co', 'Batman Kozluk', '5.550912572E9',
    'Sağ', 'Sağ', 'Çiftçi',
    'Sağ', 'Ev hanımı',
    5000.0, 4, 4,
    'Marmara', 'Atatürk eğitim fakültesi', 'Özel eğitim',
    '1.0', 4.0, 'https://drive.google.com/open?id=192WFHP6uIeE_KLUTNVNLj1bbb3dQedBK',
    'Hasan Güneş', 'Batman Gazi Erkek Anadolu İmam Hatip Lisesi Rehberlik Öğretmeni', '5.3484102E9',
    'Yok', 'Tarih, dini kitaplar, felsefe, coğrafya, sosyal bilimler', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'PHOTO', 'https://drive.google.com/open?id=16HHvY2TR8qhIOllj6yXYgbVCMlZ76cvy', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'ID_COPY', 'https://drive.google.com/open?id=1rLFJk378b59V5Uc7gZfBM6jbzRUuzJMW', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1zNua6HlHRd_i4n6v8Ys2STh_M5SikCQr', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1qA9acxJDKU2fHzdG-WM5jvhFYzzthT67', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1GjY2QEfe2LIazaTiSoqScXfKs2BTu9mU', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1vQ8w5mqvviyaIciT040sFq7oRy0G_thR', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '14067024442'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Qw5iE8NN2PlsDyrmEIYNeTOeEbU5LhjT', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-14 11:39:31'::timestamptz,
    'Emre İliş', '10715612474', 'Kars/Sarıkamış', '2005-02-21'::date,
    'ilisadem594@gmail.com', 'Esenevler Mahallesi Mahir Caddesi No:7/9', '05511930176',
    'Sağ', 'Sağ', 'İnşaat işçisi',
    'Sağ', 'Ev hanımı',
    25000.0, 3, 3,
    'İstanbul Üniversitesi', 'İstanbul Tıp Fakültesi', 'Tıp',
    '2.0', 2.68, 'https://drive.google.com/open?id=1tvY5Lw6OoanUNclcOMoqEPNQf7V9OnRZ',
    'Mücahit Kıbrıs', 'İTO Marmara AİHL', '5.067606E9',
    'Yok', 'Kitap okuma araştırma gezme tarih sağlık teknoloji', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'PHOTO', 'https://drive.google.com/open?id=1SIf9j7sV9qdn61MBUUVQggmP0hJUxgjO', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'ID_COPY', 'https://drive.google.com/open?id=1Cx8GqGaun03zqNX4ryZyC0ivdwf0QrPw', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1crfWNISSHS_QyWLfSSxZg0XqfaZ9tYPn', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1uXTYutdPoNUl01C2TB3Ohv9jPIeGPDyB', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1yRVymoAd_TOhN1pcI2SduI4KyvqZjgdE', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1SG18RAd6EudtrbgxO_GlrSw2IiodeXGY', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10715612474'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1fv-z-fS6jPTvZEJUcaxi9dWi1mHoqQun', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-14 13:20:45'::timestamptz,
    'Ömer Özdemir', '10517516758', 'Beykoz/İstanbul', '2005-03-24'::date,
    'ozaliomer04@gmail.com', 'İncirköy mah. Tepeköy mevkii Ay sokak no:1  Beykoz/İstanbul', '05511377384',
    'Sağ', 'Sağ', 'Malülen emekli',
    'Sağ', 'Ev hanımı',
    30000.0, 1, 1,
    'İstanbul Üniversitesi Cerrahpaşa', 'Mühendislik Fakültesi', 'Çevre Mühendisliği',
    '3.0', 3.01, 'https://drive.google.com/open?id=1OyxcVP51jPOGrdZkdzZZzZb32wclJzKG',
    'Ramazan Küpdel', 'Ajet', '05078897141',
    'Anadolu Gençlik Derneği 
Yeşilay Cemiyeti', 'Sosyal alanlar', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'PHOTO', 'https://drive.google.com/open?id=10hyUVu9HHEIkgoRtK0QbfQodGHxUeykR', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'ID_COPY', 'https://drive.google.com/open?id=1Zi33HK76SfG3JkfikoskpcC8VApLwk8Z', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=12m6J6ZVN3X0Ln93sWyBWShJ_w1-YiOtl', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1aKI65dgzD8YImiOVSl4bbh2VlRZFlVaa', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1oS9HydeUJRVRk-kp3X8gase5LZO2skIZ', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1xXVpCfp6fYOLJW_aq5Ty3I1jpvFPBu2P', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10517516758'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=14Zxv_atjKH4fdK4YNxMrWqv6nsDIQQg6', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-14 21:37:11'::timestamptz,
    'Mustafa İsmail Bilgin', '23594110948', 'İstanbul', '2005-11-11'::date,
    'mismailbilgin@gmail.com', 'Yeşilvadi Caddesi Ortaköy Sitesi C 19 Başakşehir İstanbul', '05511793026',
    'Sağ', 'Sağ', 'Memur',
    'Sağ', 'Ev Hanımı',
    160000.0, 2, 2,
    'Bezmialem', 'Tıp', 'Tıp',
    '2.', 3.12, 'https://drive.google.com/open?id=1hWtd2m2TVVSU_c97QEuLyHWfPFDtHBvu',
    'Şeymanur Karagöz/Tuğba Naz Yıldız', 'Dostluk Vakfı', '05066516158',
    'Bezmialem Tog', 'Futbol,Tarih,Kitap,Masa Tenisi', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'PHOTO', 'https://drive.google.com/open?id=1lOA0EyfDV31TWyb_yV4nIg5wpBHOTkuN', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'ID_COPY', 'https://drive.google.com/open?id=1N5E2cEQhnwYQmHZYUvTpdPk7dCSDA4A2', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1gJz0hBXZt2kWGTZfmNDYY7JidusqIxgR', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1clWYi_Iwz9AYa0uE8Wu_o35UtbFV52B4', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1B5BoB08X5yArQgkifbyXz1bDTLZPfhg9', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1um1_tD6VDDeT6P_LEzQJIP3hr_cLtj4n', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '23594110948'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Jk40c4uJs2zvVBNwHlHAgDRSvTbHCObC', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-16 16:39:10'::timestamptz,
    'Enes Emre Türkmen', '10268076280', 'Çorum', '2006-08-04'::date,
    'enesemreturkmen19@gmail.com', 'Fatih Mahallesi 3003. Sokak Uzunbacak  Apartmanı No:14/13 Çorum/Sungurlu', '5.550235729E9',
    'Sağ', 'Sağ', 'Eczane Kalfası',
    'Sağ', 'Fahri Kuran Kursu Öğreticisi',
    43000.0, 2, 2,
    'Marmara Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat %30 Arapça',
    '1.0', 1.0, 'https://drive.google.com/open?id=1G759lhKEFG6HodN9TAXjFVyfxFelYETK',
    'Bekir Sami Ünsal', 'Ünsal Eczanesi', '5.32356397E9',
    'Gaye Vakfı', 'Fitness', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'PHOTO', 'https://drive.google.com/open?id=11gAz0BPUVPsP6yu70w-sj1WNTLN-Uz45', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'ID_COPY', 'https://drive.google.com/open?id=1ROZmI_GksOV13AcKB41oQ9W2sC9FIanp', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1-AM63G7ZwSf4IvV02L-zEaWbw86bjH8J', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1T_OvSclZIhrxHF25rg7wpAtLk0K0jq9w', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1YOeM87qRu741dEOcfPycOjlUGn9zYx53', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1nn2XNeOi5VrrxzWx5M5fkCnykLyOpSRx', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10268076280'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1QyeJ7qpbPCh1jtZlyYjmyapLfPI3BE7a', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-17 14:14:12'::timestamptz,
    'Ali Taha Erdoğan', '10529823516', 'Sakarya/Hendek', '2005-09-26'::date,
    'alterdogan1@gmail.com', 'Ferah Mah. Kartal Sok. 49/2 İstanbul/Üsküdar', '5.511371537E9',
    'Sağ', NULL, 'Eğitim Koordinatörü',
    'Sağ', 'Ev Hanımı',
    40000.0, 4, 1,
    'İstanbul 29 Mayıs Üniversitesi', 'İktisadi ve İdari Bilimler Fakültesi', 'Siyaset Bilimi ve Uluslararası İlişkiler',
    '2.0', 3.5, 'https://drive.google.com/open?id=1SahUgBI0C2gPyZpM9ZhOjJDqmfZebTgZ',
    'Hüseyin Suiçmez', 'Hakkı Demir AİHL', '5.334794561E9',
    'Şahsiyet Derneği 
TTOK
ÖNDER
Hüdayi Vakfı 
Yardımhane Derneği 
Lider Eğitim', 'Türk Sanat Müziği 
Öğrenci Toplulukları 
Münazara Toplulukları
Spor Kulüpleri 
İzcilik Federasyonu', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'PHOTO', 'https://drive.google.com/open?id=1R2RERFLSHlqjtxxa2pg3fM_4JrdgZvJf', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'ID_COPY', 'https://drive.google.com/open?id=1O8H1qkqNKWPGU5PdoMk3jHeVNdFEfKdT', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1UP-N6K2acWP0gMyuO9AvE7neIQaiVt5H', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1XA6gCRPLsF-narAV8XHacghrA7WNxsNA', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1d8ZdwX0j4Y9-vZNNL8V83a3O5bNtPWF3', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1AuyenQ6sm9bGqDsK2hcmhZnD1_x_-BKt', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10529823516'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1K4LKfa0xqC4tg8GsgeabToPcUl1kQnVD', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-17 15:29:42'::timestamptz,
    'Ahmet Kefçi', '32437612648', 'Hatay Antakya', '2004-02-08'::date,
    'Ahmet.kfc@outlook.com', 'Selamiali mah. Selanikliler sk. No:44-2 İstanbul/Üsküdar', '05540073431',
    'Sağ', NULL, 'İmam',
    'Sağ', 'Ev hanımı',
    58000.0, 2, NULL,
    'İstanbul Medipol Üniversitesi', 'İletişim', 'Yeni Medya ve İletişim',
    '3.0', 2.9, 'https://drive.google.com/open?id=1DHt8Re8IenbgNwvl922i5cUE7hc_8-GX',
    'Ali Esmerli', 'Merter Hukuk Bürosu', '05519479839',
    'PENDER (Pendik Ömer Çam AİHL Mezunlar Derneği)', 'Seyahat etmek. Kültür ve bölge araştırmaları. Dil öğrenmek. Toplumsal okumalar. Film analizleri. Spor yapmak. Hareketli etkinlikler, aksiyonlu sporlar. Arabalar.', 'İngilizce, Arapça, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'PHOTO', 'https://drive.google.com/open?id=1sFeyGTruVmLYsXudEW8FRuo_-k-wHk1g', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'ID_COPY', 'https://drive.google.com/open?id=1S631oqKNDxO8DWAdJm3dnHlzZWFCiBsx', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1tekZwbfv4Dr0J0jByHyEBKd4eTHc0fZa', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1MvoNvMSfD9FUhN3hTqcuMnlaHJF-WrSE', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1nWKladQgUu4kHnr5HA_A6qcxQFD7RLTo', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1g7UC2rj-JKPBGpBSsFFZealJz4Et1qSs', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '32437612648'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1U_f_CEkNs8e87wcPlfLoSwPijLDo16Q5', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-17 22:18:46'::timestamptz,
    'SAFA MERVE ZEHİROĞLU', '36929170524', 'SÜRMENE', '2003-11-10'::date,
    'zehiroglu.safamerve@gmail.com', 'ÇAMLICA MAH. ADNAN MENDERES BUL. NO:  103 İÇ KAPI NO: 7 BOYABAT / SİNOP', '05531757261',
    'Sağ', NULL, 'Öğretmen',
    'Sağ', 'Hemşire',
    100000.0, 2, 1,
    'ÜSKÜDAR ÜNİVERSİTESİ', 'MÜHENDİSLİK VE DOĞA BİLİMLERİ', 'ELEKTRİK ELEKTRONİK MÜHENDİSLİĞİ',
    '2.0', 2.86, 'https://drive.google.com/open?id=1ShTk92zcyj2lXt3mJfa230m2xLYwkahO',
    'SADIK ÇAKIR', 'VAKIF YÖNETİCİSİ', '05355471537',
    'Society for Science (ABD)
Türk Kızılayı', 'Bilimsel araştırmalarla ilgileniyorum. TÜBİTAK Araştırma Projeleri Yarışmasında Fizik''te Türkiye derecesi elde edip dünyada 1000 kişinin seçildiği dünyanın en büyük mühendislik ve bilim olimpiyatı ISEF''te Türkiyeyi temsil ettim ve projelerimi Nobel ödüllü bilim insanlarına sundum. Patentini almak ve makalesini yayınlamayı planladığım çalışmalarım mevcut, okuyup kendimi geliştirmeye çok değer veriyorum. Buna ek Satrançta Karadeniz bölgesinde en iyi kadın sporcu geneldeyse 2.en iyi sporcu seçildim. Müzik kulağım iyidir, keman çalıyorum. Resim ve metin yarışmalarında Türkiye dereceleri kazandım, cumhurbaşkanımızın önsözünü yazdığı metnimi de içeren bir kitap da basıldı bu süreçte, sanatla uğraşmayı severim. Ulusal uluslarası 20''yi aşkın MUN, TED, ERASMUS vb konferans düzenlenmesinde yönetimde bulundum, bu yollarla İngilizce olmak suretiyle politika ve siyasi konularda derinlemesine çalışmalar gerçekleştirdim. Vakit buldukça yüzme ve atletizmle ilgileniyorum. Tarihi camilerde gönüllü olarak turistlere yardımcı olmayı seviyorum. Türk Savunma Sanayine büyük ilgi duyuyorum ve şu an Teknofest''te yarışmak üzere bir İHA projesinde kaptanlık yapıyorum. Şehit aileleriyle bir arada bulunmayı seviyorum bu sebeple Edirnekapı Şehitliğinde düzenlenen anma ve mevlüt programlarında yardımcı olmaya çalışıyorum gönüllü olarak.', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'PHOTO', 'https://drive.google.com/open?id=10MACF1j_cjVl5RYXQkDvEgkDsvjZTBWs', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'ID_COPY', 'https://drive.google.com/open?id=1eN-yrJ6uW0zn0okuPj_Gj1AQocmbUDBa', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1HF-rukSvXeh7s9mXru9cxuNJEhSemqBI', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Wo2jv40tDr-Ei06dsZDWo2tgI1PsR_bO', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1we7e02SkWV0vD4KOXWLiokpCMJWUJ-Lf', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=16Sg9vhv9_SOiO5OxAjD03o6P1VsW9YZ8', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '36929170524'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=18cPkjkrm5nKGtPC0qMFBaX4MfOjJP54r', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-18 23:40:56'::timestamptz,
    'Nurettin Özer', '25094024534', 'Bağcılar/İstanbul', '2003-08-18'::date,
    'nurettinozer@ogr.iuc.edu.tr', 'Gümüşpala Mahallesi, Yelpaze Sokak, No:23, D:5 Avcılar/İSTANBUL', '5.443609145E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ücretli Öğretmen',
    55000.0, 2, 2,
    'İstanbul Üniversitesi - Cerrahpaşa', 'Veteriner Fakültesi', 'Veterinerlik (5 yıllık)',
    '4.0', 3.47, 'https://drive.google.com/open?id=1LhLmiXFKro1Xl1LpLvai1RkIl3EvWrCb',
    'Mehmet KOÇ', 'Anadolu Gençlik Derneği', '5.352947787E9',
    'Anadolu Gençlik Derneği
İlim Yayma Cemiyeti Avcılar Şubesi', 'İslam Coğrafyaları
Ülke ve Dünya Siyaseti
İslami İlimler', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'PHOTO', 'https://drive.google.com/open?id=1PWzInDmRt1gkg7mYIs-B1gqq5SY90vP3', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'ID_COPY', 'https://drive.google.com/open?id=1dc0gBzl0i6sOCfTdxkgNjl8-KoB-J94U', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1X4LbS9rJ3kWy9bFhEcWTOU_vqqjq6L9W', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1CeY9arKHQFu_iEQaoQNaYkZrb90TF07S', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=18w-AdxYsOgM7H1vWbvZBhJie7GZlv_ig', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1GoCT7Wr1B6fZT_ws6zjFix9Rp2jQ44lF', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '25094024534'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=14vc9pPm1E-2T_SrTilk5UAzx9ccElHYb', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 02:36:05'::timestamptz,
    'Ahmet emin şahin', '10205340634', 'Gümüşhane', '2006-11-06'::date,
    'aeminsahin34@gmail.com', 'Cumhuriyet mah./atmaca sok./işcan apart./Daire:4/No:1-3/Bahçelievler-İstanbul', '05427285161',
    'Sağ', 'Sağ', 'Milli egitim şube müdürü',
    'Vefat', NULL,
    63000.0, 2, NULL,
    'Düzce üniversitesi', 'Düzce üniversitesi  mühendislik fakültesi', 'Elektrik elektronik mühendislik',
    '1.0', 3.5, 'https://drive.google.com/open?id=1pS-1FWxjDE7DcCaDJMS_6jEiVw-6dX0g',
    'Kadir şahin', 'İstanbul ESENLER MİLLİ EGİTİM müdürlüğü', '05055842729',
    'Üye olunan dernek vakıf yok', 'Spor yapmak satranç oynamak yabancı dil çalışmak gezi yapmak', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'PHOTO', 'https://drive.google.com/open?id=12FEw8UGD27Gv2zhSg33WVIPra3qdjd-l', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'ID_COPY', 'https://drive.google.com/open?id=15ARSrsPNGZ3Fu_XaBvXwmz3In6VibyJQ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1Kork7chAIjqLZphPxqT1TPSvwJzFDQHs', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1sKRhFPzfty9FD45z4Th3IViJTXMj2z-b', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1y8VsY-dU9vcicldy_PH7GvgKbd96Dot0', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1tEF4ARiyg8grT4wNWyso668b8q2Ol2a-', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10205340634'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1afDpy40_O_DHeksLv6CeN72kp7erzKQW', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 08:32:45'::timestamptz,
    'Mehmet Ali Altay', '21578714274', 'Uşak', '2005-10-08'::date,
    'aydinana04@gmail.com', 'Atatürk Mahallesi 5. Nilüfer Sokak No:7', '05525348284',
    'Vefat', 'Vefat', 'Yok',
    'Sağ', NULL,
    16800.0, 4, 1,
    'Marmara Üniversitesi', 'Tıp', 'Tıp',
    '1.0', 4.0, 'https://drive.google.com/open?id=1DDq3aYcNY9RGrilCmXDuplcqYNl7M7rt',
    'Yok :(', 'Yok', '5.0',
    'Kutu Kutu Tebessüm Derneği', 'Arkadaşlarımla gezmek, ders çalışmak', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'PHOTO', 'https://drive.google.com/open?id=124NhZKT831GFitpId0hOzJMYKLBOVSdP', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'ID_COPY', 'https://drive.google.com/open?id=1JKjh9g1kM6wAbxYl1VsH98ifYIFA3QUW', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1RFLVuCgUEPwlXumpyY8C73N6FppnoLYA', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1ZUbNXK0l9oKHWvf1CODfFF2r4pNQJxi5', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1kj3n9tJ2RCv69VOI7oEK18MHzaQky-63', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1AkbRH0B74dEMfjPKyTBUi7Q6tpl1r88z', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '21578714274'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1tleR287_e9bAZe9WUzUOrMl0rjvq1vlT', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 11:45:16'::timestamptz,
    'Musa Alçiçek', '10580164320', 'Kovancılar', '2006-01-12'::date,
    'alcicekmusa580@gmail.com', 'Elazığ kovancılar ismetpaşa mahallesi bedevi caddesi no 85', '05456991678',
    'Sağ', NULL, 'Emekli',
    'Sağ', 'Evhanımı',
    17359.0, 4, 2,
    'İstanbul Aydın üniversitesi', 'Fen ve Edebiyat', 'Arapça mütercim ve tercümanlık',
    '1.0', 3.6, 'https://drive.google.com/open?id=1Qi5DES01hS4TT23wFVR1h6l9l2yjUxnu',
    'Mehmet Koç', 'AGD-MGV GAZİOSMANBAŞA İLÇE BAŞKANI', '05352947787',
    'AGD', 'Tarihi Araştırmalar,kitap okumak,Kültürel geziler,fotoğrafçılık,spor', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'PHOTO', 'https://drive.google.com/open?id=1to7RX5Gi5a3vE4jcoecb2UGrRxRsr5ZK', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'ID_COPY', 'https://drive.google.com/open?id=1b2kubgcruMzUqasL3Hs8Tfa-5ot9jGBB', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1nSFyUB2OcTPZI8SbogV1lTghEPsZ6YcG', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1McmhlFIW_zb2DpGqn24yOK_umaxtcsio', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1j1iGKvBbow9wzccoT9vzJ-adGxuIyKpW', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1V5RtnSXuibUulXldzGFHmbiLnoB5iC4C', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10580164320'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1h0pqyc8IhyehX8oCkk09HDz7PwXFhT1K', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 11:58:02'::timestamptz,
    'İsa Alçiçek', '10985151628', 'Kovancılar', '2007-05-02'::date,
    'isa.alcicek6458@gmail.com', 'Elazığ kovancılar ismetpaşa mahallesi bedevi caddesi', '05539479332',
    'Sağ', 'Sağ yaşıyor', 'Emekli',
    'Sağ', 'Ev hanımı',
    17359.0, 4, 2,
    'İstanbul selahattin zaim üniversitesi', 'İslami ilimler', '(Arapça) İslami ilimler',
    '1.0', 1.0, 'https://drive.google.com/open?id=1RxYrGlJ9atAbqnDvPDDQXQIXJ2VMz3Oq',
    'Mehmet koç', 'AGD-MGV GAZİOSMANBAŞA İLÇE BAŞKANI', '05352947787',
    'AGD', 'Kitap okuma,islami bilgiler alanında uzmanlaşma,ilmi araştırmalar yapmak,satranç  oynamak,bisiklet sürmek.', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'PHOTO', 'https://drive.google.com/open?id=11XlTfg-I4W4HXjYZsqJH0m_RyDYZZG1e', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'ID_COPY', 'https://drive.google.com/open?id=1M6aFuQxUwKRTV74m2C2B39-Me1bbx-Sr', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1xJgCPj3h2SYaBTyRJbP2iiMvOT2Xf9SI', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1oZL4hp2rroAwaSnlo466VJ9rMg9NGBzc', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1twSeeQ5xw5WtkxpEyE1JgQiQuw7ntt32', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1EsOBh0LMdGM01aDCvdNZK7xdS4_1sP1y', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10985151628'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1fFhFCKizGaBFNce5D7G85gLFN454FK0L', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 12:02:28'::timestamptz,
    'Ali Fuat Erdoğdu', '39064719368', 'Kayseri', '2004-05-24'::date,
    'ali.fuat.erd@gmail.com', 'Kayseri', '05386941077',
    'Sağ', 'Sağ', 'İmam',
    'Sağ', 'Ev hanimi',
    65.0, 2, NULL,
    'İstanbul Sabahattin Zaim Üniversitesi', 'İnsan ve Toplum Bilimleri Fakültesi', 'Siyaset bilimi ve uluslarası ilişkiler',
    '2.0', 1.27, 'https://drive.google.com/open?id=1J255-kA9pBOZ0H7TFroQ9XD0fqzltPfZ',
    'Mehmet Koç', 'AGD', '5.352947787E9',
    'Agd mgv', 'Yabancı dil fotoğrafçılık vakıf çalışmaları', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'PHOTO', 'https://drive.google.com/open?id=1inuvqDwdz4BnNVdqhtnixn5S2P4NGN_3', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'ID_COPY', 'https://drive.google.com/open?id=1P_8M8nkprR_fTIiSzqNbHudwMoF-X01L', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1GcT-Yt8KsA-MIWQrHdozwsg1jOR50t-E', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1vR5yYeQG8m8fKnX0WnPRnOJuxB2WJfp2', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1IbPA_8Xlto8Wmc_H1E9mcD6U0auO-1od', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1OrrL4ZpN_sCsB6yJFZWyAXPjLyPNEMrh', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39064719368'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1RgivgHWOr1XCA3tP0AEYyE-GXVRMWboj', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 12:44:35'::timestamptz,
    'Ahmet Yusuf Demiryürek', '37426657358', 'Kartal', '2004-08-24'::date,
    'ahmed.yusuf.demiryurek@gmail.com', 'Zümrütevler mahallesi başaran sokak no:57 daire:8', '05511344972',
    'Vefat', 'Vefat etti', 'Öğretmen',
    'Sağ', 'Ev Hanımı',
    36000.0, 2, 2,
    'Medeniyet Üniveristesi', 'Mühendislik ve Doğa Bilimleri Fakültesi', 'Endüstri Mühendisliği',
    '4.0', 2.2, 'https://drive.google.com/open?id=1VyZAeGqPt8M7y77oDxw2DZVOxHIMLs1W',
    'Mehmet Koç', 'AGD', '05352947787',
    'AGD', 'Futbol, Siyaset', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'PHOTO', 'https://drive.google.com/open?id=1TF51e4hizqdPl6Vb480gD4Pjf0y1AqDm', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'ID_COPY', 'https://drive.google.com/open?id=1A3lF48a9CqP1pBWV0m2zYYyRom0Blze3', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1FUt098vXhtuUMai5nFBlH26v9km3VrX3', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1x4cbVDqT4FfBYvG4uKaCG_e7mDCDCHEf', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1qenZARhT8VokG0FM9UC3LBiO0KmFKVet', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=17Gf4cR-QeHtKAYZYxXUEGLFvzFABgjYl', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '37426657358'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ClXNP5Z968jSSZWf5squnYz0qAXoq7Vb', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 12:45:28'::timestamptz,
    'Ahmet Yasir Pertekli', '30544887706', 'Pendik', '2006-09-17'::date,
    'ahmetpertekli@gmail.com', 'Güzelyalı mahallesi bayrak sokak no13 daire5 pendik istanbul', '5.013441333E9',
    'Sağ', NULL, 'Serbest',
    'Sağ', 'Ev hanımı',
    40000.0, 3, NULL,
    'Fatih Sultan Mehmet Vakıf Üniversitesi', 'Hukuk fakültesi', 'Hukuk',
    '2.0', 1.71, 'https://drive.google.com/open?id=1y_2Cc9TzKoYxOqWBJw3ditBnZGp7-kHz',
    'Mehmet Koç', 'Agd Gop ilçe başkanı', '5.352947787E9',
    'Agd', 'Spor hukuk', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'PHOTO', 'https://drive.google.com/open?id=1audkA0nEJkXR3yDXH_WOPAjWWaPhUB6e', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'ID_COPY', 'https://drive.google.com/open?id=1qF3dFGtoNLJNBUdNLWc1C0ypwPXeIzUE', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1qHBv0zvoYUh3kfe7VQJwtoDJAFTzbb56', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1HhDxFTki5dIxzuhtco5FJeda5NhfR30j', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1ASU5qnVPYZ-zX13gIWO4DfsCvnSKj01o', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=19vdAatL69AQC-hSu52jzPnBszGRsCIOx', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30544887706'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1kh3UuKOJyOc6ZGsxBTBHdqGbBWz4rNUG', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 14:25:40'::timestamptz,
    'Yunus Emre Çakır', '17081626326', 'ÇEKEREK/YOZGAT', '2002-04-25'::date,
    'cakiryunusemre126@gmail.com', 'Aydınevler Mah. Aşık Veysel Şatıroğlu Sok. No:7/6 Maltepe/İstanbul', '05417430566',
    'Sağ', NULL, 'Çiftçi',
    'Sağ', 'Ev Hanımı',
    22104.0, 2, 1,
    'Marmara Üniversitesi', 'İşletme', 'İşletme',
    '3.0', 2.73, 'https://drive.google.com/open?id=1KWtHhEqzN1q5uj_9Blgrfk-_hqIegcy4',
    'Mehmet Koç', 'AGD', '05352947787',
    'AGD', 'İslam İktisadı', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'PHOTO', 'https://drive.google.com/open?id=1m7tZ2a4_YVwU97in1iekkzFqZoPdL5AU', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'ID_COPY', 'https://drive.google.com/open?id=1z83DgocyPkDTbpbtYtYD529QnTQ1aNcy', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1aRN6Dn8XKGvMyuihEKyB4UwoCrYI5HBR', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1mes38qFMpXrmPvWlOKwxA4owaFDA0NdA', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1pBlk84FA4XqrNs-Kzo1zrxwvdcUd6Te0', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1C88wzW09yTnDLB-MoCGJ9jcMR0uuaHji', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '17081626326'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1QpB-wxNdQlsnJE4iZ6f1nwkDFkvy3aR1', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 15:19:51'::timestamptz,
    'AHMED AFFAN OSKAY', '42167028022', 'UŞAK / MERKEZ', '2006-06-07'::date,
    'oahmedaffan64@gmail.com', 'fatih mahallesi 6.ülkü sokak Gökay apartmanı no:33 kat:1 daire:2', '5.379290424E9',
    'Sağ', 'sağ', 'serbest meslek',
    'Sağ', 'sağ',
    13561.0, 3, 2,
    'İstanbul Üniversitesi Cerrahpaşa', 'Mühendislik Fakültesi', 'Elektrik Elektronik (İngilizce)',
    '1.0', 4.0, 'https://drive.google.com/open?id=1-LB1RZhHZdM4mOuodkamoFlDX27TNdvV',
    'Mehmet Yaroğlu', 'Anadolu Gençlik Deneği', '5.35314076E9',
    'Anadolu Gençlik Derneği', 'voleybol', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'PHOTO', 'https://drive.google.com/open?id=1lvW2V3HQwO_0qF7CLrglSjGN31queZUI', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'ID_COPY', 'https://drive.google.com/open?id=1XSsa_jcjEmpex8zQp3QC-NU2GtxM8o2T', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=19HFed22VEXOOQEHxNPWFvYVJaUWqWpoK', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1p8bf3HjlBY0Dzc2hRzpU0PJ9yfqK3j6-', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1dvGbQ4eb4K74mQLRlCiJBClqDiKcxqQa', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1RMF-PcGwofQ_2RGwuMCQPFvHERxfytf8', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '42167028022'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1fJdp-wWLPSZd-sf1rkfQVLDtX3Oq1lwO', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 18:07:50'::timestamptz,
    'yusuf ramazan gider', '11281952650', '05.10.2005', '2005-10-05'::date,
    'rgider313@gmail.com', 'MİLLET MAH. 6.BÜLBÜL SK. G BLOK NO: 25  İÇ KAPI NO: 12 YILDIRIM / BURSA', '05522244471',
    'Sağ', 'sağ', 'memur',
    'Sağ', 'yok',
    40000.0, NULL, NULL,
    'beykent', 'meslek yüksek okulu', 'patoloji',
    '1.0', 4.0, 'https://drive.google.com/open?id=1OiVzrFFgOU2HBHXQioH98XI056kCPVHq',
    'mehmet koç', 'anadolu gençlik derneği', '05352947787',
    'agd', 'yok', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'PHOTO', 'https://drive.google.com/open?id=1cMjunZYSuYJOKxZUkic8EMI5mEyRKiil', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'ID_COPY', 'https://drive.google.com/open?id=1A-dLQszH8Lj0braUl3JvU1i_e2DR5IOL', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1cS57FIJAEJS6UKQj3fSuARkM4xpNw5HA', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1A_78cDViWyWmJrDRqgFT06z2EFXAy_5U', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1P6khd_tJJJ6mT8-ylVp2z9DZVEIF8QJe', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1mOonl-5BWb2YSJcaOE-WKhV4DeOwSozR', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11281952650'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Tdx1e1Dtu464sLTjHKUhGRov84R2mafr', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 19:46:06'::timestamptz,
    'Bedirhan Gümüşçü', '10319392918', 'Mersin', '2005-02-03'::date,
    'gumuscubedirhan34@gmail.com', 'GÖZTEPE MAH. DÜLGERZADE SK. NO: 6 İÇ KAPI NO: 26 BATTALGAZİ / MALATYA', '5.524642644E9',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'yok',
    41371.0, 3, NULL,
    'YILDIZ TEKNİK ÜNİVERSİTESİ', 'ELEKTRİK-ELEKTRONİK FAKÜLTESİ', 'KONTROL VE OTOMASYON MÜHENDİSLİĞİ',
    '1.0', 3.5, 'https://drive.google.com/open?id=186x12JBYE-U0jp2wk-LBskIZ6o0JyXW9',
    'Taha Özdemir', 'Mali Müşavir', '5.359651671E9',
    'yok', 'Halk Oyunları ve Bireysel Sporlar', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'PHOTO', 'https://drive.google.com/open?id=1tCCHAyVAK5qYKCftvXI8ifihopy42NXk', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'ID_COPY', 'https://drive.google.com/open?id=11VC3tDRzUd5m2s5I84Io91yHRD3AeZwK', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1rjigBeX1jEndL4hNM_xQzYDca6ZE4qBq', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1na-xTa4Gg8GvJzlh98BeluLKYgKxzrit', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1MZAqQ7ecLQjMLUX741WIeGvF6h0vQvtI', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1rli4mHcA-OruaozMhMWCfZcnp7yURxOF', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10319392918'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1HqS5nKTou9CZW975XgTWmNOU7AfD5BRj', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 23:27:50'::timestamptz,
    'Fatih Karagül', '11392440992', 'Gerger', '2003-01-25'::date,
    'Karagulfatihh@gmail.com', 'Esentepe mahallesi 2392.Sokak 12/1', '5.348702047E9',
    'Sağ', 'Sağ', 'Esnaf',
    'Sağ', 'ev hanımı',
    30000.0, 4, 1,
    'biruni üniversitesi', 'diş hekimliği', 'diş hekimliği',
    '5.0', 3.0, 'https://drive.google.com/open?id=1xF7vK094z-7qCOXK3_s68HaLdqWYE5xN',
    'mehmet koç', 'agd gop ilçe bşk', '5.352947787E9',
    'AGD-T3-Kızılay-ydd', 'fotoğrafçılık-atıcılık-sağlık teknolojileri-...', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'PHOTO', 'https://drive.google.com/open?id=1IArxzuLBYe9gqgpM74b7Ux_zEckm6Y2H', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'ID_COPY', 'https://drive.google.com/open?id=13gil44P4tgCQ2_8myrjjA2vv4ewz0M2P', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1AqXrYDAxZTwNkgOJ0nc09F9tCMgiOdUG', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1R25xpQiTyvgMAeAkODdrolXzkeePQhMI', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1juBwsrkk_KEfyECqUFHDKkLuVC1wPULJ', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1M63Yzz-eSQDODzHSOVwGMjQTP48RhQk9', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11392440992'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1DCcEroy1zJBlEAMN7j2isgTw0xGTbON4', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 23:35:29'::timestamptz,
    'Ahmet özşahin', '11459866314', 'Muş/varto', '2005-09-01'::date,
    'ahmetozsahin86', 'Muş/Varto/sazlıca köyü', '05525357048',
    'Sağ', 'Sağ', 'İmam',
    'Sağ', 'Ev hanımı',
    46094.0, 3, 1,
    'Istanbul üniversitesi cerrahpaşa', 'Tıp fakültesi', 'Tıp',
    '2.0', 2.59, 'https://drive.google.com/open?id=1y4paMVNlh7f8FRCNOeeiMhbvdacqtJum',
    'Recep özşahin', 'Sağlık bakanlığı', '05061595826',
    'Gaye vakfı', 'Tenis,futbol,kitap okuma', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'PHOTO', 'https://drive.google.com/open?id=1NXcZGqKrE3TdDBLlpCYD83uHZbTjjWjd', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'ID_COPY', 'https://drive.google.com/open?id=1LTRVbErWGJhzXAsFeQTLSlXA5Zb-zdGm', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1tr83igMvlRzc8mxC8qcLuPsvY-0T8OFC', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=195DwGUpJIorI4_Sl7IR57dgoXm6e96pb', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1oH85X85sljhHiTZE0M17h6M8a4iFnUkP', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1ZFnNALpi9Pr2yqWecOVB_K_LDWWrhR2h', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11459866314'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=15wQqoVyXl_jBcKRzz-CpURPCfqY44E7Z', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-19 23:40:31'::timestamptz,
    'Talha Gün', '11012527188', 'Fatih Çapa', '2007-01-05'::date,
    'talhagun2507@gmail.com', 'Merkez mh. Kavaklı sk. Apartman 10 Daire 5 Gaziosmanpaşa/İstanbul', '5.53883564E9',
    'Sağ', NULL, 'Emekli Mali Müşavir',
    'Sağ', NULL,
    35000.0, 2, NULL,
    'Yıldız Teknik Üni', 'Makine', 'Makine',
    '2.0', 3.37, 'https://drive.google.com/open?id=1c07eZvaKXIQoqpFUC6yorXpsEjJcHCAS',
    'Osman Kurum', 'Emekli, Belediye, AGD İl Başkanlığı', '5.326783098E9',
    'yok', 'Sinema, bilim kurgu eserleri, müzik, çizgi romanlar', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'PHOTO', 'https://drive.google.com/open?id=1dFNdStIUWhuX5ZFRNxCCsZWxN0Z8VxJH', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'ID_COPY', 'https://drive.google.com/open?id=1ybO0Q-lUpdtN8jbjdlbuo70riu-SDF41', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1O-Yw9EguNVrzHVbYdf4qwbnmYwYExyPm', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1dAo3Q9XeKm0vf2ar1MB-zN4EZqXY-6hO', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1EVlSD9J2gRUT4IyPlrANT429-butTpVu', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1p2kDZwvYwAFl7V_3ipDmuyFZFAbaDmEL', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11012527188'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=104eXBcHATfKE0FJ6KJUAKVAtmcn29Xlo', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-20 11:52:03'::timestamptz,
    'Ömer Faruk Salman', '29872903370', 'İstanbul/Eminönü', '2003-07-01'::date,
    'faruksalman2010@gmail.com', 'Çırçır mah. öncü sk. c blok no: 12 iç kapı no:14  Eyüpsultan/İstanbul', '5.070589587E9',
    'Sağ', NULL, 'Zabıta memuru',
    'Sağ', 'Ev hanımı',
    50000.0, 1, NULL,
    'İstanbul Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat',
    '4.0', 2.8, 'https://drive.google.com/open?id=1iz0rmfpVwx_GjRtyxNVKgEnljfadG341',
    'Ömer Faruk Korkmaz', 'Sedav Vakfı Başkanı', '05301043832',
    'İlim Yayma Cemiyeti', 'Okumak, dil öğrenmek, seyahat etmek, katkı sağlamak, spor yapmak, ilim tahsil etmek...', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'PHOTO', 'https://drive.google.com/open?id=1vyD5k6dszcZQhXAQsOfbv0_V8M6BQ1g_', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'ID_COPY', 'https://drive.google.com/open?id=1e__Dhv5drzh8PRtUGoVpyiEChYK58NTg', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1_AufQHu04av6nGVU0_GYtw2LWJMIWriN', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1XcaF97q-84g23wvQqbTrbof23jjG6xv9', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1MwU44nEAujn8qnD3S758QnFBT6U5MYN3', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1D9dCQJf7ZNps5P-LQYeeWVh7a7fC6peU', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '29872903370'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1_BIDC7JVRhHuPBhxQN-dMkPhlz_9nFF9', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-20 14:57:36'::timestamptz,
    'Ramazan Öklü', '27764298498', 'Mardin', '2002-08-25'::date,
    'ramazanoklu69@gmail.com', 'Üsküdar/ İstanbul', '05346743060',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Yok',
    15000.0, 4, 1,
    'Marmara üniversitesi', 'İlahiyat fakültesi', 'İlahiyat',
    '4.0', 2.0, 'https://drive.google.com/open?id=1l4muBKhiJmEUMZ91O2Ws5imKdslagFzN',
    'Mehmet Koç', 'AGD', '5.352947787E9',
    'AGD', 'Futbol
Kitap okuma 
Spor
Yüzme 
Atıcılık', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'PHOTO', 'https://drive.google.com/open?id=1f5jN_h07eohp9SKbPAoSqkFymQGAelSI', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'ID_COPY', 'https://drive.google.com/open?id=1-MBzrXdtQCfN06ED5xg54ru3TrSyfut7', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1ukLy9iq74F11IDG-PKFdbcOqpJ27A84Y', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1hVcvWi72ORN8okqBIi1hCrU5-0pucoiK', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1NeXTJdolTtOcl_wNl1pbPOi5xfuJIPWm', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1QjL5v7glrJvAyYxUY_lca3eQxPDa0dxz', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '27764298498'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1B8FH3SjHpo8Q7Jj43vkT17CIyq4w-UsX', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-20 22:40:18'::timestamptz,
    'Abdullah Erez', '11189819086', 'Van Başkale', '2002-02-23'::date,
    'eabdullah6565@gmail.com', 'Van Başkale', '05530723887',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev hanımı',
    16000.0, NULL, NULL,
    'Marmara üniversitesi', 'Atatürk eğitim fakültesi', 'Sınıf öğretmenliği',
    '4.0', 2.21, 'https://drive.google.com/open?id=1e0gv5ZZe7hMYt0vP6zcWmHlFnVJnaDvG',
    'Muhammed iş', 'Aile danışma merkezi', '5.392643328E9',
    'Aziz Mahmud Hüdayi vakfı', 'Spor, kitap okumak, gezi', 'Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'PHOTO', 'https://drive.google.com/open?id=1doCVe2SVxOLwH0L3nvU2dMofUCDG537z', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'ID_COPY', 'https://drive.google.com/open?id=1e_jsTVAs_Go7O5EF3TRkHGwhMGwtVE2X', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1pxp_o_1MEtLAB0OIYj4T_KZ82C9j6TTx', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Uy940CX1tAuC-JvOIPRP3Q6_eUiocQsX', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=14TnFnqHVWv6ZdDeVnoUxdvzFisBYH30F', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1-Jg0eofaM64Rl2IZ7-bNEz9Wk6YNG5CE', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11189819086'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1uYOGZobhLz0yzabvIdG3q9YhtTFqpTtG', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-21 14:25:17'::timestamptz,
    'Ahmet Faruk Altuntaş', '39464086022', 'Trabzon sürmene', '2002-12-16'::date,
    'afaltuntas@hotmail.com', 'Yavuz selim mah şair baki sok kapı 9 not 4', '05433668388',
    'Sağ', NULL, 'Vaiz',
    'Sağ', 'Ev hanımı',
    92849.0, 4, NULL,
    'İstanbul Üniversitesi', 'İlahiyat fakültesi', 'Türkçe ilahiyat',
    '4.0', 2.16, 'https://drive.google.com/open?id=1tz2KPLNc5FZ2RqcmHcv0UuZsl81CxVET',
    'Mehmet Koç', 'Anadolu Gençlik Derneği', '5.352947787E9',
    'Anadolu gençlik derneği', 'Siyaset, futbol', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'PHOTO', 'https://drive.google.com/open?id=1i-qp6eVs5OeyYs_ax-RgdtYkuKJjA2yW', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'ID_COPY', 'https://drive.google.com/open?id=1TnTMzF2gFe_9IOZuBualfoNqcRZ_Zx8-', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1JxEYPDpzgg4FrwDcO7KNaneDuTpV0D_J', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Ioio6QU0IjN5afcD5gxFtA5u49e381SE', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1LEGgNgij0kNcx9JKOnkD-Xv53lLuB2LP', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1p7YrCqzI0vZb1KmV5pJ4rQxesM7Ac6UV', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '39464086022'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1JvLPPz8GnL79p8I4YOk_veR_Chqcw6cy', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-21 21:35:33'::timestamptz,
    'zülal palabıyık', '10308137216', 'karaman', '2006-01-01'::date,
    'zulalsengul20@gmail.com', 'atakent mah. 235.sk no 17 müftülük binası', '05464545778',
    'Sağ', 'sağ', 'öğretmen',
    'Sağ', 'öğretmen',
    60.0, 3, 2,
    'istanbul sabahattin zaim üniversitesi', 'eğitim fakültesi', 'okul öncesi öğretmenliği',
    '1.0', 4.0, 'https://drive.google.com/open?id=1WI8inKZt9enw6gI-wt1FdJI6duQksTbJ',
    'hasan hüseyin palabıyık', 'küçükçekmece müftülüğü', '05054523692',
    'yok', 'dini alanlar', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'PHOTO', 'https://drive.google.com/open?id=1vJ2AxeFwj7qOuQdOa-daD5Zt6vseeJJY', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'ID_COPY', 'https://drive.google.com/open?id=1hIj7r8mqvKwzCdKI7KE0cVphK_qJaU12', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1N_yHrPgBNviGCkT6oMkOM5kGr5N6odcB', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1xx_gy23x35NycO4YCtYWzpcTfgj1p4Rk', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=16Dc1mXYt9W8dGSFhHAY8M64UEjCCwzfo', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1AuaJ3doEgDGw1ieM5m7Z-SXFa8YGj75s', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10308137216'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1_NYwcbNvUdrDI2tAMH7x5n0LkhdSzmxx', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-22 22:23:41'::timestamptz,
    'Fatih YILDIZ', '11390584056', 'KARS/KAĞIZMAN', '2006-06-10'::date,
    'fth14531915@gmail.com', 'Örnek mahallesi 1 Demet sokak no 12 Kars/Merkez', '5.518681411E9',
    'Sağ', 'Sağ', 'Temizlik işçisi',
    'Sağ', 'Sağ',
    30000.0, 3, 2,
    'İstanbul Üniversitesi', 'İlahiyat Fakültesi', 'İlahiyat',
    '1.0', 4.0, 'https://drive.google.com/open?id=1GCwKiZFABl_uwns-fvRxASN4yRCyBD_K',
    'Ömer KORKMAZ  1982 7/A', 'Sabahattin Zaim üniversitesi araştırma görevlisi', '5.301043832E9',
    'Yok', 'Kitap okuumayı ve tarih araştırmaları ilgi odağı sır.Yeni bilgiler öğrenmek hep en baştaki ilgi alanım olmuştur.', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'PHOTO', 'https://drive.google.com/open?id=1RCIUAeCD65xYohFs5HgeBVr8ESWUeOEm', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'ID_COPY', 'https://drive.google.com/open?id=1AN-7RJaOCoqFSKVyw65AKgzydW01_ntV', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=15yE5Or4NVY2T3aEIEgfQA1kqs_eGOztu', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1jzeUvFBcJObNohpRb-hlxX9z23E77lMv', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1kAvnuo_b2CIqsiuROrX_Zwlcd2VYql_L', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Ti9HXYXbtP5ehdUrcfv4VQSIOz_AUMyX', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11390584056'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1UV-xI63pgXElPLacbBXemRUfq2VpQNpN', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-23 18:37:49'::timestamptz,
    'Furkan selekel', '11629538904', 'Afyonkarahisar', '2004-02-09'::date,
    'Furkanselekel0307@gmail.com', 'İskenderpaşa mahallesi ahmediye caddesi no 30 Fatih İstanbul', '05519825374',
    'Sağ', 'Elhamdülillah Sağ', 'İmam hatip',
    'Sağ', 'Ev hanımı',
    58000.0, 2, 2,
    'İstanbul üniversitesi', 'İlahiyat fakültesi', 'İlahiyat',
    '2.0', 2.88, 'https://drive.google.com/open?id=1RSYI5rUbtzsmnXhDmyN2VF2q32bTYtLI',
    '1-Ali Çelik 2-Fikret Soyal', '1- Rami Kütüphanesi Müdürü 2- İHAM VAKFI Müdürü', '5.49775443E9',
    'Uluslararası Genç Derneği', 'Fotoğrafçılık, Gezi, yüzme', 'İngilizce, Arapça, Diğer',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'PHOTO', 'https://drive.google.com/open?id=1UJWEbw62lSoaba8SgP58O7_Fx0GyXYnh', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'ID_COPY', 'https://drive.google.com/open?id=1yL0v7s-WJebcgTGEQsoe9Te91iUKLUGp', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1-8s4VV0ttRfdlAP6uJVUFsrggM0AVbY0', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1xl_SSmm5KkAs6C9oJxTdPszTktOV_NgA', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1I31XcHUOd9t2NFOlscLQehfB7hu2zzQ2', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1NR6jTjmya8hIss1itAaEll7Bv1PHlHJx', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11629538904'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1Vw6F38jw64-EkwnpYpQxdlqbY4CMRTht', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-29 10:09:22'::timestamptz,
    'Kıymet Zahma', '34363751002', 'İstanbul/Bakırköy', '2007-04-14'::date,
    'kiymetzahma102@gmail.com', 'Hürriyet Mahallesi 500 Evler Caddesi 261. Sokak No: 3 Daire 6 İstanbul/Gaziosmanpaşa', '5.321308479E9',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Ev Hanımı',
    22000.0, 1, 1,
    'İstanbul Üniversitesi', 'Edebiyat Fakültesi', 'Rus dili ve edebiyatı',
    '1.0', 3.0, 'https://drive.google.com/open?id=11XGE-NKUUPSOU3Ht9PavlsKicO9zTY74',
    'Ömer Yeşilyurt', 'Behçet Canbaz Anadolu Lisesi', '5.545680673E9',
    'Yok', 'kitap okumayı ve müzik dinlemeyi severim. Ayrıca farklı kültürleri tanımak hoşuma gider, uluslararası ilişkiler ve edebiyat ile ilgilenirim.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'PHOTO', 'https://drive.google.com/open?id=1FECmP95iaKSp0oeyKBDxIQ6L9RNhzSSR', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'ID_COPY', 'https://drive.google.com/open?id=1G8AggM802AJDLMVzXN5miQtfDiSmvcSr', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1_M6mR5Qy5IRUibOVtdIUbBXxvSi9XHlS', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1lFJ_Mmb0N8V_ue3ruQsCUshhOEynzk6k', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1Js3CwsIDkmIAn515pAhw451Hv1A2KYZl', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1Fo6zFHc9YO0gccmWQRdmWkVBDjyuAoBe', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '34363751002'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1El5ZWA-LHWqZKkizsLuylZW72TK3K5t0', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-29 20:32:13'::timestamptz,
    'Faruk Can Yumuşak', '10522486480', 'Adıyaman Kahta', '2006-05-05'::date,
    'farukcanyumusak5@gmail.com', 'Kazımkarabekir mahallesi 916sk no11 daire5', '05510268196',
    'Sağ', NULL, 'Güvenlik',
    'Sağ', 'Ev hanımı',
    35000.0, 3, 2,
    'İstanbul Sabahattin Zaim Üniversitesi', 'Eğitim Fakültesi', 'Türkçe Öğretmenliği',
    '1.0', 1.0, 'https://drive.google.com/open?id=1CE0QnKpU-sLD5ouLupxSPg1k1lMCXcbb',
    'Hamza Ertürk', 'Medeniyet Üniversitesi', '05436152787',
    'İlim yaym cemiyeti', 'Kelam, felsefe, siyaset, edebiyat, tarih, sosyoloji, psikoloji', 'Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'PHOTO', 'https://drive.google.com/open?id=1n7GJKywpUd0fs9PVEIqw0ipzeoR5S5Qp', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'ID_COPY', 'https://drive.google.com/open?id=10cWRPfTittq6MeqTKGl3zYs57iiPzBJQ', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1vU0QywkFdKAKNwWNS6N__OPUfJy30I78', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1LjAywkHXUspfBoQfCqksH5l9AL-_QEJ8', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1iv4JPwq5JkmWVFNVSAYBTu2mleXQSpLY', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1jVZsX_ng7fcnwP0T3MahBt_nmnnNXuLB', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10522486480'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=12jZyBmPAbKPCa3C7-aV3udp-_00_rle3', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-09-29 22:29:35'::timestamptz,
    'Necmeddin Fatih Başar', '30742871866', 'İstanbul / Gaziosmanpaşa', '2006-12-01'::date,
    'necmeddinfatihbasar@gmail.com', 'Sultangazi/İstanbul', '05465011761',
    'Sağ', 'sağ', 'emekli',
    'Sağ', 'ev hanımı',
    64108.0, 4, 1,
    'Fatih Sultan Mehmet Vakıf Üniversitesi', 'Mühendislik Fakültesi', 'Elektrik-Elektronik Mühendisliği',
    '1.0', 3.0, 'https://drive.google.com/open?id=13hZoEJ0E4lz7OInDTDC439rnil6hyv3E',
    'Hasan Tahsin Usta', 'Eski belediye başkanı', '05322911564',
    'AGD', 'Havacılık. İnsansız hava araçları.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'PHOTO', 'https://drive.google.com/open?id=1f073712ZW9bwzsQIk-A3obkL1GUnllDm', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'ID_COPY', 'https://drive.google.com/open?id=15qv-bEBfWS8uHm06LEyVVH-9J24r59tP', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1Nc-3U641xrLKmKNdwz_rr0Grtf-A6qne', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1jIBD0zS-P5ITSYxa5uJbb6vxlfHLtZDr', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1YSlkr2S1aAUq06SdMuMiVXMEaA48HpSk', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1hoAXvqpKvyX31LAXyfjGNkkpa4uBzpwm', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '30742871866'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1y-dNZA9WKgiSF6LMLMoVqVL0U-PtO892', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-10-02 11:17:51'::timestamptz,
    'Ece Büşra Demir', '10646455720', 'Tekirdağ', '2006-08-02'::date,
    'ecbd8011@gmail.com', 'Gündoğdu Mahallesi Dövenci Sokak No:3', '05437350259',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Çalışmıyor',
    17000.0, NULL, NULL,
    'Boğaziçi Üniversitesi', 'İktisadi ve İdari Bilimler Fakültesi', 'Siyaset Bilimi ve Uluslararası İlişkiler',
    '1.0', 1.0, 'https://drive.google.com/open?id=1pk2HhcCEZpsNmbtLVu0KMehlM6fBXnd5',
    'Seçkin Kibar', '.', '05055351981',
    'yok', 'Dans, sosyal bilimler, örgü.', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'PHOTO', 'https://drive.google.com/open?id=1x1n9tHamw4073WZ35Z_qH3ag5whi18zM', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'ID_COPY', 'https://drive.google.com/open?id=1XW0ng_CUOdmAZA5UlKWRU7l9PdcJsNT0', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1nNygiXIlhK-1k6fJqS9DnZm96XP78Q-k', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=13Ba6xWO8cp58xnjDbP2NiVLdtLn0yG-1', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=18z0yU0PNLBLjaLUvYgoRJf-knTBIUIGL', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1fI9T55KSrjFqRS_ej1_OeihMfbv6EPD9', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '10646455720'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1ALX_LBbRptZNnYyniV9qG6DId0qdOiSe', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-10-02 20:49:28'::timestamptz,
    'Hüseyin Candan', '11243730562', 'Eskişehir', '2007-01-30'::date,
    'Candanh515@gmail.com', 'Tarabya mahallesi karanfil sokak No:2', '05059986237',
    'Sağ', 'Sağ', 'Emekli',
    'Sağ', 'Temizlik görevlisi',
    45000.0, 2, 2,
    'İstanbul teknik üniversitesi', 'Mimarlık fakültesi', 'Mimarlık',
    '1.0', 4.0, 'https://drive.google.com/open?id=1JhVyqH1vQq0yVIzkAoXy-RScCHrRGG_t',
    'İsmail candan', 'İbn Haldun üniversitesi', '05315130362',
    'Yok', 'Spor', 'İngilizce',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'PHOTO', 'https://drive.google.com/open?id=1Rzuvvu21f1nx14yTmNBP9ODnyh_D15rt', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'ID_COPY', 'https://drive.google.com/open?id=1JGz5PU3iiBmgoSAqzuSBQyqkSRZnMsQ-', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1IlBvdN9JjREHanEif5AdyxUjEQuZqfZG', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=15IjjgoSFdOgpSnPNd_z2rx9ys-SaGpCe', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1-HeyupcGd74LJl-je9HnM0vEGOW5dNus', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=13D6oCp2pSPQQUcXDt1C2EAszyf6DCLLz', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11243730562'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1suJ1yHCFPtvXYyIINyAwD2tG5g-L4wrJ', 'transcript-link'
);

INSERT INTO applications (
    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,
    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,
    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,
    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,
    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source
) VALUES (
    (SELECT id FROM application_seasons WHERE code = '2024-2025'),
    NULL,
    'SUBMITTED',
    '2025-10-14 20:25:03'::timestamptz,
    'Hayrü nisa balay', '11844029706', 'İstanbul', '2003-12-05'::date,
    'nisaabalay@gmail.com', 'İstanbul başakşehir', '05411434463',
    'Sağ', 'Sağ', 'Serbest meslek',
    'Sağ', 'Ev hanımı',
    60000.0, 2, NULL,
    'İstanbul Üniversitesi', 'Diş hekimliği', 'Diş hekimliği',
    '3.0', 3.13, 'https://drive.google.com/open?id=152dlqHN0q45SBS0-wCDMhLloanknkRG_',
    'Ümit ünal', 'Esenyurt belediyesi başkan yardımcısı', '05323276339',
    'Yok', 'Voleybol oynamak', 'İngilizce, Arapça',
    TRUE, TRUE, TRUE, TRUE, 'excel-2425'
) ON CONFLICT (season_id, tc_no) DO NOTHING;

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'PHOTO', 'https://drive.google.com/open?id=1pbtEhwH0sq_mMdLHU3OP3e7-8T9NWfZ3', 'photo-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'ID_COPY', 'https://drive.google.com/open?id=1NYL6_xhhWS9jA52llZA1lgHPO5h4D4en', 'id_copy-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'FATHER_SALARY', 'https://drive.google.com/open?id=1HKJTpFCpIipYfVqmLIWgTk8lWTDxF32J', 'father_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'MOTHER_SALARY', 'https://drive.google.com/open?id=1Buf8gXnUTMtG-BCQD70NG057vQfIl_pp', 'mother_salary-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'SIBLING_STUDENT', 'https://drive.google.com/open?id=1gOCLM82Etvii85ntP4xuvI4pIK4WQGjG', 'sibling_student-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'STUDENT_CERT', 'https://drive.google.com/open?id=1rKtJL-WQVhrwKbgxNRWtXYYsUaporyBf', 'student_cert-link'
);

INSERT INTO application_documents (application_id, document_type, external_url, file_name)
VALUES (
    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = '11844029706'),
    'TRANSCRIPT', 'https://drive.google.com/open?id=1LicJ06oLxuToHDu6mPrnCNNyK_xN_7GI', 'transcript-link'
);
