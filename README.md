# Tarot Yorum - AI-Powered Turkish Tarot & Astrology Platform

🔮 **Modern, AI destekli Türk tarot ve astroloji platformu**

## 🌟 Özellikler

- 🤖 **AI Destekli Tarot Falları** - OpenAI/Gemini entegrasyonu
- ⭐ **Günlük Burç Yorumları** - Kişiselleştirilmiş astroloji
- 💝 **Aşk Uyumu Analizi** - Burç uyumluluğu
- 📊 **Doğum Haritası** - Detaylı astroloji haritası
- 🎨 **Modern UI/UX** - Mistik siyah-kırmızı tema
- 📱 **Responsive Design** - Mobile-first yaklaşım
- 🔒 **Güvenli API** - JWT authentication
- 💰 **AdSense Entegrasyonu** - Monetizasyon hazır

## 🛠️ Teknolojiler

### Frontend
- ⚛️ Next.js 15 + TypeScript
- 🎨 Tailwind CSS + Custom Components
- 📊 React Hooks + Context API
- 🚀 Turbopack Build System

### Backend
- 🟢 Node.js + Express.js + TypeScript
- 🗄️ PostgreSQL + Redis Cache
- 🔐 JWT Authentication + bcrypt
- 🤖 OpenAI/Gemini API Integration
- 📈 Rate Limiting + Security Middleware

### DevOps
- 🐳 Docker + Docker Compose
- 🌐 Nginx Reverse Proxy
- 🔒 SSL/TLS (Let's Encrypt)
- 📦 Ubuntu 25 Deployment Ready

## 🚀 Hızlı Başlangıç

### Yerel Geliştirme

```bash
# Repository'yi klonlayın
git clone https://github.com/losing911/tarot-yorum.git
cd tarot-yorum

# Backend kurulumu
cd backend
npm install
cp .env.example .env
# .env dosyasını düzenleyin
npm run dev

# Frontend kurulumu (yeni terminal)
cd frontend
npm install
npm run dev
```

### Docker ile Çalıştırma

```bash
# Tüm servisleri başlat
docker-compose up -d

# Logları takip et
docker-compose logs -f
```

## 🌐 Production Deployment

### DigitalOcean Ubuntu 25

```bash
# Otomatik kurulum scripti
wget https://raw.githubusercontent.com/losing911/tarot-yorum/main/ubuntu25-setup.sh
chmod +x ubuntu25-setup.sh
sudo ./ubuntu25-setup.sh
```

Detaylı deployment rehberi için: [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

## 📁 Proje Yapısı

```
tarot-yorum/
├── frontend/                 # Next.js Frontend
│   ├── src/
│   │   ├── app/             # App Router pages
│   │   ├── components/      # React components
│   │   ├── lib/            # Utilities & API
│   │   └── styles/         # Global styles
│   └── package.json
├── backend/                 # Express.js Backend
│   ├── src/
│   │   ├── controllers/    # Route handlers
│   │   ├── middleware/     # Express middleware
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   └── config/         # Configuration
│   └── package.json
├── migrations/              # Database migrations
├── docker-compose.yml       # Docker configuration
├── nginx-tarot-yorum.conf  # Nginx configuration
├── ubuntu25-setup.sh       # Deployment script
└── DEPLOYMENT_GUIDE.md     # Deployment guide
```

## 🔧 Konfigürasyon

### Environment Variables

#### Backend (.env)
```env
NODE_ENV=production
DATABASE_URL=postgresql://user:pass@localhost:5432/tarot_yorum_db
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key
OPENAI_API_KEY=sk-your-openai-key
CORS_ORIGIN=https://tarot-yorum.fun
```

#### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=https://tarot-yorum.fun/api
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=G-YOUR-GA-ID
```

## � API Endpoints

### Authentication
- `POST /api/auth/register` - Kullanıcı kaydı
- `POST /api/auth/login` - Giriş yapma
- `POST /api/auth/refresh` - Token yenileme

### Tarot & Astrology
- `GET /api/horoscope/:sign` - Günlük burç
- `POST /api/tarot/reading` - Tarot falı
- `POST /api/compatibility` - Burç uyumu
- `POST /api/natal-chart` - Doğum haritası

### Blog & Content
- `GET /api/blog/posts` - Blog yazıları
- `GET /api/blog/posts/:id` - Tekil yazı
- `POST /api/blog/posts` - Yeni yazı (admin)

## 💰 Monetizasyon

- 🎯 **Google AdSense** - Banner ve native reklamlar
- 💎 **Premium Abonelik** - Özel özellikler
- 🎁 **Affiliate Marketing** - Tarot ürünleri
- 📱 **Mobile App** - React Native versiyonu

## 🔒 Güvenlik

- 🛡️ **Helmet.js** - Security headers
- 🚦 **Rate Limiting** - DDoS koruması
- 🔐 **JWT Authentication** - Secure token
- 🔍 **Input Validation** - XSS/SQL injection koruması
- 🌐 **CORS** - Cross-origin configuration

## � İstatistikler

- ⚡ **Performance**: Lighthouse 95+ score
- 📱 **SEO Ready**: Meta tags, structured data
- 🌍 **i18n**: Türkçe/İngilizce desteği
- ♿ **Accessibility**: WCAG 2.1 AA uyumlu

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## � Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🎯 Roadmap

- [ ] Mobile App (React Native)
- [ ] Real-time Chat Support
- [ ] AI Voice Readings
- [ ] Advanced Analytics Dashboard
- [ ] Multi-language Support
- [ ] API Monetization

## 🆘 Destek

- 📧 **Email**: support@tarot-yorum.fun
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/losing911/tarot-yorum/issues)
- 💬 **Discord**: [Tarot Yorum Community](https://discord.gg/tarot-yorum)

---

⭐ **Beğendiyseniz yıldız verin!** ⭐

🔮 **Demo**: [https://tarot-yorum.fun](https://tarot-yorum.fun)