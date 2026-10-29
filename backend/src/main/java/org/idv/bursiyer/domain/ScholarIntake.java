package org.idv.bursiyer.domain;

/**
 * How an active scholar entered the current roster.
 * President quota is kept outside the renewal + interview count.
 */
public enum ScholarIntake {
    RENEWAL,
    INTERVIEW,
    PRESIDENT_QUOTA
}
