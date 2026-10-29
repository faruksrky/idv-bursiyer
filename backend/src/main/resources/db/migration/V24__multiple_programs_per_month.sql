-- Bir ayda birden fazla program (ad + tarih) tutulabilsin.
DO $$
DECLARE
    constraint_name text;
BEGIN
    FOR constraint_name IN
        SELECT c.conname
        FROM pg_constraint c
        JOIN pg_class t ON c.conrelid = t.oid
        WHERE t.relname = 'monthly_programs'
          AND c.contype = 'u'
          AND pg_get_constraintdef(c.oid) LIKE '%(year, month)%'
    LOOP
        EXECUTE format('ALTER TABLE monthly_programs DROP CONSTRAINT %I', constraint_name);
    END LOOP;
END $$;

CREATE INDEX IF NOT EXISTS idx_monthly_programs_period ON monthly_programs (year, month);
