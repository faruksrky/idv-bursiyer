package org.idv.bursiyer.web;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.service.AttendanceService;
import org.idv.bursiyer.service.ScholarExcelService;
import org.idv.bursiyer.service.ScholarService;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.idv.bursiyer.web.dto.ScholarProgramAttendanceResponse;
import org.idv.bursiyer.web.dto.ScholarSeasonAttendanceResponse;
import org.idv.bursiyer.web.dto.ScholarResponse;
import org.idv.bursiyer.web.dto.UpdateScholarIbanRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@RestController
@RequestMapping("/api/v1/scholars")
public class ScholarController {

    private final ScholarService scholarService;
    private final ScholarExcelService scholarExcelService;
    private final AttendanceService attendanceService;

    public ScholarController(
            ScholarService scholarService,
            ScholarExcelService scholarExcelService,
            AttendanceService attendanceService
    ) {
        this.scholarService = scholarService;
        this.scholarExcelService = scholarExcelService;
        this.attendanceService = attendanceService;
    }

    @GetMapping
    public List<ScholarResponse> listScholars(@RequestParam(required = false) ScholarStatus status) {
        return scholarService.listScholars(status);
    }

    @GetMapping("/export/excel")
    public ResponseEntity<byte[]> exportScholarsExcel(@RequestParam(required = false) ScholarStatus status) {
        byte[] workbook = scholarExcelService.exportScholars(status);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"idv-bursiyerler.xlsx\"")
                .contentType(MediaType.parseMediaType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                ))
                .body(workbook);
    }

    @GetMapping("/import/template")
    public ResponseEntity<byte[]> downloadImportTemplate() {
        byte[] workbook = scholarExcelService.buildImportTemplate();
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"idv-bursiyer-sablon.xlsx\"")
                .contentType(MediaType.parseMediaType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                ))
                .body(workbook);
    }

    @PostMapping(value = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ScholarImportResult importScholars(@RequestParam("file") MultipartFile file) {
        return scholarExcelService.importScholars(file);
    }

    @PutMapping("/{id}/iban")
    public ScholarResponse updateIban(@PathVariable Long id, @RequestBody UpdateScholarIbanRequest request) {
        return scholarService.updateIban(id, request == null ? null : request.iban());
    }

    @GetMapping("/{id}/program-attendance")
    public List<ScholarProgramAttendanceResponse> listScholarProgramAttendance(
            @PathVariable Long id,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) AttendanceStatus attendanceStatus
    ) {
        return attendanceService.listScholarProgramHistory(id, year, month, attendanceStatus);
    }

    @GetMapping("/{id}/season-attendance")
    public List<ScholarSeasonAttendanceResponse> listScholarSeasonAttendance(
            @PathVariable Long id,
            @RequestParam int academicYear
    ) {
        return attendanceService.listScholarSeasonAttendance(id, academicYear);
    }
}
