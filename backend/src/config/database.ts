import { Pool, PoolClient, QueryResult, QueryResultRow } from 'pg';

class Database {
  private pool: Pool;
  private static instance: Database;

  private constructor() {
    this.pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
      max: 20, // maximum number of clients in the pool
      idleTimeoutMillis: 30000, // how long a client is allowed to remain idle
      connectionTimeoutMillis: 2000, // how long to wait for a connection
    });

    // Handle pool errors
    this.pool.on('error', (err) => {
      console.error('Unexpected error on idle client', err);
      process.exit(-1);
    });

    // Test the connection
    this.testConnection();
  }

  public static getInstance(): Database {
    if (!Database.instance) {
      Database.instance = new Database();
    }
    return Database.instance;
  }

  private async testConnection(): Promise<void> {
    try {
      const client = await this.pool.connect();
      await client.query('SELECT NOW()');
      client.release();
      console.log('✅ Database connected successfully');
    } catch (error) {
      console.error('❌ Database connection failed:', error);
      throw error;
    }
  }

  // Execute a query
  public async query<T extends QueryResultRow = any>(text: string, params?: any[]): Promise<QueryResult<T>> {
    const start = Date.now();
    try {
      const result = await this.pool.query<T>(text, params);
      const duration = Date.now() - start;
      
      if (process.env.NODE_ENV === 'development') {
        console.log('Executed query', { text, duration, rows: result.rowCount });
      }
      
      return result;
    } catch (error) {
      console.error('Database query error:', { text, params, error });
      throw error;
    }
  }

  // Get a client from the pool for transactions
  public async getClient(): Promise<PoolClient> {
    return await this.pool.connect();
  }

  // Transaction wrapper
  public async transaction<T>(callback: (client: PoolClient) => Promise<T>): Promise<T> {
    const client = await this.getClient();
    
    try {
      await client.query('BEGIN');
      const result = await callback(client);
      await client.query('COMMIT');
      return result;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  // Close all connections
  public async close(): Promise<void> {
    await this.pool.end();
    console.log('🔌 Database connections closed');
  }

  // Health check
  public async healthCheck(): Promise<boolean> {
    try {
      const result = await this.query('SELECT 1 as health');
      return result.rows[0].health === 1;
    } catch {
      return false;
    }
  }

  // Get pool info
  public getPoolInfo() {
    return {
      totalCount: this.pool.totalCount,
      idleCount: this.pool.idleCount,
      waitingCount: this.pool.waitingCount
    };
  }
}

// Export singleton instance
export const db = Database.getInstance();

// Export types
export type { PoolClient, QueryResult, QueryResultRow };

// Helper functions for common patterns
export class QueryBuilder {
  private conditions: string[] = [];
  private values: any[] = [];
  private paramCount = 0;

  where(condition: string, value?: any): this {
    if (value !== undefined) {
      this.paramCount++;
      this.conditions.push(condition.replace('?', `$${this.paramCount}`));
      this.values.push(value);
    } else {
      this.conditions.push(condition);
    }
    return this;
  }

  whereIn(column: string, values: any[]): this {
    if (values.length === 0) return this;
    
    const placeholders = values.map(() => `$${++this.paramCount}`).join(', ');
    this.conditions.push(`${column} IN (${placeholders})`);
    this.values.push(...values);
    return this;
  }

  build(): { where: string; values: any[] } {
    return {
      where: this.conditions.length > 0 ? `WHERE ${this.conditions.join(' AND ')}` : '',
      values: this.values
    };
  }
}

// Pagination helper
export interface PaginationOptions {
  page?: number;
  limit?: number;
  orderBy?: string;
  orderDirection?: 'ASC' | 'DESC';
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}

export async function paginate<T extends QueryResultRow>(
  baseQuery: string,
  countQuery: string,
  params: any[],
  options: PaginationOptions = {}
): Promise<PaginatedResult<T>> {
  const page = Math.max(1, options.page || 1);
  const limit = Math.min(100, Math.max(1, options.limit || 10));
  const offset = (page - 1) * limit;

  // Add ordering and pagination to base query
  let query = baseQuery;
  if (options.orderBy) {
    query += ` ORDER BY ${options.orderBy} ${options.orderDirection || 'ASC'}`;
  }
  query += ` LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;

  // Execute queries
  const [dataResult, countResult] = await Promise.all([
    db.query<T>(query, [...params, limit, offset]),
    db.query<{ count: string }>(countQuery, params)
  ]);

  const total = parseInt(countResult.rows[0].count);
  const pages = Math.ceil(total / limit);

  return {
    data: dataResult.rows,
    pagination: {
      page,
      limit,
      total,
      pages,
      hasNext: page < pages,
      hasPrev: page > 1
    }
  };
}