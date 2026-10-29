package org.idv.bursiyer.web;

import org.idv.bursiyer.service.DriveIngestService;
import org.idv.bursiyer.web.dto.DriveIngestStatusResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/drive-cache")
public class DriveCacheController {

    private final DriveIngestService ingestService;

    public DriveCacheController(DriveIngestService ingestService) {
        this.ingestService = ingestService;
    }

    @GetMapping("/status")
    public DriveIngestStatusResponse status() {
        return ingestService.status();
    }

    @PostMapping("/ingest")
    public DriveIngestStatusResponse ingest() {
        return ingestService.start();
    }
}
