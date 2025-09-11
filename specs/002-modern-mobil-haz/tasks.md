# Tasks: Modern Mobil-Hazır Tarot & Astroloji Platformu

**Input**: Design documents from `/specs/002-modern-mobil-haz/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Web app**: `backend/src/`, `frontend/src/`
- Paths shown below are adjusted for the web app structure.

## Phase 3.1: Setup
- [ ] T001 Create `backend` and `frontend` directories at the repository root.
- [ ] T002 Initialize a NestJS project in the `backend` directory.
- [ ] T003 Initialize a Next.js project in the `frontend` directory.
- [ ] T004 [P] Configure linting and formatting (ESLint, Prettier) for the `backend` project.
- [ ] T005 [P] Configure linting and formatting (ESLint, Prettier) for the `frontend` project.
- [ ] T006 [P] Create a `docker-compose.yml` file at the root to manage `backend`, `frontend`, `postgres`, and `redis` services.

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T007 [P] Create a contract test for the `POST /auth/register` endpoint in `backend/tests/contract/auth.register.test.ts`.
- [ ] T008 [P] Create a contract test for the `POST /auth/login` endpoint in `backend/tests/contract/auth.login.test.ts`.
- [ ] T009 [P] Create an integration test for the complete user registration and login flow in `backend/tests/integration/auth.flow.test.ts`.

## Phase 3.3: Core Implementation (Backend)
- [ ] T010 [P] Create the `User` entity based on `data-model.md` in `backend/src/models/user.entity.ts`.
- [ ] T011 [P] Create the `SubscriptionPlan` entity in `backend/src/models/subscription-plan.entity.ts`.
- [ ] T012 [P] Create the `TarotReading` entity in `backend/src/models/tarot-reading.entity.ts`.
- [ ] T013 [P] Create the `AstrologyReport` entity in `backend/src/models/astrology-report.entity.ts`.
- [ ] T014 [P] Create the `Payment` entity in `backend/src/models/payment.entity.ts`.
- [ ] T015 [P] Create the `AICallLog` entity in `backend/src/models/ai-call-log.entity.ts`.
- [ ] T016 Create the `AuthService` with placeholder methods for registration and login in `backend/src/services/auth.service.ts`.
- [ ] T017 Implement the `POST /auth/register` endpoint in `backend/src/controllers/auth.controller.ts` to call the `AuthService`.
- [ ] T018 Implement the `POST /auth/login` endpoint in `backend/src/controllers/auth.controller.ts` to call the `AuthService`.

## Phase 3.4: Integration (Backend)
- [ ] T019 Configure TypeORM and connect the `AuthService` to the PostgreSQL database.
- [ ] T020 Implement JWT generation in the `AuthService` and return it on successful login.
- [ ] T021 Create a JWT-based authentication middleware/guard to protect routes.
- [ ] T022 Create a request/response logging middleware.

## Phase 3.5: Core Implementation (Frontend)
- [ ] T023 [P] Create a registration page component in `frontend/src/pages/register.tsx`.
- [ ] T024 [P] Create a login page component in `frontend/src/pages/login.tsx`.
- [ ] T025 [P] Create an API service/client to communicate with the backend authentication endpoints in `frontend/src/services/api.ts`.
- [ ] T026 Implement the registration form UI and connect it to the API service.
- [ ] T027 Implement the login form UI and connect it to the API service, storing the JWT upon success.

## Phase 3.6: Polish
- [ ] T028 [P] Write unit tests for the `AuthService` in `backend/tests/unit/auth.service.test.ts`.
- [ ] T029 [P] Write unit tests for the frontend registration and login components.
- [ ] T030 [P] Update the main `README.md` with detailed setup, run, and test instructions from `quickstart.md`.

## Phase 3.7: CI/CD Pipeline
- [ ] T031 Create a GitHub Actions workflow file in `.github/workflows/ci.yml`.
- [ ] T032 Configure the CI workflow to run linting, testing, and building for both `backend` and `frontend` on every push.
- [ ] T033 Add a job to the CI workflow to build and push Docker images to a container registry.
- [ ] T034 Configure a deployment job for a staging environment, triggered on merges to the `main` branch.

## Phase 3.8: Tarot AI Flow (Backend)
- [ ] T035 [P] Create a new API contract for tarot readings in `specs/002-modern-mobil-haz/contracts/tarot.openapi.yaml`.
- [ ] T036 [P] Create a contract test for the `POST /tarot-readings` endpoint in `backend/tests/contract/tarot.reading.test.ts`.
- [ ] T037 Create a `TarotService` in `backend/src/services/tarot.service.ts`.
- [ ] T038 Integrate `TarotService` with an AI provider (e.g., OpenAI) to generate the reading.
- [ ] T039 Implement the `POST /tarot-readings` endpoint in `backend/src/controllers/tarot.controller.ts`.
- [ ] T040 Ensure that the AI call is logged to the `AICallLog` entity.

## Phase 3.9: Tarot AI Flow (Frontend)
- [ ] T041 Create a page for tarot readings in `frontend/src/pages/tarot.tsx`.
- [ ] T042 Implement a form to enter a question for the tarot reading.
- [ ] T043 Connect the form to the backend API to request a reading and display the result.

## Phase 3.10: Payments (Sandbox - Backend)
- [ ] T044 [P] Create a new API contract for payments in `specs/002-modern-mobil-haz/contracts/payment.openapi.yaml`.
- [ ] T045 [P] Create a contract test for the payment endpoint in `backend/tests/contract/payment.test.ts`.
- [ ] T046 Create a `PaymentService` in `backend/src/services/payment.service.ts`.
- [ ] T047 Integrate the `PaymentService` with a payment provider's sandbox (e.g., İyzico or PayTR).
- [ ] T048 Implement an endpoint to create a checkout session.
- [ ] T049 Implement a webhook endpoint to handle payment success and failure events.

## Phase 3.11: Payments (Sandbox - Frontend)
- [ ] T050 Create a subscription/pricing page in `frontend/src/pages/pricing.tsx`.
- [ ] T051 Implement buttons to initiate the payment process for different subscription plans.
- [ ] T052 Integrate with the payment provider's frontend library/redirect mechanism.

## Phase 3.12: Admin Panel (MVP)
- [ ] T053 [P] Create a protected route/layout for the admin panel in the frontend.
- [ ] T054 [P] Create a new API contract for the admin panel in `specs/002-modern-mobil-haz/contracts/admin.openapi.yaml`.
- [ ] T055 [P] Create contract tests for the admin endpoints.
- [ ] T056 Create an `AdminService` in `backend/src/services/admin.service.ts`.
- [ ] T057 Implement the backend endpoints to fetch users and payments.
- [ ] T058 Create a page in the frontend admin panel to display a list of users.
- [ ] T059 Create a page in the frontend admin panel to display a list of payment transactions.

## Dependencies
- **Setup (T001-T006)** must be completed before all other phases.
- **Tests (T007-T009)** must be completed and failing before **Core Implementation (T010-T018)**.
- **Backend Models (T010-T015)** can be done in parallel but must be completed before the services that use them.
- **T016 (AuthService)** blocks **T017, T018, T019, T020**.
- **Backend API (T017, T018)** must be functional before **Frontend Implementation (T025-T027)**.
- **CI/CD (T031-T034)** can be worked on in parallel after initial setup.
- **Tarot/Payment/Admin features** depend on the core Auth implementation being complete.

## Parallel Example
```
# The following setup and test tasks can be run in parallel:
Task: "[P] Configure linting and formatting for the backend..." (T004)
Task: "[P] Configure linting and formatting for the frontend..." (T005)
Task: "[P] Create a docker-compose.yml file..." (T006)
Task: "[P] Create a contract test for the POST /auth/register endpoint..." (T007)
Task: "[P] Create a contract test for the POST /auth/login endpoint..." (T008)
Task: "[P] Create an integration test for the complete user registration..." (T009)
```

## Validation Checklist
*GATE: Checked by main() before returning*

- [X] All contracts have corresponding tests
- [X] All entities have model tasks
- [X] All tests come before implementation
- [X] Parallel tasks truly independent
- [X] Each task specifies exact file path
- [X] No task modifies same file as another [P] task
