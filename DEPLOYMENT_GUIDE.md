# 🚀 Tarot Yorum - DigitalOcean Deployment Rehberi

## 📋 Gereksinimler
- DigitalOcean hesabı
- Domain: `tarot-yorum.fun` (satın alınmış)
- SSH key çifti
- API anahtarları (OpenAI/Gemini)

## 1️⃣ DigitalOcean Droplet Oluşturma

### Droplet Spesifikasyonları
```
- **İşletim Sistemi:** Ubuntu 25.04 LTS
- **Plan:** Basic Droplet
- **CPU & RAM:** 1 vCPU, 2 GB RAM, 50 GB SSD ($12/ay)
- **Datacenter:** Frankfurt (FRA1) - Türkiye'ye en yakın
- **SSH Keys:** SSH anahtarınızı ekleyin
- **Hostname:** tarot-yorum-prod
```

### Droplet Oluşturma Adımları
1. DigitalOcean'da "Create" → "Droplets"
2. Ubuntu 25.04 x64 seçin
3. Regular CPU, $12/ay plan seçin
4. Frankfurt datacenter seçin
5. SSH anahtarınızı ekleyin
6. Hostname: `tarot-yorum-prod`
7. "Create Droplet" tıklayın

## 2️⃣ Domain ve DNS Ayarları

### DNS Kayıtları (GoDaddy/Namecheap/CloudFlare)
```
Tip    İsim               Değer              TTL
A      @                  DROPLET_IP_ADRESI  600
A      www                DROPLET_IP_ADRESI  600
A      api                DROPLET_IP_ADRESI  600
CNAME  www.tarot-yorum    tarot-yorum.fun    600
```

### DigitalOcean DNS (Opsiyonel)
1. DigitalOcean'da "Networking" → "Domains"
2. Domain adınızı ekleyin: `tarot-yorum.fun`
3. Droplet'i seçin
4. A ve CNAME kayıtlarını otomatik oluşturun

## 3️⃣ Server Kurulumu

### SSH Bağlantısı
```bash
ssh root@DROPLET_IP_ADRESI
```

### Otomatik Kurulum Scripti
```bash
# Setup scriptini indirin
wget https://raw.githubusercontent.com/YOUR_REPO/main/ubuntu25-setup.sh

# Çalıştırılabilir yapın
chmod +x ubuntu25-setup.sh

# Scripti çalıştırın
sudo ./ubuntu25-setup.sh
```

### Manuel Kurulum (Script Çalışmazsa)

#### Sistem Güncellemesi
```bash
apt update && apt upgrade -y
apt install -y curl wget gnupg2 software-properties-common
```

#### Node.js 20 LTS
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs
```

#### PostgreSQL 16
```bash
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt update && apt install -y postgresql-16 postgresql-contrib-16
```

#### Redis
```bash
apt install -y redis-server
systemctl enable redis-server
systemctl start redis-server
```

#### Nginx
```bash
apt install -y nginx
systemctl enable nginx
```

#### Certbot (SSL)
```bash
apt install -y certbot python3-certbot-nginx
```

## 4️⃣ Veritabanı Kurulumu

### PostgreSQL Konfigürasyonu
```bash
# PostgreSQL'e geçiş
sudo -u postgres psql

