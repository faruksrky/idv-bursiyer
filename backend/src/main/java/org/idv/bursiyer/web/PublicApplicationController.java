package org.idv.bursiyer.web;

import org.idv.bursiyer.domain.ApplicationDocumentType;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.service.ApplicationService;
import org.idv.bursiyer.web.dto.ApplicationDetailResponse;
import org.idv.bursiyer.web.dto.ApplicationSeasonResponse;
import org.idv.bursiyer.web.dto.ApplicationSubmitRequest;
import org.idv.bursiyer.web.dto.ApplicationSummaryResponse;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import jakarta.validation.Valid;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/public/applications")
public class PublicApplicationController {

    private final ApplicationService applicationService;

    public PublicApplicationController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @GetMapping("/seasons/{slug}")
    public ApplicationSeasonResponse getSeason(@PathVariable String slug) {
        return applicationService.getPublicSeason(slug);
    }

    @PostMapping(value = "/seasons/{slug}/submit", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApplicationDetailResponse submit(
            @PathVariable String slug,
            @Valid @RequestPart("payload") ApplicationSubmitRequest request,
            @RequestPart("photo") MultipartFile photo,
            @RequestPart("idCopy") MultipartFile idCopy,
            @RequestPart("fatherSalary") MultipartFile fatherSalary,
            @RequestPart("motherSalary") MultipartFile motherSalary,
            @RequestPart(value = "siblingStudent", required = false) MultipartFile siblingStudent,
            @RequestPart("studentCert") MultipartFile studentCert,
            @RequestPart("transcript") MultipartFile transcript
    ) {
        Map<ApplicationDocumentType, MultipartFile> files = new EnumMap<>(ApplicationDocumentType.class);
        files.put(ApplicationDocumentType.PHOTO, photo);
        files.put(ApplicationDocumentType.ID_COPY, idCopy);
        files.put(ApplicationDocumentType.FATHER_SALARY, fatherSalary);
        files.put(ApplicationDocumentType.MOTHER_SALARY, motherSalary);
        files.put(ApplicationDocumentType.SIBLING_STUDENT, siblingStudent);
        files.put(ApplicationDocumentType.STUDENT_CERT, studentCert);
        files.put(ApplicationDocumentType.TRANSCRIPT, transcript);
        return applicationService.submit(slug, request, files);
    }
}
