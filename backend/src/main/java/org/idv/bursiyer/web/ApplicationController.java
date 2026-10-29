package org.idv.bursiyer.web;

import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.repository.ApplicationDocumentRepository;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.service.ApplicationExcelService;
import org.idv.bursiyer.service.ApplicationService;
import org.idv.bursiyer.service.ApplicationStorageService;
import org.idv.bursiyer.service.DriveCacheService;
import org.idv.bursiyer.web.dto.ApplicationDetailResponse;
import org.idv.bursiyer.web.dto.ApplicationSeasonResponse;
import org.idv.bursiyer.web.dto.ApplicationSummaryResponse;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.idv.bursiyer.web.dto.UpdateApplicationInterviewRequest;
import org.idv.bursiyer.web.dto.UpdateApplicationInterviewResultRequest;
import org.idv.bursiyer.web.dto.UpdateSeasonPrescreenRequest;
import jakarta.validation.Valid;
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

@RestController
@RequestMapping("/api/v1/applications")
public class ApplicationController {

    private final ApplicationService applicationService;
    private final ApplicationExcelService applicationExcelService;
    private final ApplicationDocumentRepository documentRepository;
    private final ApplicationRepository applicationRepository;
    private final ApplicationStorageService storageService;
    private final DriveCacheService driveCacheService;

    public ApplicationController(
            ApplicationService applicationService,
            ApplicationExcelService applicationExcelService,
            ApplicationDocumentRepository documentRepository,
            ApplicationRepository applicationRepository,
            ApplicationStorageService storageService,
            DriveCacheService driveCacheService
    ) {
        this.applicationService = applicationService;
        this.applicationExcelService = applicationExcelService;
        this.documentRepository = documentRepository;
        this.applicationRepository = applicationRepository;
        this.storageService = storageService;
        this.driveCacheService = driveCacheService;
    }

    @GetMapping("/seasons")
    public List<ApplicationSeasonResponse> listSeasons() {
        return applicationService.listSeasons();
    }

    @PutMapping("/seasons/{seasonId}/prescreen")
    public ApplicationSeasonResponse updateSeasonPrescreen(
            @PathVariable Long seasonId,
            @Valid @RequestBody UpdateSeasonPrescreenRequest request
    ) {
        return applicationService.updateIncomePrescreen(seasonId, request.familyIncomeInterviewMax());
    }

    @GetMapping
    public List<ApplicationSummaryResponse> listApplications(
            @RequestParam Long seasonId,
            @RequestParam(required = false) ApplicationStatus status
    ) {
        return applicationService.listApplications(seasonId, status);
    }

    @GetMapping("/{id}")
    public ApplicationDetailResponse getApplication(@PathVariable Long id) {
        return applicationService.getApplication(id);
    }

    @PutMapping("/{id}/interview-decision")
    @PostMapping("/{id}/interview-decision")
    public ApplicationDetailResponse updateInterviewDecision(
            @PathVariable Long id,
            @RequestBody UpdateApplicationInterviewRequest request
    ) {
        return applicationService.updateInterviewDecision(
                id,
                request.interviewInvite(),
                request.staffNote()
        );
    }

    @PutMapping("/{id}/interview-result")
    @PostMapping("/{id}/interview-result")
    public ApplicationDetailResponse updateInterviewResult(
            @PathVariable Long id,
            @RequestBody UpdateApplicationInterviewResultRequest request
    ) {
        return applicationService.updateInterviewResult(id, request.interviewResult());
    }

    @PostMapping(value = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ScholarImportResult importApplications(
            @RequestParam Long seasonId,
            @RequestParam("file") MultipartFile file
    ) {
        return applicationExcelService.importGoogleFormResponses(seasonId, file);
    }

    @GetMapping("/{applicationId}/high-school")
    public ResponseEntity<Resource> downloadHighSchool(@PathVariable Long applicationId) {
        var application = applicationRepository.findDetailedById(applicationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru bulunamadı"));
        Path path = driveCacheService.pathForUrl(application.getHighSchool())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dosya henüz kopyalanmadı"));
        return driveCacheService.toResponse(path, "lise-diplomasi");
    }

    @GetMapping("/{applicationId}/documents/{documentId}/download")
    public ResponseEntity<Resource> downloadDocument(
            @PathVariable Long applicationId,
            @PathVariable Long documentId
    ) {
        ApplicationDocument document = documentRepository.findDetailedById(documentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Belge bulunamadı"));
        if (!document.getApplication().getId().equals(applicationId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Belge bulunamadı");
        }
        if (document.getStoragePath() != null) {
            Path path = storageService.resolveStoragePath(document.getStoragePath());
            if (Files.exists(path)) {
                return driveCacheService.toResponse(path, document.getFileName() != null
                        ? document.getFileName()
                        : document.getDocumentType().name());
            }
        }
        Path cached = driveCacheService.pathForUrl(document.getExternalUrl())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dosya henüz kopyalanmadı"));
        return driveCacheService.toResponse(cached, document.getFileName() != null
                ? document.getFileName()
                : document.getDocumentType().name());
    }
}
