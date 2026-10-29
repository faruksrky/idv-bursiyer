package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.Scholar;
import org.idv.bursiyer.domain.ScholarStatus;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.idv.bursiyer.web.dto.ScholarResponse;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
public class ScholarExcelService {

    static final String[] HEADERS = {
            "Ad",
            "Soyad",
            "TC Kimlik No",
            "E-posta",
            "Telefon",
            "IBAN",
            "Üniversite",
            "Fakülte",
            "Bölüm",
            "Sınıf",
            "Statü",
            "Burs Başlangıç"
    };

    private final ScholarRepository scholarRepository;
    private final ScholarService scholarService;
    private final ExcelService excelService;
    private final ScholarReviewService scholarReviewService;

    public ScholarExcelService(
            ScholarRepository scholarRepository,
            ScholarService scholarService,
            ExcelService excelService,
            ScholarReviewService scholarReviewService
    ) {
        this.scholarRepository = scholarRepository;
        this.scholarService = scholarService;
        this.excelService = excelService;
        this.scholarReviewService = scholarReviewService;
    }

    @Transactional(readOnly = true)
    public byte[] exportScholars(ScholarStatus status) {
        List<ScholarResponse> scholars = scholarService.listScholars(status);
        try (Workbook workbook = excelService.createWorkbook()) {
            Sheet sheet = workbook.createSheet("Bursiyerler");
            CellStyle headerStyle = excelService.createHeaderStyle(workbook);
            excelService.writeHeaderRow(sheet, headerStyle, HEADERS);

            int rowIndex = 1;
            for (ScholarResponse scholar : scholars) {
                Row row = sheet.createRow(rowIndex++);
                excelService.writeCell(row, 0, scholar.firstName());
                excelService.writeCell(row, 1, scholar.lastName());
                excelService.writeCell(row, 2, scholar.tcNo());
                excelService.writeCell(row, 3, scholar.email());
                excelService.writeCell(row, 4, scholar.phone());
                excelService.writeCell(row, 5, scholar.iban());
                excelService.writeCell(row, 6, scholar.university());
                excelService.writeCell(row, 7, scholar.faculty());
                excelService.writeCell(row, 8, scholar.department());
                excelService.writeCell(row, 9, scholar.classYear());
                excelService.writeCell(row, 10, scholar.status().name());
                excelService.writeCell(row, 11, scholar.scholarshipStart());
            }

            return excelService.toBytes(workbook);
        } catch (Exception exception) {
            throw new IllegalStateException("Bursiyer Excel dosyası oluşturulamadı", exception);
        }
    }

    public byte[] buildImportTemplate() {
        try (Workbook workbook = excelService.createWorkbook()) {
            Sheet sheet = workbook.createSheet("Bursiyer Şablonu");
            CellStyle headerStyle = excelService.createHeaderStyle(workbook);
            excelService.writeHeaderRow(sheet, headerStyle, HEADERS);

            Row exampleRow = sheet.createRow(1);
            excelService.writeCell(exampleRow, 0, "Ayşe");
            excelService.writeCell(exampleRow, 1, "Yılmaz");
            excelService.writeCell(exampleRow, 2, "12345678901");
            excelService.writeCell(exampleRow, 3, "ayse@ornek.edu.tr");
            excelService.writeCell(exampleRow, 4, "05551234567");
            excelService.writeCell(exampleRow, 5, "TR000000000000000000000000");
            excelService.writeCell(exampleRow, 6, "İstanbul Üniversitesi");
            excelService.writeCell(exampleRow, 7, "Mühendislik Fakültesi");
            excelService.writeCell(exampleRow, 8, "Bilgisayar Mühendisliği");
            excelService.writeCell(exampleRow, 9, "3");
            excelService.writeCell(exampleRow, 10, "OGRENCI");
            excelService.writeCell(exampleRow, 11, LocalDate.of(2025, 9, 1));

            return excelService.toBytes(workbook);
        } catch (Exception exception) {
            throw new IllegalStateException("Bursiyer şablonu oluşturulamadı", exception);
        }
    }

    @Transactional
    public ScholarImportResult importScholars(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Excel dosyası seçilmedi.");
        }

