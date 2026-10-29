package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.MonthlyProgram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface MonthlyProgramRepository extends JpaRepository<MonthlyProgram, Long> {

    List<MonthlyProgram> findByYearAndMonthOrderByProgramDateAscIdAsc(int year, int month);

    Optional<MonthlyProgram> findFirstByYearAndMonthOrderByProgramDateAscIdAsc(int year, int month);

    boolean existsByYearAndMonthAndProgramDateAndNameIgnoreCase(int year, int month, LocalDate programDate, String name);

    List<MonthlyProgram> findByYearAndMonthAndProgramDateAndNameIgnoreCase(
            int year,
            int month,
            LocalDate programDate,
            String name
    );

    @Query("""
            SELECT p FROM MonthlyProgram p
            WHERE (p.year = :startYear AND p.month >= 10)
               OR (p.year = :endYear AND p.month <= 7)
            """)
    List<MonthlyProgram> findInAcademicSeason(
            @Param("startYear") int startYear,
            @Param("endYear") int endYear
    );
}
