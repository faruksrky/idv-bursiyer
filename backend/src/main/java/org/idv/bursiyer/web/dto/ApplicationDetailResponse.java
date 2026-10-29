package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.service.InterviewPrescreen;
import org.idv.bursiyer.service.PersonNames;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public record ApplicationDetailResponse(
        Long id,
        String seasonCode,
        ApplicationStatus status,
        Instant submittedAt,
        String fullName,
        String tcNo,
        String birthPlace,
        LocalDate birthDate,
        String email,
        String address,
        String phone,
        String fatherStatus,
        String fatherName,
        String fatherJob,
        String motherStatus,
        String motherJob,
        BigDecimal familyMonthlyIncome,
        Integer siblingCount,
        Integer studyingSiblingCount,
        String university,
        String faculty,
        String department,
        String classYear,
        BigDecimal gpa,
        String highSchool,
        String referenceName,
        String referenceOrganization,
        String referencePhone,
        String associations,
        String interests,
        String languages,
        boolean interviewEligible,
        String interviewScreenReason,
        String interviewInvite,
        String interviewResult,
        String staffNote,
        int familyIncomeInterviewMax,
        boolean highSchoolAvailable,
        List<ApplicationDocumentResponse> documents
) {
    public static ApplicationDetailResponse from(
            Application application,
            List<ApplicationDocument> documents,
            int familyIncomeInterviewMax
    ) {
        return from(application, documents, familyIncomeInterviewMax, url -> false);
    }

    public static ApplicationDetailResponse from(
            Application application,
            List<ApplicationDocument> documents,
            int familyIncomeInterviewMax,
            java.util.function.Predicate<String> cached
    ) {
        boolean interviewEligible = InterviewPrescreen.isInterviewEligible(application, familyIncomeInterviewMax);
        return new ApplicationDetailResponse(
                application.getId(),
                application.getSeason().getCode(),
                application.getStatus(),
                application.getSubmittedAt(),
                PersonNames.titleCase(application.getFullName()),
                application.getTcNo(),
                application.getBirthPlace(),
                application.getBirthDate(),
                application.getEmail(),
                application.getAddress(),
                application.getPhone(),
                application.getFatherStatus(),
                application.getFatherName(),
                application.getFatherJob(),
                application.getMotherStatus(),
                application.getMotherJob(),
                application.getFamilyMonthlyIncome(),
                application.getSiblingCount(),
                application.getStudyingSiblingCount(),
                application.getUniversity(),
                application.getFaculty(),
                application.getDepartment(),
                application.getClassYear(),
                application.getGpa(),
                application.getHighSchool(),
                application.getReferenceName(),
                application.getReferenceOrganization(),
                application.getReferencePhone(),
                application.getAssociations(),
                application.getInterests(),
                application.getLanguages(),
                interviewEligible,
                InterviewPrescreen.screenReason(application, familyIncomeInterviewMax),
                InterviewPrescreen.inviteCode(application),
                application.getInterviewResult().name(),
                application.getStaffNote(),
                familyIncomeInterviewMax,
                cached.test(application.getHighSchool()),
                documents.stream().map(document -> ApplicationDocumentResponse.from(
                        document,
                        cached.test(document.getExternalUrl())
                )).toList()
        );
    }
}
