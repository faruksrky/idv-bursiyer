-- Demo mezun kayıtları (V4): gerçek bursiyer değil.
UPDATE applications
SET scholar_id = NULL
WHERE scholar_id IN (SELECT id FROM scholars WHERE tc_no IN ('12345678904', '12345678905', '12345678906'));

UPDATE scholar_reviews
SET scholar_id = NULL
WHERE scholar_id IN (SELECT id FROM scholars WHERE tc_no IN ('12345678904', '12345678905', '12345678906'));

DELETE FROM program_attendance
WHERE scholar_id IN (SELECT id FROM scholars WHERE tc_no IN ('12345678904', '12345678905', '12345678906'));

DELETE FROM monthly_payments
WHERE scholar_id IN (SELECT id FROM scholars WHERE tc_no IN ('12345678904', '12345678905', '12345678906'));

DELETE FROM scholars
WHERE tc_no IN ('12345678904', '12345678905', '12345678906');
