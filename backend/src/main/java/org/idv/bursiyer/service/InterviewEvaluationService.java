package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.domain.InterviewResult;
import org.idv.bursiyer.domain.EvaluationCriterion;
import org.idv.bursiyer.domain.InterviewEvaluation;
import org.idv.bursiyer.domain.InterviewEvaluationScore;
import org.idv.bursiyer.domain.InterviewSession;
import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.EvaluationCriterionRepository;
import org.idv.bursiyer.repository.InterviewEvaluationRepository;
import org.idv.bursiyer.repository.InterviewSessionRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.service.CurrentUserService.EvaluatorIdentity;
import org.idv.bursiyer.web.dto.ApplicationDecisionResponse;
import org.idv.bursiyer.web.dto.CriterionScoreResponse;
import org.idv.bursiyer.web.dto.EvaluationCriterionResponse;
import org.idv.bursiyer.web.dto.EvaluationQueueItemResponse;
import org.idv.bursiyer.web.dto.EvaluationScoreInput;
import org.idv.bursiyer.web.dto.InterviewEvaluationResponse;
import org.idv.bursiyer.web.dto.MemberEvaluationResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.time.LocalDate;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class InterviewEvaluationService {

    private static final Set<ApplicationStatus> EVALUATION_QUEUE_STATUSES = EnumSet.of(
            ApplicationStatus.SUBMITTED,
            ApplicationStatus.INTERVIEW_SCHEDULED,
            ApplicationStatus.EVALUATION_IN_PROGRESS,
            ApplicationStatus.EVALUATION_COMPLETE
    );

    private final ApplicationRepository applicationRepository;
    private final EvaluationCriterionRepository criterionRepository;
    private final InterviewSessionRepository sessionRepository;
    private final InterviewEvaluationRepository evaluationRepository;
    private final ScholarRepository scholarRepository;
    private final CurrentUserService currentUserService;
    private final AppProperties appProperties;

    public InterviewEvaluationService(
            ApplicationRepository applicationRepository,
            EvaluationCriterionRepository criterionRepository,
            InterviewSessionRepository sessionRepository,
            InterviewEvaluationRepository evaluationRepository,
            ScholarRepository scholarRepository,
            CurrentUserService currentUserService,
            AppProperties appProperties
    ) {
        this.applicationRepository = applicationRepository;
        this.criterionRepository = criterionRepository;
        this.sessionRepository = sessionRepository;
        this.evaluationRepository = evaluationRepository;
        this.scholarRepository = scholarRepository;
        this.currentUserService = currentUserService;
        this.appProperties = appProperties;
    }

    @Transactional(readOnly = true)
    public List<EvaluationQueueItemResponse> listQueue(Long seasonId) {
        return applicationRepository.findBySeasonId(seasonId).stream()
                .filter(application -> EVALUATION_QUEUE_STATUSES.contains(application.getStatus()))
                .filter(application -> InterviewPrescreen.isInterviewEligible(
                        application,
                        incomeMax(application)
                ))
                .map(this::toQueueItem)
                .toList();
    }

    @Transactional(readOnly = true)
    public InterviewEvaluationResponse getEvaluation(Long applicationId) {
        Application application = loadApplication(applicationId);
        InterviewSession session = getOrCreateSessionReadOnly(application);
        EvaluatorIdentity evaluator = currentUserService.currentEvaluator();
        return buildEvaluationResponse(application, session, evaluator.sub());
    }

    @Transactional
    public InterviewEvaluationResponse scheduleInterview(Long applicationId, Instant scheduledAt) {
        throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Mülakat planlama şimdilik kapalı. Atama ve e-posta sonra yapılacak."
        );
    }

    @Transactional
    public InterviewEvaluationResponse submitEvaluation(
            Long applicationId,
            List<EvaluationScoreInput> scoreInputs,
            String note
    ) {
        Application application = loadApplication(applicationId);
        if (application.getStatus() == ApplicationStatus.ACCEPTED
                || application.getStatus() == ApplicationStatus.REJECTED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Karar verilmiş başvuruya puan girilemez");
        }
        if (application.getStatus() == ApplicationStatus.SUBMITTED
                && !InterviewPrescreen.isInterviewEligible(
                        application,
                        incomeMax(application)
                )) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Aile geliri mülakat eşiğinin üzerinde olduğu için puan girilemez"
            );
        }

        List<EvaluationCriterion> criteria = criterionRepository.findByActiveTrueOrderBySortOrderAsc();
        Map<Long, EvaluationCriterion> criteriaById = new HashMap<>();
        for (EvaluationCriterion criterion : criteria) {
            criteriaById.put(criterion.getId(), criterion);
        }

        validateScores(scoreInputs, criteriaById);

        InterviewSession session = sessionRepository.findByApplicationId(applicationId)
                .orElseGet(() -> createSession(application));
        EvaluatorIdentity evaluator = currentUserService.currentEvaluator();

        InterviewEvaluation evaluation = evaluationRepository
                .findDetailedBySessionIdAndEvaluatorSub(session.getId(), evaluator.sub())
                .or(() -> evaluationRepository.findBySessionIdAndEvaluatorSub(session.getId(), evaluator.sub()))
                .orElseGet(InterviewEvaluation::new);

        evaluation.setSession(session);
        evaluation.setEvaluatorSub(evaluator.sub());
        evaluation.setEvaluatorName(evaluator.name());
        evaluation.setSubmittedAt(Instant.now());
        evaluation.setNote(trimToNull(note));
        upsertScores(evaluation, scoreInputs, criteriaById);
        evaluationRepository.save(evaluation);

        updateApplicationStatusAfterEvaluation(application, session);
        sessionRepository.save(session);

        return buildEvaluationResponse(application, session, evaluator.sub());
    }

    @Transactional
    public ApplicationDecisionResponse decide(Long applicationId, String decision) {
        Application application = loadApplication(applicationId);
        if (!"ACCEPTED".equalsIgnoreCase(decision) && !"REJECTED".equalsIgnoreCase(decision)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Karar ACCEPTED veya REJECTED olmalı");
        }

        if (application.getStatus() == ApplicationStatus.ACCEPTED
                || application.getStatus() == ApplicationStatus.REJECTED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bu başvuru için karar zaten verilmiş");
        }

        if ("ACCEPTED".equalsIgnoreCase(decision)) {
            application.setStatus(ApplicationStatus.ACCEPTED);
            Scholar scholar = application.getScholar();
            if (scholar == null) {
                scholar = createScholarFromApplication(application);
                application.setScholar(scholar);
            }
            applicationRepository.save(application);
            return new ApplicationDecisionResponse(applicationId, ApplicationStatus.ACCEPTED.name(), scholar.getId());
        }

        application.setStatus(ApplicationStatus.REJECTED);
        applicationRepository.save(application);
        return new ApplicationDecisionResponse(applicationId, ApplicationStatus.REJECTED.name(), null);
    }

    private Application loadApplication(Long applicationId) {
        return applicationRepository.findDetailedById(applicationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru bulunamadı"));
    }

    private int incomeMax(Application application) {
        return InterviewPrescreen.incomeMax(
                application.getSeason(),
                appProperties.evaluation().familyIncomeInterviewMax()
        );
    }

    private InterviewSession getOrCreateSessionReadOnly(Application application) {
        return sessionRepository.findByApplicationId(application.getId())
                .orElseGet(() -> {
                    InterviewSession session = new InterviewSession();
                    session.setApplication(application);
                    return session;
                });
    }

    private InterviewSession createSession(Application application) {
        InterviewSession session = new InterviewSession();
        session.setApplication(application);
        return sessionRepository.save(session);
    }

    private void updateApplicationStatusAfterEvaluation(Application application, InterviewSession session) {
        List<InterviewEvaluation> evaluations = uniqueByEvaluator(
                evaluationRepository.findBySessionIdOrderBySubmittedAtAsc(session.getId())
        );
        int committeeSize = appProperties.evaluation().committeeMemberCount();

        if (application.getStatus() == ApplicationStatus.SUBMITTED
                || application.getStatus() == ApplicationStatus.INTERVIEW_SCHEDULED) {
            application.setStatus(ApplicationStatus.EVALUATION_IN_PROGRESS);
        }

        if (evaluations.size() >= committeeSize) {
            application.setStatus(ApplicationStatus.EVALUATION_COMPLETE);
        }
        syncInterviewResultFromCommitteeAverage(application, evaluations);
    }

    /**
     * Official Geçti/Kaldı follows committee average vs pass threshold (inclusive 80).
     * Applied whenever an average exists, and always refreshed at 5/5 so a later score
     * that crosses the line updates the result. Staff can still override afterwards.
     * Başkan kontenjanı and other non-interview tracks are never kaldı.
     */
    private void syncInterviewResultFromCommitteeAverage(
            Application application,
            List<InterviewEvaluation> evaluations
    ) {
        if (!InterviewPrescreen.isInterviewEligible(application, incomeMax(application))
                || evaluations.isEmpty()) {
            return;
        }
        double committeeAverage = evaluations.stream()
                .mapToInt(InterviewEvaluation::getTotalScore)
                .average()
                .orElse(0);
        int passThreshold = appProperties.evaluation().interviewPassThreshold();
        application.setInterviewResult(
                InterviewResult.fromCommitteeAverage(committeeAverage, passThreshold)
        );
    }

    private InterviewEvaluationResponse buildEvaluationResponse(
            Application application,
            InterviewSession session,
            String currentEvaluatorSub
    ) {
        List<EvaluationCriterion> criteria = criterionRepository.findByActiveTrueOrderBySortOrderAsc();
        List<EvaluationCriterionResponse> criterionResponses = criteria.stream()
                .map(c -> new EvaluationCriterionResponse(c.getId(), c.getCode(), c.getLabel(), c.getMaxScore()))
                .toList();

        Long sessionId = session.getId();
        List<InterviewEvaluation> evaluations = sessionId == null
                ? List.of()
                : uniqueByEvaluator(evaluationRepository.findDetailedBySessionId(sessionId));

        List<MemberEvaluationResponse> committeeEvaluations = evaluations.stream()
                .map(this::toMemberEvaluation)
                .toList();

        MemberEvaluationResponse myEvaluation = committeeEvaluations.stream()
                .filter(member -> member.evaluatorSub().equals(currentEvaluatorSub))
                .findFirst()
                .orElse(null);

        int committeeMemberCount = appProperties.evaluation().committeeMemberCount();
        int passThreshold = appProperties.evaluation().interviewPassThreshold();
        int submittedCount = committeeEvaluations.size();
        boolean evaluationComplete = submittedCount >= committeeMemberCount;

        Double committeeAverage = null;
        String recommendedResult = null;
        if (!committeeEvaluations.isEmpty()) {
            committeeAverage = committeeEvaluations.stream()
                    .mapToInt(MemberEvaluationResponse::totalScore)
                    .average()
                    .orElse(0);
            recommendedResult = committeeAverage >= passThreshold ? "OLUMLU" : "OLUMSUZ";
        }

        return new InterviewEvaluationResponse(
                application.getId(),
                PersonNames.titleCase(application.getFullName()),
                application.getSeason().getCode(),
                application.getStatus().name(),
                session.getScheduledAt(),
                passThreshold,
                committeeMemberCount,
                submittedCount,
                evaluationComplete,
                committeeAverage,
                recommendedResult,
                criterionResponses,
                myEvaluation,
                committeeEvaluations
        );
    }

    private EvaluationQueueItemResponse toQueueItem(Application application) {
        InterviewSession session = sessionRepository.findByApplicationId(application.getId()).orElse(null);
        List<InterviewEvaluation> evaluations = session == null
                ? List.of()
                : uniqueByEvaluator(evaluationRepository.findBySessionIdOrderBySubmittedAtAsc(session.getId()));

        int committeeMemberCount = appProperties.evaluation().committeeMemberCount();
        int passThreshold = appProperties.evaluation().interviewPassThreshold();
        int submittedCount = evaluations.size();

        Double committeeAverage = null;
        String recommendedResult = null;
        if (!evaluations.isEmpty()) {
            committeeAverage = evaluations.stream()
                    .mapToInt(InterviewEvaluation::getTotalScore)
                    .average()
                    .orElse(0);
            recommendedResult = committeeAverage >= passThreshold ? "OLUMLU" : "OLUMSUZ";
        }

        return new EvaluationQueueItemResponse(
                application.getId(),
                PersonNames.titleCase(application.getFullName()),
                application.getTcNo(),
                application.getUniversity(),
                application.getDepartment(),
                application.getStatus().name(),
                session != null ? session.getScheduledAt() : null,
                submittedCount,
                committeeMemberCount,
                committeeAverage,
                recommendedResult
        );
    }

    private MemberEvaluationResponse toMemberEvaluation(InterviewEvaluation evaluation) {
        List<CriterionScoreResponse> scores = evaluation.getScores().stream()
                .map(score -> new CriterionScoreResponse(
                        score.getCriterion().getId(),
                        score.getCriterion().getCode(),
                        score.getCriterion().getLabel(),
                        score.getCriterion().getMaxScore(),
                        score.getScore()
                ))
                .toList();

        return new MemberEvaluationResponse(
                evaluation.getEvaluatorSub(),
                evaluation.getEvaluatorName(),
                evaluation.getTotalScore(),
                evaluation.getSubmittedAt(),
                evaluation.getNote(),
                scores
        );
    }

    private void upsertScores(
            InterviewEvaluation evaluation,
            List<EvaluationScoreInput> scoreInputs,
            Map<Long, EvaluationCriterion> criteriaById
    ) {
        Map<Long, InterviewEvaluationScore> existingByCriterionId = new HashMap<>();
        for (InterviewEvaluationScore score : evaluation.getScores()) {
            existingByCriterionId.put(score.getCriterion().getId(), score);
        }

        Set<Long> incomingIds = new HashSet<>();
        int total = 0;
        for (EvaluationScoreInput input : scoreInputs) {
            incomingIds.add(input.criterionId());
            EvaluationCriterion criterion = criteriaById.get(input.criterionId());
            InterviewEvaluationScore scoreEntity = existingByCriterionId.get(input.criterionId());
            if (scoreEntity == null) {
                scoreEntity = new InterviewEvaluationScore();
                scoreEntity.setEvaluation(evaluation);
                scoreEntity.setCriterion(criterion);
                evaluation.getScores().add(scoreEntity);
            }
            int score = input.score() == null ? 0 : input.score();
            scoreEntity.setScore(score);
            total += score;
        }

        evaluation.getScores().removeIf(score -> !incomingIds.contains(score.getCriterion().getId()));
        evaluation.setTotalScore(total);
    }

    private List<InterviewEvaluation> uniqueByEvaluator(List<InterviewEvaluation> evaluations) {
        Map<String, InterviewEvaluation> unique = new LinkedHashMap<>();
        for (InterviewEvaluation evaluation : evaluations) {
            unique.putIfAbsent(evaluation.getEvaluatorSub(), evaluation);
        }
        return List.copyOf(unique.values());
    }

    private void validateScores(List<EvaluationScoreInput> scoreInputs, Map<Long, EvaluationCriterion> criteriaById) {
        if (criteriaById.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Değerlendirme kriterleri tanımlı değil. Puan kaydı yapılamaz."
            );
        }
        if (scoreInputs == null || scoreInputs.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tüm kriterler için puan girilmelidir");
        }

        Set<Long> seen = new HashSet<>();
        for (EvaluationScoreInput input : scoreInputs) {
            if (input == null || input.criterionId() == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz kriter");
            }
            EvaluationCriterion criterion = criteriaById.get(input.criterionId());
            if (criterion == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz kriter");
            }
            if (!seen.add(input.criterionId())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Aynı kriter birden fazla kez gönderildi");
            }
            int score = input.score() == null ? 0 : input.score();
            if (score < 0 || score > criterion.getMaxScore()) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        criterion.getLabel() + " için puan 0–" + criterion.getMaxScore() + " arasında olmalı"
                );
            }
        }
        if (seen.size() != criteriaById.size()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tüm kriterler için puan girilmelidir");
        }
    }

    private Scholar createScholarFromApplication(Application application) {
        scholarRepository.findByTcNo(application.getTcNo()).ifPresent(existing -> {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Bu TC kimlik numarası ile kayıtlı bursiyer zaten var"
            );
        });

        Scholar scholar = new Scholar();
        String[] nameParts = PersonNames.splitFullName(application.getFullName());
        scholar.setFirstName(nameParts[0]);
        scholar.setLastName(nameParts[1]);
        scholar.setTcNo(application.getTcNo());
        scholar.setEmail(application.getEmail());
        scholar.setPhone(application.getPhone());
        scholar.setUniversity(application.getUniversity());
        scholar.setFaculty(application.getFaculty());
        scholar.setDepartment(application.getDepartment());
        scholar.setClassYear(application.getClassYear());
        scholar.setStatus(ScholarStatus.OGRENCI);
        scholar.setActive(true);
        scholar.setScholarshipStart(LocalDate.now());
        return scholarRepository.save(scholar);
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
