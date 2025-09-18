-- Migration: 003_create_readings_table.sql
-- Created: 2025-09-18
-- Description: Create readings table for storing tarot, astrology, and compatibility readings

CREATE TABLE IF NOT EXISTS readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('tarot', 'astro', 'compatibility', 'natal_chart', 'horoscope')),
    subtype VARCHAR(50), -- e.g., 'daily', 'weekly', 'monthly' for horoscope; 'three_card', 'celtic_cross' for tarot
    input_params JSONB NOT NULL DEFAULT '{}',
    ai_model_used VARCHAR(50) NOT NULL,
    ai_provider VARCHAR(50) NOT NULL DEFAULT 'openai',
    output_text TEXT NOT NULL,
    metadata JSONB DEFAULT '{}', -- cards drawn, birth chart data, etc.
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    is_private BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_readings_user_id ON readings(user_id);
CREATE INDEX idx_readings_type ON readings(type);
CREATE INDEX idx_readings_created_at ON readings(created_at);
CREATE INDEX idx_readings_user_type ON readings(user_id, type);

-- Create updated_at trigger
CREATE TRIGGER update_readings_updated_at BEFORE UPDATE ON readings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();