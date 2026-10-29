UPDATE applications
SET staff_note = NULLIF(
    btrim(
        replace(
            replace(
                staff_note,
                E'Transkript ortalaması 2''nin altında olduğu için GNO kuralına göre mülakata çağrılmaz.\n',
                ''
            ),
            'Transkript ortalaması 2''nin altında olduğu için GNO kuralına göre mülakata çağrılmaz.',
            ''
        )
    ),
    ''
)
WHERE staff_note ILIKE '%GNO kuralına göre mülakata çağrılmaz%'
   OR staff_note ILIKE '%GNO kuralına göre çağrılmaz%';

ALTER TABLE scholar_reviews
    ADD COLUMN IF NOT EXISTS gpa NUMERIC(4, 2),
    ADD COLUMN IF NOT EXISTS gpa_below_two BOOLEAN NOT NULL DEFAULT FALSE;
