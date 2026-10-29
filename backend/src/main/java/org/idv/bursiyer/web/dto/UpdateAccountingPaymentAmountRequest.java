package org.idv.bursiyer.web.dto;

import java.math.BigDecimal;
import java.util.List;

public record UpdateAccountingPaymentAmountRequest(
        int year,
        int month,
        List<Long> scholarIds,
        BigDecimal amount
) {}
