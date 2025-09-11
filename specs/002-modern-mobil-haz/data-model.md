# Data Model

This document defines the key data entities for the platform.

## 1. User

Represents a customer of the platform.

*   **id**: `UUID` (Primary Key)
*   **email**: `String` (Unique, Indexed)
*   **password_hash**: `String`
*   **subscription_plan_id**: `UUID` (Foreign Key to SubscriptionPlan)
*   **created_at**: `Timestamp`
*   **updated_at**: `Timestamp`

## 2. SubscriptionPlan

Defines access levels and features for users.

*   **id**: `UUID` (Primary Key)
*   **name**: `String` (e.g., "Free", "Premium", "Pro")
*   **price**: `Decimal`
*   **currency**: `String` (e.g., "USD", "EUR", "TRY")
*   **features**: `JSONB` (e.g., `{"audio_readings": true, "max_readings_per_day": 10}`)
*   **created_at**: `Timestamp`
*   **updated_at**: `Timestamp`

## 3. TarotReading

Represents a tarot reading generated for a user.

*   **id**: `UUID` (Primary Key)
*   **user_id**: `UUID` (Foreign Key to User)
*   **question**: `Text`
*   **reading_text**: `Text` (AI-generated response)
*   **ai_call_log_id**: `UUID` (Foreign Key to AICallLog)
*   **created_at**: `Timestamp`

## 4. AstrologyReport

Represents an astrology report generated for a user.

*   **id**: `UUID` (Primary Key)
*   **user_id**: `UUID` (Foreign Key to User)
*   **birth_date**: `Timestamp`
*   **birth_location**: `String`
*   **report_text**: `Text` (AI-generated response)
*   **ai_call_log_id**: `UUID` (Foreign Key to AICallLog)
*   **created_at**: `Timestamp`

## 5. Payment

Records a financial transaction for a subscription.

*   **id**: `UUID` (Primary Key)
*   **user_id**: `UUID` (Foreign Key to User)
*   **subscription_plan_id**: `UUID` (Foreign Key to SubscriptionPlan)
*   **amount**: `Decimal`
*   **currency**: `String`
*   **status**: `String` (e.g., "succeeded", "pending", "failed")
*   **provider**: `String` (e.g., "iyzico", "paytr")
*   **provider_transaction_id**: `String`
*   **created_at**: `Timestamp`

## 6. AICallLog

Logs each interaction with an AI provider for cost tracking.

*   **id**: `UUID` (Primary Key)
*   **provider**: `String` (e.g., "OpenAI", "Gemini", "ElevenLabs")
*   **model_name**: `String` (e.g., "gpt-4", "gemini-pro")
*   **prompt_tokens**: `Integer`
*   **completion_tokens**: `Integer`
*   **total_tokens**: `Integer`
*   **cost**: `Decimal`
*   **currency**: `String` (e.g., "USD")
*   **created_at**: `Timestamp`

## Relationships

*   A `User` has one `SubscriptionPlan`.
*   A `User` can have many `TarotReadings`, `AstrologyReports`, and `Payments`.
*   A `TarotReading` and `AstrologyReport` each have one `AICallLog`.
