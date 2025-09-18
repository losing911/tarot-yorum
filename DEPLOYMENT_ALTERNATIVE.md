# 🔧 DigitalOcean Deployment - Alternative Setup

GitHub'da 404 hatası alıyorsanız, alternatif yöntemlerle deployment yapabilirsiniz:

## 🚀 **Yöntem 1: Manuel Script Oluşturma**

### DigitalOcean droplet'ta aşağıdaki komutu çalıştırın:

```bash
# 1. Script dosyasını oluşturun
sudo nano ubuntu25-setup.sh
```

### 2. Aşağıdaki içeriği kopyalayıp yapıştırın:

```bash
#!/bin/bash

# Tarot Yorum - Ubuntu 25 Server Setup Script
# Domain: tarot-yorum.fun
# Repository: https://github.com/losing911/tarot-yorum

set -e  # Exit on any error

echo "🚀 Starting Tarot Yorum server setup for Ubuntu 25..."

# Update system
apt update && apt upgrade -y

# Install essential packages
apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates

# Install Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install PostgreSQL 16
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt update
apt install -y postgresql-16 postgresql-contrib-16

# Install Redis & Nginx
apt install -y redis-server nginx

# Install Certbot for SSL
apt install -y certbot python3-certbot-nginx

# Install PM2 & build tools
npm install -g pm2
apt install -y build-essential git

# Configure PostgreSQL
sudo -u postgres psql -c "CREATE USER tarotyorum WITH PASSWORD 'tarot2025!';"
sudo -u postgres psql -c "CREATE DATABASE tarot_yorum_db OWNER tarotyorum;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE tarot_yorum_db TO tarotyorum;"

# Configure services
systemctl enable redis-server nginx postgresql
systemctl start redis-server nginx postgresql

# Create application user and directories
useradd -m -s /bin/bash tarotyorum
usermod -aG sudo tarotyorum
mkdir -p /var/www/tarot-yorum.fun
chown -R tarotyorum:tarotyorum /var/www/tarot-yorum.fun

# Configure firewall
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

echo "✅ Basic server setup completed!"
echo "🔧 Next: Clone your repository and configure services"
```

### 3. Script'i çalıştırılabilir yapın ve çalıştırın:

```bash
chmod +x ubuntu25-setup.sh
sudo ./ubuntu25-setup.sh
```

---

## 🚀 **Yöntem 2: Doğrudan GitHub Klonlama**

```bash
# 1. Repository'yi klonlayın
cd /var/www/
git clone https://github.com/losing911/tarot-yorum.git tarot-yorum.fun
chown -R www-data:www-data /var/www/tarot-yorum.fun

# 2. Manual kurulum
cd /var/www/tarot-yorum.fun
sudo ./ubuntu25-setup.sh  # Bu dosya repo'da mevcut
```

---

## 🚀 **Yöntem 3: Tek Komut Kurulum**

```bash
# Tek komutla tüm kurulum
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
apt update && apt install -y docker-compose-plugin git && \
cd /var/www && \
git clone https://github.com/losing911/tarot-yorum.git tarot-yorum.fun && \
cd tarot-yorum.fun && \
docker compose up -d
```

---

## 📝 **Manuel Nginx Konfigürasyonu**

GitHub'dan nginx config dosyasını manuel olarak oluşturun:

```bash
sudo nano /etc/nginx/sites-available/tarot-yorum.fun
```

Config içeriği (repository'deki nginx-tarot-yorum.conf dosyasından):

```nginx
server {
    listen 80;
    server_name tarot-yorum.fun www.tarot-yorum.fun;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name tarot-yorum.fun www.tarot-yorum.fun;
    
    # SSL Configuration (will be managed by Certbot)
    ssl_certificate /etc/letsencrypt/live/tarot-yorum.fun/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tarot-yorum.fun/privkey.pem;
    
    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_buffering off;
    }
    
    # Backend API
    location /api {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_buffering off;
    }
}
```

Site'i aktif edin:
```bash
ln -s /etc/nginx/sites-available/tarot-yorum.fun /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx
```

---

## 🔒 **SSL Kurulumu**

```bash
sudo certbot --nginx -d tarot-yorum.fun -d www.tarot-yorum.fun
```

---

## 🎯 **Test Edilmiş Deployment Adımları**

1. **DigitalOcean Ubuntu 25 droplet oluşturun**
2. **Yöntem 1'i kullanarak manuel script oluşturun**
3. **Repository'yi klonlayın**
4. **Environment variables'ları ayarlayın**
5. **SSL sertifikaları kurun**
6. **Servisleri başlatın**

Bu yöntemlerden herhangi biri GitHub 404 hatasını çözer! 🚀