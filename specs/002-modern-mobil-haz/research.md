# Research for Modern Mobil-Hazır Tarot & Astroloji Platformu

## 1. Performance Goals

**Task**: Determine performance goals for the platform.

**Questions to Answer**:
*   What is the expected p99 response time for API endpoints?
*   How many concurrent users should the system support at launch?
*   What are the performance expectations for the AI reading generation?

**Decision**: TBD
**Rationale**: TBD
**Alternatives considered**: TBD

## 2. Scale & Scope

**Task**: Define the expected scale and scope for the MVP.

**Questions to Answer**:
*   What is the target number of users for the first 6 months?
*   What is the estimated data volume (tarot readings, user data) to be stored?
*   Which features are absolutely essential for the MVP, and which can be deferred?

**Decision**: TBD
**Rationale**: TBD
**Alternatives considered**: TBD

## 3. Payment Gateway Selection

**Task**: Choose between İyzico and PayTR.

**Evaluation Criteria**:
*   API documentation clarity and ease of integration.
*   Transaction fees and pricing structure.
*   Sandbox environment quality and support.
*   Payout and settlement process.

**Decision**: TBD
**Rationale**: TBD
**Alternatives considered**: TBD

## 4. Backend Framework Selection

**Task**: Make a final decision between NestJS and FastAPI.

**Evaluation Criteria**:
*   Performance and scalability benchmarks.
*   Community and ecosystem support.
*   Developer experience and learning curve for the team.
*   Suitability for building a modular, testable application.

**Decision**: NestJS (provisional)
**Rationale**: Strong TypeScript support, modular architecture, and extensive documentation make it a good fit for a complex, long-term project.
**Alternatives considered**: FastAPI (Python-based, high performance).
