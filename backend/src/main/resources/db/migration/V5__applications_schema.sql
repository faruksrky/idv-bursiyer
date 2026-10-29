CREATE TABLE application_seasons (
    id              BIGSERIAL PRIMARY KEY,
    code            VARCHAR(20)  NOT NULL UNIQUE,
    title           VARCHAR(255) NOT NULL,
    public_slug     VARCHAR(50)  NOT NULL UNIQUE,
    status          VARCHAR(20)  NOT NULL,
    opens_at        TIMESTAMPTZ,
    closes_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE applications (
    id                          BIGSERIAL PRIMARY KEY,
    season_id                   BIGINT       NOT NULL REFERENCES application_seasons(id),
    scholar_id                  BIGINT       REFERENCES scholars(id),
    status                      VARCHAR(30)  NOT NULL,
    submitted_at                TIMESTAMPTZ,
    full_name                   VARCHAR(255) NOT NULL,
    tc_no                       VARCHAR(11)  NOT NULL,
    birth_place                 VARCHAR(255),
    birth_date                  DATE,
    email                       VARCHAR(255),
    address                     TEXT,
    phone                       VARCHAR(30),
    father_status               VARCHAR(20),
    father_name                 VARCHAR(255),
    father_job                  VARCHAR(255),
    mother_status               VARCHAR(20),
    mother_job                  VARCHAR(255),
    family_monthly_income       NUMERIC(12, 2),
    sibling_count               INT,
    studying_sibling_count      INT,
    university                  VARCHAR(255),
    faculty                     VARCHAR(255),
    department                  VARCHAR(255),
    class_year                  VARCHAR(20),
    gpa                         NUMERIC(4, 2),
    high_school                 VARCHAR(255),
    reference_name              VARCHAR(255),
    reference_organization      VARCHAR(255),
    reference_phone             VARCHAR(30),
    associations                TEXT,
    interests                   TEXT,
    languages                   TEXT,
    consent_accuracy            BOOLEAN      NOT NULL DEFAULT FALSE,
    consent_terms               BOOLEAN      NOT NULL DEFAULT FALSE,
    consent_rejection           BOOLEAN      NOT NULL DEFAULT FALSE,
    consent_kvkk                BOOLEAN      NOT NULL DEFAULT FALSE,
    import_source               VARCHAR(50),
    created_at                  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (season_id, tc_no)
);

CREATE TABLE application_documents (
    id              BIGSERIAL PRIMARY KEY,
    application_id  BIGINT       NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    document_type   VARCHAR(50)  NOT NULL,
    file_name       VARCHAR(255),
    content_type    VARCHAR(100),
    file_size       BIGINT,
    storage_path    TEXT,
    external_url    TEXT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_applications_season ON applications(season_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_tc ON applications(tc_no);
CREATE INDEX idx_application_documents_app ON application_documents(application_id);

CREATE UNIQUE INDEX uq_scholars_tc ON scholars(tc_no) WHERE tc_no IS NOT NULL;

INSERT INTO application_seasons (code, title, public_slug, status, opens_at, closes_at)
VALUES
    ('2024-2025', '2024–2025 Burs Başvurusu', '2425', 'ARCHIVED', '2024-08-01', '2024-10-31'),
    ('2026-2027', '2026–2027 Burs Başvurusu', '2627', 'OPEN', '2026-08-01', '2026-10-31');
