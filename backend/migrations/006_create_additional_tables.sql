-- Migration: 006_create_additional_tables.sql
-- Created: 2025-09-18
-- Description: Create additional supporting tables for the platform

-- Refresh tokens table for JWT management
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT false,
    device_info JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);
CREATE INDEX idx_refresh_tokens_token_hash ON refresh_tokens(token_hash);

-- User sessions for tracking active sessions
CREATE TABLE IF NOT EXISTS user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    is_active BOOLEAN DEFAULT true,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_user_sessions_last_activity ON user_sessions(last_activity);

-- Zodiac signs reference table
CREATE TABLE IF NOT EXISTS zodiac_signs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    symbol VARCHAR(10) NOT NULL,
    element VARCHAR(20) NOT NULL,
    quality VARCHAR(20) NOT NULL,
    ruling_planet VARCHAR(50),
    date_range_start VARCHAR(20) NOT NULL,
    date_range_end VARCHAR(20) NOT NULL,
    traits TEXT[],
    compatibility_high TEXT[],
    compatibility_low TEXT[]
);

-- Insert zodiac signs data
INSERT INTO zodiac_signs (name, symbol, element, quality, ruling_planet, date_range_start, date_range_end, traits, compatibility_high, compatibility_low) VALUES
('Aries', '♈', 'Fire', 'Cardinal', 'Mars', 'March 21', 'April 19', ARRAY['Energetic', 'Confident', 'Impulsive', 'Leader'], ARRAY['Leo', 'Sagittarius', 'Gemini'], ARRAY['Cancer', 'Capricorn']),
('Taurus', '♉', 'Earth', 'Fixed', 'Venus', 'April 20', 'May 20', ARRAY['Reliable', 'Patient', 'Stubborn', 'Practical'], ARRAY['Virgo', 'Capricorn', 'Cancer'], ARRAY['Leo', 'Aquarius']),
('Gemini', '♊', 'Air', 'Mutable', 'Mercury', 'May 21', 'June 20', ARRAY['Adaptable', 'Curious', 'Inconsistent', 'Communicative'], ARRAY['Libra', 'Aquarius', 'Aries'], ARRAY['Virgo', 'Pisces']),
('Cancer', '♋', 'Water', 'Cardinal', 'Moon', 'June 21', 'July 22', ARRAY['Nurturing', 'Emotional', 'Protective', 'Intuitive'], ARRAY['Scorpio', 'Pisces', 'Taurus'], ARRAY['Aries', 'Libra']),
('Leo', '♌', 'Fire', 'Fixed', 'Sun', 'July 23', 'August 22', ARRAY['Confident', 'Generous', 'Dramatic', 'Creative'], ARRAY['Aries', 'Sagittarius', 'Gemini'], ARRAY['Taurus', 'Scorpio']),
('Virgo', '♍', 'Earth', 'Mutable', 'Mercury', 'August 23', 'September 22', ARRAY['Analytical', 'Perfectionist', 'Practical', 'Helpful'], ARRAY['Taurus', 'Capricorn', 'Cancer'], ARRAY['Gemini', 'Sagittarius']),
('Libra', '♎', 'Air', 'Cardinal', 'Venus', 'September 23', 'October 22', ARRAY['Diplomatic', 'Harmonious', 'Indecisive', 'Social'], ARRAY['Gemini', 'Aquarius', 'Leo'], ARRAY['Cancer', 'Capricorn']),
('Scorpio', '♏', 'Water', 'Fixed', 'Pluto', 'October 23', 'November 21', ARRAY['Intense', 'Mysterious', 'Passionate', 'Transformative'], ARRAY['Cancer', 'Pisces', 'Virgo'], ARRAY['Leo', 'Aquarius']),
('Sagittarius', '♐', 'Fire', 'Mutable', 'Jupiter', 'November 22', 'December 21', ARRAY['Adventurous', 'Optimistic', 'Philosophical', 'Freedom-loving'], ARRAY['Aries', 'Leo', 'Libra'], ARRAY['Virgo', 'Pisces']),
('Capricorn', '♑', 'Earth', 'Cardinal', 'Saturn', 'December 22', 'January 19', ARRAY['Ambitious', 'Disciplined', 'Conservative', 'Responsible'], ARRAY['Taurus', 'Virgo', 'Scorpio'], ARRAY['Aries', 'Libra']),
('Aquarius', '♒', 'Air', 'Fixed', 'Uranus', 'January 20', 'February 18', ARRAY['Independent', 'Innovative', 'Humanitarian', 'Eccentric'], ARRAY['Gemini', 'Libra', 'Sagittarius'], ARRAY['Taurus', 'Scorpio']),
('Pisces', '♓', 'Water', 'Mutable', 'Neptune', 'February 19', 'March 20', ARRAY['Intuitive', 'Compassionate', 'Dreamy', 'Escapist'], ARRAY['Cancer', 'Scorpio', 'Capricorn'], ARRAY['Gemini', 'Sagittarius']);

