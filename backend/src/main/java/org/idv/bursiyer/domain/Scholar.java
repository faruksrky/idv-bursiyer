package org.idv.bursiyer.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "scholars")
public class Scholar {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "tc_no", length = 11)
    private String tcNo;

    private String email;
    private String phone;
    private String iban;
    private String university;
    private String faculty;
    private String department;

    @Column(name = "class_year", length = 20)
    private String classYear;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ScholarStatus status = ScholarStatus.OGRENCI;

    @Column(name = "graduation_date")
    private java.time.LocalDate graduationDate;

    @Column(name = "scholarship_start")
    private java.time.LocalDate scholarshipStart;

    @Column(name = "monthly_amount")
    private java.math.BigDecimal monthlyAmount;

    @Column(nullable = false)
    private boolean active = true;

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

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getTcNo() {
        return tcNo;
    }

    public void setTcNo(String tcNo) {
        this.tcNo = tcNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIban() {
        return iban;
    }

    public void setIban(String iban) {
        this.iban = iban;
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

    public ScholarStatus getStatus() {
        return status;
    }

    public void setStatus(ScholarStatus status) {
        this.status = status;
    }

    public java.time.LocalDate getGraduationDate() {
        return graduationDate;
    }

    public void setGraduationDate(java.time.LocalDate graduationDate) {
        this.graduationDate = graduationDate;
    }

    public java.time.LocalDate getScholarshipStart() {
        return scholarshipStart;
    }

    public void setScholarshipStart(java.time.LocalDate scholarshipStart) {
        this.scholarshipStart = scholarshipStart;
    }

    public java.math.BigDecimal getMonthlyAmount() {
        return monthlyAmount;
    }

    public void setMonthlyAmount(java.math.BigDecimal monthlyAmount) {
        this.monthlyAmount = monthlyAmount;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
