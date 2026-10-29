package org.idv.bursiyer.web.dto;

public record SaveScholarReviewRequest(
        String decision,
        String note,
        Boolean graduating,
        Boolean gpaBelowTwo
) {}
