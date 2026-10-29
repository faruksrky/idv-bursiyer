package org.idv.bursiyer.web.dto;

import java.util.List;

public record ScholarImportResult(
        int created,
        int updated,
        int skipped,
        List<String> errors
) {}
