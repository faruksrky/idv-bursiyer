package org.idv.bursiyer.domain;

import java.util.Locale;

/** Mülakat yoklaması: geldi / gelmedi / boş (null). */
public enum InterviewAttendance {
    GELDI,
    GELMEDI;

    public static InterviewAttendance parse(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String normalized = value.trim().toUpperCase(Locale.ROOT)
                .replace('İ', 'I')
                .replace('ı', 'I');
        if (normalized.equals("BOS")
                || normalized.equals("EMPTY")
                || normalized.equals("NONE")
                || normalized.equals("NULL")
                || normalized.equals("PENDING")) {
            return null;
        }
        if (normalized.equals("GELDI") || normalized.equals("GELDİ")) {
            return GELDI;
        }
        if (normalized.equals("GELMEDI")) {
            return GELMEDI;
        }
        throw new IllegalArgumentException("Geçersiz yoklama; geldi, gelmedi veya boş olmalı");
    }
}
