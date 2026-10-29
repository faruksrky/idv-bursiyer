ALTER TABLE applications
    ADD COLUMN IF NOT EXISTS staff_note TEXT,
    ADD COLUMN IF NOT EXISTS interview_invite VARCHAR(10);

COMMENT ON COLUMN applications.staff_note IS 'Ön eleme / belge inceleme notu. Mülakat puan notundan ayrıdır.';
COMMENT ON COLUMN applications.interview_invite IS 'NULL = gelir kuralı, INVITE = çağır, SKIP = çağırma.';
