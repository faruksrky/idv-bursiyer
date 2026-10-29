# IDV Bursiyer Takip Uygulaması — Proje Gereksinim Dokümanı

> **Durum:** Gereksinimler büyük ölçüde netleşti — geliştirmeye hazır  
> **Son güncelleme:** 28 Temmuz 2026  
> **Konum:** `Desktop/IDV Bursiyer Takip Uygulamasi`  
> **Stack:** React (frontend) + Spring Boot (backend)

---

## 1. Proje Özeti

Kurumun bursiyer adaylarını davet ederek başvuru topladığı, başvuruları puanlayıp değerlendirdiği, kabul edilenleri bursiyer olarak kaydettiği ve aylık burs ödemelerini takip ettiği bir web uygulaması.

### Temel hedefler

- Bursiyer adaylarından standart bilgi ve belge toplamak
- Değerlendirme ekibinin soru/puan sistemiyle objektif karar vermesini sağlamak
- Aktif bursiyerlerin **aylık program katılımını** (katıldı / katılmadı / mazeret) izlemek
- Katılım durumuna göre **aylık burs ödemesi** yapılacakları belirlemek
- Mezuniyet statüsü ve bursiyer yaşam döngüsünü yönetmek

### Netleşen kararlar (Tur 1 — 28 Temmuz 2026)

| Konu | Karar |
|------|-------|
| **Ölçek** | Her yıl ~**60 yeni bursiyer**; yıllar içinde aktif bursiyer havuzu büyür (mezunlar arşivlenir) |
| **Burs tutarı** | **Sabit** — tüm bursiyerler için aynı aylık tutar |
| **Değerlendirme** | **Komite** — birden fazla değerlendirici puanlar |
| **Mevcut veri** | **Excel listesi var** — halihazırdaki bursiyerler sisteme **aktarılacak** (migrasyon) |
| **Hosting** | **Bulut (cloud)** — sunucu satın alınacak (sağlayıcı henüz seçilmedi) |

### Netleşen kararlar (Tur 2 — 28 Temmuz 2026)

| Konu | Karar |
|------|-------|
| **Başvuru formu** | Mevcut Google Form alanları **olduğu gibi** kullanılacak; ekleme/çıkarma **sonra** yapılır |
| **IBAN** | Başvuru formunda **yok**; bursiyer **kabul edildikten sonra** ayrıca istenecek |
| **Dil** | Sadece **Türkçe** |

### Netleşen kararlar (Tur 3 — 28 Temmuz 2026)

| Konu | Karar |
|------|-------|
| **Komite büyüklüğü** | **5 üye** (hedef); her üye bağımsız puanlar |
| **Puan birleştirme** | Komite puanları **ortalama** alınır |
| **OLUMLU eşiği** | Varsayılan **80 puan** (105 üzerinden); **sistem parametresi** — admin panelden değiştirilebilir |
| **Mezuniyet** | Bursiyer **Mezun** olarak işaretlenir; **bir sonraki eğitim-öğretim yılında burs verilmez** / yenilenmez |
| **Ödeme** | **Banka entegrasyonu yok** — muhasebeci manuel **ödendi / ödenmedi** girer |
| **Muhasebe listesi** | Seçilen ay için **IBAN listesi** export: ad, soyad, IBAN, tutar, ödeme durumu, ay/yıl |
| **Aylık program** | Her ay program yapılır; **katılım / mazeret** işaretlenir; ödeme buna bağlı |

### Netleşen kararlar (Tur 4 — 28 Temmuz 2026)

| Konu | Karar |
|------|-------|
| **Aylık program katılımı** | Her ay düzenlenen programa bursiyerlerin **katıldı / katılmadı** durumu işaretlenir |
| **Mazeret** | Katılmayanlar için mazeret yazılır; koordinatör **anında kabul veya red** eder (beklemede yok) |
| **Ödeme kuralı** | **Katılanlar** + **mazereti kabul edilenler** ödenir; mazereti **kabul edilmeyenler** ödenmez |
| **Mazeret reddi** | Mazereti **kabul edilmeyen** katılmayan bursiyere **burs verilmez** |
| **Mazeret kabulü** | Mazereti **kabul edilen** katılmayan bursiyere **burs verilir** |

---

