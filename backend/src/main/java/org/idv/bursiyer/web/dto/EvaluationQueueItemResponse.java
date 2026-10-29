package org.idv.bursiyer.web.dto;

import java.time.Instant;

public record EvaluationQueueItemResponse(
        Long applicationId,
        String fullName,
        String tcNo,
        String university,
        String department,
        String applicationStatus,
        Instant scheduledAt,
        int submittedEvaluationCount,
        int committeeMemberCount,
        Double committeeAverage,
        String recommendedResult
) {}
