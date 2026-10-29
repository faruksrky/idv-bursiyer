package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.InterviewAttendance;
import java.time.Instant;

public record InterviewCalendarSlotResponse(
        Long applicationId,
        Long sessionId,
        String fullName,
        Instant scheduledAt,
        InterviewAttendance attendance
) {}
