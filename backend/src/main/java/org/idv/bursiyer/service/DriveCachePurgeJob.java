package org.idv.bursiyer.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class DriveCachePurgeJob {

    private static final Logger LOG = LoggerFactory.getLogger(DriveCachePurgeJob.class);

    private final DriveCacheService cacheService;

    public DriveCachePurgeJob(DriveCacheService cacheService) {
        this.cacheService = cacheService;
    }

    @Scheduled(cron = "0 20 3 * * *")
    public void purge() {
        int deleted = cacheService.purgeExpired();
        if (deleted > 0) {
            LOG.info("Süresi dolan {} Drive kopyası silindi", deleted);
        }
    }
}
