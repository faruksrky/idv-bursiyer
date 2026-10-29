CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    full_name       VARCHAR(255) NOT NULL,
    role            VARCHAR(50)  NOT NULL,
    active          BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE scholars (
    id                  BIGSERIAL PRIMARY KEY,
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100) NOT NULL,
    tc_no               VARCHAR(11),
    email               VARCHAR(255),
    phone               VARCHAR(30),
    iban                VARCHAR(34),
    university          VARCHAR(255),
    faculty             VARCHAR(255),
    department          VARCHAR(255),
    class_year          VARCHAR(20),
    status              VARCHAR(30)  NOT NULL DEFAULT 'OGRENCI',
    graduation_date     DATE,
    scholarship_start   DATE,
    monthly_amount      NUMERIC(12, 2),
    active              BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE monthly_programs (
    id              BIGSERIAL PRIMARY KEY,
    year            INT          NOT NULL,
    month           INT          NOT NULL CHECK (month BETWEEN 1 AND 12),
    name            VARCHAR(255) NOT NULL,
    program_date    DATE,
    location        VARCHAR(255),
    note            TEXT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (year, month)
);

CREATE TABLE program_attendance (
    id                  BIGSERIAL PRIMARY KEY,
    program_id          BIGINT       NOT NULL REFERENCES monthly_programs(id),
    scholar_id          BIGINT       NOT NULL REFERENCES scholars(id),
    attendance_status   VARCHAR(20)  NOT NULL,
    excuse_text         TEXT,
    excuse_status       VARCHAR(20),
    recorded_by         BIGINT REFERENCES users(id),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (program_id, scholar_id)
);

CREATE TABLE monthly_payments (
    id                  BIGSERIAL PRIMARY KEY,
    scholar_id          BIGINT       NOT NULL REFERENCES scholars(id),
    program_id          BIGINT       NOT NULL REFERENCES monthly_programs(id),
    year                INT          NOT NULL,
    month               INT          NOT NULL CHECK (month BETWEEN 1 AND 12),
    amount              NUMERIC(12, 2) NOT NULL,
    payment_status      VARCHAR(20)  NOT NULL,
    payment_date        DATE,
    non_payment_reason  TEXT,
    note                TEXT,
    recorded_by         BIGINT REFERENCES users(id),
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (scholar_id, year, month)
);

CREATE TABLE system_settings (
    setting_key     VARCHAR(100) PRIMARY KEY,
    setting_value   VARCHAR(255) NOT NULL,
    description     TEXT,
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO system_settings (setting_key, setting_value, description) VALUES
    ('interview_pass_threshold', '80', 'Mülakat OLUMLU eşik puanı (105 üzerinden)'),
    ('committee_member_count', '5', 'Hedef komite üye sayısı'),
    ('monthly_scholarship_amount', '3000', 'Aylık sabit burs tutarı (TL)');

CREATE INDEX idx_scholars_status ON scholars(status);
CREATE INDEX idx_program_attendance_program ON program_attendance(program_id);
CREATE INDEX idx_monthly_payments_period ON monthly_payments(year, month);
