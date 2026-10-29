package org.idv.bursiyer.web.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record ApplicationSubmitRequest(
        @NotBlank String fullName,
        @NotBlank @Pattern(regexp = "\\d{11}") String tcNo,
        @NotBlank String birthPlace,
        @NotNull LocalDate birthDate,
        @NotBlank @Email String email,
        @NotBlank String address,
        @NotBlank String phone,
        @NotBlank String fatherStatus,
        String fatherName,
        @NotBlank String fatherJob,
        @NotBlank String motherStatus,
        @NotBlank String motherJob,
        @NotNull BigDecimal familyMonthlyIncome,
        @NotNull Integer siblingCount,
        @NotNull Integer studyingSiblingCount,
        @NotBlank String university,
        @NotBlank String faculty,
        @NotBlank String department,
        @NotBlank String classYear,
        @NotNull BigDecimal gpa,
        @NotBlank String highSchool,
        @NotBlank String referenceName,
        @NotBlank String referenceOrganization,
        @NotBlank String referencePhone,
        String associations,
        @NotBlank String interests,
        @NotBlank String languages,
        @NotNull Boolean consentAccuracy,
        @NotNull Boolean consentTerms,
        @NotNull Boolean consentRejection,
        @NotNull Boolean consentKvkk
) {}