## 2. Kullanıcı Rolleri

| Rol | Açıklama | Örnek yetkiler |
|-----|----------|----------------|
| **Süper Admin** | Sistem yöneticisi | Kullanıcı/rol yönetimi, sistem ayarları |
| **Değerlendirme Ekibi** | Başvuruları puanlar | Soruları yanıtlar, puan girer, karar önerir |
| **Burs Koordinatörü** | Operasyonel takip | Program katılım girişi, bursiyer listesi, raporlar, muhasebe listesi |
| **Muhasebeci** | Ödeme işaretleme | Katılıma uygun listeyi indirir; ödendi/ödenmedi girer |
| **Bursiyer / Aday** | Davet linkiyle başvuru | Form doldurma, belge yükleme, durum görüntüleme |

**Komite yapısı:** **5 kişilik komite**; her üye aynı aday için bağımsız mülakat puanlama formunu doldurur. Sistem üye puanlarının **ortalamasını** alır. Ortalama ≥ eşik puan (varsayılan **80**) ise sonuç **OLUMLU** önerilir.

---

## 3. Bursiyer Yaşam Döngüsü (Durum Makinesi)

```
Davet Gönderildi
    → Başvuru Bekleniyor
        → Başvuru Tamamlandı
            → Ön Eleme / Sıralama (form verilerine göre)
                → Mülakat Daveti (uygun adaylar)
                    → Mülakat Tamamlandı
            → Değerlendirme Bekliyor
                → Değerlendirme Devam Ediyor (komite puanlama)
                    → Kabul Edildi → Aktif Bursiyer
                    → Reddedildi
            → Eksik Belge / Bilgi (geri gönderim)
Aktif Bursiyer
    → Mezun (statü güncellenir; sonraki eğitim yılında burs yenilenmez)
    → Burs Sonlandırıldı (ihtiyaç kalmadı, disiplin, vb.)
    → Askıya Alındı (geçici)
```

### Mezun statüsü

- **Öğrenci** — halen okuyor, burs devam eder
- **Mezun** — mezuniyet tarihi kayıtlı; **bir sonraki eğitim-öğretim yılında burs verilmez**
- Mezuniyet bilgisi koordinatör veya bursiyer tarafından güncellenir (başvuru formunda sınıf bilgisi var; mezuniyet sonradan işaretlenir)
- Mezun bursiyerler arşivlenir; yeni dönem ödeme matrisine dahil edilmez

---

## 4. Modül 1 — Davet ve Başvuru

