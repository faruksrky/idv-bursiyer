package org.idv.bursiyer.web.dto;

import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationDocumentType;

public record ApplicationDocumentResponse(
        Long id,
        ApplicationDocumentType documentType,
        String fileName,
        String contentType,
        Long fileSize,
        boolean uploaded,
        String externalUrl
) {
    public static ApplicationDocumentResponse from(ApplicationDocument document) {
        return from(document, false);
    }

    public static ApplicationDocumentResponse from(ApplicationDocument document, boolean cached) {
        return new ApplicationDocumentResponse(
                document.getId(),
                document.getDocumentType(),
                document.getFileName(),
                document.getContentType(),
                document.getFileSize(),
                document.getStoragePath() != null || cached,
                document.getExternalUrl()
        );
    }
}
