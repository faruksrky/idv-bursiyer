package org.idv.bursiyer.domain;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

class InterviewAttendanceTest {

    @Test
    void blankIsEmpty() {
        assertNull(InterviewAttendance.parse(null));
        assertNull(InterviewAttendance.parse(""));
        assertNull(InterviewAttendance.parse("  "));
        assertNull(InterviewAttendance.parse("bos"));
    }

    @Test
    void parsesGeldiGelmedi() {
        assertEquals(InterviewAttendance.GELDI, InterviewAttendance.parse("geldi"));
        assertEquals(InterviewAttendance.GELDI, InterviewAttendance.parse("GELDI"));
        assertEquals(InterviewAttendance.GELMEDI, InterviewAttendance.parse("gelmedi"));
        assertEquals(InterviewAttendance.GELMEDI, InterviewAttendance.parse("GELMEDI"));
    }

    @Test
    void rejectsUnknown() {
        assertThrows(IllegalArgumentException.class, () -> InterviewAttendance.parse("KATILDI"));
    }
}
