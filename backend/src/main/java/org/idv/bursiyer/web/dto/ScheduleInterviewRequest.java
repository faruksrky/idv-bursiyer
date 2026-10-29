package org.idv.bursiyer.web.dto;

import java.time.Instant;

public record ScheduleInterviewRequest(
        Instant scheduledAt
) {}
