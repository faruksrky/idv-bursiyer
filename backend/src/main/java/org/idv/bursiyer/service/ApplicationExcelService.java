package org.idv.bursiyer.service;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.idv.bursiyer.domain.Application;
import org.idv.bursiyer.domain.ApplicationDocument;
import org.idv.bursiyer.domain.ApplicationDocumentType;
import org.idv.bursiyer.domain.ApplicationSeason;
import org.idv.bursiyer.domain.ApplicationStatus;
import org.idv.bursiyer.repository.ApplicationDocumentRepository;
import org.idv.bursiyer.repository.ApplicationRepository;
import org.idv.bursiyer.repository.ApplicationSeasonRepository;
import org.idv.bursiyer.web.dto.ScholarImportResult;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@Service
public class ApplicationExcelService {

    private static final Pattern DIGITS = Pattern.compile("\\D+");

    private final ApplicationSeasonRepository seasonRepository;
    private final ApplicationRepository applicationRepository;
    private final ApplicationDocumentRepository documentRepository;
    private final ExcelService excelService;

    public ApplicationExcelService(
            ApplicationSeasonRepository seasonRepository,
            ApplicationRepository applicationRepository,
            ApplicationDocumentRepository documentRepository,
            ExcelService excelService
    ) {
        this.seasonRepository = seasonRepository;
        this.applicationRepository = applicationRepository;
        this.documentRepository = documentRepository;
        this.excelService = excelService;
    }

    @Transactional
    public ScholarImportResult importGoogleFormResponses(Long seasonId, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Excel dosyası seçilmedi.");
        }

