package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.idv.bursiyer.domain.MonthlyPayment;
import org.idv.bursiyer.domain.PaymentStatus;
import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarReview;
import org.idv.bursiyer.domain.ScholarReviewDecision;
import org.idv.bursiyer.domain.SystemSetting;
import org.idv.bursiyer.repository.MonthlyPaymentRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.repository.SystemSettingRepository;
import org.idv.bursiyer.web.dto.AccountingExportRow;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class AccountingExportService {

    private static final int YENILEME_YEAR = 2026;
    static final String EXTRA_SCHOLAR_IDS_KEY = "accounting_extra_scholar_ids";

    private final ScholarReviewRepository scholarReviewRepository;
    private final ScholarRepository scholarRepository;
    private final SystemSettingRepository systemSettingRepository;
    private final MonthlyPaymentRepository paymentRepository;
    private final AppProperties appProperties;

    public AccountingExportService(
            ScholarReviewRepository scholarReviewRepository,
            ScholarRepository scholarRepository,
            SystemSettingRepository systemSettingRepository,
            MonthlyPaymentRepository paymentRepository,
            AppProperties appProperties
    ) {
        this.scholarReviewRepository = scholarReviewRepository;
        this.scholarRepository = scholarRepository;
        this.systemSettingRepository = systemSettingRepository;
        this.paymentRepository = paymentRepository;
        this.appProperties = appProperties;
    }

    @Transactional(readOnly = true)
    public List<AccountingExportRow> buildExport(int year, int month) {
        BigDecimal defaultAmount = BigDecimal.valueOf(appProperties.scholarship().monthlyAmount());
        String periodLabel = formatPeriod(year, month);

        Map<Long, Source> byScholar = eligibleSources();

        List<Source> sources = new ArrayList<>(byScholar.values());
        sources.sort(Comparator.comparing(source -> PersonNames.fold(source.fullName()), String.CASE_INSENSITIVE_ORDER));

        List<Long> scholarIds = sources.stream().map(source -> source.scholar().getId()).toList();
        Map<Long, MonthlyPayment> paymentByScholar = scholarIds.isEmpty()
                ? Map.of()
                : paymentRepository.findForPeriod(year, month, scholarIds).stream()
                        .collect(Collectors.toMap(
                                payment -> payment.getScholar().getId(),
                                Function.identity(),
                                (left, right) -> left
                        ));

        List<AccountingExportRow> rows = new ArrayList<>();
        int index = 1;
        for (Source source : sources) {
            Scholar scholar = source.scholar();
            String[] names = PersonNames.splitFullName(source.fullName());
            MonthlyPayment payment = paymentByScholar.get(scholar.getId());
            PaymentStatus status = payment != null ? payment.getPaymentStatus() : PaymentStatus.ODENMEDI;
            BigDecimal storedAmount = payment != null ? payment.getAmount() : null;
            rows.add(new AccountingExportRow(
                    index++,
                    scholar.getId(),
                    names[0],
                    names[1],
                    PersonGenders.fromName(names[0]),
                    scholar.getIban(),
                    periodLabel,
                    storedAmount,
                    status.name(),
                    scholar.getUniversity(),
                    suggestedAmount(scholar, defaultAmount)
            ));
        }
        return rows;
    }

    @Transactional(readOnly = true)
    public Map<Long, BigDecimal> continueScholarAmounts() {
        BigDecimal defaultAmount = BigDecimal.valueOf(appProperties.scholarship().monthlyAmount());
        Map<Long, BigDecimal> amounts = new LinkedHashMap<>();
        for (Source source : eligibleSources().values()) {
            Scholar scholar = source.scholar();
            amounts.putIfAbsent(scholar.getId(), suggestedAmount(scholar, defaultAmount));
        }
        return amounts;
    }

    /**
     * Renewal CONTINUE scholars, plus the specific scholars listed by id in
     * system_settings. Those extras are acceptance replies, not every ACCEPTED application.
     */
    private Map<Long, Source> eligibleSources() {
        Map<Long, Source> byScholar = new LinkedHashMap<>();
        for (ScholarReview review : scholarReviewRepository.findDetailedByAcademicYear(YENILEME_YEAR)) {
            if (review.getDecision() != ScholarReviewDecision.CONTINUE) {
                continue;
            }
            addSource(byScholar, review.getScholar(), review.getFullName());
        }
        List<Long> extraIds = extraScholarIds();
        if (!extraIds.isEmpty()) {
            for (Scholar scholar : scholarRepository.findAllById(extraIds)) {
                addSource(byScholar, scholar, PersonNames.fullName(scholar));
            }
        }
        return byScholar;
    }

    private List<Long> extraScholarIds() {
        return systemSettingRepository.findById(EXTRA_SCHOLAR_IDS_KEY)
                .map(SystemSetting::getSettingValue)
                .map(AccountingExportService::parseExtraScholarIds)
                .orElse(List.of());
    }

    static List<Long> parseExtraScholarIds(String raw) {
        if (raw == null || raw.isBlank()) {
            return List.of();
        }
        List<Long> ids = new ArrayList<>();
        for (String part : raw.split(",")) {
            String token = part.trim();
            if (token.isEmpty()) {
                continue;
            }
            try {
                long id = Long.parseLong(token);
                if (id > 0) {
                    ids.add(id);
                }
            } catch (NumberFormatException ignored) {
                // A single bad token must not drop the rest of the explicit list.
            }
        }
        return ids;
    }

    private static BigDecimal suggestedAmount(Scholar scholar, BigDecimal defaultAmount) {
        return scholar.getMonthlyAmount() != null ? scholar.getMonthlyAmount() : defaultAmount;
    }

    private static void addSource(Map<Long, Source> byScholar, Scholar scholar, String fullName) {
        if (scholar == null) {
            return;
        }
        String name = (fullName == null || fullName.isBlank())
                ? PersonNames.fullName(scholar)
                : fullName;
        byScholar.putIfAbsent(scholar.getId(), new Source(scholar, name));
    }

    private String formatPeriod(int year, int month) {
        String monthName = Month.of(month).getDisplayName(TextStyle.FULL_STANDALONE, new Locale("tr"));
        return monthName.substring(0, 1).toUpperCase(new Locale("tr")) + monthName.substring(1) + " " + year;
    }

    private record Source(Scholar scholar, String fullName) {}
}
