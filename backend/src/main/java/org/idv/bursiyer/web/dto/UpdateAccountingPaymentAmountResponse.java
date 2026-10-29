package org.idv.bursiyer.web.dto;

import java.math.BigDecimal;

public record UpdateAccountingPaymentAmountResponse(
        int updated,
        BigDecimal amount
) {}
