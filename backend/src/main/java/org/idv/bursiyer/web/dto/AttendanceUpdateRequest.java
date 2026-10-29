package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ExcuseStatus;
import jakarta.validation.constraints.NotNull;

public record AttendanceUpdateRequest(
        @NotNull AttendanceStatus attendanceStatus,
        String excuseText,
        ExcuseStatus excuseStatus
) {}
