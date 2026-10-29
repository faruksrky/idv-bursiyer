package org.idv.bursiyer.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "application_seasons")
public class ApplicationSeason {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 20)
    private String code;

    @Column(nullable = false)
    private String title;

    @Column(name = "public_slug", nullable = false, unique = true, length = 50)
    private String publicSlug;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ApplicationSeasonStatus status;

    @Column(name = "opens_at")
    private Instant opensAt;

    @Column(name = "closes_at")
    private Instant closesAt;

    @Column(name = "family_income_interview_max", nullable = false)
    private Integer familyIncomeInterviewMax = 100000;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    public Long getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public String getTitle() {
        return title;
    }

    public String getPublicSlug() {
        return publicSlug;
    }

    public ApplicationSeasonStatus getStatus() {
        return status;
    }

    public Instant getOpensAt() {
        return opensAt;
    }

    public Instant getClosesAt() {
        return closesAt;
    }

    public Integer getFamilyIncomeInterviewMax() {
        return familyIncomeInterviewMax;
    }

    public void setFamilyIncomeInterviewMax(Integer familyIncomeInterviewMax) {
        this.familyIncomeInterviewMax = familyIncomeInterviewMax;
    }
}
