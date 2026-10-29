package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ApplicationRepository extends JpaRepository<Application, Long> {

    boolean existsBySeasonIdAndTcNo(Long seasonId, String tcNo);

    @Query("""
            SELECT a FROM Application a
            JOIN FETCH a.season
            WHERE a.season.id = :seasonId
            ORDER BY a.submittedAt DESC NULLS LAST, a.fullName ASC
            """)
    List<Application> findBySeasonId(@Param("seasonId") Long seasonId);

    @Query("""
            SELECT a FROM Application a
            JOIN FETCH a.season
            WHERE a.id = :id
            """)
    Optional<Application> findDetailedById(@Param("id") Long id);

    List<Application> findBySeasonIdAndStatusOrderBySubmittedAtDesc(Long seasonId, ApplicationStatus status);

    @Query("""
            SELECT a FROM Application a
            LEFT JOIN FETCH a.scholar
            WHERE a.status = :status
            """)
    List<Application> findByStatusWithScholar(@Param("status") ApplicationStatus status);

    @Query(value = """
            SELECT a.scholar_id, a.full_name
            FROM applications a
            WHERE a.status = 'ACCEPTED' AND a.scholar_id IS NOT NULL
            """, nativeQuery = true)
    List<Object[]> findAcceptedScholarNames();

    @Query("""
            SELECT DISTINCT a.scholar.id
            FROM Application a
            WHERE a.scholar IS NOT NULL
              AND a.interviewInvite = org.idv.bursiyer.domain.InterviewInviteOverride.PRESIDENT_QUOTA
            """)
    List<Long> findPresidentQuotaScholarIds();

    @Query("""
            SELECT DISTINCT a.scholar.id
            FROM Application a
            WHERE a.scholar IS NOT NULL
              AND a.interviewResult = org.idv.bursiyer.domain.InterviewResult.PASSED
              AND (a.interviewInvite IS NULL
                   OR a.interviewInvite <> org.idv.bursiyer.domain.InterviewInviteOverride.PRESIDENT_QUOTA)
            """)
    List<Long> findInterviewPassedScholarIds();

    @Query(value = "select high_school from applications where high_school is not null and high_school <> ''", nativeQuery = true)
    List<String> findHighSchoolUrls();
}
