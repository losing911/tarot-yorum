# Feature Specification: Modern Mobil-Hazır Tarot & Astroloji Platformu

**Feature Branch**: `002-modern-mobil-haz`  
**Created**: 11 Eylül 2025  
**Status**: Draft  
**Input**: User description: "Proje: Modern Mobil-Hazır Tarot & Astroloji Platformu (Fullstack Anahtar Teslim)One-liner:Mobil-öncelikli, ileride native/hybrid mobil uygulamaya dönüştürülebilecek; tarot, fal ve astroloji okumalarını yapay zeka (OpenAI + Google Gemini; ElevenLabs opsiyonel TTS) ile üreten, üyelik tabanlı (ücretsiz/ücretli) bir platform. Admin paneli her AI sağlayıcı için aylık token ve maliyet raporlaması gösterecek. Sistem eksiksiz, production-ready **anahtar teslim** olarak çalışır şekilde teslim edilecek.Teslim Edilecekler (Anahtar Teslim Paketi):1. Tamamlanmış **fullstack repo**: frontend (Next.js/React, TS), backend (NestJS veya FastAPI), infra dizinleri.2. **Çalışır CI/CD**: GitHub Actions pipeline (lint/test/build, staging deploy, production deploy).3. **Containerization**: Dockerfile’lar, docker-compose (dev) + Kubernetes manifests (prod).4. **Veritabanı altyapısı**: PostgreSQL + Redis. Migration & seed scriptleri hazır, çalıştırıldığında db otomatik kurulur.5. **AI entegrasyonları**: OpenAI, Gemini, ElevenLabs. Token/maliyet logging aktif. Fallback & orchestrator çalışır halde.6. **Ödeme sistemleri**: İyzico veya PayTR tam entegre (sandbox & prod modları).7. **Admin panel**: kullanıcı yönetimi, üyelik planları, ödemeler, sistem ayarları, **AI Cost Dashboard (aylık token & maliyet raporu, provider bazlı breakdown, alert)**.8. **Monitoring**: Sentry, Prometheus/Grafana dashboard & alerting entegre.9. **Test suite**: Unit + integration + e2e smoke testler. CI içinde otomatik çalışır.10. **Hazır dokümantasyon**: README, deploy.md, admin-guide.md, prompt-guidelines.md, runbook.  11. **Demo environment**: demo kullanıcı hesapları + test payment sandbox credentials ile çalışan örnek.12. **PWA yapılandırma**: mobil uyumlu, offline cache destekli.13. **Security**: TLS, JWT auth, şifreleme, OWASP temel kontrolleri uygulanmış.Kabul Kriterleri (Acceptance Criteria):- Sistem repo’dan indirildiğinde `docker-compose up` veya `kubectl apply` ile ayağa kalkar ve **çalışır**.- Kullanıcı kayıt/giriş, e-posta doğrulama, parola reset çalışır.- Ücretli ve ücretsiz planlar eksiksiz işler. Ödeme sandbox testleri başarılıdır.- Tarot ve astroloji okumaları OpenAI/Gemini’den alınır, loglanır, admin panelde token & maliyet raporları görünür.- ElevenLabs entegrasyonu ile sesli çıktı alınabilir (plan bazlı erişim).- Admin paneli tüm fonksiyonları içerir (kullanıcı, ödeme, rapor, API key yönetimi, AI cost dashboard).- Monitoring paneli (Grafana) AI çağrı metriklerini, maliyet trendlerini gösterir.- CI pipeline tam geçer, staging’e otomatik deploy olur.- Dokümantasyon eksiksizdir; kurulumu bilen biri, dokümana bakarak sistemi çalıştırabilir.Zaman Planı / Yol Haritası:- MVP Teslim (6–10 hafta): Auth, tarot AI akışı, ödeme sandbox, admin kullanıcı/transaction view, CI pipeline.- Full Release (10–18 hafta): Astroloji raporları, abonelik, ElevenLabs TTS pipeline, AI cost dashboard.- Production Ready (18–24 hafta): PWA optimizasyon, prod deploy, gelişmiş monitoring, multi-model orchestration, localization.Anahtar Not:- Proje sonunda sistem **tam çalışır, production’a hazır, eksiksiz fonksiyonel bir ürün** olarak teslim edilecek.  - Repo ve tüm bileşenler kurulduktan sonra **ekstra geliştirme olmadan kullanıcıya açılabilir durumda** olacak."

## Execution Flow (main)
```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, data, constraints
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements
   → Each requirement must be testable
   → Mark ambiguous requirements
6. Identify Key Entities (if data involved)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
8. Return: SUCCESS (spec ready for planning)
```

---

## ⚡ Quick Guidelines
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
- 👥 Written for business stakeholders, not developers

