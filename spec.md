# Proje Spec — Astroloji & Tarot Web Platformu (AI Destekli)

## Genel
Mobil uyumlu web sitesi. Özellikler:
- Burç yorumları (günlük/haftalık/aylık)
- Natal harita (doğum bilgisine göre)
- Burç uyumu analizi
- Tarot açılımları (3 kart, kelt haçı vs.)
- Blog (SEO uyumlu, AI destekli)
- Kullanıcı profili (blog + fal geçmişi sadece kendine açık)
- Google Ads gelir modeli (slot yönetimi)
- Admin panel (tam içerik, model, reklam kontrolü)
- AI: OpenAI + Gemini (admin panelden seçilebilir)

## Teknik
- **Frontend**: Next.js (React, Tailwind CSS), mobil öncelikli, SEO uyumlu
- **Backend**: Node.js (NestJS/Express) + REST/GraphQL API
- **DB**: PostgreSQL (users, readings, blogs), Redis (cache)
- **Auth**: JWT, refresh token, sosyal login opsiyonel
- **Deployment**: Vercel (frontend) + Dockerized backend (AWS/GCP)
- **Ads/Analytics**: Google AdSense, Google Analytics 4, Tag Manager

## Veri Modeli (özet)
- `User`: id, email, password_hash, display_name, birth_date, birth_time, birth_place, privacy_settings, role
- `Profile`: user_id, bio, avatar_url
- `Reading`: id, user_id, type (tarot/astro/uyum), input_params, ai_model_used, output_text, created_at
- `BlogPost`: id, user_id, title, slug, content, tags, meta_description, created_at
- `AdminSettings`: ad_slots, ai_defaults, analytics_keys, seo_meta

## Admin Panel Özellikleri
- İçerik CRUD (blog, burç yorumu, tarot şablonları)
- AI model yönetimi (OpenAI/Gemini seçimi, API keys, temperature, max_tokens)
- Reklam alanları yönetimi (aktif/pasif, konum)
- SEO/meta ayarları
- Analytics entegrasyonu
- Kullanıcı yönetimi (ban/sil)

## Güvenlik
- KVKK uyumluluk, GDPR consent
- Kullanıcı fal geçmişi private
- API anahtarları şifreli saklanır
- Rate limit (Redis)

## Prompt Şablonları
- **Günlük Burç**: kısa başlık + özet/ipucu/enerji bölümleri, max 180 kelime
- **Natal Harita**: güçlü yanlar / zorluklar / kariyer / aşk & ilişkiler / günlük tavsiye
- **Uyum Analizi**: quick score (0-100) + strengths/challenges/advice
- **Tarot 3 Kart**: geçmiş/şimdi/gelecek + yorum + 2 öneri
- **Blog**: SEO uyumlu, meta desc + slug + tags + görsel önerisi

## Gelir
- Google AdSense slotları: anasayfa, içerik üstü, sidebar, sticky footer
- Premium üyelik (Iyzico entegrasyonu, reklam kaldırma) — v2

## Yol Haritası
- MVP: kayıt, günlük burç, tarot, admin CRUD, reklam slotları
- v1: natal harita, uyum, blog, analytics
- v2: ödeme sistemi, push notification, çoklu dil

---
