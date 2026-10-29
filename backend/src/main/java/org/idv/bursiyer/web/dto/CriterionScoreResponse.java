package org.idv.bursiyer.web.dto;

public record CriterionScoreResponse(
        Long criterionId,
        String code,
        String label,
        int maxScore,
        int score
) {}
