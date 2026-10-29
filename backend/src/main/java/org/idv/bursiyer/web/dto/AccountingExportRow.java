package org.idv.bursiyer.web.dto;

import java.math.BigDecimal;

public record AccountingExportRow(
        int rowNumber,
        Long scholarId,
        String firstName,
        String lastName,
        String gender,
        String iban,
        String periodLabel,
        BigDecimal amount,
        String paymentStatus,
        String university,
        BigDecimal suggestedAmount
) {}
