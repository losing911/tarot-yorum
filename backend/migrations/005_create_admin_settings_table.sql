-- Migration: 005_create_admin_settings_table.sql
-- Created: 2025-09-18
-- Description: Create admin settings table for platform configuration

CREATE TABLE IF NOT EXISTS admin_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value JSONB NOT NULL,
    category VARCHAR(50) NOT NULL DEFAULT 'general',
    description TEXT,
    is_encrypted BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_admin_settings_key ON admin_settings(setting_key);
CREATE INDEX idx_admin_settings_category ON admin_settings(category);

-- Create updated_at trigger
CREATE TRIGGER update_admin_settings_updated_at BEFORE UPDATE ON admin_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default settings
INSERT INTO admin_settings (setting_key, setting_value, category, description) VALUES
('ai_provider', '"openai"', 'ai', 'Default AI provider (openai or gemini)'),
('ai_models', '{"openai": {"default": "gpt-3.5-turbo", "premium": "gpt-4"}, "gemini": {"default": "gemini-pro"}}', 'ai', 'Available AI models configuration'),
('ai_parameters', '{"temperature": 0.7, "max_tokens": 1000}', 'ai', 'Default AI generation parameters'),
('google_ads_slots', '[]', 'ads', 'Google AdSense slot configurations'),
('seo_meta', '{"site_title": "Astrrolog - AI Powered Astrology & Tarot", "site_description": "Get personalized astrology readings and tarot card interpretations powered by AI"}', 'seo', 'Global SEO meta settings'),
('analytics_keys', '{"google_analytics": "", "google_tag_manager": ""}', 'analytics', 'Analytics tracking IDs'),
('rate_limits', '{"general": 100, "ai_requests": 10, "window_minutes": 15}', 'security', 'API rate limiting configuration'),
('features', '{"user_registration": true, "blog_system": true, "premium_features": false}', 'features', 'Platform feature toggles'),
('maintenance', '{"enabled": false, "message": "Site under maintenance", "allowed_ips": []}', 'system', 'Maintenance mode settings');

-- Create table for Google Ads slot management
CREATE TABLE IF NOT EXISTS ad_slots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slot_name VARCHAR(100) NOT NULL,
    slot_id VARCHAR(50) NOT NULL,
    page_location VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    size_config JSONB NOT NULL DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    is_responsive BOOLEAN DEFAULT true,
    targeting JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for ad slots
CREATE INDEX idx_ad_slots_name ON ad_slots(slot_name);
CREATE INDEX idx_ad_slots_location ON ad_slots(page_location);
CREATE INDEX idx_ad_slots_active ON ad_slots(is_active) WHERE is_active = true;

-- Create updated_at trigger for ad slots
CREATE TRIGGER update_ad_slots_updated_at BEFORE UPDATE ON ad_slots
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default ad slots
INSERT INTO ad_slots (slot_name, slot_id, page_location, position, size_config) VALUES
('Homepage Banner', 'homepage-banner', 'homepage', 'header', '{"desktop": [728, 90], "mobile": [320, 50]}'),
('Sidebar Rectangle', 'sidebar-rect', 'all', 'sidebar', '{"desktop": [300, 250], "mobile": [300, 250]}'),
('Article Inline', 'article-inline', 'blog', 'content', '{"desktop": [728, 90], "mobile": [320, 100]}'),
('Footer Banner', 'footer-banner', 'all', 'footer', '{"desktop": [728, 90], "mobile": [320, 50]}'),
('Reading Result', 'reading-result', 'readings', 'after_content', '{"desktop": [300, 250], "mobile": [300, 250]}');