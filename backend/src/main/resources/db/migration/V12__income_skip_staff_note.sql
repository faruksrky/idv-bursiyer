UPDATE applications a
SET staff_note = CASE
    WHEN a.staff_note IS NULL OR btrim(a.staff_note) = '' THEN
        'Aile geliri eşik ' || replace(trim(to_char(s.family_income_interview_max, '999,999,999')), ',', '.')
            || ' TL üzerinde olduğu için gelir kuralına göre mülakata çağrılmaz.'
    ELSE
        btrim(a.staff_note) || E'\n'
            || 'Aile geliri eşik ' || replace(trim(to_char(s.family_income_interview_max, '999,999,999')), ',', '.')
            || ' TL üzerinde olduğu için gelir kuralına göre mülakata çağrılmaz.'
    END
FROM application_seasons s
WHERE a.season_id = s.id
  AND a.family_monthly_income IS NOT NULL
  AND a.family_monthly_income > s.family_income_interview_max
  AND (a.interview_invite IS NULL OR a.interview_invite <> 'INVITE')
  AND (
      a.staff_note IS NULL
      OR a.staff_note NOT ILIKE '%gelir kuralına göre mülakata çağrılmaz%'
  );
