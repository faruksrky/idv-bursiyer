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
import java.time.Instant;

@Entity
@Table(name = "scholar_reviews")
public class ScholarReview {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scholar_id")
    private Scholar scholar;

    @Column(name = "academic_year", nullable = false)
    private int academicYear;

    @Column(name = "tc_no", nullable = false, length = 11)
    private String tcNo;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "submitted_at")
    private Instant submittedAt;

    @Column(name = "student_cert_url", columnDefinition = "text")
    private String studentCertUrl;

    @Column(name = "photo_url", columnDefinition = "text")
    private String photoUrl;

    @Column(name = "transcript_url", columnDefinition = "text")
    private String transcriptUrl;

    @Column(name = "family_income_url", columnDefinition = "text")
    private String familyIncomeUrl;

    @Column(name = "father_status", length = 20)
    private String fatherStatus;

    @Column(name = "mother_status", length = 20)
    private String motherStatus;

    @Column(name = "program_attendance_answer", columnDefinition = "text")
    private String programAttendanceAnswer;

    @Column(columnDefinition = "text")
    private String suggestions;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ScholarReviewDecision decision = ScholarReviewDecision.PENDING;

    @Column(columnDefinition = "text")
    private String note;

    @Column(nullable = false)
    private boolean graduating = false;

    @Column(precision = 4, scale = 2)
    private java.math.BigDecimal gpa;

    @Column(name = "gpa_below_two", nullable = false)
    private boolean gpaBelowTwo = false;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    void onCreate() {
        Instant now = Instant.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public Scholar getScholar() {
        return scholar;
    }

    public void setScholar(Scholar scholar) {
        this.scholar = scholar;
    }

    public int getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(int academicYear) {
        this.academicYear = academicYear;
    }

    public String getTcNo() {
        return tcNo;
    }

    public void setTcNo(String tcNo) {
        this.tcNo = tcNo;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Instant getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Instant submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getStudentCertUrl() {
        return studentCertUrl;
    }

    public void setStudentCertUrl(String studentCertUrl) {
        this.studentCertUrl = studentCertUrl;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public String getTranscriptUrl() {
        return transcriptUrl;
    }

    public void setTranscriptUrl(String transcriptUrl) {
        this.transcriptUrl = transcriptUrl;
    }

    public String getFamilyIncomeUrl() {
        return familyIncomeUrl;
    }

    public void setFamilyIncomeUrl(String familyIncomeUrl) {
        this.familyIncomeUrl = familyIncomeUrl;
    }

    public String getFatherStatus() {
        return fatherStatus;
    }

    public void setFatherStatus(String fatherStatus) {
        this.fatherStatus = fatherStatus;
    }

    public String getMotherStatus() {
        return motherStatus;
    }

    public void setMotherStatus(String motherStatus) {
        this.motherStatus = motherStatus;
    }

    public String getProgramAttendanceAnswer() {
        return programAttendanceAnswer;
    }

    public void setProgramAttendanceAnswer(String programAttendanceAnswer) {
        this.programAttendanceAnswer = programAttendanceAnswer;
    }

    public String getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(String suggestions) {
        this.suggestions = suggestions;
    }

    public ScholarReviewDecision getDecision() {
        return decision;
    }

    public void setDecision(ScholarReviewDecision decision) {
        this.decision = decision;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public boolean isGraduating() {
        return graduating;
    }

    public void setGraduating(boolean graduating) {
        this.graduating = graduating;
    }

    public java.math.BigDecimal getGpa() {
        return gpa;
    }

    public void setGpa(java.math.BigDecimal gpa) {
        this.gpa = gpa;
    }

    public boolean isGpaBelowTwo() {
        return gpaBelowTwo;
    }

    public void setGpaBelowTwo(boolean gpaBelowTwo) {
        this.gpaBelowTwo = gpaBelowTwo;
    }
}