        int created = 0;
        int updated = 0;
        int skipped = 0;
        List<String> errors = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            Row headerRow = sheet.getRow(0);
            if (headerRow != null && isRosterHeader(headerRow)) {
                ScholarImportResult result = importRosterSheet(sheet);
                scholarReviewService.linkReviewsToScholars(AcademicYears.currentStartYear());
                return result;
            }
            int lastRow = sheet.getLastRowNum();

            for (int rowIndex = 1; rowIndex <= lastRow; rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null || isBlankRow(row)) {
                    skipped++;
                    continue;
                }

                int excelRowNumber = rowIndex + 1;
                String firstName = excelService.readCell(row, 0);
                String lastName = excelService.readCell(row, 1);

                if (firstName.isBlank() || lastName.isBlank()) {
                    errors.add("Satır " + excelRowNumber + ": Ad ve Soyad zorunludur.");
                    continue;
                }

                String tcNo = normalizeTc(excelService.readCell(row, 2));
                Scholar scholar = findExistingScholar(tcNo).orElseGet(Scholar::new);
                boolean isNew = scholar.getId() == null;

                scholar.setFirstName(PersonNames.titleCase(firstName));
                scholar.setLastName(PersonNames.titleCase(lastName));
                scholar.setTcNo(tcNo.isBlank() ? null : tcNo);
                scholar.setEmail(emptyToNull(excelService.readCell(row, 3)));
                scholar.setPhone(emptyToNull(excelService.readCell(row, 4)));
                scholar.setIban(emptyToNull(excelService.readCell(row, 5)));
                scholar.setUniversity(emptyToNull(excelService.readCell(row, 6)));
                scholar.setFaculty(emptyToNull(excelService.readCell(row, 7)));
                scholar.setDepartment(emptyToNull(excelService.readCell(row, 8)));
                scholar.setClassYear(emptyToNull(excelService.readCell(row, 9)));

                String statusText = excelService.readCell(row, 10);
                if (!statusText.isBlank()) {
                    try {
                        scholar.setStatus(ScholarStatus.valueOf(statusText.trim().toUpperCase(Locale.ROOT)));
                    } catch (IllegalArgumentException exception) {
                        errors.add("Satır " + excelRowNumber + ": Geçersiz statü '" + statusText + "'. OGRENCI veya MEZUN olmalı.");
                        continue;
                    }
                } else if (isNew) {
                    scholar.setStatus(ScholarStatus.OGRENCI);
                }

                LocalDate scholarshipStart = excelService.readDateCell(row, 11);
                if (scholarshipStart != null) {
                    scholar.setScholarshipStart(scholarshipStart);
                }

                if (scholar.getStatus() == ScholarStatus.MEZUN) {
                    scholar.setActive(false);
                } else if (isNew) {
                    scholar.setActive(true);
                }

