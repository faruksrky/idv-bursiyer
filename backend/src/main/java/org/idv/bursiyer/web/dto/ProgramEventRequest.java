package org.idv.bursiyer.web.dto;

import java.time.LocalDate;

public record ProgramEventRequest(
        String name,
        LocalDate programDate
) {}
