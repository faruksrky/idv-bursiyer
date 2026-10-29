package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.MonthlyProgram;
import java.time.LocalDate;

public record ProgramEventResponse(
        Long id,
        int year,
        int month,
        String name,
        LocalDate programDate
) {
    public static ProgramEventResponse from(MonthlyProgram program) {
        return new ProgramEventResponse(
                program.getId(),
                program.getYear(),
                program.getMonth(),
                program.getName(),
                program.getProgramDate()
        );
    }
}
