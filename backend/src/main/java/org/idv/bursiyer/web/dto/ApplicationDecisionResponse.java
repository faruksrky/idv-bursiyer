package org.idv.bursiyer.web.dto;

public record ApplicationDecisionResponse(
        Long applicationId,
        String status,
        Long scholarId
) {}
