package org.idv.bursiyer.web.dto;

public record EvaluationCriterionResponse(
        Long id,
        String code,
        String label,
        int maxScore
) {}
