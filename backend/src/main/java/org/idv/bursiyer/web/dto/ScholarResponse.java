package org.idv.bursiyer.web.dto;

import java.time.LocalDate;
import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarIntake;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.service.PersonGenders;
import org.idv.bursiyer.service.PersonNames;

public record ScholarResponse(
        Long id,
        String firstName,
        String lastName,
        String tcNo,
        String email,
        String phone,
        String iban,
        String university,
        String faculty,
        String department,
        String classYear,
        ScholarStatus status,
        LocalDate graduationDate,
        LocalDate scholarshipStart,
        boolean active,
        long programsAttendedCount,
        String gender,
        ScholarIntake intake
) {
    public static ScholarResponse from(Scholar scholar, long programsAttendedCount, ScholarIntake intake) {
        String firstName = PersonNames.titleCase(scholar.getFirstName());
        return new ScholarResponse(
                scholar.getId(),
                firstName,
                PersonNames.titleCase(scholar.getLastName()),
                scholar.getTcNo(),
                scholar.getEmail(),
                scholar.getPhone(),
                scholar.getIban(),
                scholar.getUniversity(),
                scholar.getFaculty(),
                scholar.getDepartment(),
                scholar.getClassYear(),
                scholar.getStatus(),
                scholar.getGraduationDate(),
                scholar.getScholarshipStart(),
                scholar.isActive(),
                programsAttendedCount,
                PersonGenders.fromName(firstName),
                intake
        );
    }
}
