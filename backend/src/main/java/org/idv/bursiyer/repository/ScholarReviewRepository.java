package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.ScholarReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ScholarReviewRepository extends JpaRepository<ScholarReview, Long> {

    Optional<ScholarReview> findByAcademicYearAndTcNo(int academicYear, String tcNo);

    @Query("""
            SELECT r FROM ScholarReview r
            LEFT JOIN FETCH r.scholar
            WHERE r.academicYear = :academicYear
            ORDER BY r.fullName ASC
            """)
    List<ScholarReview> findDetailedByAcademicYear(@Param("academicYear") int academicYear);

    @Query("""
            SELECT r FROM ScholarReview r
            LEFT JOIN FETCH r.scholar
            WHERE r.id = :id
            """)
    Optional<ScholarReview> findDetailedById(@Param("id") Long id);

    @Query("""
            SELECT DISTINCT r.scholar.id
            FROM ScholarReview r
            WHERE r.scholar IS NOT NULL
              AND r.academicYear = :year
              AND r.decision = org.idv.bursiyer.domain.ScholarReviewDecision.CONTINUE
            """)
    List<Long> findContinueScholarIds(@Param("year") int year);

    @Query(value = """
            select student_cert_url from scholar_reviews where student_cert_url is not null
            union all select photo_url from scholar_reviews where photo_url is not null
            union all select transcript_url from scholar_reviews where transcript_url is not null
            union all select family_income_url from scholar_reviews where family_income_url is not null
            """, nativeQuery = true)
    List<String> findDocumentUrls();
}
