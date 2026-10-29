package org.idv.bursiyer.web.dto;

import java.time.Instant;

public record DriveIngestStatusResponse(
        boolean running,
        int total,
        int done,
        int saved,
        int skipped,
        int failed,
        String lastError,
        Instant startedAt,
        Instant finishedAt
) {}
