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
import jakarta.persistence.UniqueConstraint;
import java.time.Instant;

@Entity
@Table(
        name = "program_attendance",
        uniqueConstraints = @UniqueConstraint(columnNames = {"program_id", "scholar_id"})
)
public class ProgramAttendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "program_id", nullable = false)
    private MonthlyProgram program;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "scholar_id", nullable = false)
    private Scholar scholar;

    @Enumerated(EnumType.STRING)
    @Column(name = "attendance_status", nullable = false, length = 20)
    private AttendanceStatus attendanceStatus;

    @Column(name = "excuse_text")
    private String excuseText;

    @Enumerated(EnumType.STRING)
    @Column(name = "excuse_status", length = 20)
    private ExcuseStatus excuseStatus;

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

    public boolean isPaymentEligible() {
        if (attendanceStatus == AttendanceStatus.KATILDI) {
            return true;
        }
        return excuseStatus == ExcuseStatus.KABUL;
    }

    public Long getId() {
        return id;
    }

    public MonthlyProgram getProgram() {
        return program;
    }

    public void setProgram(MonthlyProgram program) {
        this.program = program;
    }

    public Scholar getScholar() {
        return scholar;
    }

    public void setScholar(Scholar scholar) {
        this.scholar = scholar;
    }

    public AttendanceStatus getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(AttendanceStatus attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public String getExcuseText() {
        return excuseText;
    }

    public void setExcuseText(String excuseText) {
        this.excuseText = excuseText;
    }

    public ExcuseStatus getExcuseStatus() {
        return excuseStatus;
    }

    public void setExcuseStatus(ExcuseStatus excuseStatus) {
        this.excuseStatus = excuseStatus;
    }
}
