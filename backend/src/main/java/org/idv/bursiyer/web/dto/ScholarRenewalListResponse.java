package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.service.AcademicYears;
import java.util.List;

public record ScholarRenewalListResponse(
        int academicYear,
        String periodLabel,
        List<ScholarReviewResponse> responses,
        List<ScholarMissingRenewalResponse> missingScholars
) {
    public static ScholarRenewalListResponse of(
            int academicYear,
            List<ScholarReviewResponse> responses,
            List<ScholarMissingRenewalResponse> missingScholars
    ) {
        return new ScholarRenewalListResponse(
                academicYear,
                AcademicYears.label(academicYear),
                responses,
                missingScholars
        );
    }
}
