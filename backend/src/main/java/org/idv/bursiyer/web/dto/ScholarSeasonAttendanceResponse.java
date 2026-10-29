package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ExcuseStatus;

public record ScholarSeasonAttendanceResponse(
        int year,
        int month,
        String periodLabel,
        String programName,
        AttendanceStatus attendanceStatus,
        ExcuseStatus excuseStatus,
        String excuseText,
        boolean paymentEligible,
        boolean programExists,
        boolean recordExists
) {}
