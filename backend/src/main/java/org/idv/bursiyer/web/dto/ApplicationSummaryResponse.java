package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.service.InterviewPrescreen;
import org.idv.bursiyer.service.PersonNames;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public record ApplicationSummaryResponse(
        Long id,
        String seasonCode,
        ApplicationStatus status,
        Instant submittedAt,
        String fullName,
        String tcNo,
        String email,
        String phone,
        String university,
        String department,
        BigDecimal gpa,
        boolean acceptedScholarLinked,
        BigDecimal familyMonthlyIncome,
        boolean interviewEligible,
        String interviewScreenReason,
        String interviewInvite,
        String interviewResult,
        String staffNote,
        String highSchool,
        List<ApplicationDocumentResponse> documents
) {
    public static ApplicationSummaryResponse from(
            Application application,
            int familyIncomeInterviewMax,
            List<ApplicationDocument> documents
    ) {
        boolean interviewEligible = InterviewPrescreen.isInterviewEligible(application, familyIncomeInterviewMax);
        return new ApplicationSummaryResponse(
                application.getId(),
                application.getSeason().getCode(),
                application.getStatus(),
                application.getSubmittedAt(),
                PersonNames.titleCase(application.getFullName()),
                application.getTcNo(),
                application.getEmail(),
                application.getPhone(),
                application.getUniversity(),
                application.getDepartment(),
                application.getGpa(),
                application.getScholar() != null,
                application.getFamilyMonthlyIncome(),
                interviewEligible,
                InterviewPrescreen.screenReason(application, familyIncomeInterviewMax),
                InterviewPrescreen.inviteCode(application),
                application.getInterviewResult().name(),
                application.getStaffNote(),
                application.getHighSchool(),
                documents.stream().map(ApplicationDocumentResponse::from).toList()
        );
    }
}
