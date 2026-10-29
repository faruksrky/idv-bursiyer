package org.idv.bursiyer.domain;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class InterviewResultTest {

    @Test
    void committeeAverageAtThresholdPasses() {
        assertEquals(InterviewResult.PASSED, InterviewResult.fromCommitteeAverage(80, 80));
        assertEquals(InterviewResult.PASSED, InterviewResult.fromCommitteeAverage(80.0, 80));
        assertEquals(InterviewResult.PASSED, InterviewResult.fromCommitteeAverage(92.4, 80));
    }

    @Test
    void committeeAverageBelowThresholdFails() {
        assertEquals(InterviewResult.FAILED, InterviewResult.fromCommitteeAverage(79.9, 80));
        assertEquals(InterviewResult.FAILED, InterviewResult.fromCommitteeAverage(0, 80));
    }
}