> **Kaynak:** Mevcut Google Form — [İstanbul Dostluk Vakfı 2025-2026 Burs Başvuru Formu](https://forms.gle/XjCR6VMKPsr8SiVR8)  
> Soru listesi, `Desktop/IDV BURS/IDV Burs Basvuru Formu_2526_v2.csv` dosyasından çıkarıldı (form kapalı olsa da CSV yanıtları mevcut).

### 4.1 Form açıklaması (mevcut metin)

> İstanbul Dostluk Vakfı; adayları sisteme girdikleri bu form içerisindeki bilgiler doğrultusunda **başarı ve ihtiyaç durumlarına göre sıralamaktadır**. Ön eleme sonrası yapılacak **mülakatlara** davet edilmesi uygun görülen adaylar; Vakfımız tarafından **e-posta, SMS ya da arama** yoluyla haberdar edilecektir.

### 4.2 Davet süreci

1. Koordinatör veya admin adayın **e-posta** adresine davet gönderir
2. Davet linki **tek kullanımlık / süreli token** içerir (örn. 7 gün geçerli)
3. Aday linke tıklayıp başvuru formunu doldurur
4. Bildirim kanalları: **e-posta, SMS, telefon** (mülakat daveti vb.)

### 4.3 Başvuru formu alanları (2025-2026 — mevcut form)

#### Kişisel bilgiler

| # | Alan | Tip | Zorunlu |
|---|------|-----|---------|
| 1 | Adı-Soyadı | Metin | Evet |
| 2 | T.C. Kimlik Numarası | Metin (11 hane) | Evet |
| 3 | Doğum Yeri | Metin | Evet |
| 4 | Doğum Tarihi | Tarih | Evet |
| 5 | Fotoğraf | Dosya yükleme | Evet |
| 6 | Kimlik Fotokopisi | Dosya yükleme | Evet |
| 7 | E-Mail | E-posta | Evet |
| 8 | İkamet Adresi | Uzun metin | Evet |
| 9 | Cep Tel | Telefon | Evet |

#### Aile bilgileri

| # | Alan | Tip | Zorunlu |
|---|------|-----|---------|
| 10 | Baba Sağ/Vefat | Seçim (Sağ / Vefat) | Evet |
| 11 | Baba Adı Soyadı | Metin | Sağ ise |
| 12 | Baba Meslek | Metin | Evet |
| 13 | Baba Maaş Belgesi | Dosya yükleme | Evet |
| 14 | Anne Sağ/Vefat | Seçim (Sağ / Vefat) | Evet |
| 15 | Anne Meslek | Metin | Evet |
| 16 | Anne Maaş Belgesi | Dosya yükleme | Evet |
| 17 | Aile Aylık Net Geliri | Sayı (TL) | Evet |
| 18 | Kardeş Sayısı | Sayı | Evet |
| 19 | Okuyan Kardeş Sayısı | Sayı | Evet |
| 20 | Okuyan Kardeşlerin Öğrenci Belgesi | Dosya yükleme | Okuyan kardeş varsa |

#### Eğitim bilgileri

| # | Alan | Tip | Zorunlu |
|---|------|-----|---------|
| 21 | Üniversite | Metin | Evet |
| 22 | Fakülte | Metin | Evet |
| 23 | Bölüm | Metin | Evet |
| 24 | Sınıf | Sayı / seçim | Evet |
| 25 | Genel Not Ortalaması (GNO) | Ondalık sayı | Evet |
| 26 | Öğrenci Belgesi | Dosya yükleme | Evet |
| 27 | Transkript / Not dökümü | Dosya yükleme | Evet |
| 28 | Mezun Olunan Lise | Metin | Evet |

#### Referans

| # | Alan | Tip | Zorunlu |
|---|------|-----|---------|
| 29 | Referans Adı Soyadı | Metin | Evet |
| 30 | Çalıştığı Kurum | Metin | Evet |
| 31 | Referans Cep Tel | Telefon | Evet |

#### Diğer

| # | Alan | Tip | Zorunlu |
|---|------|-----|---------|
| 32 | Üye Olduğu Dernek(ler) veya Vakıf(lar) | Metin | Hayır |
| 33 | İlgi Alanları | Uzun metin | Evet |
| 34 | Yabancı Diller | Çoklu seçim / metin | Evet |

**Formda olmayan — kabul sonrası toplanacak:**

- **IBAN / banka bilgisi** — bursiyer kabul edildikten sonra koordinatör veya aday tarafından girilir (onaylı karar)
- **İkametgâh belgesi** — ayrı alan olarak yok (adres metin olarak var); ileride eklenebilir

> Form alanları şimdilik mevcut Google Form ile **birebir**; alan ekleme/çıkarma sonraki aşamada yapılacak.

### 4.4 Yüklenecek belgeler (formdan)

| Belge | Ne zaman |
|-------|----------|
| Fotoğraf | Başvuruda |
| Kimlik fotokopisi | Başvuruda |
| Baba maaş belgesi | Başvuruda |
| Anne maaş belgesi | Başvuruda |
| Okuyan kardeş(ler) öğrenci belgesi | Varsa, başvuruda |
| Öğrenci belgesi | Başvuruda |
| Transkript / not dökümü | Başvuruda |

**Kabul sonrası ek bilgi:**

| Alan | Ne zaman |
|------|----------|
| IBAN | Bursiyer kabul edildikten sonra (ödeme öncesi zorunlu) |

### 4.5 Başvuru formu davranışı

- Taslak kaydetme (yarım bırakıp devam)
- Gönderim sonrası düzenleme kapalı mı?
- Eksik belge durumunda koordinatör geri bildirim gönderebilir mi?
- Dosya formatları: PDF, JPG, PNG (Google Form ile uyumlu)

### 4.6 Kabul sonrası — IBAN toplama

1. Aday **Kabul Edildi** statüsüne geçer
2. Sistem adaya veya koordinatöre **IBAN girişi** hatırlatması gönderir
3. IBAN kaydedilmeden ilk ödeme işaretlenemez (veya uyarı verilir)
4. IBAN ekranında TR IBAN format validasyonu

---

## 5. Modül 2 — Değerlendirme ve Puanlama

> **Kaynak:** `mulakat-puanlama-2025-2026.xlsx` (Downloads'tan proje klasörüne kopyalandı)

### 5.1 Değerlendirme süreci (mevcut akış)

1. **Ön eleme:** Form verilerine göre başarı + ihtiyaç sıralaması (otomatik veya koordinatör)
2. **Mülakat daveti:** Uygun adaylar e-posta / SMS / arama ile çağrılır
3. **Mülakat puanlama:** Komite üyesi aşağıdaki kriterlere göre puan girer
4. **Puan toplamı ve sonuç:** Sistem otomatik hesaplar → **OLUMLU / OLUMSUZ**
5. **Nihai karar:** Koordinatör / admin onayı (gerekirse)
6. **Bildirim:** Kabul / red

### 5.2 Mülakat puanlama formu (2025-2026 — mevcut Excel)

Her mülakat kaydı için üst bilgiler:

| Alan | Açıklama |
|------|----------|
| Gün / Saat | Mülakat tarihi ve saati |
| İsim Soyisim | Aday adı |

#### Puanlama kriterleri

| # | Kriter | Maks. puan |
|---|--------|------------|
| 1 | Yetim kardeş (YETİM K.) | **5** |
| 2 | Kendisini ifade | **10** |
| 3 | Kılık kıyafet | **10** |
| 4 | Ev ve barınma durumu | **10** |
| 5 | Dini ve milli değerlere bağlılık | **30** |
| 6 | İhtiyaç durumu | **20** |
| 7 | Hobi ve yetenek | **5** |
| 8 | STK çalışması | **5** |
| 9 | Vakıfta görev alır mı? | **5** |
| 10 | Yeniliklere açık mı? | **5** |
| | **Puan toplamı** | **105** |

#### Sonuç alanı

| Alan | Değerler |
|------|----------|
| Puan Toplamı (üye) | Kriterlerin otomatik toplamı (0–105) |
| Komite ortalaması | 5 üyenin puan toplamlarının ortalaması |
| Sonuç | **OLUMLU** (ortalama ≥ eşik) / **OLUMSUZ** (ortalama < eşik) |

#### Sistem parametreleri (admin)

| Parametre | Varsayılan | Açıklama |
|-----------|------------|----------|
| `mülakat_olumlu_esik_puani` | **80** | OLUMLU için minimum komite ortalaması (105 üzerinden) |
| `komite_uye_sayisi` | **5** | Hedef komite üye sayısı |

### 5.3 Komite puanlama akışı

1. Aday mülakat kuyruğuna alınır (ön eleme sonrası)
2. **5 komite üyesi** (hedef) aynı aday için mülakat puanlama formunu doldurur
3. Sistem her üyenin **Puan Toplamı**nı hesaplar (0–105)
4. Komite puanlarının **ortalaması** alınır
5. Ortalama ≥ **eşik puan** (varsayılan 80, parametrik) → **OLUMLU**; altında → **OLUMSUZ**
6. Koordinatör / admin gerekirse nihai kararı onaylar
7. OLUMLU → bursiyer kabul sürecine; OLUMSUZ → red

> **Karar bekleyen:** Tüm 5 üye puanlamadan sonuç hesaplanmasın mı, yoksa minimum kaç üye yeterli?

---

## 6. Modül 3 — Bursiyer Yönetimi

### 6.1 Aktif bursiyer profili

Kabul edilen aday **bursiyer** statüsüne geçer. Profilde:

- Tüm başvuru bilgileri
- Değerlendirme puanı ve karar geçmişi
- Mezun statüsü: **Öğrenci** / **Mezun**
- Burs başlangıç / bitiş tarihi
- Aylık burs tutarı: **sabit** (kurum genelinde tek tutar; admin panelden güncellenebilir)
- **IBAN** (kabul sonrası girilir — ödeme için zorunlu)

### 6.3 Mevcut bursiyerlerin aktarımı (Excel migrasyonu)

Halihazırda Excel'de tutulan **mevcut bursiyer listesi** sisteme taşınacak.

- İlk kurulumda toplu **Excel/CSV import** (ad, soyad, okul, IBAN, mezun statüsü, burs başlangıç tarihi vb.)
- Import sonrası kayıtlar doğrudan **Aktif Bursiyer** statüsünde oluşturulur
- Geçmiş ödeme kayıtları varsa ayrıca import edilebilir (format Tur 2–3'te netleştirilecek)
- Mevcut Excel dosyası projeye eklendiğinde sütun yapısına göre import şablonu hazırlanır

### 6.2 Mezuniyet takibi

- Bursiyer veya koordinatör **Mezun** statüsünü işaretler (mezuniyet tarihi kaydedilir)
- Mezun olan bursiyer **o eğitim yılını** tamamlayabilir; **bir sonraki eğitim-öğretim yılında burs yenilenmez** ve ödeme matrisine dahil edilmez
- Sistem mezun bursiyerleri aktif listeden çıkarır / arşivler
- Yıllık burs yenileme döneminde mezunlar otomatik hariç tutulur

---

## 7. Modül 4 — Aylık Program ve Katılım Takibi

> **Mevcut süreç:** Her ay vakıf programı düzenlenir. Koordinatör **katılım** işaretler; katılmayanların **mazereti** yazılır ve **kabul/red** edilir. Muhasebeci yalnızca **katılanlara** ve **mazereti kabul edilenlere** ödeme yapar.

### 7.1 Aylık program kaydı

Her ay için bir **program / etkinlik** kaydı:

| Alan | Açıklama |
|------|----------|
| Yıl | 2026 |
| Ay | Programın ait olduğu burs ayı |
| Program adı | Örn. `Ekim 2026 Bursiyer Programı` |
| Tarih | Program tarihi |
| Yer | (opsiyonel) |
| Not | (opsiyonel) |

### 7.2 Katılım kaydı (bursiyer × program)

Her aktif bursiyer için o ayın programına bir satır:

| Alan | Değerler | Zorunlu |
|------|----------|---------|
| Bursiyer | FK | Evet |
| Program | FK (aylık program) | Evet |
| Katılım durumu | `KATILDI` / `KATILMADI` | Evet |
| Mazeret metni | Serbest metin | Katılmadı ise (varsa) |
| Mazeret durumu | `YOK` / `KABUL` / `RED` | Katılmadı ise — **beklemede durumu yok**, anında kabul veya red |
| Kaydeden | Koordinatör | Evet |
| Kayıt tarihi | Otomatik | |

**Koordinatör ekranı (matris veya liste):**

- Tüm aktif bursiyerler listelenir
- Her biri için: ☑ Katıldı / ☐ Katılmadı
- Katılmadı seçilirse → **Mazeret metni** + hemen **Kabul** veya **Red** (ikisi biri zorunlu, beklemede yok)
- Toplu kaydet

### 7.3 Ödeme kuralı (katılım ile bağlantı)

| Katılım | Mazeret durumu | Burs ödemesi |
|---------|----------------|--------------|
| **KATILDI** | — | **Ödenir** |
| **KATILMADI** | `YOK` (mazeret yok) | **Ödenmez** |
| **KATILMADI** | `KABUL` | **Ödenir** |
| **KATILMADI** | `RED` | **Ödenmez** |

**Özet:** IBAN / ödeme listesine girenler:
- Programa **katılanlar**
- Katılmayan ama mazereti **kabul edilenler**

**Listeye girmeyenler:** Mazereti **reddedilenler**, mazeretsiz katılmayanlar

### 7.4 Görünümler

- **Aylık katılım listesi:** Bursiyer × katılım + mazeret + mazeret durumu (kabul/red)
- **Özet:** X katıldı, Y katılmadı (Z mazeret kabul, W mazeret red)
- Geçmiş ayların katılım geçmişi bursiyer profilinde

---

## 8. Modül 5 — Aylık Burs Ödeme Takibi

> **Karar:** Banka entegrasyonu **yok**. Ödeme, **aylık program katılımına** göre belirlenir. Muhasebeci sisteme **ödendi / ödenmedi** bilgisini manuel girer.

### 8.1 Ödeme kaydı (manuel)

Her aktif bursiyer × her ay için bir kayıt. **Muhasebeci** veya **koordinatör** günceller:

| Alan | Açıklama |
|------|----------|
| Bursiyer | FK |
| Yıl | 2026 |
| Ay | 1–12 (veya eğitim yılı ayı: Eylül–Mayıs) |
| Tutar | Sabit burs tutarı (TL) |
| Durum | `ÖDENECEK` / `ÖDENDİ` / `ÖDENMEDİ` |
| Ödeme tarihi | Gerçekleşen ödeme (ödendi ise) |
| Ödenmeme nedeni | Zorunlu (durum = ÖDENMEDİ ise) — örn. program katılımı yok |
| Program katılımı | FK — ödeme hangi ay programına bağlı |
| Not | Serbest metin |
| Kaydeden | Kullanıcı (muhasebeci) |

**Akış:**

1. Koordinatör o ayın **program katılım listesini** doldurur (katıldı / katılmadı + mazeret + kabul/red)
2. Sistem ödemeye hak kazananlar için kayıt **ÖDENECEK** oluşturur:
   - **KATILDI** olanlar
   - **KATILMADI** + mazeret **KABUL** olanlar
3. Koordinatör / muhasebeci **IBAN listesini** export eder (yalnızca ödemeye hak kazananlar)
4. Muhasebeci bankada ödemeleri yapar
5. Muhasebeci sistemde **ÖDENDİ** veya **ÖDENMEDİ** (+ neden) işaretler

### 8.2 Muhasebe listesi (IBAN export)

Seçilen **ay ve yıl** için Excel/CSV indirilir. Muhasebecinin banka ödemesi yapması için:

| Sütun | Açıklama |
|-------|----------|
| Sıra | |
| Ad | |
| Soyad | |
| IBAN | TR formatında |
| Burs ayı | Örn. `Ekim 2026` |
| Tutar | Sabit aylık burs |
| Program katılımı | `KATILDI` veya mazeret `KABUL` |
| Ödeme durumu | `ÖDENECEK` / `ÖDENDİ` / `ÖDENMEDİ` |
| Ödenmeme nedeni | Varsa |
| Üniversite | (opsiyonel, kontrol için) |
| Not | |

- Listeye **katılanlar** ve **mazereti kabul edilen katılmayanlar** dahil edilir
- Mazereti **reddedilen** ve mazeretsiz katılmayanlar **listede yer almaz** — “ödenmedi raporu”nda görünür
- IBAN’ı eksik bursiyerler listede **uyarı** ile gösterilir veya hariç tutulur
- Mezun / pasif bursiyerler otomatik dahil edilmez

### 8.3 Ödenmeme nedenleri

- **Programa katılmadı — mazeret kabul edilmedi**
- **Programa katılmadı — mazeret yok**
- Belge eksik / güncellenmedi
- Not düşüklüğü / akademik uyarı
- Mezun oldu
- Bursiyer talep etmedi / ulaşılamadı
- IBAN hatası / IBAN eksik
- Kurum bütçe kısıtı
- Diğer: serbest metin

### 8.4 Görünümler ve raporlar

- **Takvim / matris görünümü:** Bursiyer satır × ay sütun — katılım + ödeme durumu
- **Ay bazlı özet:** Kaç kişi katıldı, kaçına ödeme yapıldı, toplam tutar
- **Katılmayanlar raporu:** Mazeret kabul / red ayrımı
- **Filtreler:** Mezun/öğrenci, okul, katılım, ödeme durumu
- **Excel / CSV export** — muhasebe IBAN listesi (sadece katılanlar)
- **Toplu işaretleme:** Seçilen ay için katılanların tamamını ödendi işaretle

---

## 9. Teknik Mimari

### 9.1 Genel yapı

```
┌─────────────────┐     REST API      ┌──────────────────┐
│  React SPA      │ ◄──────────────► │  Spring Boot     │
│  (Vite + TS?)   │                   │  REST + Security │
└─────────────────┘                   └────────┬─────────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │  PostgreSQL           │
                                    │  (veya MySQL?)        │
                                    └──────────┬──────────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │  Dosya depolama       │
                                    │  (S3 uyumlu — cloud)  │
                                    └───────────────────────┘
```

### 9.1.1 Hosting (cloud)

- Uygulama **bulut ortamında** çalışacak; sunucu **IDV tarafından satın alınacak**
- Sağlayıcı henüz seçilmedi (DigitalOcean, AWS, Hetzner, Turhost vb. değerlendirilebilir)
- Önerilen minimum: 1 uygulama sunucusu + yönetilen PostgreSQL + object storage (belgeler için)
- CI/CD ile deploy (GitHub Actions vb. — ileride)

### 9.2 Backend (Spring Boot)

- **Java 17+**, Spring Boot 3.x
- Spring Security + JWT (veya session?)
- Spring Data JPA
- Flyway / Liquibase — veritabanı migration
- Dosya yükleme: multipart, virüs taraması (ileride?)
- E-posta: davet, durum bildirimleri (Spring Mail / SendGrid?)

Önerilen paket yapısı:

```
com.kurum.bursiyer
├── config
├── auth
├── invitation
├── application      # başvuru
├── evaluation       # değerlendirme
├── scholar          # bursiyer
├── payment          # aylık ödeme
├── program          # aylık program & katılım
├── document         # belge yönetimi
└── notification
```

### 9.3 Frontend (React)

- **React 18+**, TypeScript önerilir
- **Dil:** Sadece Türkçe arayüz (i18n gerekmez — MVP)
- Vite build
- React Router — sayfa yönlendirme
- TanStack Query — API state
- UI kütüphanesi: **Karar bekleyen** (MUI, Ant Design, shadcn/ui?)
- Form: React Hook Form + Zod validasyon
- Tablo: ödeme matrisi için güçlü data grid

Ana sayfalar (taslak):

| Sayfa | Rol |
|-------|-----|
| Giriş / Kayıt | Tümü |
| Davet ile başvuru formu | Aday |
| Belge yükleme | Aday |
| Başvuru listesi | Koordinatör |
| Değerlendirme formu | Değerlendirici |
| Aylık program katılım girişi | Koordinatör |
| Bursiyer listesi | Koordinatör |
| Ödeme takip matrisi | Koordinatör / Muhasebeci |
| Muhasebe IBAN listesi (export) | Koordinatör / Muhasebeci |
| Ödeme girişi (ödendi/ödenmedi) | Muhasebeci |
| Raporlar | Koordinatör / Admin |
| Soru seti yönetimi | Admin |
| Kullanıcı yönetimi | Admin |

### 9.4 Veritabanı — temel tablolar (taslak)

```
users
invitations
applications
application_documents
evaluation_question_sets
evaluation_questions
evaluation_scores
scholars
scholar_status_history
monthly_programs          # aylık program kaydı
program_attendance        # bursiyer × program katılım + mazeret
monthly_payments
payment_non_payment_reasons (lookup)
audit_logs
```

---

## 10. Güvenlik ve Uyumluluk

- **KVKK:** Kişisel veri ve belgeler — açık rıza, saklama süresi, silme hakkı
- Rol bazlı erişim (RBAC)
- Hassas alanlar (TC, IBAN) şifreli veya maskelenmiş gösterim
- Dosya erişimi: imzalı URL, yetkisiz indirme engeli
- Audit log: kim, ne zaman, ne değiştirdi

**Hosting:** Bulut (cloud) — bkz. [§9.1.1](#911-hosting-cloud). Yedekleme politikası henüz tanımlanmadı.

---

## 11. MVP Kapsamı (Öneri — 1. faz)

İlk sürümde **mutlaka** olması gerekenler:

- [ ] Admin / koordinatör girişi
- [ ] E-posta daveti + aday başvuru formu
- [ ] Belge yükleme
- [ ] Komite değerlendirme formu (çoklu değerlendirici puanlama)
- [ ] Kabul / red kararı
- [ ] Bursiyer listesi + mezun statüsü
- [ ] **Mevcut Excel bursiyer listesi import**
- [ ] **Aylık program katılım girişi** (katıldı / katılmadı + mazeret + kabul/red)
- [ ] Aylık ödeme kaydı (katılıma göre ödendi / ödenmedi + neden)
- [ ] Ödeme matris görünümü
- [ ] **Muhasebe IBAN listesi export** (sadece katılanlar; ad, soyad, IBAN, ay, tutar)
- [ ] Muhasebeci rolü + manuel ödeme girişi

**2. faz (sonra):**

- [ ] Soru seti admin paneli (yıllık güncelleme)
- [ ] E-posta bildirimleri
- [ ] Excel export
- [ ] Dashboard / istatistikler
- [ ] Aday self-servis durum takibi

---

## 12. Açık Sorular — Birlikte Karar Verelim

### ✅ Tur 1 — yanıtlandı

| # | Soru | Karar |
|---|------|-------|
| 2 | Kaç bursiyer? | Her yıl ~60 yeni bursiyer |
| 3 | Burs tutarı? | Sabit |
| 4 | Değerlendirme? | Komite |
| 8 | Hosting? | Bulut — IDV satın alacak |
| 11 | Excel / migrasyon? | Evet, mevcut bursiyerler aktarılacak |

### ✅ Tur 2 — yanıtlandı (başvuru formu)

| # | Soru | Karar |
|---|------|-------|
| 5 | TC Kimlik zorunlu mu? | **Evet** — mevcut formda var |
| 5b | IBAN? | **Kabul sonrası** alınacak |
| 6 | Davet / bildirim kanalı? | **E-posta, SMS, telefon** |
| 7 | Dil? | **Sadece Türkçe** |
| 9 | Belge / alan listesi? | **Mevcut form aynen** — ekleme/çıkarma sonra |
| — | Form alanları değişecek mi? | **Şimdilik hayır** — sonra yapılır |

### ✅ Tur 3 — yanıtlandı (komite & mezuniyet)

| Konu | Karar |
|------|-------|
| Komite üye sayısı | **5** |
| Puan birleştirme | **Ortalama** |
| OLUMLU eşiği | **80** (105 üzerinden), **parametrik** |
| Mezuniyet | **Mezun** işaretlenir; **sonraki eğitim yılında burs verilmez** |
| Mülakat formu | 10 kriter, max 105 puan — `mulakat-puanlama-2025-2026.xlsx` |
| Ödeme | **Manuel** — banka entegrasyonu yok; muhasebeci ödendi/ödenmedi girer |
| Muhasebe export | Ay bazlı **IBAN listesi**: ad, soyad, IBAN, tutar, ay, ödeme durumu |

### ⏳ İsteğe bağlı / sonra netleştirilecek

| # | Soru | Durum |
|---|------|-------|
| — | 5 komite üyesinin tamamı puanlamadan sonuç çıksın mı? | Bekliyor |
| — | Geçmiş aylar düzenlenebilir mi, audit log? | Bekliyor |

---

## 13. Sonraki Adımlar

1. Bu dokümandaki açık soruları yanıtla → gereksinimleri kesinleştir
2. ER diyagramı ve API endpoint listesi yaz
3. Repo oluştur (monorepo veya ayrı frontend/backend?)
4. Spring Boot + React iskelet projelerini kur
5. MVP sprint planı (2–4 haftalık)

---

## Değişiklik Geçmişi

| Tarih | Değişiklik | Kim |
|-------|------------|-----|
| 2026-07-28 | İlk taslak oluşturuldu | — |
| 2026-07-28 | Tur 1 kararları eklendi (60/yıl, sabit burs, komite, Excel migrasyon, cloud) | — |
| 2026-07-28 | Mevcut Google Form alanları CSV'den çıkarılıp eklendi (2025-2026 formu) | — |
| 2026-07-28 | Tur 2 kararları (IBAN kabul sonrası, sadece Türkçe, form alanları aynen) | — |
| 2026-07-28 | Mülakat puanlama formu Excel'den eklendi (105 puan, OLUMLU/OLUMSUZ) | — |
| 2026-07-28 | Tur 3 kararları (5 kişi komite, ortalama, eşik 80 parametrik, mezun sonraki yıl yok) | — |
| 2026-07-28 | Ödeme modülü (manuel, muhasebeci, IBAN listesi export — banka entegrasyonu yok) | — |
| 2026-07-28 | Aylık program katılım modülü eklendi (katılım + mazeret → ödeme kuralı) | — |
| 2026-07-28 | Mazeret kabul/red kuralı netleşti (kabul edilmeyenlere burs yok) | — |
| 2026-07-28 | Mazeret beklemede durumu kaldırıldı — anında kabul/red | — |
