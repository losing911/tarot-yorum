import { createClient, RedisClientType } from 'redis';

class RedisService {
  private client: RedisClientType;
  private static instance: RedisService;
  private isConnected = false;

  private constructor() {
    this.client = createClient({
      url: process.env.REDIS_URL || 'redis://localhost:6379',
      password: process.env.REDIS_PASSWORD || undefined,
    });

    this.client.on('error', (err) => {
      console.error('Redis Client Error:', err);
    });

    this.client.on('connect', () => {
      console.log('🔥 Redis connected');
      this.isConnected = true;
    });

    this.client.on('disconnect', () => {
      console.log('🔌 Redis disconnected');
      this.isConnected = false;
    });

    this.connect();
  }

  public static getInstance(): RedisService {
    if (!RedisService.instance) {
      RedisService.instance = new RedisService();
    }
    return RedisService.instance;
  }

  private async connect(): Promise<void> {
    try {
      await this.client.connect();
    } catch (error) {
      console.error('Failed to connect to Redis:', error);
    }
  }

  public async get(key: string): Promise<string | null> {
    try {
      if (!this.isConnected) return null;
      return await this.client.get(key);
    } catch (error) {
      console.error('Redis GET error:', error);
      return null;
    }
  }

  public async set(key: string, value: string, expireInSeconds?: number): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      
      if (expireInSeconds) {
        await this.client.setEx(key, expireInSeconds, value);
      } else {
        await this.client.set(key, value);
      }
      return true;
    } catch (error) {
      console.error('Redis SET error:', error);
      return false;
    }
  }

  public async del(key: string): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      await this.client.del(key);
      return true;
    } catch (error) {
      console.error('Redis DEL error:', error);
      return false;
    }
  }

  public async exists(key: string): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      const result = await this.client.exists(key);
      return result === 1;
    } catch (error) {
      console.error('Redis EXISTS error:', error);
      return false;
    }
  }

  public async increment(key: string, expireInSeconds?: number): Promise<number> {
    try {
      if (!this.isConnected) return 0;
      
      const result = await this.client.incr(key);
      
      if (expireInSeconds && result === 1) {
        await this.client.expire(key, expireInSeconds);
      }
      
      return result;
    } catch (error) {
      console.error('Redis INCR error:', error);
      return 0;
    }
  }

  public async setHash(key: string, hash: Record<string, string>): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      await this.client.hSet(key, hash);
      return true;
    } catch (error) {
      console.error('Redis HSET error:', error);
      return false;
    }
  }

  public async getHash(key: string): Promise<Record<string, string> | null> {
    try {
      if (!this.isConnected) return null;
      return await this.client.hGetAll(key);
    } catch (error) {
      console.error('Redis HGETALL error:', error);
      return null;
    }
  }

  public async addToSet(key: string, value: string): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      await this.client.sAdd(key, value);
      return true;
    } catch (error) {
      console.error('Redis SADD error:', error);
      return false;
    }
  }

  public async getSet(key: string): Promise<string[]> {
    try {
      if (!this.isConnected) return [];
      return await this.client.sMembers(key);
    } catch (error) {
      console.error('Redis SMEMBERS error:', error);
      return [];
    }
  }

  public async removeFromSet(key: string, value: string): Promise<boolean> {
    try {
      if (!this.isConnected) return false;
      await this.client.sRem(key, value);
      return true;
    } catch (error) {
      console.error('Redis SREM error:', error);
      return false;
    }
  }

  // Cache helpers
  public async cacheData(key: string, data: any, expireInSeconds = 3600): Promise<void> {
    const jsonData = JSON.stringify(data);
    await this.set(key, jsonData, expireInSeconds);
  }

  public async getCachedData<T>(key: string): Promise<T | null> {
    const data = await this.get(key);
    if (!data) return null;
    
    try {
      return JSON.parse(data) as T;
    } catch {
      return null;
    }
  }

  public async flush(): Promise<void> {
    try {
      if (!this.isConnected) return;
      await this.client.flushAll();
    } catch (error) {
      console.error('Redis FLUSH error:', error);
    }
  }

  public async close(): Promise<void> {
    try {
      await this.client.quit();
      console.log('🔌 Redis connection closed');
    } catch (error) {
      console.error('Error closing Redis connection:', error);
    }
  }

  public isReady(): boolean {
    return this.isConnected;
  }
}

// Export singleton instance
export const redis = RedisService.getInstance();

// Cache key generators
export const CacheKeys = {
  user: (id: string) => `user:${id}`,
  session: (token: string) => `session:${token}`,
  reading: (id: string) => `reading:${id}`,
  blog: (slug: string) => `blog:${slug}`,
  aiResponse: (hash: string) => `ai:${hash}`,
  rateLimit: (ip: string, endpoint: string) => `rate:${ip}:${endpoint}`,
  analytics: (date: string) => `analytics:${date}`,
};