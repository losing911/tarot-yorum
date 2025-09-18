import { Router } from 'express';
import aiService from '../services/aiService';
import { AppError } from '../middleware/errorHandler';

const router = Router();

/**
 * @route   POST /api/ai/horoscope
 * @desc    Generate daily horoscope
 * @access  Private
 */
router.post('/horoscope', async (req, res, next) => {
  try {
    const { sign, type, date } = req.body;
    
    if (!sign || !type) {
      const error: AppError = new Error('Sign and type are required');
      error.statusCode = 400;
      return next(error);
    }

    const content = await aiService.generateHoroscope({ sign, type, date });
    
    res.json({
      success: true,
      data: {
        sign,
        type,
        date: date || new Date().toISOString().split('T')[0],
        content,
        aiProvider: process.env.AI_PROVIDER || 'openai',
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/ai/tarot
 * @desc    Generate tarot reading
 * @access  Private
 */
router.post('/tarot', async (req, res, next) => {
  try {
    const { spread, question, cards } = req.body;
    
    if (!spread) {
      const error: AppError = new Error('Spread type is required');
      error.statusCode = 400;
      return next(error);
    }

    const content = await aiService.generateTarotReading({ spread, question, cards });
    
    res.json({
      success: true,
      data: {
        spread,
        question,
        cards: cards || [],
        content,
        aiProvider: process.env.AI_PROVIDER || 'openai',
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/ai/natal-chart
 * @desc    Generate natal chart analysis
 * @access  Private
 */
router.post('/natal-chart', async (req, res, next) => {
  try {
    const { birthDate, birthTime, birthPlace, name } = req.body;
    
    if (!birthDate || !birthTime || !birthPlace) {
      const error: AppError = new Error('Birth date, time, and place are required');
      error.statusCode = 400;
      return next(error);
    }

    const content = await aiService.generateNatalChart({ 
      birthDate, 
      birthTime, 
      birthPlace, 
      name 
    });
    
    res.json({
      success: true,
      data: {
        birthInfo: { birthDate, birthTime, birthPlace, name },
        content,
        aiProvider: process.env.AI_PROVIDER || 'openai',
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/ai/compatibility
 * @desc    Generate compatibility analysis
 * @access  Private
 */
router.post('/compatibility', async (req, res, next) => {
  try {
    const { person1, person2 } = req.body;
    
    if (!person1?.sign || !person2?.sign) {
      const error: AppError = new Error('Both persons\' zodiac signs are required');
      error.statusCode = 400;
      return next(error);
    }

    const content = await aiService.generateCompatibilityAnalysis({ person1, person2 });
    
    res.json({
      success: true,
      data: {
        person1,
        person2,
        content,
        aiProvider: process.env.AI_PROVIDER || 'openai',
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   POST /api/ai/blog-post
 * @desc    Generate SEO-optimized blog post
 * @access  Private (Admin)
 */
router.post('/blog-post', async (req, res, next) => {
  try {
    const { topic, keywords } = req.body;
    
    if (!topic) {
      const error: AppError = new Error('Topic is required');
      error.statusCode = 400;
      return next(error);
    }

    const blogPost = await aiService.generateBlogPost(
      topic, 
      keywords || []
    );
    
    res.json({
      success: true,
      data: {
        ...blogPost,
        aiProvider: process.env.AI_PROVIDER || 'openai',
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route   GET /api/ai/status
 * @desc    Get AI service status
 * @access  Private (Admin)
 */
router.get('/status', (req, res) => {
  const providerStatus = aiService.getProviderStatus();
  
  res.json({
    success: true,
    data: {
      currentProvider: process.env.AI_PROVIDER || 'openai',
      providers: providerStatus,
      healthCheck: 'OK'
    }
  });
});

export default router;