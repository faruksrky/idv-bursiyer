package org.idv.bursiyer.domain;

public enum InterviewResult {
    PENDING,
    PASSED,
    FAILED;

    public static InterviewResult orPending(InterviewResult value) {
        return value == null ? PENDING : value;
    }

    public static InterviewResult parse(String value) {
        if (value == null || value.isBlank()) {
            return PENDING;
        }
        try {
            return InterviewResult.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException("Geçersiz mülakat sonucu");
        }
    }

    public static InterviewResult fromCommitteeRecommendation(String recommendedResult) {
        if ("OLUMLU".equalsIgnoreCase(recommendedResult)) {
            return PASSED;
        }
        if ("OLUMSUZ".equalsIgnoreCase(recommendedResult)) {
            return FAILED;
        }
        return PENDING;
    }

    /** Inclusive pass threshold, matching InterviewPrescreen / evaluation (80/105). */
    public static InterviewResult fromCommitteeAverage(double committeeAverage, int passThreshold) {
        return committeeAverage >= passThreshold ? PASSED : FAILED;
    }
}