-- Tarot cards reference table
CREATE TABLE IF NOT EXISTS tarot_cards (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    suit VARCHAR(20), -- Major Arcana has no suit
    number INTEGER, -- Major Arcana: 0-21, Minor Arcana: 1-14 (11=Jack, 12=Queen, 13=King, 14=Ace)
    arcana VARCHAR(20) NOT NULL CHECK (arcana IN ('Major', 'Minor')),
    upright_meaning TEXT,
    reversed_meaning TEXT,
    keywords TEXT[],
    description TEXT,
    image_url VARCHAR(500)
);

-- Insert Major Arcana cards (simplified for demo)
INSERT INTO tarot_cards (name, arcana, number, upright_meaning, reversed_meaning, keywords) VALUES
('The Fool', 'Major', 0, 'New beginnings, innocence, spontaneity', 'Recklessness, taken advantage of, inconsideration', ARRAY['new beginnings', 'innocence', 'adventure']),
('The Magician', 'Major', 1, 'Manifestation, resourcefulness, power', 'Manipulation, poor planning, untapped talents', ARRAY['manifestation', 'power', 'skill']),
('The High Priestess', 'Major', 2, 'Intuition, sacred knowledge, divine feminine', 'Secrets, disconnected from intuition, withdrawal', ARRAY['intuition', 'mystery', 'subconscious']),
('The Empress', 'Major', 3, 'Femininity, beauty, nature, abundance', 'Creative block, dependence on others', ARRAY['abundance', 'nurturing', 'fertility']),
('The Emperor', 'Major', 4, 'Authority, establishment, structure, father figure', 'Tyranny, rigidity, coldness', ARRAY['authority', 'structure', 'control']);

-- Insert some Minor Arcana cards (example)
INSERT INTO tarot_cards (name, suit, arcana, number, upright_meaning, reversed_meaning, keywords) VALUES
('Ace of Cups', 'Cups', 'Minor', 1, 'Love, new relationships, compassion, creativity', 'Self-love, intuition, repressed emotions', ARRAY['love', 'emotions', 'spirituality']),
('Two of Cups', 'Cups', 'Minor', 2, 'Unified love, partnership, mutual attraction', 'Break-up, imbalance, lack of harmony', ARRAY['partnership', 'love', 'harmony']),
('Ace of Wands', 'Wands', 'Minor', 1, 'Inspiration, new opportunities, growth', 'Lack of energy, lack of passion, boredom', ARRAY['inspiration', 'energy', 'passion']),
('Ace of Swords', 'Swords', 'Minor', 1, 'Breakthrough, clarity, sharp mind', 'Confusion, brutality, chaos', ARRAY['clarity', 'truth', 'breakthrough']),
('Ace of Pentacles', 'Pentacles', 'Minor', 1, 'Manifestation, new financial opportunity', 'Lost opportunity, lack of planning', ARRAY['opportunity', 'prosperity', 'manifestation']);

-- Create indexes for tarot cards
CREATE INDEX idx_tarot_cards_arcana ON tarot_cards(arcana);
CREATE INDEX idx_tarot_cards_suit ON tarot_cards(suit);
CREATE INDEX idx_tarot_cards_number ON tarot_cards(number);