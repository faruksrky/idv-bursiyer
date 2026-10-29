package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.InterviewEvaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface InterviewEvaluationRepository extends JpaRepository<InterviewEvaluation, Long> {

    List<InterviewEvaluation> findBySessionIdOrderBySubmittedAtAsc(Long sessionId);

    Optional<InterviewEvaluation> findBySessionIdAndEvaluatorSub(Long sessionId, String evaluatorSub);

    @Query("""
            SELECT DISTINCT e FROM InterviewEvaluation e
            LEFT JOIN FETCH e.scores s
            LEFT JOIN FETCH s.criterion
            WHERE e.session.id = :sessionId
            ORDER BY e.submittedAt ASC
            """)
    List<InterviewEvaluation> findDetailedBySessionId(@Param("sessionId") Long sessionId);

    @Query("""
            SELECT DISTINCT e FROM InterviewEvaluation e
            LEFT JOIN FETCH e.scores s
            LEFT JOIN FETCH s.criterion
            WHERE e.session.id = :sessionId AND e.evaluatorSub = :evaluatorSub
            """)
    Optional<InterviewEvaluation> findDetailedBySessionIdAndEvaluatorSub(
            @Param("sessionId") Long sessionId,
            @Param("evaluatorSub") String evaluatorSub
    );
}
