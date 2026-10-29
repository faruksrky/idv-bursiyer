package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationSeason;
import org.idv.bursiyer.domain.InterviewInviteOverride;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

public final class InterviewPrescreen {

    private InterviewPrescreen() {}

    public static int incomeMax(ApplicationSeason season, int fallback) {
        if (season == null || season.getFamilyIncomeInterviewMax() == null || season.getFamilyIncomeInterviewMax() <= 0) {
            return fallback;
        }
        return season.getFamilyIncomeInterviewMax();
    }

    public static boolean incomeEligible(Application application, int familyIncomeInterviewMax) {
        BigDecimal income = application.getFamilyMonthlyIncome();
        if (income == null) {
            return true;
        }
        return income.compareTo(BigDecimal.valueOf(familyIncomeInterviewMax)) <= 0;
    }

    public static boolean isPresidentQuota(Application application) {
        return application.getInterviewInvite() == InterviewInviteOverride.PRESIDENT_QUOTA;
    }

    public static boolean isInterviewEligible(Application application, int familyIncomeInterviewMax) {
        InterviewInviteOverride override = application.getInterviewInvite();
        if (override == InterviewInviteOverride.SKIP || override == InterviewInviteOverride.PRESIDENT_QUOTA) {
            return false;
        }
        if (override == InterviewInviteOverride.INVITE) {
            return true;
        }
        return incomeEligible(application, familyIncomeInterviewMax);
    }

    public static String screenReason(Application application, int familyIncomeInterviewMax) {
        if (isInterviewEligible(application, familyIncomeInterviewMax)) {
            return null;
        }
        if (application.getInterviewInvite() == InterviewInviteOverride.PRESIDENT_QUOTA) {
            return "QUOTA";
        }
        if (application.getInterviewInvite() == InterviewInviteOverride.SKIP) {
            return "MANUAL";
        }
        return "INCOME";
    }

    public static String inviteCode(Application application) {
        if (application.getInterviewInvite() == null) {
            return "AUTO";
        }
        return application.getInterviewInvite().name();
    }

    public static InterviewInviteOverride parseInvite(String code) {
        if (code == null || code.isBlank() || "AUTO".equalsIgnoreCase(code.trim())) {
            return null;
        }
        try {
            return InterviewInviteOverride.valueOf(code.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException("Geçersiz mülakat kararı");
        }
    }

    public static String incomeSkipNote(int familyIncomeInterviewMax) {
        NumberFormat format = NumberFormat.getIntegerInstance(Locale.forLanguageTag("tr-TR"));
        format.setGroupingUsed(true);
        return "Aile geliri eşik "
                + format.format(familyIncomeInterviewMax)
                + " TL üzerinde olduğu için gelir kuralına göre mülakata çağrılmaz.";
    }

    public static final String QUOTA_NOTE =
            "Başkan kontenjanı: mülakata çağrılmaz; burs bu kottan verilecek.";

    public static boolean applyQuotaNote(Application application) {
        if (!isPresidentQuota(application)) {
            return false;
        }
        String current = application.getStaffNote();
        if (current != null && current.contains("Başkan kontenjanı")) {
            return false;
        }
        if (current == null || current.isBlank()) {
            application.setStaffNote(QUOTA_NOTE);
        } else {
            application.setStaffNote(current.trim() + "\n" + QUOTA_NOTE);
        }
        return true;
    }

    public static boolean applyIncomeSkipNote(Application application, int familyIncomeInterviewMax) {
        if (isPresidentQuota(application)
                || application.getInterviewInvite() == InterviewInviteOverride.INVITE
                || incomeEligible(application, familyIncomeInterviewMax)) {
            return false;
        }
        String sentence = incomeSkipNote(familyIncomeInterviewMax);
        String current = application.getStaffNote();
        if (current != null && current.contains("gelir kuralına göre mülakata çağrılmaz")) {
            return false;
        }
        if (current == null || current.isBlank()) {
            application.setStaffNote(sentence);
        } else {
            application.setStaffNote(current.trim() + "\n" + sentence);
        }
        return true;
    }
}
