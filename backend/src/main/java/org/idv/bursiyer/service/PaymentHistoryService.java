package org.idv.bursiyer.service;

import org.idv.bursiyer.config.AppProperties;
import org.idv.bursiyer.domain.AttendanceStatus;
import org.idv.bursiyer.domain.MonthlyPayment;
import org.idv.bursiyer.domain.PaymentStatus;
import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.repository.MonthlyPaymentRepository;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.web.dto.ScholarPaymentHistoryRow;
import org.idv.bursiyer.web.dto.ScholarSeasonAttendanceResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentHistoryService {

    private final ScholarRepository scholarRepository;
    private final AttendanceService attendanceService;
    private final MonthlyPaymentRepository paymentRepository;
    private final AppProperties appProperties;

    public PaymentHistoryService(
            ScholarRepository scholarRepository,
            AttendanceService attendanceService,
            MonthlyPaymentRepository paymentRepository,
            AppProperties appProperties
    ) {
        this.scholarRepository = scholarRepository;
        this.attendanceService = attendanceService;
        this.paymentRepository = paymentRepository;
        this.appProperties = appProperties;
    }

    @Transactional(readOnly = true)
    public List<ScholarPaymentHistoryRow> listScholarPaymentHistory(Long scholarId, int academicYear) {
        Scholar scholar = scholarRepository.findById(scholarId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bursiyer bulunamadı"));

        BigDecimal defaultAmount = scholar.getMonthlyAmount() != null
                ? scholar.getMonthlyAmount()
                : BigDecimal.valueOf(appProperties.scholarship().monthlyAmount());

        List<ScholarSeasonAttendanceResponse> attendanceRows =
                attendanceService.listScholarSeasonAttendance(scholarId, academicYear);

        List<ScholarPaymentHistoryRow> rows = new ArrayList<>();
        for (ScholarSeasonAttendanceResponse attendance : attendanceRows) {
            Optional<MonthlyPayment> payment = paymentRepository.findByScholarIdAndYearAndMonth(
                    scholarId,
                    attendance.year(),
                    attendance.month()
            );

            if (payment.isEmpty() && !attendance.programExists()) {
                rows.add(new ScholarPaymentHistoryRow(
                        attendance.year(),
                        attendance.month(),
                        attendance.periodLabel(),
                        "YOK",
                        null,
                        false,
                        false,
                        null
                ));
                continue;
            }

            String paymentStatus;
            BigDecimal amount = defaultAmount;
            String note = null;

            if (payment.isPresent()) {
                MonthlyPayment monthlyPayment = payment.get();
                paymentStatus = monthlyPayment.getPaymentStatus().name();
                amount = monthlyPayment.getAmount();
            } else if (attendance.paymentEligible()) {
                paymentStatus = PaymentStatus.ODENECEK.name();
            } else {
                paymentStatus = PaymentStatus.ODENMEDI.name();
                note = buildNonPaymentNote(attendance);
            }

            rows.add(new ScholarPaymentHistoryRow(
                    attendance.year(),
                    attendance.month(),
                    attendance.periodLabel(),
                    paymentStatus,
                    amount,
                    attendance.paymentEligible(),
                    attendance.programExists(),
                    note
            ));
        }

        return rows;
    }

    private String buildNonPaymentNote(ScholarSeasonAttendanceResponse attendance) {
        if (!attendance.recordExists()) {
            return "Katılım kaydı yok";
        }
        if (attendance.attendanceStatus() == AttendanceStatus.KATILMADI
                && attendance.excuseStatus() != null) {
            return switch (attendance.excuseStatus()) {
                case RED -> "Mazeret reddedildi";
                case YOK -> "Mazeret değerlendirilmedi";
                case KABUL -> null;
            };
        }
        return "Ödeme koşulları sağlanmadı";
    }
}
