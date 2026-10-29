package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationDocumentType;
import org.idv.bursiyer.domain.ApplicationSeason;
import org.idv.bursiyer.domain.ApplicationSeasonStatus;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.domain.InterviewInviteOverride;
import org.idv.bursiyer.domain.InterviewResult;
import org.idv.bursiyer.repository.ApplicationDocumentRepository;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.ApplicationSeasonRepository;
import org.idv.bursiyer.web.dto.ApplicationDetailResponse;
import org.idv.bursiyer.web.dto.ApplicationSeasonResponse;
import org.idv.bursiyer.web.dto.ApplicationSubmitRequest;
import org.idv.bursiyer.web.dto.ApplicationSummaryResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

@Service
public class ApplicationService {

    private final ApplicationSeasonRepository seasonRepository;
    private final ApplicationRepository applicationRepository;
    private final ApplicationDocumentRepository documentRepository;
    private final ApplicationStorageService storageService;
    private final DriveCacheService driveCacheService;
    private final AppProperties appProperties;

    public ApplicationService(
            ApplicationSeasonRepository seasonRepository,
            ApplicationRepository applicationRepository,
            ApplicationDocumentRepository documentRepository,
            ApplicationStorageService storageService,
            DriveCacheService driveCacheService,
            AppProperties appProperties
    ) {
        this.seasonRepository = seasonRepository;
        this.applicationRepository = applicationRepository;
        this.documentRepository = documentRepository;
        this.storageService = storageService;
        this.driveCacheService = driveCacheService;
        this.appProperties = appProperties;
    }

