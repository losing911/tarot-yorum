#!/bin/bash

# Tarot Yorum - Ubuntu 25 Server Setup Script
# Domain: tarot-yorum.fun
# Repository: https://github.com/losing911/tarot-yorum
# Author: AI Assistant
# Date: September 18, 2025

set -e  # Exit on any error

echo "🚀 Starting Tarot Yorum server setup for Ubuntu 25..."
echo "Domain: tarot-yorum.fun"
echo "Repository: https://github.com/losing911/tarot-yorum"
echo "Server will be configured with Node.js, PostgreSQL, Redis, Nginx, and SSL"

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release

# Install Node.js 20 LTS
echo "📦 Installing Node.js 20 LTS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install PostgreSQL 16
echo "📦 Installing PostgreSQL 16..."
# Create the keyring directory if it doesn't exist
mkdir -p /usr/share/keyrings

# Add PostgreSQL official APT repository with modern GPG key handling
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Update package list and install PostgreSQL
apt update
apt install -y postgresql-16 postgresql-contrib-16

# Install Redis
echo "📦 Installing Redis..."
apt install -y redis-server

# Install Nginx
echo "📦 Installing Nginx..."
apt install -y nginx

# Install Certbot for SSL
echo "📦 Installing Certbot for SSL certificates..."
apt install -y certbot python3-certbot-nginx

# Install PM2 for process management
echo "📦 Installing PM2..."
npm install -g pm2

# Install build tools
echo "📦 Installing build tools..."
apt install -y build-essential git

# Configure PostgreSQL
echo "🗄️ Configuring PostgreSQL..."
sudo -u postgres psql -c "CREATE USER tarotyorum WITH PASSWORD 'tarot2025!';"
sudo -u postgres psql -c "CREATE DATABASE tarot_yorum_db OWNER tarotyorum;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE tarot_yorum_db TO tarotyorum;"

# Configure Redis
echo "🔄 Configuring Redis..."
systemctl enable redis-server
systemctl start redis-server

# Create application user
echo "👤 Creating application user..."
useradd -m -s /bin/bash tarotyorum
usermod -aG sudo tarotyorum

# Create application directories
echo "📁 Creating application directories..."
mkdir -p /var/www/tarot-yorum.fun
chown -R tarotyorum:tarotyorum /var/www/tarot-yorum.fun

# Configure Nginx
echo "🌐 Configuring Nginx..."
cat > /etc/nginx/sites-available/tarot-yorum.fun << 'EOF'
server {
    listen 80;
    server_name tarot-yorum.fun www.tarot-yorum.fun;
    
    # Redirect all HTTP requests to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name tarot-yorum.fun www.tarot-yorum.fun;
    
    # SSL Configuration (will be managed by Certbot)
    ssl_certificate /etc/letsencrypt/live/tarot-yorum.fun/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tarot-yorum.fun/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
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
    
    # Static files with caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri @proxy;
    }
    
    location @proxy {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/tarot-yorum.fun /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Configure firewall
echo "🔥 Configuring UFW firewall..."
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Create systemd service for backend
echo "🔧 Creating systemd service for backend..."
cat > /etc/systemd/system/tarot-yorum-backend.service << 'EOF'
[Unit]
Description=Tarot Yorum Backend
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=tarotyorum
WorkingDirectory=/var/www/tarot-yorum.fun/backend
Environment=NODE_ENV=production
ExecStart=/usr/bin/node dist/index.js
Restart=always
RestartSec=5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=tarot-yorum-backend

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service for frontend
echo "🔧 Creating systemd service for frontend..."
cat > /etc/systemd/system/tarot-yorum-frontend.service << 'EOF'
[Unit]
Description=Tarot Yorum Frontend
After=network.target

[Service]
Type=simple
User=tarotyorum
WorkingDirectory=/var/www/tarot-yorum.fun/frontend
Environment=NODE_ENV=production
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=tarot-yorum-frontend

[Install]
WantedBy=multi-user.target
EOF

# Create production environment file
echo "📝 Creating production environment template..."
cat > /var/www/tarot-yorum.fun/.env.production << 'EOF'
# Production Environment Configuration
NODE_ENV=production

# Database Configuration
DATABASE_URL=postgresql://tarotyorum:tarot2025!@localhost:5432/tarot_yorum_db

# Redis Configuration
REDIS_URL=redis://localhost:6379

# JWT Configuration (CHANGE THESE IN PRODUCTION!)
JWT_SECRET=CHANGE_THIS_TO_SECURE_SECRET_KEY_123
JWT_REFRESH_SECRET=CHANGE_THIS_TO_SECURE_REFRESH_KEY_456
JWT_EXPIRE=15m
JWT_REFRESH_EXPIRE=7d

# AI Configuration (ADD YOUR API KEYS)
AI_PROVIDER=openai
OPENAI_API_KEY=your-openai-api-key-here
GEMINI_API_KEY=your-gemini-api-key-here

# Google Services (ADD YOUR IDs)
GOOGLE_ADS_CLIENT_ID=your-google-ads-client-id
GOOGLE_ANALYTICS_ID=your-ga-tracking-id

# Security
BCRYPT_ROUNDS=12
CORS_ORIGIN=https://tarot-yorum.fun

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100

# Domain Configuration
DOMAIN=tarot-yorum.fun
FRONTEND_URL=https://tarot-yorum.fun
BACKEND_URL=https://tarot-yorum.fun/api
EOF

chown tarotyorum:tarotyorum /var/www/tarot-yorum.fun/.env.production

# Create deployment script
echo "📝 Creating deployment script..."
cat > /var/www/tarot-yorum.fun/deploy.sh << 'EOF'
#!/bin/bash

echo "🚀 Deploying Tarot Yorum..."

# Pull latest code
git pull origin main

# Install backend dependencies
cd backend
npm ci --production
npm run build

# Install frontend dependencies
cd ../frontend
npm ci --production
npm run build

# Restart services
sudo systemctl restart tarot-yorum-backend
sudo systemctl restart tarot-yorum-frontend
sudo systemctl reload nginx

echo "✅ Deployment completed!"
EOF

chmod +x /var/www/tarot-yorum.fun/deploy.sh
chown tarotyorum:tarotyorum /var/www/tarot-yorum.fun/deploy.sh

# Enable services
systemctl daemon-reload
systemctl enable nginx
systemctl enable postgresql
systemctl enable redis-server

# Start services
systemctl start nginx
systemctl start postgresql
systemctl start redis-server

echo "✅ Basic server setup completed!"
echo ""
echo "🔧 Next steps:"
echo "1. Upload your project files to /var/www/tarot-yorum.fun/"
echo "2. Update /var/www/tarot-yorum.fun/.env.production with your API keys"
echo "3. Run SSL certificate setup:"
echo "   sudo certbot --nginx -d tarot-yorum.fun -d www.tarot-yorum.fun"
echo "4. Build and start your applications:"
echo "   cd /var/www/tarot-yorum.fun && sudo -u tarotyorum ./deploy.sh"
echo "5. Enable the systemd services:"
echo "   sudo systemctl enable tarot-yorum-backend"
echo "   sudo systemctl enable tarot-yorum-frontend"
echo ""
echo "🌟 Your server is ready for Tarot Yorum deployment!"
echo "Domain: https://tarot-yorum.fun"