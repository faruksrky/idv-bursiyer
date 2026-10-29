package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Duration;
import java.time.Instant;
import java.util.Optional;
import java.util.stream.Stream;

@Service
public class DriveCacheService {

    static final Duration RETAIN_FOR = Duration.ofDays(30);

    private final Path uploadRoot;

    public DriveCacheService(AppProperties appProperties) {
        this.uploadRoot = Path.of(appProperties.storage().uploadDir()).toAbsolutePath().normalize();
    }

    public Path driveDir() {
        return uploadRoot.resolve("drive");
    }

    public Path fileForId(String driveId) {
        return driveDir().resolve(driveId);
    }

    public boolean isReady(String url) {
        String id = DriveIds.extract(url);
        return id != null && Files.isRegularFile(fileForId(id));
    }

    public Optional<Path> pathForUrl(String url) {
        String id = DriveIds.extract(url);
        if (id == null) {
            return Optional.empty();
        }
        Path path = fileForId(id);
        return Files.isRegularFile(path) ? Optional.of(path) : Optional.empty();
    }

    public void save(String driveId, byte[] body) throws IOException {
        Files.createDirectories(driveDir());
        Files.write(fileForId(driveId), body);
    }

    public void delete(String driveId) throws IOException {
        Files.deleteIfExists(fileForId(driveId));
    }

    public int purgeExpired() {
        Path dir = driveDir();
        if (!Files.isDirectory(dir)) {
            return 0;
        }
        Instant cutoff = Instant.now().minus(RETAIN_FOR);
        int deleted = 0;
        try (Stream<Path> stream = Files.list(dir)) {
            for (Path path : stream.toList()) {
                if (!Files.isRegularFile(path)) {
                    continue;
                }
                FileTime modified = Files.getLastModifiedTime(path);
                if (modified.toInstant().isBefore(cutoff)) {
                    Files.deleteIfExists(path);
                    deleted++;
                }
            }
        } catch (IOException ignored) {
            return deleted;
        }
        return deleted;
    }

    public static String sniffContentType(Path path) {
        try (InputStream in = Files.newInputStream(path)) {
            byte[] head = in.readNBytes(8);
            if (head.length >= 4 && head[0] == '%' && head[1] == 'P' && head[2] == 'D' && head[3] == 'F') {
                return "application/pdf";
            }
            if (head.length >= 3 && (head[0] & 0xFF) == 0xFF && (head[1] & 0xFF) == 0xD8) {
                return "image/jpeg";
            }
            if (head.length >= 8 && (head[0] & 0xFF) == 0x89 && head[1] == 'P' && head[2] == 'N' && head[3] == 'G') {
                return "image/png";
            }
            String asText = new String(head);
            if (asText.startsWith("<!") || asText.startsWith("<h") || asText.startsWith("<H")) {
                return "text/html";
            }
        } catch (IOException ignored) {
            // fall through
        }
        return MediaType.APPLICATION_OCTET_STREAM_VALUE;
    }

    public static boolean looksLikeHtml(byte[] body) {
        if (body == null || body.length < 12) {
            return false;
        }
        int start = 0;
        while (start < body.length && Character.isWhitespace(body[start])) {
            start++;
        }
        if (start + 1 >= body.length) {
            return false;
        }
        return body[start] == '<' && (body[start + 1] == '!' || body[start + 1] == 'h' || body[start + 1] == 'H');
    }

    public ResponseEntity<Resource> toResponse(Path path, String fileName) {
        if (!path.normalize().startsWith(uploadRoot)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz dosya yolu");
        }
        if (!Files.exists(path)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Dosya bulunamadı");
        }
        String contentType = sniffContentType(path);
        String safeName = fileName == null || fileName.isBlank() ? path.getFileName().toString() : fileName;
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + safeName.replace("\"", "") + "\"")
                .contentType(MediaType.parseMediaType(contentType))
                .body(new FileSystemResource(path));
    }
}
