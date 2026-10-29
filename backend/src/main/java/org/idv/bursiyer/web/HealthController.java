package org.idv.bursiyer.web;

import org.idv.bursiyer.config.AppProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private final AppProperties appProperties;

    public HealthController(AppProperties appProperties) {
        this.appProperties = appProperties;
    }

    @GetMapping
    public Map<String, Object> health() {
        return Map.of(
                "status", "UP",
                "application", "IDV Bursiyer Takip",
                "interviewPassThreshold", appProperties.evaluation().interviewPassThreshold(),
                "committeeMemberCount", appProperties.evaluation().committeeMemberCount(),
                "familyIncomeInterviewMax", appProperties.evaluation().familyIncomeInterviewMax()
        );
    }
}
