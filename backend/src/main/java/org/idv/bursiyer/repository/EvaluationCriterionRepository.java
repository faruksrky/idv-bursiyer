package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.EvaluationCriterion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EvaluationCriterionRepository extends JpaRepository<EvaluationCriterion, Long> {

    List<EvaluationCriterion> findByActiveTrueOrderBySortOrderAsc();
}
