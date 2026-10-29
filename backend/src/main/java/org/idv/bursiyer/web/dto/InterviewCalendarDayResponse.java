package org.idv.bursiyer.web.dto;

import java.util.List;

public record InterviewCalendarDayResponse(
        String date,
        String weekday,
        String label,
        List<InterviewCalendarSlotResponse> slots
) {}
