UPDATE applications
SET staff_note = CASE
    WHEN staff_note IS NULL OR btrim(staff_note) = '' THEN
        'Transkript ortalaması 2''nin altında olduğu için GNO kuralına göre mülakata çağrılmaz.'
    ELSE
        btrim(staff_note) || E'\n'
            || 'Transkript ortalaması 2''nin altında olduğu için GNO kuralına göre mülakata çağrılmaz.'
    END
WHERE gpa IS NOT NULL
  AND gpa < 2
  AND (interview_invite IS NULL OR interview_invite <> 'INVITE')
  AND (
      staff_note IS NULL
      OR staff_note NOT ILIKE '%GNO kuralına göre mülakata çağrılmaz%'
  );
