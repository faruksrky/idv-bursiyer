package org.idv.bursiyer.web;

import org.idv.bursiyer.service.AttendanceService;
import org.idv.bursiyer.web.dto.AttendanceResponse;
import org.idv.bursiyer.web.dto.AttendanceUpdateRequest;
import org.idv.bursiyer.web.dto.ProgramEventRequest;
import org.idv.bursiyer.web.dto.ProgramEventResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/v1/programs")
public class ProgramAttendanceController {

    private final AttendanceService attendanceService;

    public ProgramAttendanceController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @GetMapping
    public List<ProgramEventResponse> listPrograms(
            @RequestParam int year,
            @RequestParam int month
    ) {
        return attendanceService.listPrograms(year, month).stream()
                .map(ProgramEventResponse::from)
                .toList();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProgramEventResponse createProgram(@RequestBody ProgramEventRequest request) {
        return ProgramEventResponse.from(attendanceService.createProgram(request));
    }

    @PutMapping("/{id}")
    public ProgramEventResponse updateProgram(
            @PathVariable Long id,
            @RequestBody ProgramEventRequest request
    ) {
        return ProgramEventResponse.from(attendanceService.updateProgram(id, request));
    }

    @GetMapping("/attendance")
    public List<AttendanceResponse> listAttendance(
            @RequestParam int year,
            @RequestParam int month
    ) {
        return attendanceService.listForPeriod(year, month).stream()
                .map(AttendanceResponse::from)
                .toList();
    }

    @PutMapping("/attendance/{id}")
    public AttendanceResponse updateAttendance(
            @PathVariable Long id,
            @Valid @RequestBody AttendanceUpdateRequest request
    ) {
        return AttendanceResponse.from(attendanceService.updateAttendance(id, request));
    }
}
