-- Demo mezun bursiyerler
INSERT INTO scholars (
    first_name, last_name, tc_no, email, phone, iban,
    university, faculty, department, class_year,
    status, graduation_date, scholarship_start, monthly_amount, active
)
VALUES
    (
        'Elif', 'Arslan', '12345678904', 'elif.arslan@example.com', '5554445566',
        'TR120006400519786457841329', 'Boğaziçi Üniversitesi', 'Mühendislik Fakültesi',
        'Bilgisayar Mühendisliği', 'Mezun', 'MEZUN', '2024-07-10', '2020-10-01', 3000, false
    ),
    (
        'Burak', 'Şahin', '12345678905', 'burak.sahin@example.com', '5555556677',
        'TR890006500519786457841330', 'Ankara Üniversitesi', 'Eğitim Fakültesi',
        'Sınıf Öğretmenliği', 'Mezun', 'MEZUN', '2025-06-20', '2021-10-01', 3000, false
    ),
    (
        'Selin', 'Koç', '12345678906', 'selin.koc@example.com', '5556667788',
        'TR560006600519786457841331', 'ODTÜ', 'İşletme Fakültesi',
        'İşletme', 'Mezun', 'MEZUN', '2025-07-05', '2022-10-01', 3000, true
    );
