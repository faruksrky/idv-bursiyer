package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ExcuseStatus;
import org.idv.bursiyer.domain.ProgramAttendance;
import org.idv.bursiyer.service.PersonNames;
import java.time.LocalDate;

public record AttendanceResponse(
        Long id,
        Long scholarId,
        String scholarName,
        Long programId,
        String programName,
        LocalDate programDate,
        AttendanceStatus attendanceStatus,
        String excuseText,
        ExcuseStatus excuseStatus,
        boolean paymentEligible
) {
    public static AttendanceResponse from(ProgramAttendance attendance) {
        ScholarSummary scholar = ScholarSummary.from(attendance.getScholar());
        return new AttendanceResponse(
                attendance.getId(),
                scholar.id(),
                scholar.fullName(),
                attendance.getProgram().getId(),
                attendance.getProgram().getName(),
                attendance.getProgram().getProgramDate(),
                attendance.getAttendanceStatus(),
                attendance.getExcuseText(),
                attendance.getExcuseStatus(),
                attendance.isPaymentEligible()
        );
    }

    private record ScholarSummary(Long id, String fullName) {
        static ScholarSummary from(org.idv.bursiyer.domain.Scholar scholar) {
            return new ScholarSummary(
                    scholar.getId(),
                    PersonNames.titleCase(scholar.getFirstName()) + " " + PersonNames.titleCase(scholar.getLastName())
            );
        }
    }
}
