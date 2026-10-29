package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationDocumentType;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;

@Service
public class ApplicationStorageService {

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "application/pdf",
            "image/jpeg",
            "image/png",
            "image/jpg"
    );
    private static final long MAX_FILE_SIZE = 10L * 1024 * 1024;

    private final Path uploadRoot;

    public ApplicationStorageService(AppProperties appProperties) {
        this.uploadRoot = Path.of(appProperties.storage().uploadDir()).toAbsolutePath().normalize();
    }

    public ApplicationDocument store(Application application, ApplicationDocumentType type, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, type + " belgesi zorunludur");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Dosya boyutu 10 MB'ı geçemez: " + type);
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Desteklenmeyen dosya türü: " + type);
        }

        String extension = switch (contentType) {
            case "application/pdf" -> ".pdf";
            case "image/png" -> ".png";
            default -> ".jpg";
        };

        Path directory = uploadRoot
                .resolve("applications")
                .resolve(String.valueOf(application.getSeason().getId()))
                .resolve(String.valueOf(application.getId()));

        try {
            Files.createDirectories(directory);
            String storedName = type.name().toLowerCase() + "-" + UUID.randomUUID() + extension;
            Path target = directory.resolve(storedName);
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

            ApplicationDocument document = new ApplicationDocument();
            document.setApplication(application);
            document.setDocumentType(type);
            document.setFileName(file.getOriginalFilename());
            document.setContentType(contentType);
            document.setFileSize(file.getSize());
            document.setStoragePath(uploadRoot.relativize(target).toString().replace('\\', '/'));
            return document;
        } catch (IOException ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Dosya kaydedilemedi", ex);
        }
    }

    public Path resolveStoragePath(String storagePath) {
        Path resolved = uploadRoot.resolve(storagePath).normalize();
        if (!resolved.startsWith(uploadRoot)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz dosya yolu");
        }
        return resolved;
    }
}
