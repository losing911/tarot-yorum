# tarot-yorum.fun

Basit bir Python kütüphanesi ve CLI ile günlük tarot yorumu üretimi.

## Hızlı Başlangıç
- Geliştirme bağımlılıkları: pytest
- Çalıştırma: CLI ile rastgele yerine deterministik bir günlük mesaj üretir (tohum olarak tarih kullanılır).

## Geliştirme
- Testleri çalıştır: `pytest`
- CLI: `python -m tarot_yorum.cli --date 2025-09-11`

## API
- Çalıştır (lokal): `python -m uvicorn tarot_yorum.api:app --reload --port 8000`
- Swagger: http://localhost:8000/docs
- Endpoint: `GET /api/daily?date=YYYY-MM-DD`

## Docker
```
docker build -t tarot-yorum:0.1.0 .
docker run --rm -p 8000:8000 tarot-yorum:0.1.0
```
Tarayıcı: http://localhost:8000/api/daily?date=2025-09-11

## Sözleşme
OpenAPI dokümanı: `specs/003-gunluk-tarot-yorumu/contracts/openapi.yaml`

## Lisans
MIT