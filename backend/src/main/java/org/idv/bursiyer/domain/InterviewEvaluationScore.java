package org.idv.bursiyer.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "interview_evaluation_scores")
@IdClass(InterviewEvaluationScore.ScoreId.class)
public class InterviewEvaluationScore {

    @Id
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "evaluation_id", nullable = false)
    private InterviewEvaluation evaluation;

    @Id
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "criterion_id", nullable = false)
    private EvaluationCriterion criterion;

    private int score;

    public InterviewEvaluation getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(InterviewEvaluation evaluation) {
        this.evaluation = evaluation;
    }

    public EvaluationCriterion getCriterion() {
        return criterion;
    }

    public void setCriterion(EvaluationCriterion criterion) {
        this.criterion = criterion;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public static class ScoreId implements Serializable {
        private Long evaluation;
        private Long criterion;

        public ScoreId() {
        }

        public ScoreId(Long evaluation, Long criterion) {
            this.evaluation = evaluation;
            this.criterion = criterion;
        }

        @Override
        public boolean equals(Object object) {
            if (this == object) {
                return true;
            }
            if (!(object instanceof ScoreId that)) {
                return false;
            }
            return Objects.equals(evaluation, that.evaluation) && Objects.equals(criterion, that.criterion);
        }

        @Override
        public int hashCode() {
            return Objects.hash(evaluation, criterion);
        }
    }
}