                scholarRepository.save(scholar);
                if (isNew) {
                    created++;
                } else {
                    updated++;
                }
            }
        } catch (IOException exception) {
            throw new IllegalArgumentException("Excel dosyası okunamadı.", exception);
        }

        scholarReviewService.linkReviewsToScholars(AcademicYears.currentStartYear());
        return new ScholarImportResult(created, updated, skipped, errors);
    }

    private Optional<Scholar> findExistingScholar(String tcNo) {
        if (tcNo.isBlank()) {
            return Optional.empty();
        }
        return scholarRepository.findByTcNo(tcNo);
    }

    private ScholarImportResult importRosterSheet(Sheet sheet) {
        int created = 0;
        int updated = 0;
        int skipped = 0;
        List<String> errors = new ArrayList<>();
        Row headerRow = sheet.getRow(0);
        java.util.Map<String, Integer> columns = rosterColumns(headerRow);
        List<Scholar> existing = new ArrayList<>(scholarRepository.findAll());
        int lastRow = sheet.getLastRowNum();

        for (int rowIndex = 1; rowIndex <= lastRow; rowIndex++) {
            Row row = sheet.getRow(rowIndex);
            int excelRow = rowIndex + 1;
            if (row == null) {
                skipped++;
                continue;
            }
            String fullName = rosterText(row, columns, "ad-soyad", "ad soyad", "ad soyadı");
            if (fullName == null || fullName.length() < 3) {
                if (isBlankRow(row)) {
                    skipped++;
                } else {
                    errors.add("Satır " + excelRow + ": Ad-soyad yok, atlandı.");
                }
                continue;
            }

            String iban = rosterText(row, columns, "iban bilgiler", "iban");
            String phone = normalizePhone(rosterText(row, columns, "tel", "telefon"));
            Scholar scholar = findRosterScholar(existing, fullName, iban, phone).orElseGet(Scholar::new);
            boolean isNew = scholar.getId() == null;
            String[] names = PersonNames.splitFullName(fullName);
            scholar.setFirstName(names[0]);
            scholar.setLastName(names[1]);
            scholar.setPhone(phone);
            scholar.setEmail(rosterText(row, columns, "mail", "e-posta", "eposta"));
            if (iban != null) {
                scholar.setIban(iban.replace(" ", ""));
            }
            scholar.setUniversity(rosterText(row, columns, "okul", "üniversite"));
            scholar.setDepartment(rosterText(row, columns, "bölüm"));
            scholar.setClassYear(rosterText(row, columns, "sınıf"));
            scholar.setStatus(ScholarStatus.OGRENCI);
            scholar.setActive(true);
            LocalDate start = periodStart(rosterText(row, columns, "kayıt donemi", "kayıt dönemi"));
            if (start != null) {
                scholar.setScholarshipStart(start);
            }
            scholarRepository.save(scholar);
            if (isNew) {
                existing.add(scholar);
                created++;
            } else {
                updated++;
            }
        }
        return new ScholarImportResult(created, updated, skipped, errors);
    }

    private Optional<Scholar> findRosterScholar(List<Scholar> existing, String fullName, String iban, String phone) {
        if (iban != null && !iban.isBlank()) {
            String compact = iban.replace(" ", "");
            Optional<Scholar> byIban = scholarRepository.findByIban(compact);
            if (byIban.isPresent()) {
                return byIban;
            }
            for (Scholar scholar : existing) {
                if (scholar.getIban() != null && compact.equalsIgnoreCase(scholar.getIban().replace(" ", ""))) {
                    return Optional.of(scholar);
                }
            }
        }
        Optional<Scholar> byName = PersonNames.findByName(existing, fullName);
        if (byName.isPresent()) {
            return byName;
        }
        if (phone != null && phone.length() >= 10) {
            for (Scholar scholar : existing) {
                String scholarPhone = normalizePhone(scholar.getPhone());
                if (scholarPhone != null && scholarPhone.endsWith(phone.substring(Math.max(0, phone.length() - 10)))) {
                    return Optional.of(scholar);
                }
            }
        }
        return Optional.empty();
    }

    private boolean isRosterHeader(Row headerRow) {
        short last = headerRow.getLastCellNum();
        for (int i = 0; i < last; i++) {
            String header = foldHeader(excelService.readCell(headerRow, i));
            if (header.contains("ad-soyad") || header.contains("ad soyad")) {
                return true;
            }
        }
        return false;
    }

    private java.util.Map<String, Integer> rosterColumns(Row headerRow) {
        java.util.Map<String, Integer> columns = new java.util.HashMap<>();
        short last = headerRow.getLastCellNum();
        for (int i = 0; i < last; i++) {
            String header = foldHeader(excelService.readCell(headerRow, i));
            if (!header.isBlank()) {
                columns.putIfAbsent(header, i);
            }
        }
        return columns;
    }

    private String rosterText(Row row, java.util.Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(foldHeader(name));
            if (index == null) {
                continue;
            }
            String value = excelService.readCell(row, index);
            if (!value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private static String foldHeader(String value) {
        return PersonNames.fold(value == null ? "" : value);
    }

    private static String normalizePhone(String value) {
        if (value == null) {
            return null;
        }
        String digits = value.replaceAll("\\D", "");
        return digits.isEmpty() ? null : digits;
    }

    private static LocalDate periodStart(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String digits = value.replaceAll("[^0-9]", " ").trim();
        String[] parts = digits.split("\\s+");
        if (parts.length == 0 || parts[0].length() < 4) {
            return null;
        }
        try {
            return LocalDate.of(Integer.parseInt(parts[0].substring(0, 4)), 9, 1);
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private boolean isBlankRow(Row row) {
        for (int column = 0; column < HEADERS.length; column++) {
            if (!excelService.readCell(row, column).isBlank()) {
                return false;
            }
        }
        return true;
    }

    private String normalizeTc(String tcNo) {
        if (tcNo == null) {
            return "";
        }
        return tcNo.replaceAll("\\D", "");
    }

    private String emptyToNull(String value) {
        return value == null || value.isBlank() ? null : value;
    }
}
