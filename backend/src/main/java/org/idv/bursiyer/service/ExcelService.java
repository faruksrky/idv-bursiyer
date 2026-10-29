package org.idv.bursiyer.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

@Service
public class ExcelService {

    private static final DataFormatter DATA_FORMATTER = new DataFormatter();

    public Workbook createWorkbook() {
        return new XSSFWorkbook();
    }

    public CellStyle createHeaderStyle(Workbook workbook) {
        Font font = workbook.createFont();
        font.setBold(true);
        CellStyle style = workbook.createCellStyle();
        style.setFont(font);
        return style;
    }

    public Row writeHeaderRow(Sheet sheet, CellStyle headerStyle, String... headers) {
        Row row = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
            sheet.setColumnWidth(i, Math.min(256 * 24, 256 * 60));
        }
        return row;
    }

    public void writeCell(Row row, int column, Object value) {
        Cell cell = row.createCell(column);
        if (value == null) {
            cell.setBlank();
            return;
        }
        if (value instanceof Number number) {
            cell.setCellValue(number.doubleValue());
            return;
        }
        if (value instanceof LocalDate date) {
            cell.setCellValue(date);
            return;
        }
        cell.setCellValue(value.toString());
    }

    public byte[] toBytes(Workbook workbook) {
        try (workbook; ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            workbook.write(output);
            return output.toByteArray();
        } catch (IOException exception) {
            throw new IllegalStateException("Excel dosyası oluşturulamadı", exception);
        }
    }

    public String readCell(Row row, int column) {
        if (row == null) {
            return "";
        }
        Cell cell = row.getCell(column);
        if (cell == null) {
            return "";
        }
        return DATA_FORMATTER.formatCellValue(cell).trim();
    }

    public LocalDate readDateCell(Row row, int column) {
        if (row == null) {
            return null;
        }
        Cell cell = row.getCell(column);
        if (cell == null) {
            return null;
        }
        if (DateUtil.isCellDateFormatted(cell)) {
            Date date = cell.getDateCellValue();
            return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        }
        String text = readCell(row, column);
        if (text.isBlank()) {
            return null;
        }
        if (text.matches("\\d{4}-\\d{2}-\\d{2}")) {
            return LocalDate.parse(text);
        }
        if (text.matches("\\d{2}\\.\\d{2}\\.\\d{4}")) {
            String[] parts = text.split("\\.");
            return LocalDate.of(Integer.parseInt(parts[2]), Integer.parseInt(parts[1]), Integer.parseInt(parts[0]));
        }
        return null;
    }

    public Instant readInstantCell(Row row, int column) {
        if (row == null) {
            return null;
        }
        Cell cell = row.getCell(column);
        if (cell == null) {
            return null;
        }
        if (DateUtil.isCellDateFormatted(cell)) {
            Date date = cell.getDateCellValue();
            return date.toInstant();
        }
        String text = readCell(row, column);
        if (text.isBlank()) {
            return null;
        }
        try {
            return Instant.parse(text.replace(' ', 'T') + (text.contains("T") ? "" : "Z"));
        } catch (Exception ignored) {
            return null;
        }
    }

    public BigDecimal readDecimalCell(Row row, int column) {
        String text = readCell(row, column);
        if (text.isBlank()) {
            return null;
        }
        return new BigDecimal(text.replace(" TL", "").replace(',', '.').trim());
    }
}