# Veritabanı ve kullanıcı oluşturma
CREATE USER tarotyorum WITH PASSWORD 'GÜÇLÜ_ŞİFRE';
CREATE DATABASE tarot_yorum_db OWNER tarotyorum;
GRANT ALL PRIVILEGES ON DATABASE tarot_yorum_db TO tarotyorum;
\q
```

### Redis Test
```bash
redis-cli ping
# Yanıt: PONG
```

## 5️⃣ Proje Dosyalarını Yükleme

### Git ile Klonlama
```bash
cd /var/www/
git clone https://github.com/YOUR_USERNAME/tarot-yorum.git tarot-yorum.fun
chown -R www-data:www-data /var/www/tarot-yorum.fun
```

### SFTP ile Yükleme (Alternatif)
```bash
# Yerel bilgisayardan
scp -r ./astrrolog/* root@DROPLET_IP:/var/www/tarot-yorum.fun/
```

## 6️⃣ Environment Konfigürasyonu

### Backend .env
```bash
cd /var/www/tarot-yorum.fun/backend
cp .env.example .env
nano .env
```

**Kritik Ayarlar:**
```env
NODE_ENV=production
DATABASE_URL=postgresql://tarotyorum:GÜÇLÜ_ŞİFRE@localhost:5432/tarot_yorum_db
JWT_SECRET=32_KARAKTER_GÜÇLÜ_SECRET_KEY
JWT_REFRESH_SECRET=32_KARAKTER_GÜÇLÜ_REFRESH_KEY
OPENAI_API_KEY=sk-your-openai-key
CORS_ORIGIN=https://tarot-yorum.fun
DOMAIN=tarot-yorum.fun
```

### Frontend .env
```bash
cd /var/www/tarot-yorum.fun/frontend
cat > .env.production << 'EOF'
NEXT_PUBLIC_API_URL=https://tarot-yorum.fun/api
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=G-YOUR-GA-ID
EOF
```

## 7️⃣ Bağımlılıkları Yükleme

### Backend
```bash
cd /var/www/tarot-yorum.fun/backend
npm ci --production
npm run build
```

### Frontend
```bash
cd /var/www/tarot-yorum.fun/frontend
npm ci --production
npm run build
```

## 8️⃣ Database Migration

### Migration Çalıştırma
```bash
cd /var/www/tarot-yorum.fun/backend
# Migration scripti varsa:
npm run migrate

# Manuel migration:
psql -U tarotyorum -d tarot_yorum_db -f ../migrations/001_create_tables.sql
```

## 9️⃣ Nginx Konfigürasyonu

### Site Konfigürasyonu
```bash
# Konfigürasyon dosyasını kopyala
cp /var/www/tarot-yorum.fun/nginx-tarot-yorum.conf /etc/nginx/sites-available/tarot-yorum.fun

# Site'ı aktif et
ln -s /etc/nginx/sites-available/tarot-yorum.fun /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Konfigürasyon test
nginx -t

# Nginx restart
systemctl restart nginx
```

## 🔒 SSL Kurulumu

### Let's Encrypt SSL
```bash
# SSL sertifikaları al
certbot --nginx -d tarot-yorum.fun -d www.tarot-yorum.fun

# Otomatik yenileme test
certbot renew --dry-run
```

### SSL Cron Job (Otomatik Yenileme)
```bash
crontab -e
# Ekle:
0 12 * * * /usr/bin/certbot renew --quiet && systemctl reload nginx
```

## 🔧 Systemd Servisleri

### Backend Service
```bash
# Service dosyası oluştur
cat > /etc/systemd/system/tarot-yorum-backend.service << 'EOF'
[Unit]
Description=Tarot Yorum Backend
After=network.target postgresql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/tarot-yorum.fun/backend
Environment=NODE_ENV=production
ExecStart=/usr/bin/node dist/index.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Service'i aktif et
systemctl enable tarot-yorum-backend
systemctl start tarot-yorum-backend
```

### Frontend Service
```bash
cat > /etc/systemd/system/tarot-yorum-frontend.service << 'EOF'
[Unit]
Description=Tarot Yorum Frontend
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/tarot-yorum.fun/frontend
Environment=NODE_ENV=production
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl enable tarot-yorum-frontend
systemctl start tarot-yorum-frontend
```

## 🔥 Firewall Konfigürasyonu

### UFW Kurulumu
```bash
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw status
```

## 📊 Monitoring ve Logs

### Servisleri Kontrol Etme
```bash
# Backend status
systemctl status tarot-yorum-backend

# Frontend status
systemctl status tarot-yorum-frontend

# Nginx status
systemctl status nginx

# PostgreSQL status
systemctl status postgresql

# Redis status
systemctl status redis-server
```

### Log Kontrolü
```bash
# Backend logs
journalctl -u tarot-yorum-backend -f

# Frontend logs
journalctl -u tarot-yorum-frontend -f

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

## 🎯 Health Check

### Test URL'leri
```bash
# Health check
curl https://tarot-yorum.fun/api/health

# Ana sayfa
curl https://tarot-yorum.fun

# Admin paneli
curl https://tarot-yorum.fun/admin
```

## 🚀 Go Live Checklist

- [ ] DNS kayıtları propagate oldu (24-48 saat)
- [ ] SSL sertifikaları çalışıyor
- [ ] Backend API `/health` endpoint'i 200 döndürüyor
- [ ] Frontend ana sayfa yükleniyor
- [ ] Database bağlantısı çalışıyor
- [ ] Redis cache çalışıyor
- [ ] Admin paneli erişilebilir
- [ ] Google Analytics aktif
- [ ] AdSense reklamları test edildi

## 🔄 Güncellemeler

### Kod Güncellemesi
```bash
cd /var/www/tarot-yorum.fun
git pull origin main

# Backend güncelle
cd backend
npm ci --production
npm run build
systemctl restart tarot-yorum-backend

# Frontend güncelle
cd ../frontend
npm ci --production
npm run build
systemctl restart tarot-yorum-frontend
```

## 💾 Backup Stratejisi

### PostgreSQL Backup
```bash
# Günlük backup script
cat > /root/backup-db.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -U tarotyorum tarot_yorum_db > /root/backups/db_backup_$DATE.sql
find /root/backups -name "*.sql" -mtime +7 -delete
EOF

chmod +x /root/backup-db.sh

# Cron job ekle
crontab -e
# Ekle:
0 2 * * * /root/backup-db.sh
```

## 🎉 Tebrikler!

Tarot Yorum siteniz artık canlı: **https://tarot-yorum.fun**

### Son Adımlar:
1. Google Search Console'da site'i kaydedin
2. Google Analytics'i doğrulayın
3. AdSense hesabı için başvurun
4. Social media hesapları oluşturun
5. SEO optimizasyonu yapın

**Destek için:** GitHub Issues veya email ile iletişime geçin.