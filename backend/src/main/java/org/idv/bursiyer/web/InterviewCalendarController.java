package org.idv.bursiyer.web;

import org.idv.bursiyer.service.InterviewCalendarService;
import org.idv.bursiyer.web.dto.InterviewCalendarResponse;
import org.idv.bursiyer.web.dto.InterviewCalendarSlotResponse;
import org.idv.bursiyer.web.dto.UpdateInterviewAttendanceRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/interviews/calendar")
public class InterviewCalendarController {

    private final InterviewCalendarService calendarService;

    public InterviewCalendarController(InterviewCalendarService calendarService) {
        this.calendarService = calendarService;
    }

    @GetMapping
    public InterviewCalendarResponse getCalendar() {
        return calendarService.getCalendar();
    }

    @PutMapping("/{applicationId}/attendance")
    public InterviewCalendarSlotResponse updateAttendance(
            @PathVariable Long applicationId,
            @RequestBody UpdateInterviewAttendanceRequest request
    ) {
        return calendarService.updateAttendance(
                applicationId,
                request == null ? null : request.attendance()
        );
    }
}
