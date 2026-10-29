package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarReview;
import org.idv.bursiyer.domain.ScholarReviewDecision;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.web.dto.SaveScholarReviewRequest;
import org.idv.bursiyer.web.dto.ScholarMissingRenewalResponse;
import org.idv.bursiyer.web.dto.ScholarRenewalListResponse;
import org.idv.bursiyer.web.dto.ScholarReviewResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ScholarReviewService {

    private final ScholarReviewRepository reviewRepository;
    private final ScholarRepository scholarRepository;
    private final DriveCacheService driveCacheService;

    public ScholarReviewService(
            ScholarReviewRepository reviewRepository,
            ScholarRepository scholarRepository,
            DriveCacheService driveCacheService
    ) {
        this.reviewRepository = reviewRepository;
        this.scholarRepository = scholarRepository;
        this.driveCacheService = driveCacheService;
    }

    @Transactional
    public ScholarRenewalListResponse list(Integer academicYear) {
        int year = academicYear == null ? AcademicYears.currentStartYear() : academicYear;
        linkReviewsToScholars(year);
        List<ScholarReview> reviews = reviewRepository.findDetailedByAcademicYear(year);
        List<ScholarReviewResponse> responses = reviews.stream()
                .map(review -> ScholarReviewResponse.from(review, driveCacheService::isReady))
                .toList();
        Set<Long> submittedIds = reviews.stream()
                .map(ScholarReview::getScholar)
                .filter(scholar -> scholar != null)
                .map(Scholar::getId)
                .collect(Collectors.toSet());
        List<ScholarMissingRenewalResponse> missing = scholarRepository
                .findByStatusAndActiveTrueOrderByLastNameAscFirstNameAsc(ScholarStatus.OGRENCI)
                .stream()
                .filter(scholar -> !isDemoScholar(scholar))
                .filter(scholar -> !submittedIds.contains(scholar.getId()))
                .map(scholar -> new ScholarMissingRenewalResponse(
                        scholar.getId(),
                        PersonNames.titleCase(scholar.getFirstName()),
                        PersonNames.titleCase(scholar.getLastName()),
                        scholar.getTcNo(),
                        scholar.getUniversity(),
                        scholar.getDepartment()
                ))
                .toList();
        return ScholarRenewalListResponse.of(year, responses, missing);
    }

    @Transactional
    public void linkReviewsToScholars(int academicYear) {
        List<Scholar> scholars = scholarRepository.findAll();
        for (ScholarReview review : reviewRepository.findDetailedByAcademicYear(academicYear)) {
            if (review.getScholar() == null && review.getTcNo() != null) {
                scholarRepository.findByTcNo(review.getTcNo()).ifPresent(review::setScholar);
            }
            if (review.getScholar() == null) {
                PersonNames.findByName(scholars, review.getFullName()).ifPresent(review::setScholar);
            }
            if (review.getScholar() != null) {
                String rosterName = PersonNames.titleCase(PersonNames.fullName(review.getScholar()));
                if (rosterName != null && !rosterName.isBlank()) {
                    review.setFullName(rosterName);
                }
            } else {
                String formatted = PersonNames.titleCase(review.getFullName());
                if (formatted != null && !formatted.equals(review.getFullName())) {
                    review.setFullName(formatted);
                }
            }
            boolean alreadyFlagged = review.isGpaBelowTwo();
            applyGpaRule(review);
            if (review.isGpaBelowTwo() && !alreadyFlagged) {
                applyScholarStatus(review);
            }
        }
    }

    private static final String GPA_STOP_NOTE =
            "4'lük sistemde 2'nin veya 100'lük sistemde 70'in altında olduğu için yenilemede devam edilmez.";

    static void applyGpaRule(ScholarReview review) {
        boolean lowGpa = review.isGpaBelowTwo() || GpaThreshold.belowContinuation(review.getGpa());
        if (!lowGpa) {
            return;
        }
        review.setGpaBelowTwo(true);
        if (review.getDecision() != ScholarReviewDecision.CONTINUE) {
            review.setDecision(ScholarReviewDecision.STOP);
        }
        String current = review.getNote();
        if (current != null && current.contains("yenilemede devam edilmez")) {
            return;
        }
        if (current == null || current.isBlank()) {
            review.setNote(GPA_STOP_NOTE);
        } else {
            review.setNote(current.trim() + "\n" + GPA_STOP_NOTE);
        }
    }

    private static boolean isDemoScholar(Scholar scholar) {
        String tc = scholar.getTcNo();
        return tc != null && tc.startsWith("123456789");
    }

    @Transactional
    public ScholarReviewResponse saveDecision(Long id, SaveScholarReviewRequest request) {
        ScholarReview review = reviewRepository.findDetailedById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Yenileme kaydı bulunamadı"));
        try {
            review.setDecision(parseDecision(request.decision()));
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage());
        }
        review.setNote(trimToNull(request.note()));
        if (request.graduating() != null) {
            if (request.graduating() && review.getScholar() != null
                    && !ScholarReviewResponse.isFourthYear(review.getScholar().getClassYear())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mezun işareti yalnızca 4. sınıf için");
            }
            review.setGraduating(request.graduating());
        }
        if (request.gpaBelowTwo() != null) {
            review.setGpaBelowTwo(request.gpaBelowTwo());
        }
        applyGpaRule(review);
        applyScholarStatus(review);
        return ScholarReviewResponse.from(review, driveCacheService::isReady);
    }

    private void applyScholarStatus(ScholarReview review) {
        Scholar scholar = review.getScholar();
        if (scholar == null) {
            return;
        }
        if (review.isGraduating()) {
            scholar.setStatus(ScholarStatus.MEZUN);
            scholar.setActive(false);
            if (scholar.getGraduationDate() == null) {
                scholar.setGraduationDate(LocalDate.now());
            }
            return;
        }
        if (review.getDecision() == ScholarReviewDecision.STOP) {
            scholar.setActive(false);
            if (!hasStudentCert(review)) {
                scholar.setStatus(ScholarStatus.MEZUN);
                if (scholar.getGraduationDate() == null) {
                    scholar.setGraduationDate(LocalDate.now());
                }
            }
            return;
        }
        if (review.getDecision() == ScholarReviewDecision.CONTINUE) {
            scholar.setActive(true);
            scholar.setStatus(ScholarStatus.OGRENCI);
        }
    }

    private static boolean hasStudentCert(ScholarReview review) {
        return review.getStudentCertUrl() != null && !review.getStudentCertUrl().isBlank();
    }

    private static ScholarReviewDecision parseDecision(String raw) {
        if (raw == null || raw.isBlank()) {
            return ScholarReviewDecision.PENDING;
        }
        try {
            return ScholarReviewDecision.valueOf(raw.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException("Karar PENDING, CONTINUE veya STOP olmalı");
        }
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
