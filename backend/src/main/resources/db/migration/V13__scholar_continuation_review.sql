CREATE TABLE scholar_reviews (
    id                          BIGSERIAL PRIMARY KEY,
    scholar_id                  BIGINT REFERENCES scholars(id),
    academic_year               INT          NOT NULL,
    tc_no                       VARCHAR(11)  NOT NULL,
    full_name                   VARCHAR(255) NOT NULL,
    submitted_at                TIMESTAMPTZ,
    student_cert_url            TEXT,
    photo_url                   TEXT,
    transcript_url              TEXT,
    family_income_url           TEXT,
    father_status               VARCHAR(20),
    mother_status               VARCHAR(20),
    program_attendance_answer   TEXT,
    suggestions                 TEXT,
    decision                    VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    note                        TEXT,
    created_at                  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (academic_year, tc_no)
);

CREATE INDEX idx_scholar_reviews_year ON scholar_reviews(academic_year);
CREATE INDEX idx_scholar_reviews_scholar ON scholar_reviews(scholar_id);
