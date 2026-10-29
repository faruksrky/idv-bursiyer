# IDV Bursiyer Takip Uygulaması

İstanbul Dostluk Vakfı bursiyer başvuru, değerlendirme, aylık program katılım ve ödeme takip sistemi.

Detaylı gereksinimler: [PROJE.md](./PROJE.md)

## Proje yapısı

```
backend/              Spring Boot 4 API + Dockerfile
frontend/             React + TypeScript + Dockerfile
docker/               docker-compose, .env, Docker dokümantasyonu
docker-compose.yml    Kökten stack başlatma (docker/ include)
PROJE.md              Gereksinim dokümanı
```

## Docker ile çalıştır (önerilen)

```bash
cd docker
cp .env.example .env
docker compose up -d --build
```

| Servis | Adres |
|--------|-------|
| **Uygulama** | http://localhost:3000 |
| **API** | http://localhost:8081/api/health |
| **Keycloak Admin** | http://localhost:8082/admin |
| **PostgreSQL** | localhost:5434 |

Keycloak realm: `idv-bursiyer` — demo kullanıcılar ve roller için [docker/README.md](./docker/README.md)

Detaylar: [docker/README.md](./docker/README.md)

## Yerel geliştirme (IDE)

### 1. Veritabanı (Docker)

```bash
cd docker
docker compose -f docker-compose.db.yml up -d
```

Port **5434** — `application.yml` içinde `jdbc:postgresql://localhost:5434/idv_bursiyer`

Alternatif: mevcut `idv-postgres` konteyneri (port 5432) de kullanılabilir.

### 2. Backend

```bash
cd backend
./mvnw spring-boot:run
```

API: http://localhost:8081/api/health

### 3. Frontend

```bash
cd frontend
npm install
npm run dev
```

Uygulama: http://localhost:5173

## MVP iskeletinde neler var?

- Flyway ile temel tablolar (bursiyer, program, katılım, ödeme)
- Demo bursiyer kayıtları
- Bursiyer listesi API + ekranı
- Aylık program katılım girişi (katıldı/katılmadı + mazeret kabul/red/yok)
- Muhasebe IBAN export listesi (ödemeye hak kazananlar)

## Sonraki adımlar

- JWT kimlik doğrulama ve rol bazlı yetki
- Başvuru formu + belge yükleme
- Komite mülakat puanlama ekranı
- Excel import (mevcut bursiyerler)
