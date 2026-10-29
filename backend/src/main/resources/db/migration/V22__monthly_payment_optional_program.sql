-- Muhasebe ödeme işareti, o ay için program satırı olmasa da kaydedilebilsin.
ALTER TABLE monthly_payments
    ALTER COLUMN program_id DROP NOT NULL;

COMMENT ON COLUMN monthly_payments.program_id IS 'Varsa aylık program; muhasebe işareti program olmadan da tutulabilir';
