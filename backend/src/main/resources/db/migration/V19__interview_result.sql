ALTER TABLE applications
    ADD COLUMN IF NOT EXISTS interview_result VARCHAR(16) NOT NULL DEFAULT 'PENDING';

COMMENT ON COLUMN applications.interview_result IS
    'Resmi mülakat sonucu: PENDING bekliyor, PASSED geçti, FAILED kaldı. Komite ortalaması (OLUMLU/OLUMSUZ) öneridir; başkan kontenjanı kalma sayılmaz.';

CREATE INDEX IF NOT EXISTS idx_applications_interview_result ON applications(interview_result);

-- 5/5 komite puanı varsa öneriyi resmi sonuca yaz (personel sonra değiştirebilir).
WITH committee AS (
    SELECT s.application_id,
           AVG(e.total_score) AS avg_score,
           COUNT(DISTINCT e.evaluator_sub) AS member_count
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
  AND a.interview_result = 'PENDING'
  AND c.member_count >= 5
  AND COALESCE(a.interview_invite, '') <> 'PRESIDENT_QUOTA';
