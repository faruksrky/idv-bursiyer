package org.idv.bursiyer.web.dto;

import java.time.Instant;
import java.util.List;

public record MemberEvaluationResponse(
        String evaluatorSub,
        String evaluatorName,
        int totalScore,
        Instant submittedAt,
        String note,
        List<CriterionScoreResponse> scores
) {}
