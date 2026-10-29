package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ScholarRepository extends JpaRepository<Scholar, Long> {

    List<Scholar> findByActiveTrueOrderByLastNameAscFirstNameAsc();

    List<Scholar> findByStatusAndActiveTrueOrderByLastNameAscFirstNameAsc(ScholarStatus status);

    List<Scholar> findByStatusOrderByGraduationDateDescLastNameAscFirstNameAsc(ScholarStatus status);

    @Query("""
            SELECT s FROM Scholar s
            WHERE s.status = :status
              AND s.active = true
              AND s.graduationDate IS NULL
              AND NOT EXISTS (
                  SELECT r.id FROM ScholarReview r
                  WHERE r.scholar = s AND r.graduating = true
              )
            ORDER BY s.lastName ASC, s.firstName ASC
            """)
    List<Scholar> findActiveStudents(@Param("status") ScholarStatus status);

    @Query("""
            SELECT s FROM Scholar s
            WHERE s.status = org.idv.bursiyer.domain.ScholarStatus.MEZUN
               OR s.graduationDate IS NOT NULL
               OR EXISTS (
                   SELECT r.id FROM ScholarReview r
                   WHERE r.scholar = s AND r.graduating = true
               )
            ORDER BY s.graduationDate DESC, s.lastName ASC, s.firstName ASC
            """)
    List<Scholar> findGraduates();

    Optional<Scholar> findByTcNo(String tcNo);

    Optional<Scholar> findByIban(String iban);
}
