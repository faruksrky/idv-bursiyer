CREATE TABLE evaluation_criteria (
    id          BIGSERIAL PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,
    label       VARCHAR(255) NOT NULL,
    max_score   INT          NOT NULL,
    sort_order  INT          NOT NULL,
    active      BOOLEAN      NOT NULL DEFAULT TRUE
);

INSERT INTO evaluation_criteria (code, label, max_score, sort_order) VALUES
    ('ORPHAN_SIBLING', 'Yetim kardeş', 5, 1),
    ('SELF_EXPRESSION', 'Kendisini ifade', 10, 2),
    ('APPEARANCE', 'Kılık kıyafet', 10, 3),
    ('HOUSING', 'Ev ve barınma durumu', 10, 4),
    ('VALUES', 'Dini ve milli değerlere bağlılık', 30, 5),
    ('NEED', 'İhtiyaç durumu', 20, 6),
    ('HOBBY', 'Hobi ve yetenek', 5, 7),
    ('NGO', 'STK çalışması', 5, 8),
    ('FOUNDATION_DUTY', 'Vakıfta görev alır mı?', 5, 9),
    ('OPENNESS', 'Yeniliklere açık mı?', 5, 10);

CREATE TABLE interview_sessions (
    id              BIGSERIAL PRIMARY KEY,
    application_id  BIGINT       NOT NULL UNIQUE REFERENCES applications(id) ON DELETE CASCADE,
    scheduled_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE interview_evaluations (
    id              BIGSERIAL PRIMARY KEY,
    session_id      BIGINT       NOT NULL REFERENCES interview_sessions(id) ON DELETE CASCADE,
    evaluator_sub   VARCHAR(255) NOT NULL,
    evaluator_name  VARCHAR(255),
    total_score     INT          NOT NULL,
    submitted_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (session_id, evaluator_sub)
);

CREATE TABLE interview_evaluation_scores (
    evaluation_id   BIGINT NOT NULL REFERENCES interview_evaluations(id) ON DELETE CASCADE,
    criterion_id    BIGINT NOT NULL REFERENCES evaluation_criteria(id),
    score           INT    NOT NULL CHECK (score >= 0),
    PRIMARY KEY (evaluation_id, criterion_id)
);

CREATE INDEX idx_interview_sessions_application ON interview_sessions(application_id);
CREATE INDEX idx_interview_evaluations_session ON interview_evaluations(session_id);
