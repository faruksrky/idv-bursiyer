package org.idv.bursiyer.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Entity
@Table(name = "applications")
public class Application {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "season_id", nullable = false)
    private ApplicationSeason season;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scholar_id")
    private Scholar scholar;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ApplicationStatus status = ApplicationStatus.SUBMITTED;

    @Column(name = "submitted_at")
    private Instant submittedAt;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "tc_no", nullable = false, length = 11)
    private String tcNo;

    @Column(name = "birth_place")
    private String birthPlace;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    private String email;

    @Column(columnDefinition = "text")
    private String address;

    @Column(length = 30)
    private String phone;

    @Column(name = "father_status", length = 20)
    private String fatherStatus;

    @Column(name = "father_name")
    private String fatherName;

    @Column(name = "father_job")
    private String fatherJob;

    @Column(name = "mother_status", length = 20)
    private String motherStatus;

    @Column(name = "mother_job")
    private String motherJob;

    @Column(name = "family_monthly_income")
    private BigDecimal familyMonthlyIncome;

    @Column(name = "sibling_count")
    private Integer siblingCount;

    @Column(name = "studying_sibling_count")
    private Integer studyingSiblingCount;

    private String university;
    private String faculty;
    private String department;

    @Column(name = "class_year", length = 20)
    private String classYear;

    private BigDecimal gpa;

    @Column(name = "high_school")
    private String highSchool;

    @Column(name = "reference_name")
    private String referenceName;

    @Column(name = "reference_organization")
    private String referenceOrganization;

    @Column(name = "reference_phone", length = 30)
    private String referencePhone;

    @Column(columnDefinition = "text")
    private String associations;

    @Column(columnDefinition = "text")
    private String interests;

    @Column(columnDefinition = "text")
    private String languages;

    @Column(name = "consent_accuracy", nullable = false)
    private boolean consentAccuracy;

    @Column(name = "consent_terms", nullable = false)
    private boolean consentTerms;

    @Column(name = "consent_rejection", nullable = false)
    private boolean consentRejection;

    @Column(name = "consent_kvkk", nullable = false)
    private boolean consentKvkk;

    @Column(name = "import_source", length = 50)
    private String importSource;

    @Column(name = "staff_note", columnDefinition = "text")
    private String staffNote;

    @Enumerated(EnumType.STRING)
    @Column(name = "interview_invite", length = 32)
    private InterviewInviteOverride interviewInvite;

    @Enumerated(EnumType.STRING)
    @Column(name = "interview_result", nullable = false, length = 16)
    private InterviewResult interviewResult = InterviewResult.PENDING;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    void onCreate() {
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
        if (submittedAt == null) {
            submittedAt = now;
        }
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public ApplicationSeason getSeason() {
        return season;
    }

    public void setSeason(ApplicationSeason season) {
        this.season = season;
    }

    public Scholar getScholar() {
        return scholar;
    }

    public void setScholar(Scholar scholar) {
        this.scholar = scholar;
    }

    public ApplicationStatus getStatus() {
        return status;
    }

    public void setStatus(ApplicationStatus status) {
        this.status = status;
    }

    public Instant getSubmittedAt() {
        return submittedAt;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getTcNo() {
        return tcNo;
    }

    public void setTcNo(String tcNo) {
        this.tcNo = tcNo;
    }

    public String getBirthPlace() {
        return birthPlace;
    }

    public void setBirthPlace(String birthPlace) {
        this.birthPlace = birthPlace;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFatherStatus() {
        return fatherStatus;
    }

    public void setFatherStatus(String fatherStatus) {
        this.fatherStatus = fatherStatus;
    }

    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    public String getFatherJob() {
        return fatherJob;
    }

    public void setFatherJob(String fatherJob) {
        this.fatherJob = fatherJob;
    }

    public String getMotherStatus() {
        return motherStatus;
    }

    public void setMotherStatus(String motherStatus) {
        this.motherStatus = motherStatus;
    }

    public String getMotherJob() {
        return motherJob;
    }

    public void setMotherJob(String motherJob) {
        this.motherJob = motherJob;
    }

    public BigDecimal getFamilyMonthlyIncome() {
        return familyMonthlyIncome;
    }

    public void setFamilyMonthlyIncome(BigDecimal familyMonthlyIncome) {
        this.familyMonthlyIncome = familyMonthlyIncome;
    }

    public Integer getSiblingCount() {
        return siblingCount;
    }

    public void setSiblingCount(Integer siblingCount) {
        this.siblingCount = siblingCount;
    }

    public Integer getStudyingSiblingCount() {
        return studyingSiblingCount;
    }

    public void setStudyingSiblingCount(Integer studyingSiblingCount) {
        this.studyingSiblingCount = studyingSiblingCount;
    }

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getFaculty() {
        return faculty;
    }

    public void setFaculty(String faculty) {
        this.faculty = faculty;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getClassYear() {
        return classYear;
    }

    public void setClassYear(String classYear) {
        this.classYear = classYear;
    }

    public BigDecimal getGpa() {
        return gpa;
    }

    public void setGpa(BigDecimal gpa) {
        this.gpa = gpa;
    }

    public String getHighSchool() {
        return highSchool;
    }

    public void setHighSchool(String highSchool) {
        this.highSchool = highSchool;
    }

    public String getReferenceName() {
        return referenceName;
    }

    public void setReferenceName(String referenceName) {
        this.referenceName = referenceName;
    }

    public String getReferenceOrganization() {
        return referenceOrganization;
    }

    public void setReferenceOrganization(String referenceOrganization) {
        this.referenceOrganization = referenceOrganization;
    }

    public String getReferencePhone() {
        return referencePhone;
    }

    public void setReferencePhone(String referencePhone) {
        this.referencePhone = referencePhone;
    }

    public String getAssociations() {
        return associations;
    }

    public void setAssociations(String associations) {
        this.associations = associations;
    }

    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }

    public String getLanguages() {
        return languages;
    }

    public void setLanguages(String languages) {
        this.languages = languages;
    }

    public boolean isConsentAccuracy() {
        return consentAccuracy;
    }

    public void setConsentAccuracy(boolean consentAccuracy) {
        this.consentAccuracy = consentAccuracy;
    }

    public boolean isConsentTerms() {
        return consentTerms;
    }

    public void setConsentTerms(boolean consentTerms) {
        this.consentTerms = consentTerms;
    }

    public boolean isConsentRejection() {
        return consentRejection;
    }

    public void setConsentRejection(boolean consentRejection) {
        this.consentRejection = consentRejection;
    }

    public boolean isConsentKvkk() {
        return consentKvkk;
    }

    public void setConsentKvkk(boolean consentKvkk) {
        this.consentKvkk = consentKvkk;
    }

    public void setSubmittedAt(Instant submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getImportSource() {
        return importSource;
    }

    public void setImportSource(String importSource) {
        this.importSource = importSource;
    }

    public String getStaffNote() {
        return staffNote;
    }

    public void setStaffNote(String staffNote) {
        this.staffNote = staffNote;
    }

    public InterviewInviteOverride getInterviewInvite() {
        return interviewInvite;
    }

    public void setInterviewInvite(InterviewInviteOverride interviewInvite) {
        this.interviewInvite = interviewInvite;
    }

    public InterviewResult getInterviewResult() {
        return InterviewResult.orPending(interviewResult);
    }

    public void setInterviewResult(InterviewResult interviewResult) {
        this.interviewResult = InterviewResult.orPending(interviewResult);
    }
}