    @Transactional(readOnly = true)
    public List<ApplicationSeasonResponse> listSeasons() {
        return seasonRepository.findAllByOrderByCodeDesc().stream()
                .map(ApplicationSeasonResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public ApplicationSeasonResponse getPublicSeason(String slug) {
        ApplicationSeason season = seasonRepository.findByPublicSlug(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru dönemi bulunamadı"));
        if (season.getStatus() != ApplicationSeasonStatus.OPEN) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bu dönem için başvuru alınmıyor");
        }
        Instant now = Instant.now();
        if (season.getOpensAt() != null && now.isBefore(season.getOpensAt())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Başvuru dönemi henüz açılmadı");
        }
        if (season.getClosesAt() != null && now.isAfter(season.getClosesAt())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Başvuru dönemi kapandı");
        }
        return ApplicationSeasonResponse.from(season);
    }

    @Transactional
    public List<ApplicationSummaryResponse> listApplications(Long seasonId, ApplicationStatus status) {
        List<Application> applications = status == null
                ? applicationRepository.findBySeasonId(seasonId)
                : applicationRepository.findBySeasonIdAndStatusOrderBySubmittedAtDesc(seasonId, status);
        for (Application application : applications) {
            InterviewPrescreen.applyIncomeSkipNote(application, incomeMax(application.getSeason()));
            String formatted = PersonNames.titleCase(application.getFullName());
            if (formatted != null && !formatted.equals(application.getFullName())) {
                application.setFullName(formatted);
            }
        }
        List<Long> applicationIds = applications.stream().map(Application::getId).toList();
        Map<Long, List<ApplicationDocument>> documentsByApplication = applicationIds.isEmpty()
                ? Map.of()
                : documentRepository.findByApplicationIdIn(applicationIds).stream()
                        .collect(java.util.stream.Collectors.groupingBy(document -> document.getApplication().getId()));
        return applications.stream()
                .map((application) -> ApplicationSummaryResponse.from(
                        application,
                        incomeMax(application.getSeason()),
                        documentsByApplication.getOrDefault(application.getId(), List.of())
                ))
                .toList();
    }

    @Transactional
    public ApplicationDetailResponse getApplication(Long id) {
        Application application = applicationRepository.findDetailedById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru bulunamadı"));
        InterviewPrescreen.applyIncomeSkipNote(application, incomeMax(application.getSeason()));
        List<ApplicationDocument> documents = documentRepository.findByApplicationIdOrderByDocumentTypeAsc(id);
        return ApplicationDetailResponse.from(
                application,
                documents,
                incomeMax(application.getSeason()),
                driveCacheService::isReady
        );
    }

    @Transactional
    public ApplicationDetailResponse updateInterviewDecision(
            Long id,
            String interviewInvite,
            String staffNote
    ) {
        Application application = applicationRepository.findDetailedById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru bulunamadı"));
        try {
            application.setInterviewInvite(InterviewPrescreen.parseInvite(interviewInvite));
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage());
        }
        application.setStaffNote(trimToNull(staffNote));
        InterviewPrescreen.applyQuotaNote(application);
        InterviewPrescreen.applyIncomeSkipNote(application, incomeMax(application.getSeason()));
        if (application.getInterviewInvite() == InterviewInviteOverride.SKIP
                || InterviewPrescreen.isPresidentQuota(application)) {
            application.setInterviewResult(InterviewResult.PENDING);
        }
        List<ApplicationDocument> documents = documentRepository.findByApplicationIdOrderByDocumentTypeAsc(id);
        return ApplicationDetailResponse.from(
                application,
                documents,
                incomeMax(application.getSeason()),
                driveCacheService::isReady
        );
    }

    @Transactional
    public ApplicationDetailResponse updateInterviewResult(Long id, String interviewResult) {
        Application application = applicationRepository.findDetailedById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru bulunamadı"));
        InterviewResult result;
        try {
            result = InterviewResult.parse(interviewResult);
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage());
        }
        if (InterviewPrescreen.isPresidentQuota(application) && result != InterviewResult.PENDING) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Başkan kontenjanı mülakatsızdır; geçti/kaldı olarak işaretlenmez"
            );
        }
        application.setInterviewResult(result);
        List<ApplicationDocument> documents = documentRepository.findByApplicationIdOrderByDocumentTypeAsc(id);
        return ApplicationDetailResponse.from(
                application,
                documents,
                incomeMax(application.getSeason()),
                driveCacheService::isReady
        );
    }

    @Transactional
    public ApplicationDetailResponse submit(
            String slug,
            ApplicationSubmitRequest request,
            Map<ApplicationDocumentType, MultipartFile> files
    ) {
        validateConsents(request);
        ApplicationSeason season = seasonRepository.findByPublicSlug(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru dönemi bulunamadı"));
        getPublicSeason(slug);

        if (applicationRepository.existsBySeasonIdAndTcNo(season.getId(), request.tcNo())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Bu TC kimlik numarası ile zaten başvuru yapılmış");
        }

        Application application = new Application();
        application.setSeason(season);
        application.setStatus(ApplicationStatus.SUBMITTED);
        application.setFullName(PersonNames.titleCase(request.fullName().trim()));
        application.setTcNo(request.tcNo().trim());
        application.setBirthPlace(request.birthPlace().trim());
        application.setBirthDate(request.birthDate());
        application.setEmail(request.email().trim());
        application.setAddress(request.address().trim());
        application.setPhone(request.phone().trim());
        application.setFatherStatus(request.fatherStatus().trim());
        application.setFatherName(trimToNull(request.fatherName()));
        application.setFatherJob(request.fatherJob().trim());
        application.setMotherStatus(request.motherStatus().trim());
        application.setMotherJob(request.motherJob().trim());
        application.setFamilyMonthlyIncome(request.familyMonthlyIncome());
        application.setSiblingCount(request.siblingCount());
        application.setStudyingSiblingCount(request.studyingSiblingCount());
        application.setUniversity(request.university().trim());
        application.setFaculty(request.faculty().trim());
        application.setDepartment(request.department().trim());
        application.setClassYear(request.classYear().trim());
        application.setGpa(request.gpa());
        application.setHighSchool(request.highSchool().trim());
        application.setReferenceName(request.referenceName().trim());
        application.setReferenceOrganization(request.referenceOrganization().trim());
        application.setReferencePhone(request.referencePhone().trim());
        application.setAssociations(trimToNull(request.associations()));
        application.setInterests(request.interests().trim());
        application.setLanguages(request.languages().trim());
        application.setConsentAccuracy(request.consentAccuracy());
        application.setConsentTerms(request.consentTerms());
        application.setConsentRejection(request.consentRejection());
        application.setConsentKvkk(request.consentKvkk());

        applicationRepository.save(application);
        InterviewPrescreen.applyIncomeSkipNote(application, incomeMax(season));

        Map<ApplicationDocumentType, MultipartFile> required = new EnumMap<>(ApplicationDocumentType.class);
        required.put(ApplicationDocumentType.PHOTO, files.get(ApplicationDocumentType.PHOTO));
        required.put(ApplicationDocumentType.ID_COPY, files.get(ApplicationDocumentType.ID_COPY));
        required.put(ApplicationDocumentType.FATHER_SALARY, files.get(ApplicationDocumentType.FATHER_SALARY));
        required.put(ApplicationDocumentType.MOTHER_SALARY, files.get(ApplicationDocumentType.MOTHER_SALARY));
        required.put(ApplicationDocumentType.STUDENT_CERT, files.get(ApplicationDocumentType.STUDENT_CERT));
        required.put(ApplicationDocumentType.TRANSCRIPT, files.get(ApplicationDocumentType.TRANSCRIPT));

        if (application.getStudyingSiblingCount() != null && application.getStudyingSiblingCount() > 0) {
            required.put(ApplicationDocumentType.SIBLING_STUDENT, files.get(ApplicationDocumentType.SIBLING_STUDENT));
        }

        for (var entry : required.entrySet()) {
            ApplicationDocument document = storageService.store(application, entry.getKey(), entry.getValue());
            documentRepository.save(document);
        }

        return getApplication(application.getId());
    }

    private static void validateConsents(ApplicationSubmitRequest request) {
        if (!Boolean.TRUE.equals(request.consentAccuracy())
                || !Boolean.TRUE.equals(request.consentTerms())
                || !Boolean.TRUE.equals(request.consentRejection())
                || !Boolean.TRUE.equals(request.consentKvkk())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tüm onay kutuları işaretlenmelidir");
        }
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    @Transactional
    public ApplicationSeasonResponse updateIncomePrescreen(Long seasonId, Integer familyIncomeInterviewMax) {
        if (familyIncomeInterviewMax == null || familyIncomeInterviewMax < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Gelir eşiği 0 veya daha büyük olmalıdır");
        }
        ApplicationSeason season = seasonRepository.findById(seasonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru dönemi bulunamadı"));
        season.setFamilyIncomeInterviewMax(familyIncomeInterviewMax);
        for (Application application : applicationRepository.findBySeasonId(seasonId)) {
            InterviewPrescreen.applyIncomeSkipNote(application, familyIncomeInterviewMax);
        }
        return ApplicationSeasonResponse.from(season);
    }

    private int incomeMax(ApplicationSeason season) {
        return InterviewPrescreen.incomeMax(season, appProperties.evaluation().familyIncomeInterviewMax());
    }
}
