package org.idv.bursiyer.web;

import org.idv.bursiyer.domain.ScholarReview;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.service.DriveCacheService;
import org.idv.bursiyer.service.ScholarReviewExcelService;
import org.idv.bursiyer.service.ScholarReviewService;
import org.idv.bursiyer.web.dto.SaveScholarReviewRequest;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.idv.bursiyer.web.dto.ScholarRenewalListResponse;
import org.idv.bursiyer.web.dto.ScholarReviewResponse;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
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
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/scholar-reviews")
public class ScholarReviewController {

    private final ScholarReviewService reviewService;
    private final ScholarReviewExcelService reviewExcelService;
    private final ScholarReviewRepository reviewRepository;
    private final DriveCacheService driveCacheService;

    public ScholarReviewController(
            ScholarReviewService reviewService,
            ScholarReviewExcelService reviewExcelService,
            ScholarReviewRepository reviewRepository,
            DriveCacheService driveCacheService
    ) {
        this.reviewService = reviewService;
        this.reviewExcelService = reviewExcelService;
        this.reviewRepository = reviewRepository;
        this.driveCacheService = driveCacheService;
    }

    @GetMapping
    public ScholarRenewalListResponse list(@RequestParam(required = false) Integer academicYear) {
        return reviewService.list(academicYear);
    }

    @PostMapping(value = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ScholarImportResult importRenewals(
            @RequestParam(required = false) Integer academicYear,
            @RequestParam("file") MultipartFile file
    ) {
        return reviewExcelService.importRenewalForm(academicYear, file);
    }

    @PutMapping("/{id}")
    @PostMapping("/{id}")
    public ScholarReviewResponse saveDecision(
            @PathVariable Long id,
            @RequestBody SaveScholarReviewRequest request
    ) {
        return reviewService.saveDecision(id, request);
    }

    @GetMapping("/{id}/files/{slot}")
    public ResponseEntity<Resource> downloadFile(@PathVariable Long id, @PathVariable String slot) {
        ScholarReview review = reviewRepository.findDetailedById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Yenileme kaydı bulunamadı"));
        String url = switch (slot) {
            case "student" -> review.getStudentCertUrl();
            case "photo" -> review.getPhotoUrl();
            case "transcript" -> review.getTranscriptUrl();
            case "income" -> review.getFamilyIncomeUrl();
            default -> throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Belge bulunamadı");
        };
        var path = driveCacheService.pathForUrl(url)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dosya henüz kopyalanmadı"));
        return driveCacheService.toResponse(path, slot);
    }
}
