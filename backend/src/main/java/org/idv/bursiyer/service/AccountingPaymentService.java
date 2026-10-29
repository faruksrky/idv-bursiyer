package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.MonthlyPayment;
import org.idv.bursiyer.domain.MonthlyProgram;
import org.idv.bursiyer.domain.PaymentStatus;
import org.idv.bursiyer.repository.MonthlyPaymentRepository;
import org.idv.bursiyer.repository.MonthlyProgramRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class AccountingPaymentService {

    private static final ZoneId ISTANBUL = ZoneId.of("Europe/Istanbul");
    private static final int MAX_BATCH = 200;
    private static final BigDecimal MAX_AMOUNT = new BigDecimal("9999999999.99");

    private final AccountingExportService accountingExportService;
    private final MonthlyPaymentRepository paymentRepository;
    private final MonthlyProgramRepository programRepository;
    private final ScholarRepository scholarRepository;

    public AccountingPaymentService(
            AccountingExportService accountingExportService,
            MonthlyPaymentRepository paymentRepository,
            MonthlyProgramRepository programRepository,
            ScholarRepository scholarRepository
    ) {
        this.accountingExportService = accountingExportService;
        this.paymentRepository = paymentRepository;
        this.programRepository = programRepository;
        this.scholarRepository = scholarRepository;
    }

    @Transactional
    public int updateStatuses(int year, int month, List<Long> scholarIds, PaymentStatus paymentStatus) {
        validatePeriod(year, month);
        if (paymentStatus != PaymentStatus.ODENDI && paymentStatus != PaymentStatus.ODENMEDI) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Durum yalnızca Ödendi veya Ödenmedi olabilir");
        }
        List<Long> ids = requireScholarIds(scholarIds);
        Map<Long, BigDecimal> eligible = requireEligible(ids);

        Map<Long, MonthlyPayment> existing = paymentsFor(year, month, ids);
        MonthlyProgram program = programRepository.findFirstByYearAndMonthOrderByProgramDateAscIdAsc(year, month).orElse(null);
        LocalDate paymentDate = paymentStatus == PaymentStatus.ODENDI ? LocalDate.now(ISTANBUL) : null;

        List<MonthlyPayment> toSave = new ArrayList<>();
        for (Long scholarId : ids) {
            MonthlyPayment payment = existing.get(scholarId);
            if (payment == null) {
                payment = newMonthlyPayment(scholarId, year, month, eligible.get(scholarId), program);
            } else if (payment.getProgram() == null && program != null) {
                payment.setProgram(program);
            }
            payment.setPaymentStatus(paymentStatus);
            payment.setPaymentDate(paymentDate);
            if (paymentStatus == PaymentStatus.ODENDI) {
                payment.setNonPaymentReason(null);
            }
            toSave.add(payment);
        }
        paymentRepository.saveAll(toSave);
        return toSave.size();
    }

    @Transactional
    public int updateAmounts(int year, int month, List<Long> scholarIds, BigDecimal amount) {
        validatePeriod(year, month);
        List<Long> ids = requireScholarIds(scholarIds);
        BigDecimal normalized = normalizeAmount(amount);
        requireEligible(ids);

        Map<Long, MonthlyPayment> existing = paymentsFor(year, month, ids);
        MonthlyProgram program = programRepository.findFirstByYearAndMonthOrderByProgramDateAscIdAsc(year, month).orElse(null);

        List<MonthlyPayment> toSave = new ArrayList<>();
        for (Long scholarId : ids) {
            MonthlyPayment payment = existing.get(scholarId);
            if (payment == null) {
                payment = newMonthlyPayment(scholarId, year, month, normalized, program);
                payment.setPaymentStatus(PaymentStatus.ODENMEDI);
            } else {
                payment.setAmount(normalized);
            }
            toSave.add(payment);
        }
        paymentRepository.saveAll(toSave);
        return toSave.size();
    }

    private Map<Long, MonthlyPayment> paymentsFor(int year, int month, List<Long> ids) {
        return paymentRepository.findForPeriod(year, month, ids).stream()
                .collect(Collectors.toMap(
                        payment -> payment.getScholar().getId(),
                        Function.identity(),
                        (left, right) -> left
                ));
    }

    private MonthlyPayment newMonthlyPayment(
            Long scholarId,
            int year,
            int month,
            BigDecimal amount,
            MonthlyProgram program
    ) {
        MonthlyPayment payment = new MonthlyPayment();
        payment.setScholar(scholarRepository.getReferenceById(scholarId));
        payment.setYear(year);
        payment.setMonth(month);
        payment.setAmount(amount);
        payment.setProgram(program);
        return payment;
    }

    private void validatePeriod(int year, int month) {
        if (year < 2000 || year > 2100 || month < 1 || month > 12) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Geçersiz dönem");
        }
    }

    private List<Long> requireScholarIds(List<Long> scholarIds) {
        if (scholarIds == null || scholarIds.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "En az bir bursiyer seçin");
        }
        List<Long> ids = scholarIds.stream().filter(id -> id != null && id > 0).distinct().toList();
        if (ids.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "En az bir bursiyer seçin");
        }
        if (ids.size() > MAX_BATCH) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tek seferde en fazla 200 bursiyer işaretlenebilir");
        }
        return ids;
    }

    private Map<Long, BigDecimal> requireEligible(List<Long> ids) {
        Map<Long, BigDecimal> eligible = accountingExportService.continueScholarAmounts();
        boolean unknown = ids.stream().anyMatch(id -> !eligible.containsKey(id));
        if (unknown) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Seçilen bursiyer bu ayın devam listesinde yok");
        }
        return eligible;
    }

    private BigDecimal normalizeAmount(BigDecimal amount) {
        if (amount == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tutar zorunlu");
        }
        BigDecimal stripped = amount.stripTrailingZeros();
        if (stripped.scale() < 0) {
            stripped = stripped.setScale(0);
        }
        if (stripped.scale() > 2) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tutar en fazla iki ondalık basamak olabilir");
        }
        if (stripped.signum() <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tutar sıfırdan büyük olmalı");
        }
        BigDecimal normalized = stripped.setScale(2, RoundingMode.UNNECESSARY);
        if (normalized.compareTo(MAX_AMOUNT) > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tutar çok büyük");
        }
        return normalized;
    }
}
