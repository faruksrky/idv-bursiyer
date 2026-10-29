#!/usr/bin/env python3
"""Generate Flyway migration V6 from 2425 application Excel."""
from __future__ import annotations

import re
import unicodedata
import zipfile
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
XLSX = ROOT.parent / "frontend/data/import/basvuru-2425-yanitlar.xlsx"
OUT = ROOT / "src/main/resources/db/migration/V6__import_2425_applications.sql"
NS = {"m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}

DOC_MAP = [
    ("PHOTO", "AN"),
    ("ID_COPY", "G"),
    ("FATHER_SALARY", "N"),
    ("MOTHER_SALARY", "Q"),
    ("SIBLING_STUDENT", "U"),
    ("STUDENT_CERT", "AA"),
    ("TRANSCRIPT", "AB"),
]


def sql_str(value: str | None) -> str:
    if value is None:
        return "NULL"
    text = str(value).strip()
    if not text:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"


def sql_num(value: str | None) -> str:
    if value is None or str(value).strip() == "":
        return "NULL"
    try:
        return str(float(value))
    except ValueError:
        return "NULL"


def sql_int(value: str | None) -> str:
    if value is None or str(value).strip() == "":
        return "NULL"
    text = str(value).strip()
    if text.lower() in {"3'ten fazla", "3ten fazla"}:
        return "4"
    try:
        return str(int(float(text)))
    except ValueError:
        return "NULL"


def excel_datetime(serial: str | None) -> str | None:
    if not serial:
        return None
    try:
        days = float(serial)
        dt = datetime(1899, 12, 30) + timedelta(days=days)
        return dt.strftime("%Y-%m-%d %H:%M:%S")
    except ValueError:
        return None


def excel_date(serial: str | None) -> str | None:
    if not serial:
        return None
    try:
        days = float(serial)
        dt = datetime(1899, 12, 30) + timedelta(days=days)
        return dt.strftime("%Y-%m-%d")
    except ValueError:
        return None


def normalize_tc(value: str | None) -> str | None:
    if not value:
        return None
    text = str(value).strip()
    if "E" in text.upper() or ("." in text and text.replace(".", "").isdigit()):
        try:
            return str(int(float(text))).zfill(11)[-11:]
        except ValueError:
            pass
    digits = re.sub(r"\D", "", text)
    return digits[:11] if digits else None


def normalize_phone(value: str | None) -> str:
    return re.sub(r"\D", "", value or "")


def normalize_name(value: str | None) -> str:
    text = unicodedata.normalize("NFKD", (value or "").casefold())
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return re.sub(r"\s+", " ", text).strip()


def split_name(full_name: str) -> tuple[str, str]:
    parts = full_name.strip().split()
    if not parts:
        return "Bilinmiyor", "Bilinmiyor"
    if len(parts) == 1:
        return parts[0], parts[0]
    return " ".join(parts[:-1]), parts[-1]


def read_workbook(path: Path):
    with zipfile.ZipFile(path) as z:
        shared: list[str] = []
        root = ET.fromstring(z.read("xl/sharedStrings.xml"))
        for si in root.findall(".//m:si", NS):
            shared.append("".join((t.text or "") for t in si.findall(".//m:t", NS)))

        def read_sheet(sheet_name: str) -> list[dict[str, str]]:
            sheet = ET.fromstring(z.read(sheet_name))
            rows = sheet.findall(".//m:sheetData/m:row", NS)
            parsed: list[dict[str, str]] = []
            for row in rows:
                row_map: dict[str, str] = {}
                for cell in row.findall("m:c", NS):
                    ref = cell.get("r", "")
                    col = "".join(ch for ch in ref if ch.isalpha())
                    value_node = cell.find("m:v", NS)
                    if value_node is None:
                        continue
                    raw = value_node.text or ""
                    if cell.get("t") == "s":
                        row_map[col] = shared[int(raw)]
                    else:
                        row_map[col] = raw
                parsed.append(row_map)
            return parsed

        return read_sheet("xl/worksheets/sheet1.xml"), read_sheet("xl/worksheets/sheet2.xml")


def main() -> None:
    apps, accepted_rows = read_workbook(XLSX)
    data_rows = apps[1:]

    accepted_index: dict[str, dict[str, str]] = {}
    for row in accepted_rows[1:]:
        name = row.get("B", "").strip()
        phone = normalize_phone(row.get("C", ""))
        key = f"{normalize_name(name)}|{phone[-10:] if len(phone) >= 10 else phone}"
        accepted_index[key] = row
        accepted_index[normalize_name(name)] = row

    lines: list[str] = [
        "-- 2024-2025 başvuruları (Excel import) + kabul edilen 37 bursiyer",
        "",
    ]

    for idx, row in enumerate(data_rows, start=1):
        tc = normalize_tc(row.get("D"))
        if not tc:
            continue

        full_name = row.get("B", "").strip()
        phone = row.get("J", "").strip()
        phone_norm = normalize_phone(phone)
        match_key = f"{normalize_name(full_name)}|{phone_norm[-10:] if len(phone_norm) >= 10 else phone_norm}"
        accepted = accepted_index.get(match_key) or accepted_index.get(normalize_name(full_name))
        status = "ACCEPTED" if accepted else "SUBMITTED"
        scholar_sql = "NULL"

        if accepted:
            iban = accepted.get("F", "").strip()
            first, last = split_name(full_name)
            lines.extend(
                [
                    f"UPDATE scholars SET iban = {sql_str(iban or None)}, phone = {sql_str(phone)}, email = {sql_str(row.get('H'))}, university = {sql_str(row.get('V'))}, faculty = {sql_str(row.get('W'))}, department = {sql_str(row.get('X'))}, class_year = {sql_str(row.get('Y'))}, active = TRUE WHERE tc_no = {sql_str(tc)};",
                    "INSERT INTO scholars (first_name, last_name, tc_no, email, phone, iban, university, faculty, department, class_year, status, scholarship_start, monthly_amount, active)",
                    f"SELECT {sql_str(first)}, {sql_str(last)}, {sql_str(tc)}, {sql_str(row.get('H'))}, {sql_str(phone)}, {sql_str(iban or None)}, {sql_str(row.get('V'))}, {sql_str(row.get('W'))}, {sql_str(row.get('X'))}, {sql_str(row.get('Y'))}, 'OGRENCI', DATE '2024-10-01', 3000, TRUE",
                    f"WHERE NOT EXISTS (SELECT 1 FROM scholars WHERE tc_no = {sql_str(tc)});",
                    "",
                ]
            )
            scholar_sql = f"(SELECT id FROM scholars WHERE tc_no = {sql_str(tc)} LIMIT 1)"

        consent = lambda col: "TRUE" if row.get(col, "").strip() else "FALSE"
        submitted = excel_datetime(row.get("A"))
        submitted_sql = f"{sql_str(submitted)}::timestamptz" if submitted else "NULL"

        lines.extend(
            [
                "INSERT INTO applications (",
                "    season_id, scholar_id, status, submitted_at, full_name, tc_no, birth_place, birth_date,",
                "    email, address, phone, father_status, father_name, father_job, mother_status, mother_job,",
                "    family_monthly_income, sibling_count, studying_sibling_count, university, faculty, department,",
                "    class_year, gpa, high_school, reference_name, reference_organization, reference_phone,",
                "    associations, interests, languages, consent_accuracy, consent_terms, consent_rejection, consent_kvkk, import_source",
                ") VALUES (",
                "    (SELECT id FROM application_seasons WHERE code = '2024-2025'),",
                f"    {scholar_sql},",
                f"    '{status}',",
                f"    {submitted_sql},",
                f"    {sql_str(full_name)}, {sql_str(tc)}, {sql_str(row.get('E'))}, {sql_str(excel_date(row.get('F')))}::date,",
                f"    {sql_str(row.get('H'))}, {sql_str(row.get('I'))}, {sql_str(phone)},",
                f"    {sql_str(row.get('K'))}, {sql_str(row.get('L'))}, {sql_str(row.get('M'))},",
                f"    {sql_str(row.get('O'))}, {sql_str(row.get('P'))},",
                f"    {sql_num(row.get('R'))}, {sql_int(row.get('S'))}, {sql_int(row.get('T'))},",
                f"    {sql_str(row.get('V'))}, {sql_str(row.get('W'))}, {sql_str(row.get('X'))},",
                f"    {sql_str(row.get('Y'))}, {sql_num(row.get('Z'))}, {sql_str(row.get('AC'))},",
                f"    {sql_str(row.get('AD'))}, {sql_str(row.get('AE'))}, {sql_str(row.get('AF'))},",
                f"    {sql_str(row.get('AG'))}, {sql_str(row.get('AH'))}, {sql_str(row.get('AI'))},",
                f"    {consent('AJ')}, {consent('AK')}, {consent('AL')}, {consent('AM')}, 'excel-2425'",
                ") ON CONFLICT (season_id, tc_no) DO NOTHING;",
                "",
            ]
        )

        for doc_type, col in DOC_MAP:
            url = row.get(col, "").strip()
            if not url or not url.startswith("http"):
                continue
            lines.extend(
                [
                    "INSERT INTO application_documents (application_id, document_type, external_url, file_name)",
                    f"VALUES (",
                    f"    (SELECT id FROM applications WHERE season_id = (SELECT id FROM application_seasons WHERE code = '2024-2025') AND tc_no = {sql_str(tc)}),",
                    f"    '{doc_type}', {sql_str(url)}, {sql_str(doc_type.lower() + '-link')}",
                    ");",
                    "",
                ]
            )

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT} ({len(data_rows)} applications)")


if __name__ == "__main__":
    main()
