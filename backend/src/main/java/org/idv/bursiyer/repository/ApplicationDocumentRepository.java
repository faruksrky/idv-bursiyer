package org.idv.bursiyer.repository;

import org.idv.bursiyer.domain.ApplicationDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ApplicationDocumentRepository extends JpaRepository<ApplicationDocument, Long> {

    List<ApplicationDocument> findByApplicationIdOrderByDocumentTypeAsc(Long applicationId);

    @Query("""
            SELECT d FROM ApplicationDocument d
            JOIN FETCH d.application
            WHERE d.application.id IN :applicationIds
            """)
    List<ApplicationDocument> findByApplicationIdIn(@Param("applicationIds") List<Long> applicationIds);

    @Query("""
            SELECT d FROM ApplicationDocument d
            JOIN FETCH d.application
            WHERE d.id = :id
            """)
    Optional<ApplicationDocument> findDetailedById(@Param("id") Long id);

    @Query(value = "select external_url from application_documents where external_url is not null", nativeQuery = true)
    List<String> findExternalUrls();
}
