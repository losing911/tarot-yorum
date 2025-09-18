import OpenAI from 'openai';
import { GoogleGenerativeAI } from '@google/generative-ai';

export interface AIServiceConfig {
  provider?: 'openai' | 'gemini';
  temperature?: number;
  maxTokens?: number;
  model?: string;
}

export interface HoroscopeRequest {
  sign: string;
  type: 'daily' | 'weekly' | 'monthly';
  date?: string;
}

export interface TarotRequest {
  spread: 'three-card' | 'celtic-cross' | 'single-card';
  question?: string;
  cards?: string[];
}

export interface NatalChartRequest {
  birthDate: string;
  birthTime: string;
  birthPlace: string;
  name?: string;
}

export interface CompatibilityRequest {
  person1: {
    sign: string;
    birthDate?: string;
  };
  person2: {
    sign: string;
    birthDate?: string;
  };
}

class AIService {
  private openai: OpenAI | null = null;
  private gemini: GoogleGenerativeAI | null = null;

  constructor() {
    // Initialize OpenAI if API key is provided
    if (process.env.OPENAI_API_KEY) {
      this.openai = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY,
      });
    }

    // Initialize Gemini if API key is provided
    if (process.env.GEMINI_API_KEY) {
      this.gemini = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
    }
  }

  private getProvider(): 'openai' | 'gemini' {
    const provider = process.env.AI_PROVIDER as 'openai' | 'gemini';
    
    if (provider === 'openai' && this.openai) return 'openai';
    if (provider === 'gemini' && this.gemini) return 'gemini';
    
    // Fallback logic
    if (this.openai) return 'openai';
    if (this.gemini) return 'gemini';
    
    throw new Error('No AI provider configured. Please set OPENAI_API_KEY or GEMINI_API_KEY.');
  }

  private async generateWithOpenAI(prompt: string, config: AIServiceConfig): Promise<string> {
    if (!this.openai) {
      throw new Error('OpenAI not configured');
    }

    const response = await this.openai.chat.completions.create({
      model: config.model || 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: prompt }],
      temperature: config.temperature || 0.7,
      max_tokens: config.maxTokens || 1000,
    });

    return response.choices[0]?.message?.content || '';
  }

  private async generateWithGemini(prompt: string, config: AIServiceConfig): Promise<string> {
    if (!this.gemini) {
      throw new Error('Gemini not configured');
    }

    const model = this.gemini.getGenerativeModel({ 
      model: config.model || 'gemini-pro',
      generationConfig: {
        temperature: config.temperature || 0.7,
        maxOutputTokens: config.maxTokens || 1000,
      }
    });

    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text();
  }

  private async generateContent(prompt: string, config: AIServiceConfig = {}): Promise<string> {
    const provider = config.provider || this.getProvider();

    try {
      if (provider === 'openai') {
        return await this.generateWithOpenAI(prompt, config);
      } else if (provider === 'gemini') {
        return await this.generateWithGemini(prompt, config);
      }
    } catch (error) {
      console.error(`AI generation failed with ${provider}:`, error);
      throw new Error(`AI service error: ${error}`);
    }

    throw new Error('Unknown AI provider');
  }

  async generateHoroscope(request: HoroscopeRequest, config?: AIServiceConfig): Promise<string> {
    const { sign, type, date } = request;
    const dateStr = date || new Date().toISOString().split('T')[0];

    const prompt = `Generate a ${type} horoscope for ${sign} for ${dateStr}.

Format the response as follows:
- Title: Engaging title (max 50 characters)
- Overview: Brief general overview (30-40 words)
- Love & Relationships: Insights about romantic life (30-40 words)
- Career & Finance: Professional and financial guidance (30-40 words)
- Health & Wellness: Health and wellness advice (20-30 words)
- Lucky Elements: Lucky numbers, colors, or elements (1-2 items)
- Daily Tip: One actionable piece of advice (max 25 words)

Keep the tone mystical yet practical, optimistic but realistic. Total word count should not exceed 180 words.`;

    return await this.generateContent(prompt, config);
  }

  async generateTarotReading(request: TarotRequest, config?: AIServiceConfig): Promise<string> {
    const { spread, question, cards } = request;
    
    let prompt = `Generate a tarot reading with the ${spread} spread.`;
    
    if (question) {
      prompt += ` The querent's question is: "${question}"`;
    }

    if (cards && cards.length > 0) {
      prompt += ` The cards drawn are: ${cards.join(', ')}`;
    }

    prompt += `

Format the response as follows:
- Opening: Brief interpretation of the spread's energy
- Card Interpretations: Detailed meaning for each position
- Overall Message: Synthesized guidance and advice
- Action Steps: 2-3 practical recommendations

Keep the tone intuitive, supportive, and empowering. Focus on personal growth and positive outcomes.`;

    return await this.generateContent(prompt, config);
  }

  async generateNatalChart(request: NatalChartRequest, config?: AIServiceConfig): Promise<string> {
    const { birthDate, birthTime, birthPlace, name } = request;

    const prompt = `Generate a natal chart interpretation for someone born on ${birthDate} at ${birthTime} in ${birthPlace}.

Format the response as follows:
- Sun Sign: Core personality traits and life purpose
- Moon Sign: Emotional nature and inner self
- Rising Sign: How others perceive you and life approach
- Dominant Elements: Key elemental influences
- Strengths: Natural talents and abilities
- Challenges: Areas for growth and development
- Life Purpose: Overall direction and calling
- Relationships: Love and partnership patterns
- Career: Professional inclinations and success factors

Keep the tone insightful, balanced, and encouraging. Focus on self-understanding and personal growth.`;

    return await this.generateContent(prompt, config);
  }

  async generateCompatibilityAnalysis(request: CompatibilityRequest, config?: AIServiceConfig): Promise<string> {
    const { person1, person2 } = request;

    const prompt = `Analyze the compatibility between ${person1.sign} and ${person2.sign}.

Format the response as follows:
- Compatibility Score: Rate from 1-100 with brief explanation
- Strengths: What works well in this pairing (3-4 points)
- Challenges: Potential areas of conflict (2-3 points)
- Love & Romance: Romantic dynamics and attraction
- Communication: How they interact and understand each other
- Long-term Potential: Sustainability and growth prospects
- Advice: 3 practical tips for making the relationship work

Keep the tone balanced, honest, and constructive. Focus on understanding and growth rather than predictions.`;

    return await this.generateContent(prompt, config);
  }

  async generateBlogPost(topic: string, keywords: string[], config?: AIServiceConfig): Promise<{
    title: string;
    content: string;
    metaDescription: string;
    slug: string;
    tags: string[];
  }> {
    const prompt = `Write a comprehensive blog post about "${topic}" for an astrology and tarot website.

Include these keywords naturally: ${keywords.join(', ')}

Structure:
1. Engaging title (50-60 characters, SEO-optimized)
2. Introduction (150-200 words) - hook the reader
3. Main content (800-1200 words) - informative, engaging sections
4. Conclusion (100-150 words) - summary and call-to-action
5. Meta description (150-160 characters)
6. URL slug (lowercase, hyphens)
7. Relevant tags (5-8 tags)

Tone: Expert but accessible, mystical yet practical, SEO-friendly.
Include subheadings, bullet points, and actionable advice.`;

    const response = await this.generateContent(prompt, config);
    
    // Parse the response (this is a simplified version - in production, you'd want more robust parsing)
    const lines = response.split('\n');
    
    return {
      title: topic, // Extracted from response
      content: response,
      metaDescription: `Learn about ${topic} with expert insights on astrology and tarot.`,
      slug: topic.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
      tags: keywords
    };
  }

  getProviderStatus(): { provider: string; available: boolean }[] {
    return [
      {
        provider: 'openai',
        available: !!this.openai && !!process.env.OPENAI_API_KEY
      },
      {
        provider: 'gemini',
        available: !!this.gemini && !!process.env.GEMINI_API_KEY
      }
    ];
  }
}

export default new AIService();