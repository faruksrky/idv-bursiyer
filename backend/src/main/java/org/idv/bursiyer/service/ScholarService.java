package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarIntake;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.ProgramAttendanceRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.web.dto.ScholarResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ScholarService {

    /** Same renewal year the accounting roster uses for CONTINUE decisions. */
    static final int ROSTER_RENEWAL_YEAR = 2026;

    private final ScholarRepository scholarRepository;
    private final ProgramAttendanceRepository attendanceRepository;
    private final ApplicationRepository applicationRepository;
    private final ScholarReviewRepository scholarReviewRepository;

    public ScholarService(
            ScholarRepository scholarRepository,
            ProgramAttendanceRepository attendanceRepository,
            ApplicationRepository applicationRepository,
            ScholarReviewRepository scholarReviewRepository
    ) {
        this.scholarRepository = scholarRepository;
        this.attendanceRepository = attendanceRepository;
        this.applicationRepository = applicationRepository;
        this.scholarReviewRepository = scholarReviewRepository;
    }

    @Transactional
    public List<ScholarResponse> listScholars(ScholarStatus status) {
        List<Scholar> scholars;
        if (status == ScholarStatus.MEZUN) {
            scholars = scholarRepository.findGraduates();
        } else if (status == ScholarStatus.OGRENCI) {
            scholars = scholarRepository.findActiveStudents(status);
        } else {
            scholars = scholarRepository.findByActiveTrueOrderByLastNameAscFirstNameAsc();
        }

        for (Scholar scholar : scholars) {
            String first = PersonNames.titleCase(scholar.getFirstName());
            String last = PersonNames.titleCase(scholar.getLastName());
            if (first != null && !first.equals(scholar.getFirstName())) {
                scholar.setFirstName(first);
            }
            if (last != null && !last.equals(scholar.getLastName())) {
                scholar.setLastName(last);
            }
        }

        Map<Long, Long> attendedCounts = attendanceRepository.countAttendedProgramsByScholar().stream()
                .collect(Collectors.toMap(
                        row -> (Long) row[0],
                        row -> (Long) row[1]
                ));
        RosterGroups groups = rosterGroups();

        return scholars.stream()
                .map(scholar -> ScholarResponse.from(
                        scholar,
                        attendedCounts.getOrDefault(scholar.getId(), 0L),
                        groups.intakeOf(scholar.getId())
                ))
                .toList();
    }

    @Transactional
    public ScholarResponse updateIban(Long id, String iban) {
        Scholar scholar = scholarRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bursiyer bulunamadı"));
        String normalized = normalizeIban(iban);
        if (normalized == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "IBAN boş olamaz");
        }
        if (!isValidIban(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "IBAN formatı geçersiz (TR + 24 hane)");
        }
        scholarRepository.findByIban(normalized)
                .filter(other -> !other.getId().equals(id))
                .ifPresent(other -> {
                    throw new ResponseStatusException(HttpStatus.CONFLICT, "Bu IBAN başka bir bursiyerde kayıtlı");
                });
        scholar.setIban(normalized);
        return ScholarResponse.from(scholar, 0L, rosterGroups().intakeOf(scholar.getId()));
    }

    /**
     * President quota is never folded into the interview-passed group, even if a result exists.
     * Renewal wins over a passed interview when both are present.
     */
    private RosterGroups rosterGroups() {
        return new RosterGroups(
                ids(applicationRepository.findPresidentQuotaScholarIds()),
                ids(scholarReviewRepository.findContinueScholarIds(ROSTER_RENEWAL_YEAR)),
                ids(applicationRepository.findInterviewPassedScholarIds())
        );
    }

    private static Set<Long> ids(List<Long> values) {
        return values.isEmpty() ? Set.of() : new HashSet<>(values);
    }

    private record RosterGroups(Set<Long> presidentQuota, Set<Long> renewal, Set<Long> interview) {
        private ScholarIntake intakeOf(Long scholarId) {
            if (scholarId == null) {
                return null;
            }
            if (presidentQuota.contains(scholarId)) {
                return ScholarIntake.PRESIDENT_QUOTA;
            }
            if (renewal.contains(scholarId)) {
                return ScholarIntake.RENEWAL;
            }
            if (interview.contains(scholarId)) {
                return ScholarIntake.INTERVIEW;
            }
            return null;
        }
    }

    static String normalizeIban(String iban) {
        if (iban == null) {
            return null;
        }
        String compact = iban.replace(" ", "").replace("-", "").toUpperCase();
        return compact.isBlank() ? null : compact;
    }

    static boolean isValidIban(String iban) {
        return iban != null && iban.matches("TR[0-9]{24}");
    }
}