        ApplicationSeason season = seasonRepository.findById(seasonId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Başvuru dönemi bulunamadı"));

        int created = 0;
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

                String fullName = firstText(row, columns, "Adı-Soyadı 2", "Adı-Soyadı");
                String tcNo = normalizeTc(firstText(row, columns, "TC Kimlik Numarası 2", "TC Kimlik Numarası"));
                if (fullName == null || fullName.length() < 2 || "\"".equals(fullName)) {
                    errors.add("Satır " + excelRow + ": Geçerli ad-soyad yok, atlandı.");
                    continue;
                }
                if (tcNo == null || tcNo.length() != 11) {
                    errors.add("Satır " + excelRow + " (" + fullName + "): TC kimlik no eksik veya geçersiz.");
                    continue;
                }

                if (applicationRepository.existsBySeasonIdAndTcNo(season.getId(), tcNo)) {
                    skipped++;
                    continue;
                }

                Application application = new Application();
                application.setSeason(season);
                application.setStatus(ApplicationStatus.SUBMITTED);
                Instant submittedAt = firstInstant(row, columns, "Zaman damgası");
                if (submittedAt != null) {
                    application.setSubmittedAt(submittedAt);
                }
                application.setFullName(truncate(PersonNames.titleCase(fullName), 255));
                application.setTcNo(tcNo);
                application.setBirthPlace(truncate(firstText(row, columns, "Doğum Yeri 2", "Doğum Yeri"), 255));
                int birthDateColumn = column(columns, "Doğum Tarihi 2", "Doğum Tarihi");
                if (birthDateColumn >= 0) {
                    application.setBirthDate(excelService.readDateCell(row, birthDateColumn));
                }
                application.setEmail(truncate(firstText(row, columns, "E-Mail 2", "E-Mail"), 255));
                application.setAddress(firstText(row, columns, "İkamet Adresi 2", "İkamet Adresi"));
                application.setPhone(truncate(normalizePhone(firstText(row, columns, "Cep Tel 2", "Cep Tel", "Telefon", "Cep Telefonu")), 30));
                application.setFatherStatus(truncate(firstText(row, columns, "Baba Sağ/Vefat"), 20));
                application.setFatherName(truncate(fatherName(firstText(row, columns, "Baba Sağ-Vefat")), 255));
                application.setFatherJob(truncate(firstText(row, columns, "Baba Meslek"), 255));
                application.setMotherStatus(truncate(firstText(row, columns, "Anne Sağ/Vefat"), 20));
                application.setMotherJob(truncate(firstText(row, columns, "Anne Meslek"), 255));
                application.setFamilyMonthlyIncome(decimalOrNull(firstText(row, columns, "Aile Aylık Net Geliri")));
                application.setSiblingCount(intOrNull(firstText(row, columns, "Kardeş Sayısı")));
                application.setStudyingSiblingCount(intOrNull(firstText(row, columns, "Okuyan Kardeş Sayısı")));
                application.setUniversity(truncate(firstText(row, columns, "Üniversite"), 255));
                application.setFaculty(truncate(firstText(row, columns, "Fakülte"), 255));
                application.setDepartment(truncate(firstText(row, columns, "Bölüm"), 255));
                application.setClassYear(truncate(classYear(firstText(row, columns, "Sınıf")), 20));
                application.setGpa(gpaOrNull(firstText(row, columns, "Genel Not Ortalaması")));
                application.setHighSchool(highSchool(firstText(row, columns, "Mezun Olunan Lise")));
                application.setReferenceName(truncate(firstText(row, columns, "Adı Soyadı"), 255));
                application.setReferenceOrganization(truncate(firstText(row, columns, "Çalıştığı Kurum"), 255));
                application.setReferencePhone(truncate(normalizePhone(firstText(row, columns, "Cep Tel 3")), 30));
                application.setAssociations(firstText(row, columns, "Üye Olduğu Dernek(ler) veya Vakıf(lar)"));
                application.setInterests(firstText(row, columns, "İlgi Alanları"));
                application.setLanguages(firstText(row, columns, "Yabancı Diller"));
                application.setConsentAccuracy(hasConsent(row, columns, "Onay"));
                application.setConsentTerms(hasConsent(row, columns, "Onay 2"));
                application.setConsentRejection(hasConsent(row, columns, "Onay 3"));
                application.setConsentKvkk(hasConsent(row, columns, "Onay 4"));
                application.setImportSource("google-form-2627");

                if (application.getFullName() == null) {
                    errors.add("Satır " + excelRow + ": Ad-soyad zorunlu.");
                    continue;
                }

                applicationRepository.save(application);
                InterviewPrescreen.applyIncomeSkipNote(
                        application,
                        InterviewPrescreen.incomeMax(season, 100000)
                );
                storeDriveLink(application, ApplicationDocumentType.PHOTO, firstUrl(row, columns, "Fotograf 2", "Fotograf"));
                storeDriveLink(application, ApplicationDocumentType.ID_COPY, firstUrl(row, columns, "Kimlik Fotokopisi 2", "Kimlik Fotokopisi"));
                storeDriveLink(application, ApplicationDocumentType.FATHER_SALARY, firstUrl(row, columns, "Baba Maaş"));
                storeDriveLink(application, ApplicationDocumentType.MOTHER_SALARY, firstUrl(row, columns, "Anne Maaş"));
                storeDriveLink(application, ApplicationDocumentType.SIBLING_STUDENT, firstUrl(row, columns, "Okuyan Kardeşlerin Öğrenci Belgesi"));
                storeDriveLink(application, ApplicationDocumentType.STUDENT_CERT, firstUrl(row, columns, "Öğrenci Belgesi"));
                storeDriveLink(application, ApplicationDocumentType.TRANSCRIPT, firstUrl(row, columns, "Genel Not Ortalaması 2"));
                created++;
            }
        } catch (ResponseStatusException exception) {
            throw exception;
        } catch (Exception exception) {
            throw new IllegalStateException("Başvuru Excel dosyası okunamadı: " + exception.getMessage(), exception);
        }

        return new ScholarImportResult(created, 0, skipped, errors);
    }

    private void storeDriveLink(Application application, ApplicationDocumentType type, String url) {
        if (url == null) {
            return;
        }
        ApplicationDocument document = new ApplicationDocument();
        document.setApplication(application);
        document.setDocumentType(type);
        document.setExternalUrl(url);
        document.setFileName(type.name().toLowerCase() + "-link");
        documentRepository.save(document);
    }

    private Map<String, Integer> headerIndex(Row headerRow) {
        Map<String, Integer> columns = new HashMap<>();
        short last = headerRow.getLastCellNum();
        for (int i = 0; i < last; i++) {
            String name = excelService.readCell(headerRow, i);
            if (!name.isBlank()) {
                columns.putIfAbsent(name, i);
            }
        }
        return columns;
    }

    private String firstText(Row row, Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(name);
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

    private Instant firstInstant(Row row, Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(name);
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
        if (value != null && value.startsWith("http")) {
            return value;
        }
        return null;
    }

    private int column(Map<String, Integer> columns, String... names) {
        for (String name : names) {
            Integer index = columns.get(name);
            if (index != null) {
                return index;
            }
        }
        return -1;
    }

    private boolean hasConsent(Row row, Map<String, Integer> columns, String name) {
        String value = firstText(row, columns, name);
        return value != null && !value.isBlank();
    }

    private boolean isBlankRow(Row row, int columnCount) {
        for (int i = 0; i < Math.max(columnCount, 1); i++) {
            if (!excelService.readCell(row, i).isBlank()) {
                return false;
            }
        }
        return true;
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

    private static String normalizePhone(String value) {
        if (value == null) {
            return null;
        }
        String digits = DIGITS.matcher(value).replaceAll("");
        if (digits.isEmpty()) {
            return null;
        }
        return digits;
    }

    private static String fatherName(String value) {
        if (value == null) {
            return null;
        }
        String compact = value.trim().toLowerCase()
                .replace("ğ", "g")
                .replace("ı", "i");
        if (compact.equals("sag") || compact.equals("vefat") || compact.equals("sağ")) {
            return null;
        }
        return value.trim();
    }

    private static String classYear(String value) {
        if (value == null) {
            return null;
        }
        try {
            double number = Double.parseDouble(value.replace(",", "."));
            if (number == Math.rint(number)) {
                return String.valueOf((int) number);
            }
        } catch (NumberFormatException ignored) {
            // keep original
        }
        return value;
    }

    private static String highSchool(String value) {
        if (value == null) {
            return null;
        }
        if (value.length() > 255) {
            return value.substring(0, 255);
        }
        return value;
    }

    private static String truncate(String value, int max) {
        if (value == null) {
            return null;
        }
        return value.length() <= max ? value : value.substring(0, max);
    }

    private static Integer intOrNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return (int) Math.round(Double.parseDouble(value.replace(",", ".")));
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private static BigDecimal decimalOrNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(value.replace(" TL", "").replace(",", ".").trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private static BigDecimal gpaOrNull(String value) {
        BigDecimal gpa = decimalOrNull(value);
        if (gpa == null) {
            return null;
        }
        if (gpa.compareTo(new BigDecimal("99.99")) > 0) {
            return null;
        }
        return gpa;
    }
}
