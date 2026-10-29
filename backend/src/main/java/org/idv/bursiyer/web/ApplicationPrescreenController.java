package org.idv.bursiyer.web;

import org.idv.bursiyer.service.ApplicationService;
import org.idv.bursiyer.web.dto.ApplicationDetailResponse;
import org.idv.bursiyer.web.dto.UpdateApplicationInterviewRequest;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/prescreen")
public class ApplicationPrescreenController {

    private final ApplicationService applicationService;

    public ApplicationPrescreenController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping("/{id}")
    @PutMapping("/{id}")
    public ApplicationDetailResponse save(
            @PathVariable Long id,
            @RequestBody UpdateApplicationInterviewRequest request
    ) {
        return applicationService.updateInterviewDecision(
                id,
                request.interviewInvite(),
                request.staffNote()
        );
    }
}
