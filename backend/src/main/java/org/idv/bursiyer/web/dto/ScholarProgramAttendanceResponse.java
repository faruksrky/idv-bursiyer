package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ExcuseStatus;
import org.idv.bursiyer.domain.ProgramAttendance;
import java.time.LocalDate;

public record ScholarProgramAttendanceResponse(
        Long attendanceId,
        int year,
        int month,
        String programName,
        LocalDate programDate,
        AttendanceStatus attendanceStatus,
        ExcuseStatus excuseStatus,
        String excuseText,
        boolean paymentEligible
) {
    public static ScholarProgramAttendanceResponse from(ProgramAttendance attendance) {
        return new ScholarProgramAttendanceResponse(
                attendance.getId(),
                attendance.getProgram().getYear(),
                attendance.getProgram().getMonth(),
                attendance.getProgram().getName(),
                attendance.getProgram().getProgramDate(),
                attendance.getAttendanceStatus(),
                attendance.getExcuseStatus(),
                attendance.getExcuseText(),
                attendance.isPaymentEligible()
        );
    }
}
