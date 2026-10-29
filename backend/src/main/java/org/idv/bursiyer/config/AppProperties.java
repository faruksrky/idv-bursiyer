package org.idv.bursiyer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app")
public record AppProperties(Cors cors, Scholarship scholarship, Evaluation evaluation, Storage storage) {

    public record Cors(String allowedOrigins) {}

    public record Scholarship(int monthlyAmount) {}

    public record Evaluation(int interviewPassThreshold, int committeeMemberCount, int familyIncomeInterviewMax) {}

    public record Storage(String uploadDir) {}
}
