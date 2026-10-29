package org.idv.bursiyer.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "interview_evaluations")
public class InterviewEvaluation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "session_id", nullable = false)
    private InterviewSession session;

    @Column(name = "evaluator_sub", nullable = false)
    private String evaluatorSub;

    @Column(name = "evaluator_name")
    private String evaluatorName;

    @Column(name = "total_score", nullable = false)
    private int totalScore;

    @Column(name = "submitted_at", nullable = false)
    private Instant submittedAt = Instant.now();

    @Column(columnDefinition = "text")
    private String note;

    @OneToMany(mappedBy = "evaluation", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<InterviewEvaluationScore> scores = new ArrayList<>();

    public Long getId() {
        return id;
    }

    public InterviewSession getSession() {
        return session;
    }

    public void setSession(InterviewSession session) {
        this.session = session;
    }

    public String getEvaluatorSub() {
        return evaluatorSub;
    }

    public void setEvaluatorSub(String evaluatorSub) {
        this.evaluatorSub = evaluatorSub;
    }

    public String getEvaluatorName() {
        return evaluatorName;
    }

    public void setEvaluatorName(String evaluatorName) {
        this.evaluatorName = evaluatorName;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    public Instant getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Instant submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<InterviewEvaluationScore> getScores() {
        return scores;
    }

    public void setScores(List<InterviewEvaluationScore> scores) {
        this.scores = scores;
    }

    public void replaceScores(List<InterviewEvaluationScore> newScores) {
        scores.clear();
        scores.addAll(newScores);
    }
}
