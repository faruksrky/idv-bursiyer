package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.PaymentStatus;
import java.util.List;

public record UpdateAccountingPaymentStatusRequest(
        int year,
        int month,
        List<Long> scholarIds,
        PaymentStatus paymentStatus
) {}
