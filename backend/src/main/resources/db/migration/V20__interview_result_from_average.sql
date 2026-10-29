-- Resmi mülakat sonucu: komite ortalaması varsa eşik 80 (dahil) Geçti, altı Kaldı.
-- 5/5 şart değil — ortalama göründüğü anda işaretlenir. Puan yoksa PENDING kalır.
-- Başkan kontenjanı ve mülakata çağrılmayanlar (SKIP) kalma sayılmaz.

WITH committee AS (
    SELECT s.application_id,
           AVG(e.total_score) AS avg_score
    FROM interview_sessions s
    JOIN interview_evaluations e ON e.session_id = s.id
    GROUP BY s.application_id
)
UPDATE applications a
SET interview_result = CASE
    WHEN c.avg_score >= 80 THEN 'PASSED'
    ELSE 'FAILED'
END
FROM committee c
WHERE a.id = c.application_id
  AND COALESCE(a.interview_invite, '') NOT IN ('PRESIDENT_QUOTA', 'SKIP');
