package org.idv.bursiyer.web.dto;

import java.util.List;

public record SubmitInterviewEvaluationRequest(
        List<EvaluationScoreInput> scores,
        String note
) {}
