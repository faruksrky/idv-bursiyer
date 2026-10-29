-- Mülakat yoklaması + 5–7 Ekim 2026 takvimi (41 randevu; Zaina/Elif saatsiz)
ALTER TABLE interview_sessions
    ADD COLUMN IF NOT EXISTS attendance_status VARCHAR(16);

COMMENT ON COLUMN interview_sessions.attendance_status IS 'GELDI, GELMEDI, NULL = henüz işaretlenmedi';

CREATE INDEX IF NOT EXISTS idx_interview_sessions_scheduled
    ON interview_sessions(scheduled_at);

WITH seed(email, full_name, scheduled_at) AS (
    VALUES
    ('aysemuhteremaydin@gmail.com', 'Ayşe Muhterem Aydın', TIMESTAMPTZ '2026-10-05 18:00:00+03'),
    ('busraky716@gmail.com', 'Büşra Kaya', TIMESTAMPTZ '2026-10-05 18:10:00+03'),
    ('duhayta58@gmail.com', 'Duhanur Hayta', TIMESTAMPTZ '2026-10-05 18:20:00+03'),
    ('arslanceydaarslan@gmail.com', 'Ceyda Arslan', TIMESTAMPTZ '2026-10-05 18:30:00+03'),
    ('aysedemirkaya567@gmail.com', 'Ayse Demirkaya', TIMESTAMPTZ '2026-10-05 18:40:00+03'),
    ('nisabzn3737@gmail.com', 'Hayrünnisa Bozan', TIMESTAMPTZ '2026-10-05 18:50:00+03'),
    ('hiraunaal@gmail.com', 'Hiranur Hafsa Ünal', TIMESTAMPTZ '2026-10-05 19:00:00+03'),
    ('kevserpolat2904@gmail.com', 'Kevser Polat', TIMESTAMPTZ '2026-10-05 19:10:00+03'),
    ('m3lix3604@gmail.com', 'Melike Kaya', TIMESTAMPTZ '2026-10-05 19:20:00+03'),
    ('nurann.atala@gmail.com', 'Nuran Atala', TIMESTAMPTZ '2026-10-05 19:30:00+03'),
    ('ruveydamanav@gmail.com', 'Rüveyda Zeynep Manav', TIMESTAMPTZ '2026-10-05 19:40:00+03'),
    ('suveybeyesilyurt58@gmail.com', 'Süveybe Yeşilyurt', TIMESTAMPTZ '2026-10-05 19:50:00+03'),
    ('olguntugba52@gmail.com', 'Tuğba Olgun', TIMESTAMPTZ '2026-10-05 20:00:00+03'),
    ('abdullahkrtrn1453@gmail.com', 'Abdullah Rıdvan Karaturna', TIMESTAMPTZ '2026-10-05 20:10:00+03'),
    ('yoldasburak22@gmail.com', 'Ahmet Burak Yoldaş', TIMESTAMPTZ '2026-10-05 20:30:00+03'),
    ('a.erenkamadan@gmail.com', 'Ahmet Eren Kamadan', TIMESTAMPTZ '2026-10-05 20:40:00+03'),
    ('yeltekin.ahmet.1907@gmail.com', 'Ahmet Yeltekin', TIMESTAMPTZ '2026-10-05 20:50:00+03'),
    ('ahmetyasingokdemir@gmail.com', 'Ahmet Yasin Gökdemir', TIMESTAMPTZ '2026-10-06 18:00:00+03'),
    ('ali.fuat.erd@gmail.com', 'Ali Fuat Erdoğdu', TIMESTAMPTZ '2026-10-06 18:10:00+03'),
    ('hazaraliriza83@gmail.com', 'Ali Rıza Hazar', TIMESTAMPTZ '2026-10-06 18:20:00+03'),
    ('alkelkat@gmail.com', 'Ali Özdemir', TIMESTAMPTZ '2026-10-06 18:30:00+03'),
    ('burakyigitkocyigit@gmail.com', 'Burak Yiğit Koçyiğit', TIMESTAMPTZ '2026-10-06 18:40:00+03'),
    ('aytaremir27@gmail.com', 'Emir Aytar', TIMESTAMPTZ '2026-10-06 18:50:00+03'),
    ('emirhanbsar7@gmail.com', 'Emirhan Başar', TIMESTAMPTZ '2026-10-06 19:00:00+03'),
    ('duman.esref.d@gmail.com', 'Eşref Duman', TIMESTAMPTZ '2026-10-06 19:10:00+03'),
    ('hsnogtm56@gmail.com', 'Hasan Ögtem', TIMESTAMPTZ '2026-10-06 19:20:00+03'),
    ('ibrahim191978@gmail.com', 'İbrahim Aslan', TIMESTAMPTZ '2026-10-06 19:30:00+03'),
    ('keremymnky@gmail.com', 'Kerem Yaman', TIMESTAMPTZ '2026-10-06 19:40:00+03'),
    ('kisilistem.com@gmail.com', 'Mehmet Akif Ayvacık', TIMESTAMPTZ '2026-10-06 19:50:00+03'),
    ('mehmetalitutgun89@gmail.com', 'Mehmet Ali Tutgun', TIMESTAMPTZ '2026-10-06 20:00:00+03'),
    ('mehmetfatihalkan907@gmail.com', 'Mehmet Fatih Alkan', TIMESTAMPTZ '2026-10-06 20:10:00+03'),
    ('metin.aydin@stu.ihu.edu.tr', 'Metin Aydın', TIMESTAMPTZ '2026-10-06 20:20:00+03'),
    ('hedelipalta@gmail.com', 'Muhammed Ali Delipalta', TIMESTAMPTZ '2026-10-06 20:30:00+03'),
    ('Muhammed.ali.yeltekin13@gmail.com', 'Muhammed Ali Yeltekin', TIMESTAMPTZ '2026-10-06 20:40:00+03'),
    ('muhammedxburhan@gmail.com', 'Muhammed Burhan Anbarpınar', TIMESTAMPTZ '2026-10-06 20:50:00+03'),
    ('yuk800807@gmail.com', 'Muhammed Yusuf Kamadan', TIMESTAMPTZ '2026-10-07 18:00:00+03'),
    ('carzcilgin@gmail.com', 'Muhammet Emin Kaçar', TIMESTAMPTZ '2026-10-07 18:10:00+03'),
    ('m.talha00152@icloud.com', 'Muhammet Talha Nursoy', TIMESTAMPTZ '2026-10-07 18:20:00+03'),
    ('musadur123@hotmail.com', 'Musa Dur', TIMESTAMPTZ '2026-10-07 18:30:00+03'),
    ('mkarazor1453@gmail.com', 'Mustafa Karazor', TIMESTAMPTZ '2026-10-07 18:40:00+03'),
    ('emresagir1@icloud.com', 'Yunus Emre Sağır', TIMESTAMPTZ '2026-10-07 18:50:00+03'),
    ('zainaturkiyede@gmail.com', 'Zaina Alkhazendar', NULL),
    ('elifcerit19@gmail.com', 'Elif Cerit', NULL)
),
folded_seed AS (
    SELECT
        email,
        full_name,
        scheduled_at,
        btrim(regexp_replace(
            lower(translate(full_name, 'İIıĞğÜüŞşÖöÇçÂâÎîÛû', 'iiigguussooccaaiauu')),
            '[^a-z0-9]+', ' ', 'g'
        )) AS name_key
    FROM seed
),
folded_apps AS (
    SELECT
        a.id,
        a.email,
        a.full_name,
        btrim(regexp_replace(
            lower(translate(coalesce(a.full_name, ''), 'İIıĞğÜüŞşÖöÇçÂâÎîÛû', 'iiigguussooccaaiauu')),
            '[^a-z0-9]+', ' ', 'g'
        )) AS name_key
    FROM applications a
    WHERE a.season_id = (SELECT id FROM application_seasons WHERE code = '2026-2027')
),
matched AS (
    SELECT DISTINCT ON (s.email)
        app.id AS application_id,
        s.scheduled_at
    FROM folded_seed s
    JOIN folded_apps app
      ON lower(trim(coalesce(app.email, ''))) = lower(trim(s.email))
      OR app.name_key = s.name_key
      OR (s.email = 'zainaturkiyede@gmail.com' AND app.name_key LIKE '%alkhazendar%')
    ORDER BY
        s.email,
        CASE WHEN lower(trim(coalesce(app.email, ''))) = lower(trim(s.email)) THEN 0 ELSE 1 END,
        app.id
)
INSERT INTO interview_sessions (application_id, scheduled_at)
SELECT application_id, scheduled_at
FROM matched
ON CONFLICT (application_id) DO UPDATE
SET scheduled_at = EXCLUDED.scheduled_at,
    updated_at = NOW();

UPDATE applications a
SET status = 'INTERVIEW_SCHEDULED',
    updated_at = NOW()
WHERE a.status = 'SUBMITTED'
  AND EXISTS (
      SELECT 1
      FROM interview_sessions s
      WHERE s.application_id = a.id
        AND s.scheduled_at IS NOT NULL
        AND s.scheduled_at >= TIMESTAMPTZ '2026-10-05 00:00:00+03'
        AND s.scheduled_at <  TIMESTAMPTZ '2026-10-08 00:00:00+03'
  );
