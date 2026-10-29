package org.idv.bursiyer.web;

import org.idv.bursiyer.service.AccountingExcelService;
import org.idv.bursiyer.service.AccountingExportService;
import org.idv.bursiyer.service.AccountingPaymentService;
import org.idv.bursiyer.service.PaymentHistoryService;
import org.idv.bursiyer.web.dto.AccountingExportRow;
import org.idv.bursiyer.web.dto.ScholarPaymentHistoryRow;
import org.idv.bursiyer.web.dto.UpdateAccountingPaymentAmountRequest;
import org.idv.bursiyer.web.dto.UpdateAccountingPaymentAmountResponse;
import org.idv.bursiyer.web.dto.UpdateAccountingPaymentStatusRequest;
import org.idv.bursiyer.web.dto.UpdateAccountingPaymentStatusResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/accounting")
public class AccountingExportController {

    private final AccountingExportService accountingExportService;
    private final AccountingExcelService accountingExcelService;
    private final AccountingPaymentService accountingPaymentService;
    private final PaymentHistoryService paymentHistoryService;

    public AccountingExportController(
            AccountingExportService accountingExportService,
            AccountingExcelService accountingExcelService,
            AccountingPaymentService accountingPaymentService,
            PaymentHistoryService paymentHistoryService
    ) {
        this.accountingExportService = accountingExportService;
        this.accountingExcelService = accountingExcelService;
        this.accountingPaymentService = accountingPaymentService;
        this.paymentHistoryService = paymentHistoryService;
    }

    @GetMapping("/export")
    public List<AccountingExportRow> exportEligiblePayments(
            @RequestParam int year,
            @RequestParam int month
    ) {
        return accountingExportService.buildExport(year, month);
    }

    @GetMapping("/export/excel")
    public ResponseEntity<byte[]> exportEligiblePaymentsExcel(
            @RequestParam int year,
            @RequestParam int month
    ) {
        byte[] workbook = accountingExcelService.buildWorkbook(year, month);
        String filename = accountingExcelService.buildFilename(year, month);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.parseMediaType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                ))
                .body(workbook);
    }

    @PutMapping("/payments")
    public UpdateAccountingPaymentStatusResponse updatePaymentStatus(
            @RequestBody UpdateAccountingPaymentStatusRequest request
    ) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "İstek gövdesi zorunlu");
        }
        int updated = accountingPaymentService.updateStatuses(
                request.year(),
                request.month(),
                request.scholarIds(),
                request.paymentStatus()
        );
        return new UpdateAccountingPaymentStatusResponse(updated, request.paymentStatus().name());
    }

    @PutMapping("/payments/amounts")
    public UpdateAccountingPaymentAmountResponse updatePaymentAmounts(
            @RequestBody UpdateAccountingPaymentAmountRequest request
    ) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "İstek gövdesi zorunlu");
        }
        int updated = accountingPaymentService.updateAmounts(
                request.year(),
                request.month(),
                request.scholarIds(),
                request.amount()
        );
        return new UpdateAccountingPaymentAmountResponse(updated, request.amount());
    }

    @GetMapping("/scholars/{scholarId}/payment-history")
    public List<ScholarPaymentHistoryRow> scholarPaymentHistory(
            @PathVariable Long scholarId,
            @RequestParam int academicYear
    ) {
        return paymentHistoryService.listScholarPaymentHistory(scholarId, academicYear);
    }
}
