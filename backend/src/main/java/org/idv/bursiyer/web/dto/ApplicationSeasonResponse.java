package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.ApplicationSeason;
import org.idv.bursiyer.domain.ApplicationSeasonStatus;
import java.time.Instant;

public record ApplicationSeasonResponse(
        Long id,
        String code,
        String title,
        String publicSlug,
        ApplicationSeasonStatus status,
        Instant opensAt,
        Instant closesAt,
        int familyIncomeInterviewMax
) {
    public static ApplicationSeasonResponse from(ApplicationSeason season) {
        return new ApplicationSeasonResponse(
                season.getId(),
                season.getCode(),
                season.getTitle(),
                season.getPublicSlug(),
                season.getStatus(),
                season.getOpensAt(),
                season.getClosesAt(),
                season.getFamilyIncomeInterviewMax() == null ? 100000 : season.getFamilyIncomeInterviewMax()
        );
    }
}
