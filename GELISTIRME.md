# Yerel geliştirme (IntelliJ + npm run dev)

## 1. Altyapıyı başlat (Docker)

```bash
cd docker
docker compose -f docker-compose.dev.yml up -d
```

Çalışan servisler: PostgreSQL (5434), Keycloak (8082)

## 2. Backend (IntelliJ IDEA)

1. **File → Open** → `IDV Bursiyer Takip Uygulamasi/backend` klasörünü aç (veya tüm proje kökünü)
2. Üst menüden run config: **IDV Bursiyer Backend (local)**
3. **Run** (yeşil play)

Manuel ayar gerekirse:
- Main class: `org.idv.bursiyer.IdvBursiyerTakipApplication`
- Active profiles: `local`
- Port: **8081**

## 3. Frontend

```bash
cd frontend
npm install
npm run dev
```

Uygulama: http://localhost:5173

## Giriş (Keycloak)

| Kullanıcı | Şifre |
|-----------|-------|
| admin@idv.org | 123456 |

## Durdurma

```bash
cd docker
docker compose -f docker-compose.dev.yml down
```
