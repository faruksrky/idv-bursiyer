package org.idv.bursiyer.service;

import java.time.LocalDate;

public final class AcademicYears {

    private AcademicYears() {
    }

    public static int currentStartYear() {
        LocalDate today = LocalDate.now();
        return startYearFor(today.getYear(), today.getMonthValue());
    }

    public static int startYearFor(int calendarYear, int month) {
        return month >= 9 ? calendarYear : calendarYear - 1;
    }

    public static String label(int startYear) {
        return startYear + "-" + (startYear + 1);
    }
}
