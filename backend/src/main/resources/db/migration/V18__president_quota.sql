ALTER TABLE applications
    ALTER COLUMN interview_invite TYPE VARCHAR(32);

COMMENT ON COLUMN applications.interview_invite IS
    'NULL = gelir kuralı, INVITE = çağır, SKIP = çağırma, PRESIDENT_QUOTA = başkan kontenjanı (mülakatsız burs).';
