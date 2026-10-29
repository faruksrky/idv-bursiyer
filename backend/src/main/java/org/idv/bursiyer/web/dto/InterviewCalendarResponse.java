package org.idv.bursiyer.web.dto;

import java.util.List;

public record InterviewCalendarResponse(
        String location,
        List<InterviewCalendarDayResponse> days,
        List<InterviewCalendarSlotResponse> unscheduled
) {}
