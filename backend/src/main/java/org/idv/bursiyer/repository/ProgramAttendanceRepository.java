package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.ProgramAttendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ProgramAttendanceRepository extends JpaRepository<ProgramAttendance, Long> {

    @Query("""
            SELECT pa FROM ProgramAttendance pa
            JOIN FETCH pa.scholar s
            WHERE pa.program.id = :programId
            ORDER BY s.lastName ASC, s.firstName ASC
            """)
    List<ProgramAttendance> findByProgramIdWithScholar(@Param("programId") Long programId);

    @Query("""
            SELECT pa FROM ProgramAttendance pa
            JOIN FETCH pa.scholar
            JOIN FETCH pa.program
            WHERE pa.id = :id
            """)
    Optional<ProgramAttendance> findByIdWithScholar(@Param("id") Long id);

    @Query("""
            SELECT pa FROM ProgramAttendance pa
            JOIN FETCH pa.scholar s
            JOIN FETCH pa.program p
            WHERE p.year = :year AND p.month = :month
            """)
    List<ProgramAttendance> findByProgramPeriod(@Param("year") int year, @Param("month") int month);

    List<ProgramAttendance> findByProgramIdOrderByScholar_LastNameAscScholar_FirstNameAsc(Long programId);

    @Query("""
            SELECT pa FROM ProgramAttendance pa
            JOIN FETCH pa.program p
            WHERE pa.scholar.id = :scholarId
            ORDER BY p.year DESC, p.month DESC, p.programDate DESC, p.id DESC
            """)
    List<ProgramAttendance> findByScholarIdWithProgram(@Param("scholarId") Long scholarId);

    @Query("""
            SELECT pa.scholar.id, COUNT(pa)
            FROM ProgramAttendance pa
            WHERE pa.attendanceStatus = org.idv.bursiyer.domain.AttendanceStatus.KATILDI
            GROUP BY pa.scholar.id
            """)
    List<Object[]> countAttendedProgramsByScholar();
}
