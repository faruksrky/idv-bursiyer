-- Muhammet Emin Kaçar (bursiyer 98) IBAN bilgilerini vermediği için elendi.
-- V23 bu id'yi muhasebe ek listesine eklemişti. Uygulanmış V23 tekrar çalışmaz;
-- bu kayıt, liste yeniden kurulursa 98'in geri eklenmemesini sağlar.
UPDATE system_settings
SET setting_value = (
        SELECT COALESCE(string_agg(id::text, ',' ORDER BY id), '')
        FROM (
            SELECT DISTINCT trim(part)::bigint AS id
            FROM unnest(string_to_array(system_settings.setting_value, ',')) AS part
            WHERE trim(part) ~ '^[0-9]+$'
              AND trim(part)::bigint > 0
              AND trim(part)::bigint <> 98
        ) ids
    ),
    updated_at = NOW()
WHERE setting_key = 'accounting_extra_scholar_ids'
  AND EXISTS (
      SELECT 1
      FROM unnest(string_to_array(setting_value, ',')) AS part
      WHERE trim(part) = '98'
  );
