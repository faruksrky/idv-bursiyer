-- 2025–2026 akademik yılı (Ekim 2025 – Temmuz 2026) demo programları ve katılımlar
INSERT INTO monthly_programs (year, month, name, program_date)
VALUES
    (2025, 10, 'Ekim Bursiyer Buluşması', '2025-10-12'),
    (2025, 11, 'Kasım Semineri', '2025-11-09'),
    (2025, 12, 'Aralık Değerlendirme', '2025-12-14'),
    (2026, 1, 'Ocak Yeni Dönem', '2026-01-11'),
    (2026, 2, 'Şubat Atölye', '2026-02-08'),
    (2026, 3, 'Mart Kariyer Günü', '2026-03-15'),
    (2026, 4, 'Nisan Saha Ziyareti', '2026-04-12'),
    (2026, 5, 'Mayıs Proje Sunumu', '2026-05-10')
ON CONFLICT (year, month) DO NOTHING;

-- Ayşe Yılmaz (id=1): 6 katıldı, 2 katılmadı
INSERT INTO program_attendance (program_id, scholar_id, attendance_status, excuse_status, excuse_text)
SELECT p.id, 1, v.status, v.excuse_status, v.excuse_text
FROM monthly_programs p
JOIN (VALUES
    (2025, 10, 'KATILDI', 'YOK', NULL),
    (2025, 11, 'KATILDI', 'YOK', NULL),
    (2025, 12, 'KATILMADI', 'RED', 'Aile ziyareti'),
    (2026, 1, 'KATILDI', 'YOK', NULL),
    (2026, 2, 'KATILMADI', 'YOK', NULL),
    (2026, 3, 'KATILDI', 'YOK', NULL),
    (2026, 4, 'KATILDI', 'YOK', NULL),
    (2026, 5, 'KATILDI', 'YOK', NULL)
) AS v(y, m, status, excuse_status, excuse_text) ON p.year = v.y AND p.month = v.m
ON CONFLICT (program_id, scholar_id) DO NOTHING;

-- Mehmet Demir (id=2): 4 katıldı, 4 katılmadı
INSERT INTO program_attendance (program_id, scholar_id, attendance_status, excuse_status, excuse_text)
SELECT p.id, 2, v.status, v.excuse_status, v.excuse_text
FROM monthly_programs p
JOIN (VALUES
    (2025, 10, 'KATILMADI', 'YOK', NULL),
    (2025, 11, 'KATILDI', 'YOK', NULL),
    (2025, 12, 'KATILMADI', 'KABUL', 'Sağlık raporu'),
    (2026, 1, 'KATILDI', 'YOK', NULL),
    (2026, 2, 'KATILMADI', 'YOK', NULL),
    (2026, 3, 'KATILMADI', 'YOK', NULL),
    (2026, 4, 'KATILDI', 'YOK', NULL),
    (2026, 5, 'KATILDI', 'YOK', NULL)
) AS v(y, m, status, excuse_status, excuse_text) ON p.year = v.y AND p.month = v.m
ON CONFLICT (program_id, scholar_id) DO NOTHING;

-- Zeynep Kaya (id=3): 3 katıldı, 1 katılmadı (sadece 4 programa kayıtlı)
INSERT INTO program_attendance (program_id, scholar_id, attendance_status, excuse_status, excuse_text)
SELECT p.id, 3, v.status, v.excuse_status, v.excuse_text
FROM monthly_programs p
JOIN (VALUES
    (2025, 10, 'KATILDI', 'YOK', NULL),
    (2025, 11, 'KATILMADI', 'YOK', NULL),
    (2026, 1, 'KATILDI', 'YOK', NULL),
    (2026, 3, 'KATILDI', 'YOK', NULL)
) AS v(y, m, status, excuse_status, excuse_text) ON p.year = v.y AND p.month = v.m
ON CONFLICT (program_id, scholar_id) DO NOTHING;
