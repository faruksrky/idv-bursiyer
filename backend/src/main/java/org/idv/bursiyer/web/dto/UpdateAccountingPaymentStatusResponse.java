package org.idv.bursiyer.web.dto;

public record UpdateAccountingPaymentStatusResponse(
        int updated,
        String paymentStatus
) {}
