package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.ApplicationSeason;
import org.idv.bursiyer.domain.ApplicationSeasonStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ApplicationSeasonRepository extends JpaRepository<ApplicationSeason, Long> {

    Optional<ApplicationSeason> findByPublicSlug(String publicSlug);

    List<ApplicationSeason> findAllByOrderByCodeDesc();

    Optional<ApplicationSeason> findFirstByStatusOrderByCodeDesc(ApplicationSeasonStatus status);
}
