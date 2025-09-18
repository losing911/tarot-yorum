# Astrrolog Backend API

Node.js/Express tabanlı RESTful API sunucusu. AI destekli astroloji ve tarot hizmetleri sağlar.

## 🚀 Özellikler

- **RESTful API**: Express.js tabanlı
- **TypeScript**: Type safety
- **AI Integration**: OpenAI GPT & Google Gemini
- **Authentication**: JWT tabanlı güvenlik
- **Database**: PostgreSQL + Redis
- **Rate Limiting**: API koruması
- **Validation**: Express-validator

## 📋 Requirements

- Node.js 18+
- PostgreSQL 13+
- Redis 6+
- NPM veya Yarn

## 🛠️ Installation

```bash
# Dependencies yükle
npm install

# Environment variables
cp .env.example .env
# .env dosyasını düzenleyerek API anahtarlarını ekleyin

# Development server başlat
npm run dev

# Production build
npm run build
npm start
```

## ⚙️ Environment Variables

```env
NODE_ENV=development
PORT=3001

# Database Configuration
DATABASE_URL=postgresql://username:password@localhost:5432/astrrolog_db
REDIS_URL=redis://localhost:6379

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-here
JWT_REFRESH_SECRET=your-super-secret-refresh-key-here
JWT_EXPIRE=15m
JWT_REFRESH_EXPIRE=7d

# AI Configuration
AI_PROVIDER=openai
OPENAI_API_KEY=your-openai-api-key-here
GEMINI_API_KEY=your-gemini-api-key-here

# Security
BCRYPT_ROUNDS=12
CORS_ORIGIN=http://localhost:3000

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100
```

## 📊 API Endpoints

### Health Check
```
GET /health
```

### Authentication
```
POST /api/auth/register    # Kullanıcı kaydı
POST /api/auth/login       # Giriş
POST /api/auth/refresh     # Token yenileme
POST /api/auth/logout      # Çıkış
```

### AI Services
```
POST /api/ai/horoscope     # Burç yorumu
POST /api/ai/tarot         # Tarot falı
POST /api/ai/natal-chart   # Natal harita
POST /api/ai/compatibility # Uyumluluk analizi
POST /api/ai/blog-post     # AI blog yazısı
GET  /api/ai/status        # AI servis durumu
```

### User Management
```
GET  /api/users/profile    # Profil bilgisi
PUT  /api/users/profile    # Profil güncelleme
```

### Content Management
```
GET    /api/blogs          # Blog yazıları
POST   /api/blogs          # Yeni blog yazısı
PUT    /api/blogs/:id      # Blog güncelleme
DELETE /api/blogs/:id      # Blog silme
```

### Admin Panel
```
GET  /api/admin/users      # Kullanıcı listesi
PUT  /api/admin/users/:id/ban  # Kullanıcı yasaklama
GET  /api/admin/settings   # Admin ayarları
PUT  /api/admin/settings   # Ayar güncelleme
GET  /api/admin/analytics  # Analytics verisi
```

## 🔧 Project Structure

```
src/
├── controllers/       # Request handlers
├── middleware/        # Custom middleware
├── routes/           # API routes
├── services/         # Business logic
└── index.ts          # Application entry point

migrations/           # Database migrations
```

## 🤖 AI Integration

### OpenAI Configuration
```typescript
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
```

### Gemini Configuration
```typescript
const gemini = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
```

### Usage Example
```typescript
// Horoscope generation
const horoscope = await aiService.generateHoroscope({
  sign: 'Aries',
  type: 'daily',
  date: '2025-09-18'
});
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based auth
- **Rate Limiting**: 100 requests per 15 minutes
- **Input Validation**: Express-validator
- **CORS Protection**: Configurable origins
- **Password Hashing**: bcryptjs with 12 rounds

## 📝 Scripts

```bash
npm run dev      # Development server with auto-reload
npm run build    # TypeScript compilation
npm start        # Production server
npm run lint     # Code linting
```

## 🗃️ Database

### Migration Files
Migration dosyaları `migrations/` klasöründe:

1. `001_create_users_table.sql` - Kullanıcı tablosu
2. `002_create_profiles_table.sql` - Profil tablosu
3. `003_create_readings_table.sql` - Okuma tablosu
4. `004_create_blog_posts_table.sql` - Blog tablosu
5. `005_create_admin_settings_table.sql` - Admin ayarları
6. `006_create_additional_tables.sql` - Ek tablolar

### Migration Çalıştırma
```bash
psql -d astrrolog_db -f migrations/001_create_users_table.sql
psql -d astrrolog_db -f migrations/002_create_profiles_table.sql
# ... diğer dosyalar
```

## 🚨 Error Handling

Merkezi error handling middleware:
```typescript
app.use(errorHandler);
```

Standart error response format:
```json
{
  "success": false,
  "error": "Error message",
  "stack": "Stack trace (dev only)"
}
```

## 📈 Monitoring

- **Health Check**: `/health` endpoint
- **Request Logging**: Morgan middleware
- **Error Logging**: Console.error
- **Performance**: Response time tracking

## 🧪 Testing

```bash
# Unit tests (TODO)
npm test

# Integration tests (TODO)
npm run test:integration
```

## 🔧 Development Tips

1. **Hot Reload**: `npm run dev` otomatik yeniden başlatma
2. **TypeScript**: Type safety için tüm dosyalar .ts
3. **Environment**: `.env` dosyasını asla commit etmeyin
4. **Validation**: Tüm input'ları validate edin
5. **Logging**: Önemli işlemleri logla

## 📚 Dependencies

### Production
- express - Web framework
- cors - CORS middleware
- helmet - Security headers
- bcryptjs - Password hashing
- jsonwebtoken - JWT tokens
- openai - OpenAI API
- @google/generative-ai - Gemini AI
- express-validator - Input validation
- express-rate-limit - Rate limiting

### Development
- nodemon - Auto-restart
- typescript - Type checking
- ts-node - TypeScript execution
- @types/* - Type definitions

---

🔮 **Astrrolog Backend** - AI destekli astroloji API sunucusu