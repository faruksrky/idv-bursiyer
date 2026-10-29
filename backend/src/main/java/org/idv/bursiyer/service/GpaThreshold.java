package org.idv.bursiyer.service;

import java.math.BigDecimal;

/** 4'lük sistemde 2 altı, 100'lük sistemde 70 altı — burs yenilemede devam edilmez. */
public final class GpaThreshold {

    private static final BigDecimal FOUR = new BigDecimal("4");
    private static final BigDecimal TWO = new BigDecimal("2");
    private static final BigDecimal SEVENTY = new BigDecimal("70");

    private GpaThreshold() {}

    public static boolean belowContinuation(BigDecimal gpa) {
        if (gpa == null) {
            return false;
        }
        if (gpa.compareTo(FOUR) <= 0) {
            return gpa.compareTo(TWO) < 0;
        }
        return gpa.compareTo(SEVENTY) < 0;
    }
}
