package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.MonthlyPayment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface MonthlyPaymentRepository extends JpaRepository<MonthlyPayment, Long> {

    Optional<MonthlyPayment> findByScholarIdAndYearAndMonth(Long scholarId, int year, int month);

    @Query("""
            select payment from MonthlyPayment payment
            join fetch payment.scholar
            where payment.year = :year
              and payment.month = :month
              and payment.scholar.id in :scholarIds
            """)
    List<MonthlyPayment> findForPeriod(
            @Param("year") int year,
            @Param("month") int month,
            @Param("scholarIds") Collection<Long> scholarIds
    );
}
