package org.idv.bursiyer.web;

import org.idv.bursiyer.service.InterviewEvaluationService;
import org.idv.bursiyer.web.dto.ApplicationDecisionRequest;
import org.idv.bursiyer.web.dto.ApplicationDecisionResponse;
import org.idv.bursiyer.web.dto.EvaluationQueueItemResponse;
import org.idv.bursiyer.web.dto.InterviewEvaluationResponse;
import org.idv.bursiyer.web.dto.ScheduleInterviewRequest;
import org.idv.bursiyer.web.dto.SubmitInterviewEvaluationRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class InterviewEvaluationController {

    private final InterviewEvaluationService evaluationService;

    public InterviewEvaluationController(InterviewEvaluationService evaluationService) {
        this.evaluationService = evaluationService;
    }

    @GetMapping("/evaluations/queue")
    public List<EvaluationQueueItemResponse> listQueue(@RequestParam Long seasonId) {
        return evaluationService.listQueue(seasonId);
    }

    @GetMapping("/applications/{applicationId}/evaluation")
    public InterviewEvaluationResponse getEvaluation(@PathVariable Long applicationId) {
        return evaluationService.getEvaluation(applicationId);
    }

    @PutMapping("/applications/{applicationId}/interview")
    public InterviewEvaluationResponse scheduleInterview(
            @PathVariable Long applicationId,
            @RequestBody ScheduleInterviewRequest request
    ) {
        return evaluationService.scheduleInterview(applicationId, request.scheduledAt());
    }

    @PostMapping("/applications/{applicationId}/evaluation")
    public InterviewEvaluationResponse submitEvaluation(
            @PathVariable Long applicationId,
            @RequestBody SubmitInterviewEvaluationRequest request
    ) {
        return evaluationService.submitEvaluation(applicationId, request.scores(), request.note());
    }

    @PutMapping("/applications/{applicationId}/evaluation")
    public InterviewEvaluationResponse updateEvaluation(
            @PathVariable Long applicationId,
            @RequestBody SubmitInterviewEvaluationRequest request
    ) {
        return evaluationService.submitEvaluation(applicationId, request.scores(), request.note());
    }

    @PostMapping("/applications/{applicationId}/decision")
    public ApplicationDecisionResponse decide(
            @PathVariable Long applicationId,
            @RequestBody ApplicationDecisionRequest request
    ) {
        return evaluationService.decide(applicationId, request.decision());
    }
}
