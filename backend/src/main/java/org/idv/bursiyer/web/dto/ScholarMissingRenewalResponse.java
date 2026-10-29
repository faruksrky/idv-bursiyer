package org.idv.bursiyer.web.dto;

public record ScholarMissingRenewalResponse(
        Long scholarId,
        String firstName,
        String lastName,
        String tcNo,
        String university,
        String department
) {}
