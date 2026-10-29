package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.domain.InterviewAttendance;
import org.idv.bursiyer.domain.InterviewSession;
import org.idv.bursiyer.repository.InterviewSessionRepository;
import org.idv.bursiyer.web.dto.InterviewCalendarDayResponse;
import org.idv.bursiyer.web.dto.InterviewCalendarResponse;
import org.idv.bursiyer.web.dto.InterviewCalendarSlotResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Service
public class InterviewCalendarService {

    public static final ZoneId ISTANBUL = ZoneId.of("Europe/Istanbul");
    public static final String LOCATION = "Haseki Sultan, Haseki Cd. No:11, 34096 Fatih/İstanbul";
    public static final LocalDate FIRST_DAY = LocalDate.of(2026, 10, 5);
    public static final LocalDate LAST_DAY = LocalDate.of(2026, 10, 7);

    private static final Locale TR = Locale.forLanguageTag("tr-TR");
    private static final DateTimeFormatter DAY_LABEL =
            DateTimeFormatter.ofPattern("d MMMM yyyy", TR);
    private static final Set<String> UNSCHEDULED_EMAILS = Set.of(
            "zainaturkiyede@gmail.com",
            "elifcerit19@gmail.com"
    );

    private final InterviewSessionRepository sessionRepository;

    public InterviewCalendarService(InterviewSessionRepository sessionRepository) {
        this.sessionRepository = sessionRepository;
    }

    @Transactional(readOnly = true)
    public InterviewCalendarResponse getCalendar() {
        Instant from = FIRST_DAY.atStartOfDay(ISTANBUL).toInstant();
        Instant to = LAST_DAY.plusDays(1).atStartOfDay(ISTANBUL).toInstant();
        List<InterviewSession> scheduled = sessionRepository.findScheduledBetween(from, to);
        List<InterviewSession> unscheduled = sessionRepository.findUnscheduledByEmails(UNSCHEDULED_EMAILS);

        Map<LocalDate, List<InterviewCalendarSlotResponse>> byDay = new LinkedHashMap<>();
        for (LocalDate day = FIRST_DAY; !day.isAfter(LAST_DAY); day = day.plusDays(1)) {
            byDay.put(day, new ArrayList<>());
        }
        for (InterviewSession session : scheduled) {
            if (session.getScheduledAt() == null) {
                continue;
            }
            LocalDate day = session.getScheduledAt().atZone(ISTANBUL).toLocalDate();
            List<InterviewCalendarSlotResponse> slots = byDay.get(day);
            if (slots != null) {
                slots.add(toSlot(session));
            }
        }

        List<InterviewCalendarDayResponse> days = new ArrayList<>();
        byDay.forEach((date, slots) -> days.add(new InterviewCalendarDayResponse(
                date.toString(),
                weekdayLabel(date),
                weekdayLabel(date) + " " + date.format(DAY_LABEL),
                List.copyOf(slots)
        )));

        return new InterviewCalendarResponse(
                LOCATION,
                List.copyOf(days),
                unscheduled.stream().map(InterviewCalendarService::toSlot).toList()
        );
    }

    @Transactional
    public InterviewCalendarSlotResponse updateAttendance(Long applicationId, String attendanceValue) {
        InterviewSession session = sessionRepository.findDetailedByApplicationId(applicationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Mülakat kaydı bulunamadı"));
        if (!isOnCalendar(session)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bu aday mülakat takviminde değil");
        }
        InterviewAttendance attendance;
        try {
            attendance = InterviewAttendance.parse(attendanceValue);
        } catch (IllegalArgumentException exception) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage());
        }
        session.setAttendanceStatus(attendance);
        if (session.getScheduledAt() != null
                && session.getApplication().getStatus() == ApplicationStatus.SUBMITTED) {
            session.getApplication().setStatus(ApplicationStatus.INTERVIEW_SCHEDULED);
        }
        return toSlot(session);
    }

    private boolean isOnCalendar(InterviewSession session) {
        Instant scheduledAt = session.getScheduledAt();
        if (scheduledAt != null) {
            LocalDate day = scheduledAt.atZone(ISTANBUL).toLocalDate();
            return !day.isBefore(FIRST_DAY) && !day.isAfter(LAST_DAY);
        }
        String email = session.getApplication().getEmail();
        return email != null && UNSCHEDULED_EMAILS.contains(email.trim().toLowerCase(Locale.ROOT));
    }

    private static InterviewCalendarSlotResponse toSlot(InterviewSession session) {
        return new InterviewCalendarSlotResponse(
                session.getApplication().getId(),
                session.getId(),
                session.getApplication().getFullName(),
                session.getScheduledAt(),
                session.getAttendanceStatus()
        );
    }

    static String weekdayLabel(LocalDate date) {
        return switch (date.getDayOfWeek()) {
            case MONDAY -> "Pazartesi";
            case TUESDAY -> "Salı";
            case WEDNESDAY -> "Çarşamba";
            case THURSDAY -> "Perşembe";
            case FRIDAY -> "Cuma";
            case SATURDAY -> "Cumartesi";
            case SUNDAY -> "Pazar";
        };
    }
}
