package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.InterviewSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface InterviewSessionRepository extends JpaRepository<InterviewSession, Long> {

    Optional<InterviewSession> findByApplicationId(Long applicationId);

    @Query("""
            SELECT s FROM InterviewSession s
            JOIN FETCH s.application a
            JOIN FETCH a.season
            WHERE a.id = :applicationId
            """)
    Optional<InterviewSession> findDetailedByApplicationId(@Param("applicationId") Long applicationId);

    @Query("""
            SELECT s FROM InterviewSession s
            JOIN FETCH s.application a
            WHERE s.scheduledAt >= :from AND s.scheduledAt < :to
            ORDER BY s.scheduledAt ASC, a.fullName ASC
            """)
    List<InterviewSession> findScheduledBetween(@Param("from") Instant from, @Param("to") Instant to);

    @Query("""
            SELECT s FROM InterviewSession s
            JOIN FETCH s.application a
            WHERE s.scheduledAt IS NULL AND lower(a.email) IN :emails
            ORDER BY a.fullName ASC
            """)
    List<InterviewSession> findUnscheduledByEmails(@Param("emails") Collection<String> emails);
}
