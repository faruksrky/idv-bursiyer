package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.PaymentStatus;
import org.idv.bursiyer.web.dto.AccountingExportRow;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class AccountingExcelService {

    private static final String[] HEADERS = {
            "#", "Ad", "Soyad", "Cinsiyet", "IBAN", "Dönem", "Tutar (TL)", "Durum", "Üniversite"
    };

    private final AccountingExportService accountingExportService;
    private final ExcelService excelService;

    public AccountingExcelService(AccountingExportService accountingExportService, ExcelService excelService) {
        this.accountingExportService = accountingExportService;
        this.excelService = excelService;
    }

    @Transactional(readOnly = true)
    public byte[] buildWorkbook(int year, int month) {
        List<AccountingExportRow> rows = accountingExportService.buildExport(year, month);
        try (Workbook workbook = excelService.createWorkbook()) {
            Sheet sheet = workbook.createSheet("IBAN Listesi");
            CellStyle headerStyle = excelService.createHeaderStyle(workbook);
            excelService.writeHeaderRow(sheet, headerStyle, HEADERS);

            int rowIndex = 1;
            for (AccountingExportRow row : rows) {
                Row excelRow = sheet.createRow(rowIndex++);
                excelService.writeCell(excelRow, 0, row.rowNumber());
                excelService.writeCell(excelRow, 1, row.firstName());
                excelService.writeCell(excelRow, 2, row.lastName());
                excelService.writeCell(excelRow, 3, PersonGenders.label(row.gender()));
                excelService.writeCell(excelRow, 4, row.iban());
                excelService.writeCell(excelRow, 5, row.periodLabel());
                excelService.writeCell(excelRow, 6, row.amount());
                excelService.writeCell(excelRow, 7, paymentStatusLabel(row.paymentStatus()));
                excelService.writeCell(excelRow, 8, row.university());
            }

            return excelService.toBytes(workbook);
        } catch (Exception exception) {
            throw new IllegalStateException("Muhasebe Excel dosyası oluşturulamadı", exception);
        }
    }

    public String buildFilename(int year, int month) {
        return String.format("idv-muhasebe-%d-%02d.xlsx", year, month);
    }

    private String paymentStatusLabel(String status) {
        return switch (status) {
            case "ODENDI" -> "Ödendi";
            case "ODENECEK" -> "Ödenecek";
            case "ODENMEDI" -> "Ödenmedi";
            default -> status;
        };
    }
}
