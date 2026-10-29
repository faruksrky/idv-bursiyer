package org.idv.bursiyer.web.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record UpdateSeasonPrescreenRequest(
        @NotNull @Min(0) Integer familyIncomeInterviewMax
) {}
