package org.idv.bursiyer.web.dto;

import java.math.BigDecimal;

public record ScholarPaymentHistoryRow(
        int year,
        int month,
        String periodLabel,
        String paymentStatus,
        BigDecimal amount,
        boolean paymentEligible,
        boolean programExists,
        String note
) {}
