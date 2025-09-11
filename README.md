# tarot-yorum.fun

Günlük tarot yorumu için API, Admin panel ve CLI içeren küçük bir FastAPI uygulaması. Deterministik kart çekimi yapar (tarih tohumu ile) ve yönetici panelinden mesaj özelleştirmesi yapılabilir. Statik marka varlıkları (`/static`) ile basit bir görsel kimlik içerir.

## Hızlı Başlangıç
- Geliştirme bağımlılıkları: pytest
- Çalıştırma: CLI ile rastgele yerine deterministik bir günlük mesaj üretir (tohum olarak tarih kullanılır).

## Geliştirme
- Sanal ortam: `.venv`
- Testleri çalıştır (PowerShell):
	```powershell
	.\.venv\Scripts\python.exe -m pytest -q
	```
- CLI örnek:
	```powershell
	.\.venv\Scripts\python.exe -m tarot_yorum.cli --date 2025-09-11
	```

## API
- Çalıştır (lokal):
	```powershell
	$env:ADMIN_PASSWORD = "admin123";
	.\.venv\Scripts\python.exe -m uvicorn tarot_yorum.api:app --reload --port 8000
	```
- Swagger: http://localhost:8000/docs
- Endpoint: `GET /api/daily?date=YYYY-MM-DD`

## Admin Panel
- Giriş sayfası: http://localhost:8000/admin/login
- Parola: `ADMIN_PASSWORD` ortam değişkeninden okunur (varsayılan: `admin123`). Başlamadan önce ayarlamanız önerilir.
- Panel: http://localhost:8000/admin (tarih seç, kartları gör, mesajı görüntüle/güncelle)
- Çerez tabanlı basit oturum: `admin=1` cookie’si ile korunur.

PowerShell ile örnek başlatma:
```powershell
$env:ADMIN_PASSWORD = "admin123";
 .\.venv\Scripts\python.exe -m uvicorn tarot_yorum.api:app --host 0.0.0.0 --port 8000
```

## Docker
```
docker build -t tarot-yorum:0.1.0 .
docker run --rm -e ADMIN_PASSWORD=admin123 -p 8000:8000 tarot-yorum:0.1.0
```
Tarayıcı: http://localhost:8000/api/daily?date=2025-09-11

## Render’a Deploy

Bu repo Render App Platform ile Docker üzerinden kolayca deploy edilebilir. Kök dizindeki `render.yaml` mavi-yeşil deploy ve sağlık kontrolü için temel yapılandırmayı içerir.

1) Render’da yeni Web Service oluşturun → “Use existing Dockerfile” seçin.
2) Repo ve branch’i seçin; `render.yaml` otomatik okunacaktır.
3) Environment variables:
	- `ADMIN_PASSWORD` → Secret olarak ekleyin
	- `DATA_DIR` → `/data` (dosyalar kalıcı disk üzerinde tutulur)
4) Disk ekleyin: Name: `data`, Mount Path: `/data`, Size: `1GB` (gereksinime göre artırın)
5) Health check path: `/` (uygulama `{ status: "ok" }` döner)

Notlar:
- Uygulama 8000 portundan dinler (Dockerfile’da `EXPOSE 8000`).
- DB dosyası `DATA_DIR` (varsayılan `./data`) altında `tarot.db` olarak tutulur.
- Statik varlıklar `/static` altında servis edilir.

## Statik Varlıklar ve Tema
- Statik dosyalar: `/static` altında servis edilir (örn. `/static/logo.svg`, `/static/theme.css`).
- Şablonlar marka varlıklarını kullanır (favicon, logo, `theme.css`).

## Sözleşme
OpenAPI dokümanı: `specs/003-gunluk-tarot-yorumu/contracts/openapi.yaml`

## Lisans
MIT