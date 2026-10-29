package org.idv.bursiyer.service;

import org.idv.bursiyer.repository.ApplicationDocumentRepository;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.web.dto.DriveIngestStatusResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.concurrent.atomic.AtomicBoolean;

@Service
public class DriveIngestService {

    private static final Logger LOG = LoggerFactory.getLogger(DriveIngestService.class);

    private final ApplicationDocumentRepository documentRepository;
    private final ApplicationRepository applicationRepository;
    private final ScholarReviewRepository reviewRepository;
    private final DriveCacheService cacheService;
    private final DriveGoogleDownloader downloader;

    private final AtomicBoolean running = new AtomicBoolean(false);
    private volatile int total;
    private volatile int done;
    private volatile int saved;
    private volatile int skipped;
    private volatile int failed;
    private volatile String lastError;
    private volatile Instant startedAt;
    private volatile Instant finishedAt;

    public DriveIngestService(
            ApplicationDocumentRepository documentRepository,
            ApplicationRepository applicationRepository,
            ScholarReviewRepository reviewRepository,
            DriveCacheService cacheService,
            DriveGoogleDownloader downloader
    ) {
        this.documentRepository = documentRepository;
        this.applicationRepository = applicationRepository;
        this.reviewRepository = reviewRepository;
        this.cacheService = cacheService;
        this.downloader = downloader;
    }

    public DriveIngestStatusResponse status() {
        return new DriveIngestStatusResponse(
                running.get(),
                total,
                done,
                saved,
                skipped,
                failed,
                lastError,
                startedAt,
                finishedAt
        );
    }

    public DriveIngestStatusResponse start() {
        if (!running.compareAndSet(false, true)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Kopyalama zaten çalışıyor");
        }
        total = 0;
        done = 0;
        saved = 0;
        skipped = 0;
        failed = 0;
        lastError = null;
        startedAt = Instant.now();
        finishedAt = null;
        Thread worker = new Thread(this::runSafe, "drive-ingest");
        worker.setDaemon(true);
        worker.start();
        return status();
    }

    private void runSafe() {
        try {
            run();
        } catch (Exception exception) {
            lastError = exception.getMessage();
            LOG.error("Drive kopyalama durdu", exception);
        } finally {
            finishedAt = Instant.now();
            running.set(false);
        }
    }

    private void run() {
        Set<String> ids = collectIds();
        total = ids.size();
        LOG.info("Drive kopyalama başladı: {} dosya", total);
        for (String id : ids) {
            if (cacheService.isReady("https://drive.google.com/open?id=" + id)) {
                skipped++;
                done++;
                continue;
            }
            try {
                byte[] body = downloader.download(id);
                if (DriveCacheService.looksLikeHtml(body)) {
                    throw new IllegalStateException("HTML yanıt (paylaşım kapalı)");
                }
                cacheService.save(id, body);
                saved++;
            } catch (Exception exception) {
                failed++;
                lastError = id + ": " + exception.getMessage();
                LOG.warn("Drive dosyası alınamadı {}: {}", id, exception.getMessage());
            }
            done++;
        }
        LOG.info("Drive kopyalama bitti: saved={} skipped={} failed={}", saved, skipped, failed);
    }

    Set<String> collectIds() {
        Set<String> ids = new LinkedHashSet<>();
        documentRepository.findExternalUrls().forEach(url -> add(ids, url));
        applicationRepository.findHighSchoolUrls().forEach(url -> add(ids, url));
        reviewRepository.findDocumentUrls().forEach(url -> add(ids, url));
        return ids;
    }

    private static void add(Set<String> ids, String url) {
        String id = DriveIds.extract(url);
        if (id != null) {
            ids.add(id);
        }
    }
}