### Section Requirements
- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant to the feature
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question] for any assumption you'd need to make
2. **Don't guess**: If the prompt doesn't specify something (e.g., "login system" without auth method), mark it
3. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item
4. **Common underspecified areas**:
   - User types and permissions
   - Data retention/deletion policies  
   - Performance targets and scale
   - Error handling behaviors
   - Integration requirements
   - Security/compliance needs

---

## User Scenarios & Testing *(mandatory)*

### Primary User Story
As a user, I want to sign up for the platform, choose a subscription plan (free or paid), and receive AI-generated tarot and astrology readings. As an administrator, I want to manage users, subscription plans, view payments, and monitor the costs associated with the AI providers.

### Acceptance Scenarios
1. **Given** a new user, **When** they register with their email and password and verify their email, **Then** they should be able to log into the platform.
2. **Given** a logged-in user on a free plan, **When** they request a tarot reading, **Then** the system provides a reading generated by an AI model.
3. **Given** a user on a free plan, **When** they select and pay for a premium subscription, **Then** their account is upgraded, and they can access premium features like audio readings.
4. **Given** an administrator, **When** they log in and navigate to the AI Cost Dashboard, **Then** they can view a breakdown of token usage and costs per AI provider (OpenAI, Gemini) for the current month.
5. **Given** the system is deployed, **When** a developer clones the repository and runs `docker-compose up`, **Then** the entire platform starts up and is fully functional in a local development environment.

### Edge Cases
- What happens if the primary AI provider (e.g., OpenAI) is unavailable? The system should automatically fallback to a secondary provider (e.g., Gemini).
- What happens if a user's payment fails during a subscription purchase? The user should be notified of the failure, and their plan should not be changed.
- What happens if a user tries to access a premium feature on a free plan? The user should be prompted to upgrade their plan.

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The system MUST be delivered as a complete fullstack repository including frontend (Next.js/React, TypeScript), backend (NestJS or FastAPI), and infrastructure definitions.
- **FR-002**: The system MUST include a functional CI/CD pipeline using GitHub Actions for linting, testing, building, and deploying to staging and production environments.
- **FR-003**: The application MUST be containerized using Dockerfiles, with a `docker-compose.yml` for development and Kubernetes manifests for production.
- **FR-004**: The system MUST use a PostgreSQL database for primary data and Redis for caching, with ready-to-use migration and seeding scripts.
- **FR-005**: The system MUST integrate with OpenAI and Google Gemini for generating readings, and optionally with ElevenLabs for Text-to-Speech.
- **FR-006**: All AI provider calls MUST be logged with token counts and associated costs.
- **FR-007**: The system MUST have a fallback mechanism if one AI provider fails.
- **FR-008**: The system MUST integrate with a payment provider (İyzico or PayTR) supporting both sandbox and production environments.
- **FR-009**: The system MUST feature an admin panel for user management, subscription plan configuration, payment tracking, system settings, and an AI Cost Dashboard.
- **FR-010**: The AI Cost Dashboard MUST display monthly token usage and cost reports, with a breakdown per provider and configurable alerts.
- **FR-011**: The system MUST be integrated with monitoring tools (Sentry, Prometheus/Grafana) with pre-configured dashboards and alerts.
- **FR-012**: The repository MUST include a comprehensive test suite with unit, integration, and end-to-end smoke tests that run automatically in the CI pipeline.
- **FR-013**: The project MUST be delivered with complete documentation (README, deployment guide, admin guide, prompt guidelines, runbook).
- **FR-014**: The system MUST be configured as a Progressive Web App (PWA) for mobile compatibility and offline caching.
- **FR-015**: The system MUST implement security best practices including TLS, JWT-based authentication, data encryption, and protection against common OWASP vulnerabilities.
- **FR-016**: The system MUST support user registration, login, email verification, and password reset functionalities.
- **FR-017**: The system MUST allow administrators to manage API keys for AI providers from the admin panel.

### Key Entities *(include if feature involves data)*
- **User**: Represents a customer of the platform. Attributes: ID, email, password hash, subscription plan, registration date.
- **Subscription Plan**: Defines access levels and features. Attributes: ID, name (e.g., Free, Premium), price, features (e.g., audio readings allowed).
- **Tarot Reading**: Represents a tarot reading generated for a user. Attributes: ID, user ID, question, AI-generated text, associated AI call log.
- **Astrology Report**: Represents an astrology report generated for a user. Attributes: ID, user ID, birth data, AI-generated text, associated AI call log.
- **Payment**: Records a financial transaction. Attributes: ID, user ID, amount, status (e.g., successful, failed), provider transaction ID.
- **AICallLog**: Logs each interaction with an AI provider. Attributes: ID, provider (OpenAI/Gemini), token count, calculated cost, timestamp.

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Content Quality
- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous  
- [ ] Success criteria are measurable
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

---

## Execution Status
*Updated by main() during processing*

- [ ] User description parsed
- [ ] Key concepts extracted
- [ ] Ambiguities marked
- [ ] User scenarios defined
- [ ] Requirements generated
- [ ] Entities identified
- [ ] Review checklist passed

---