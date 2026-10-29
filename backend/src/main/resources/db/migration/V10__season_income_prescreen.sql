ALTER TABLE application_seasons
    ADD COLUMN family_income_interview_max INT NOT NULL DEFAULT 100000;

COMMENT ON COLUMN application_seasons.family_income_interview_max IS
    'Aile aylık net gelir eşiği (TL). Bu tutarın üstündeki adaylar mülakata çağrılmaz.';
