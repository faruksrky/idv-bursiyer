package org.idv.bursiyer.service;

import org.junit.jupiter.api.Test;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;

class InterviewCalendarServiceTest {

    @Test
    void weekdaysMatchInterviewDays() {
        assertEquals("Pazartesi", InterviewCalendarService.weekdayLabel(LocalDate.of(2026, 10, 5)));
        assertEquals("Salı", InterviewCalendarService.weekdayLabel(LocalDate.of(2026, 10, 6)));
        assertEquals("Çarşamba", InterviewCalendarService.weekdayLabel(LocalDate.of(2026, 10, 7)));
    }
}
