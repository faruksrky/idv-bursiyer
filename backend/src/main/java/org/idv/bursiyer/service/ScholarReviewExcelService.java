package org.idv.bursiyer.service;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.idv.bursiyer.domain.ScholarReview;
import org.idv.bursiyer.domain.ScholarReviewDecision;
import org.idv.bursiyer.repository.ScholarRepository;
import org.idv.bursiyer.repository.ScholarReviewRepository;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@Service
public class ScholarReviewExcelService {

    private static final Pattern DIGITS = Pattern.compile("\\D+");

    private final ScholarReviewRepository reviewRepository;
    private final ScholarRepository scholarRepository;
    private final ExcelService excelService;
    private final ScholarReviewService reviewService;

    public ScholarReviewExcelService(
            ScholarReviewRepository reviewRepository,
            ScholarRepository scholarRepository,
            ExcelService excelService,
            ScholarReviewService reviewService
    ) {
        this.reviewRepository = reviewRepository;
        this.scholarRepository = scholarRepository;
        this.excelService = excelService;
        this.reviewService = reviewService;
    }

    @Transactional
    public ScholarImportResult importRenewalForm(Integer academicYear, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Excel dosyası seçilmedi.");
        }
        int year = academicYear == null ? AcademicYears.currentStartYear() : academicYear;
        int created = 0;
        int updated = 0;
        int skipped = 0;
        List<String> errors = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new IllegalArgumentException("Excel başlık satırı boş.");
            }
            Map<String, Integer> columns = headerIndex(headerRow);
            int lastRow = sheet.getLastRowNum();

            for (int rowIndex = 1; rowIndex <= lastRow; rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                int excelRow = rowIndex + 1;
                if (row == null || isBlankRow(row, columns.size())) {
                    skipped++;
                    continue;
                }

                String fullName = firstText(row, columns, "Adı-Soyadı", "Ad Soyad", "Adı Soyadı");
                String tcNo = normalizeTc(firstText(row, columns, "TC Kimlik Numarası", "TC Kimlik No", "TC"));
                if (fullName == null || fullName.length() < 2) {
                    errors.add("Satır " + excelRow + ": Geçerli ad-soyad yok, atlandı.");
                    continue;
                }
                if (tcNo == null || tcNo.length() != 11) {
                    errors.add("Satır " + excelRow + " (" + fullName + "): TC kimlik no eksik veya geçersiz.");
                    continue;
                }

                ScholarReview review = reviewRepository.findByAcademicYearAndTcNo(year, tcNo)
                        .orElseGet(ScholarReview::new);
                boolean existing = review.getId() != null;
                review.setAcademicYear(year);
                review.setTcNo(tcNo);
                review.setFullName(truncate(PersonNames.titleCase(fullName), 255));
                Instant submittedAt = firstInstant(row, columns, "Zaman damgası");
                if (submittedAt != null) {
                    review.setSubmittedAt(submittedAt);
                }
                review.setStudentCertUrl(firstUrl(row, columns, "Öğrenci Belgesi"));
                review.setPhotoUrl(firstUrl(row, columns, "Fotograf", "Fotoğraf"));
                String gpaCell = firstText(row, columns, "Genel Not Ortalaması");
                review.setTranscriptUrl(firstUrl(row, columns, "Genel Not Ortalaması"));
                BigDecimal parsedGpa = gpaOrNull(gpaCell);
                if (parsedGpa != null) {
                    review.setGpa(parsedGpa);
                }
                review.setFamilyIncomeUrl(firstUrl(row, columns, "Aile Aylık Geliri", "Aile Aylık Net Geliri"));
                review.setFatherStatus(truncate(firstText(row, columns, "Baba Sağ-Vefat", "Baba Sağ/Vefat"), 20));
                review.setMotherStatus(truncate(firstText(row, columns, "Anne Sağ-Vefat", "Anne Sağ/Vefat"), 20));
                review.setProgramAttendanceAnswer(firstTextByContains(row, columns, "programa katılabildiniz"));
                review.setSuggestions(firstText(row, columns, "Öneriler"));
                scholarRepository.findByTcNo(tcNo).ifPresent(review::setScholar);
                if (review.getDecision() == null) {
                    review.setDecision(ScholarReviewDecision.PENDING);
                }
                reviewRepository.save(review);
                if (existing) {
                    updated++;
                } else {
                    created++;
                }
            }
        } catch (Exception exception) {
            throw new IllegalStateException("Yenileme Excel dosyası okunamadı: " + exception.getMessage(), exception);
        }

        reviewService.linkReviewsToScholars(year);
        return new ScholarImportResult(created, updated, skipped, errors);
    }

    private Map<String, Integer> headerIndex(Row headerRow) {
        Map<String, Integer> columns = new HashMap<>();
        short last = headerRow.getLastCellNum();
        for (int i = 0; i < last; i++) {
            String name = normalizeHeader(excelService.readCell(headerRow, i));
            if (!name.isBlank()) {
                columns.putIfAbsent(name, i);
            }
        }
        return columns;
    }

    private String firstText(Row row, Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(normalizeHeader(name));
            if (index == null) {
                continue;
            }
            String value = excelService.readCell(row, index);
            if (!value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private String firstTextByContains(Row row, Map<String, Integer> columns, String fragment) {
        String needle = fragment.toLowerCase();
        for (Map.Entry<String, Integer> entry : columns.entrySet()) {
            if (!entry.getKey().toLowerCase().contains(needle)) {
                continue;
            }
            String value = excelService.readCell(row, entry.getValue());
            if (!value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private Instant firstInstant(Row row, Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(normalizeHeader(name));
            if (index == null) {
                continue;
            }
            Instant value = excelService.readInstantCell(row, index);
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    private String firstUrl(Row row, Map<String, Integer> columns, String... names) {
        String value = firstText(row, columns, names);
        if (value != null && (value.startsWith("http") || value.contains("drive.google.com"))) {
            int start = value.indexOf("http");
            return start >= 0 ? value.substring(start).trim() : value.trim();
        }
        return null;
    }

    private boolean isBlankRow(Row row, int columnCount) {
        for (int i = 0; i < Math.max(columnCount, 1); i++) {
            if (!excelService.readCell(row, i).isBlank()) {
                return false;
            }
        }
        return true;
    }

    private static String normalizeHeader(String name) {
        if (name == null) {
            return "";
        }
        return name.replace('\u00a0', ' ').replaceAll("\\s+", " ").trim();
    }

    private static String normalizeTc(String value) {
        if (value == null) {
            return null;
        }
        String text = value.trim();
        if (text.contains(".") || text.toUpperCase().contains("E")) {
            try {
                text = String.valueOf((long) Double.parseDouble(text.replace(",", ".")));
            } catch (NumberFormatException ignored) {
                // keep original
            }
        }
        String digits = DIGITS.matcher(text).replaceAll("");
        if (digits.length() < 11) {
            digits = String.format("%11s", digits).replace(' ', '0');
        }
        return digits.length() >= 11 ? digits.substring(digits.length() - 11) : null;
    }

    private static String truncate(String value, int max) {
        if (value == null) {
            return null;
        }
        return value.length() <= max ? value : value.substring(0, max);
    }

    private static BigDecimal gpaOrNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String text = value.replace(" TL", "").replace(",", ".").trim();
        if (text.startsWith("http") || text.contains("drive.google.com")) {
            return null;
        }
        try {
            BigDecimal gpa = new BigDecimal(text.replaceAll("[^0-9.]", ""));
            if (gpa.compareTo(new BigDecimal("99.99")) > 0) {
                return null;
            }
            return gpa;
        } catch (NumberFormatException ignored) {
            return null;
        }
    }
}
