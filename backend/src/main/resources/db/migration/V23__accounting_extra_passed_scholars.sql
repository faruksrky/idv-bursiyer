-- Mülakatı olumlu olan Elif Cerit (100), Hayrünnisa Bozan (99) ve
-- Muhammet Emin Kaçar (98) muhasebe listesinde kalsın. Mevcut ek id'ler silinmez.
INSERT INTO system_settings (setting_key, setting_value, description)
VALUES (
    'accounting_extra_scholar_ids',
    '81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100',
    'Muhasebe IBAN listesi: yenileme CONTINUE kayitlarina eklenecek bursiyer idleri'
)
ON CONFLICT (setting_key) DO UPDATE
SET setting_value = (
        SELECT string_agg(id::text, ',' ORDER BY id)
        FROM (
            SELECT DISTINCT trim(part)::bigint AS id
            FROM unnest(string_to_array(system_settings.setting_value, ',')) AS part
            WHERE trim(part) ~ '^[0-9]+$'
              AND trim(part)::bigint > 0
            UNION
            SELECT unnest(ARRAY[98, 99, 100]::bigint[])
        ) ids
    ),
    updated_at = NOW();
