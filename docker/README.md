# IDV Bursiyer Takip — Docker

## Servisler

| Servis | Konteyner | Port | Açıklama |
|--------|-----------|------|----------|
| postgres | idv-bursiyer-postgres | 5434 | Uygulama veritabanı |
| keycloak-db | idv-bursiyer-keycloak-db | — | Keycloak veritabanı |
| keycloak | idv-bursiyer-keycloak | **8082** | Kimlik doğrulama |
| backend | idv-bursiyer-backend | 8081 | Spring Boot API |
| frontend | idv-bursiyer-frontend | 3000 | React + Nginx |

> Keycloak **8082** portunda çalışır (PsikoHekim Keycloak 8080 ile çakışmaz).

## Hızlı başlangıç (tam stack)

```bash
cd docker
cp .env.example .env
docker compose up -d --build
```

| Adres | |
|-------|---|
| Uygulama | http://localhost:3000 |
| Keycloak Admin | http://localhost:8082/admin |
| API | http://localhost:8081/api/health |

## Keycloak giriş bilgileri (geliştirme)

### Admin konsolu
- Kullanıcı: `admin`
- Şifre: `admin`

### Uygulama kullanıcıları (realm: `idv-bursiyer`)
| E-posta | Rol | Şifre |
|---------|-----|-------|
| admin@idv.org | super-admin, coordinator | `123456` |
| muhasebe@idv.org | accountant | `123456` |

### Realm rolleri
`super-admin`, `committee`, `coordinator`, `accountant`, `scholar`

## Sadece Keycloak başlat

IDE'den backend/frontend çalıştırırken:

```bash
cd docker
docker compose -f docker-compose.keycloak.yml up -d
```

Backend'i Keycloak ile:

```bash
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=keycloak
```

Frontend (`.env.development` Keycloak URL içerir):

```bash
cd frontend
npm run dev
```

## Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `docker-compose.yml` | Tam stack |
| `docker-compose.db.yml` | Sadece uygulama PostgreSQL |
| `docker-compose.keycloak.yml` | Sadece Keycloak |
| `keycloak/idv-bursiyer-realm.json` | Realm import (roller, client, demo kullanıcılar) |

## Komutlar

```bash
docker compose up -d --build
docker compose logs -f keycloak
docker compose down
docker compose down -v   # volume'lar dahil sil
```
