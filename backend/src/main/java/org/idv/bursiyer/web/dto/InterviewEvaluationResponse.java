package org.idv.bursiyer.web.dto;

import java.time.Instant;
import java.util.List;

public record InterviewEvaluationResponse(
        Long applicationId,
        String fullName,
        String seasonCode,
        String applicationStatus,
        Instant scheduledAt,
        int passThreshold,
        int committeeMemberCount,
        int submittedEvaluationCount,
        boolean evaluationComplete,
        Double committeeAverage,
        String recommendedResult,
        List<EvaluationCriterionResponse> criteria,
        MemberEvaluationResponse myEvaluation,
        List<MemberEvaluationResponse> committeeEvaluations
) {}
