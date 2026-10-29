package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.ExcuseStatus;
import org.idv.bursiyer.domain.MonthlyProgram;
import org.idv.bursiyer.domain.ProgramAttendance;
import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.MonthlyProgramRepository;
import org.idv.bursiyer.repository.ProgramAttendanceRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.web.dto.AttendanceUpdateRequest;
import org.idv.bursiyer.web.dto.ProgramEventRequest;
import org.idv.bursiyer.web.dto.ScholarProgramAttendanceResponse;
import org.idv.bursiyer.web.dto.ScholarSeasonAttendanceResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AttendanceService {

    private static final int[] SEASON_MONTHS = {10, 11, 12, 1, 2, 3, 4, 5, 6, 7};

    private static final Comparator<ProgramAttendance> PERIOD_ORDER = Comparator
            .comparing(
                    (ProgramAttendance row) -> row.getProgram().getProgramDate(),
                    Comparator.nullsLast(Comparator.naturalOrder())
            )
            .thenComparing(row -> row.getProgram().getId())
            .thenComparing(row -> row.getScholar().getLastName(), Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER))
            .thenComparing(row -> row.getScholar().getFirstName(), Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));

    private final MonthlyProgramRepository programRepository;
    private final ScholarRepository scholarRepository;
    private final ProgramAttendanceRepository attendanceRepository;
    private final ApplicationRepository applicationRepository;

    public AttendanceService(
            MonthlyProgramRepository programRepository,
            ScholarRepository scholarRepository,
            ProgramAttendanceRepository attendanceRepository,
            ApplicationRepository applicationRepository
    ) {
        this.programRepository = programRepository;
        this.scholarRepository = scholarRepository;
        this.attendanceRepository = attendanceRepository;
        this.applicationRepository = applicationRepository;
    }

    @Transactional(readOnly = true)
    public List<ScholarProgramAttendanceResponse> listScholarProgramHistory(
            Long scholarId,
            Integer year,
            Integer month,
            AttendanceStatus attendanceStatus
    ) {
        scholarRepository.findById(scholarId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bursiyer bulunamadı"));

        return attendanceRepository.findByScholarIdWithProgram(scholarId).stream()
                .filter(row -> year == null || row.getProgram().getYear() == year)
                .filter(row -> month == null || row.getProgram().getMonth() == month)
                .filter(row -> attendanceStatus == null || row.getAttendanceStatus() == attendanceStatus)
                .map(ScholarProgramAttendanceResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ScholarSeasonAttendanceResponse> listScholarSeasonAttendance(Long scholarId, int academicYear) {
        scholarRepository.findById(scholarId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bursiyer bulunamadı"));

        Map<String, List<ProgramAttendance>> attendanceByPeriod = attendanceRepository
                .findByScholarIdWithProgram(scholarId)
                .stream()
                .collect(Collectors.groupingBy(row -> periodKey(row.getProgram().getYear(), row.getProgram().getMonth())));

        Map<String, List<MonthlyProgram>> programsByPeriod = programRepository
                .findInAcademicSeason(academicYear, academicYear + 1)
                .stream()
                .collect(Collectors.groupingBy(program -> periodKey(program.getYear(), program.getMonth())));

        List<ScholarSeasonAttendanceResponse> rows = new ArrayList<>();
        for (int month : SEASON_MONTHS) {
            int year = seasonMonthYear(academicYear, month);
            String key = periodKey(year, month);
            List<ProgramAttendance> attendances = attendanceByPeriod.getOrDefault(key, List.of());
            List<MonthlyProgram> programs = programsByPeriod.getOrDefault(key, List.of());
            String periodLabel = formatPeriodLabel(year, month);

            if (attendances.size() == 1) {
                ProgramAttendance attendance = attendances.get(0);
                rows.add(new ScholarSeasonAttendanceResponse(
                        year,
                        month,
                        periodLabel,
                        attendance.getProgram().getName(),
                        attendance.getAttendanceStatus(),
                        attendance.getExcuseStatus(),
                        attendance.getExcuseText(),
                        attendance.isPaymentEligible(),
                        true,
                        true
                ));
                continue;
            }

            if (attendances.size() > 1) {
                boolean eligible = attendances.stream().anyMatch(ProgramAttendance::isPaymentEligible);
                boolean attended = attendances.stream()
                        .anyMatch(row -> row.getAttendanceStatus() == AttendanceStatus.KATILDI);
                ProgramAttendance excuseSource = attendances.stream()
                        .filter(row -> !row.isPaymentEligible())
                        .findFirst()
                        .orElse(attendances.get(0));
                rows.add(new ScholarSeasonAttendanceResponse(
                        year,
                        month,
                        periodLabel,
                        programNames(programs, attendances),
                        attended ? AttendanceStatus.KATILDI : AttendanceStatus.KATILMADI,
                        eligible ? null : excuseSource.getExcuseStatus(),
                        eligible ? null : excuseSource.getExcuseText(),
                        eligible,
                        true,
                        true
                ));
                continue;
            }

            if (!programs.isEmpty()) {
                rows.add(new ScholarSeasonAttendanceResponse(
                        year,
                        month,
                        periodLabel,
                        programNames(programs, List.of()),
                        AttendanceStatus.KATILMADI,
                        ExcuseStatus.YOK,
                        null,
                        false,
                        true,
                        false
                ));
                continue;
            }

            rows.add(new ScholarSeasonAttendanceResponse(
                    year,
                    month,
                    periodLabel,
                    null,
                    null,
                    null,
                    null,
                    false,
                    false,
                    false
            ));
        }
        return rows;
    }

    @Transactional(readOnly = true)
    public List<MonthlyProgram> listPrograms(int year, int month) {
        validatePeriod(year, month);
        return programRepository.findByYearAndMonthOrderByProgramDateAscIdAsc(year, month).stream()
                .sorted(Comparator
                        .comparing(MonthlyProgram::getProgramDate, Comparator.nullsLast(Comparator.naturalOrder()))
                        .thenComparing(MonthlyProgram::getId))
                .toList();
    }

    @Transactional
    public MonthlyProgram createProgram(ProgramEventRequest request) {
        String name = requireName(request == null ? null : request.name());
        LocalDate programDate = requireDate(request == null ? null : request.programDate());
        int year = programDate.getYear();
        int month = programDate.getMonthValue();
        if (programRepository.existsByYearAndMonthAndProgramDateAndNameIgnoreCase(year, month, programDate, name)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Bu ay için aynı ad ve tarihte program zaten var");
        }

        MonthlyProgram program = new MonthlyProgram();
        program.setYear(year);
        program.setMonth(month);
        program.setName(name);
        program.setProgramDate(programDate);
        MonthlyProgram saved = programRepository.save(program);
        ensureAttendanceRows(saved, presidentQuotaScholarIds());
        return saved;
    }

    @Transactional
    public MonthlyProgram updateProgram(Long programId, ProgramEventRequest request) {
        MonthlyProgram program = programRepository.findById(programId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Program bulunamadı"));
        String name = requireName(request == null ? null : request.name());
        LocalDate programDate = requireDate(request == null ? null : request.programDate());
        int year = programDate.getYear();
        int month = programDate.getMonthValue();

        boolean duplicate = programRepository
                .findByYearAndMonthAndProgramDateAndNameIgnoreCase(year, month, programDate, name)
                .stream()
                .anyMatch(existing -> !existing.getId().equals(program.getId()));
        if (duplicate) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Bu ay için aynı ad ve tarihte program zaten var");
        }

        program.setName(name);
        program.setProgramDate(programDate);
        program.setYear(year);
        program.setMonth(month);
        return programRepository.save(program);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public List<ProgramAttendance> listForPeriod(int year, int month) {
        validatePeriod(year, month);
        List<MonthlyProgram> programs = programRepository.findByYearAndMonthOrderByProgramDateAscIdAsc(year, month);
        if (programs.isEmpty()) {
            return List.of();
        }

        Set<Long> presidentQuota = presidentQuotaScholarIds();
        for (MonthlyProgram program : programs) {
            ensureAttendanceRows(program, presidentQuota);
        }
        Set<Long> visibleScholars = activeTakipScholarIds(presidentQuota);
        return attendanceRepository.findByProgramPeriod(year, month).stream()
                .filter(row -> visibleScholars.contains(row.getScholar().getId()))
                .sorted(PERIOD_ORDER)
                .toList();
    }

    @Transactional
    public ProgramAttendance updateAttendance(Long attendanceId, AttendanceUpdateRequest request) {
        ProgramAttendance attendance = attendanceRepository.findByIdWithScholar(attendanceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Katılım kaydı bulunamadı"));

        validateAttendanceRequest(request);

        attendance.setAttendanceStatus(request.attendanceStatus());
        if (request.attendanceStatus() == AttendanceStatus.KATILDI) {
            attendance.setExcuseText(null);
            attendance.setExcuseStatus(null);
        } else {
            attendance.setExcuseText(request.excuseText());
            attendance.setExcuseStatus(request.excuseStatus() != null ? request.excuseStatus() : ExcuseStatus.YOK);
        }

        return attendanceRepository.save(attendance);
    }

    private void validateAttendanceRequest(AttendanceUpdateRequest request) {
        if (request.attendanceStatus() == AttendanceStatus.KATILMADI) {
            if (request.excuseStatus() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Katılmayan için mazeret durumu (KABUL/RED/YOK) zorunlu");
            }
            if (request.excuseStatus() == ExcuseStatus.KABUL || request.excuseStatus() == ExcuseStatus.RED) {
                if (request.excuseText() == null || request.excuseText().isBlank()) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mazeret kabul/red için açıklama zorunlu");
                }
            }
        }
    }

    private Set<Long> presidentQuotaScholarIds() {
        List<Long> ids = applicationRepository.findPresidentQuotaScholarIds();
        return ids.isEmpty() ? Set.of() : new HashSet<>(ids);
    }

    private Set<Long> activeTakipScholarIds(Set<Long> presidentQuota) {
        return scholarRepository.findActiveStudents(ScholarStatus.OGRENCI).stream()
                .map(Scholar::getId)
                .filter(id -> !presidentQuota.contains(id))
                .collect(Collectors.toSet());
    }

    private void ensureAttendanceRows(MonthlyProgram program, Set<Long> presidentQuota) {
        List<Scholar> activeScholars = scholarRepository.findActiveStudents(ScholarStatus.OGRENCI);
        if (activeScholars.isEmpty()) {
            return;
        }

        List<ProgramAttendance> existing = attendanceRepository.findByProgramIdWithScholar(program.getId());
        Map<Long, ProgramAttendance> byScholarId = existing.stream()
                .collect(Collectors.toMap(row -> row.getScholar().getId(), row -> row, (left, right) -> left));

        List<ProgramAttendance> toCreate = new ArrayList<>();
        for (Scholar scholar : activeScholars) {
            if (presidentQuota.contains(scholar.getId()) || byScholarId.containsKey(scholar.getId())) {
                continue;
            }
            ProgramAttendance attendance = new ProgramAttendance();
            attendance.setProgram(program);
            attendance.setScholar(scholar);
            attendance.setAttendanceStatus(AttendanceStatus.KATILMADI);
            attendance.setExcuseStatus(ExcuseStatus.YOK);
            toCreate.add(attendance);
        }
        if (!toCreate.isEmpty()) {
            attendanceRepository.saveAll(toCreate);
        }
    }

    private static void validatePeriod(int year, int month) {
        if (year < 2000 || year > 2100 || month < 1 || month > 12) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz dönem");
        }
    }

    private static String requireName(String name) {
        if (name == null || name.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Program adı zorunlu");
        }
        String trimmed = name.trim();
        if (trimmed.length() > 255) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Program adı en fazla 255 karakter olabilir");
        }
        return trimmed;
    }

    private static LocalDate requireDate(LocalDate programDate) {
        if (programDate == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tarih zorunlu");
        }
        int year = programDate.getYear();
        if (year < 2000 || year > 2100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tarih geçersiz");
        }
        return programDate;
    }

    private static String programNames(List<MonthlyProgram> programs, List<ProgramAttendance> attendances) {
        if (!programs.isEmpty()) {
            return programs.stream()
                    .map(MonthlyProgram::getName)
                    .distinct()
                    .collect(Collectors.joining(" · "));
        }
        return attendances.stream()
                .map(row -> row.getProgram().getName())
                .distinct()
                .collect(Collectors.joining(" · "));
    }

    private static int seasonMonthYear(int academicYear, int month) {
        return month >= 10 ? academicYear : academicYear + 1;
    }

    private static String periodKey(int year, int month) {
        return year + "-" + month;
    }

    private static String formatPeriodLabel(int year, int month) {
        String[] labels = {
                "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
                "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
        };
        return labels[month - 1] + " " + year;
    }
}
