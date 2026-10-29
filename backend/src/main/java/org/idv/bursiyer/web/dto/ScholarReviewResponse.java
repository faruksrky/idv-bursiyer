package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarReview;
import org.idv.bursiyer.service.AcademicYears;
import org.idv.bursiyer.service.PersonNames;
import java.time.Instant;

public record ScholarReviewResponse(
        Long id,
        int academicYear,
        String periodLabel,
        String fullName,
        String tcNo,
        Instant submittedAt,
        Long scholarId,
        boolean scholarMatched,
        String classYear,
        boolean fourthYear,
        boolean graduating,
        java.math.BigDecimal gpa,
        boolean gpaBelowTwo,
        String studentCertUrl,
        String photoUrl,
        String transcriptUrl,
        String familyIncomeUrl,
        String fatherStatus,
        String motherStatus,
        String programAttendanceAnswer,
        String suggestions,
        String decision,
        String note,
        boolean studentCertAvailable,
        boolean photoAvailable,
        boolean transcriptAvailable,
        boolean familyIncomeAvailable
) {
    public static ScholarReviewResponse from(ScholarReview review) {
        return from(review, url -> false);
    }

    public static ScholarReviewResponse from(ScholarReview review, java.util.function.Predicate<String> cached) {
        Scholar scholar = review.getScholar();
        String classYear = scholar == null ? null : scholar.getClassYear();
        return new ScholarReviewResponse(
                review.getId(),
                review.getAcademicYear(),
                AcademicYears.label(review.getAcademicYear()),
                PersonNames.titleCase(review.getFullName()),
                review.getTcNo(),
                review.getSubmittedAt(),
                scholar == null ? null : scholar.getId(),
                scholar != null,
                classYear,
                isFourthYear(classYear),
                review.isGraduating(),
                review.getGpa(),
                review.isGpaBelowTwo(),
                review.getStudentCertUrl(),
                review.getPhotoUrl(),
                review.getTranscriptUrl(),
                review.getFamilyIncomeUrl(),
                review.getFatherStatus(),
                review.getMotherStatus(),
                review.getProgramAttendanceAnswer(),
                review.getSuggestions(),
                review.getDecision().name(),
                review.getNote(),
                cached.test(review.getStudentCertUrl()),
                cached.test(review.getPhotoUrl()),
                cached.test(review.getTranscriptUrl()),
                cached.test(review.getFamilyIncomeUrl())
        );
    }

    public static boolean isFourthYear(String classYear) {
        if (classYear == null || classYear.isBlank()) {
            return false;
        }
        String compact = classYear.trim().toLowerCase();
        if (compact.contains("mezun") || compact.contains("son sinif") || compact.contains("son sınıf") || compact.contains("mezuniyet")) {
            return true;
        }
        String digits = compact.replace(',', '.');
        try {
            double value = Double.parseDouble(digits.replaceAll("[^0-9.]", ""));
            return Math.round(value) == 4;
        } catch (NumberFormatException exception) {
            return compact.startsWith("4");
        }
    }
}
