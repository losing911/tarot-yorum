# 🚀 GitHub Repository Kurulum Rehberi

## 1️⃣ GitHub Repository Oluşturma

1. **GitHub.com'a gidin** → Giriş yapın
2. **Sağ üstte "+" → "New repository"**
3. **Repository ayarları:**
   ```
   Repository name: tarot-yorum
   Description: AI-Powered Turkish Tarot & Astrology Platform - Türk tarot ve astroloji platformu
   ✅ Public (free hosting için)
   ❌ Add README file (zaten var)
   ❌ Add .gitignore (zaten var)
   License: MIT License
   ```
4. **"Create repository"** tıklayın

## 2️⃣ Remote Repository Bağlama

Aşağıdaki komutları sırayla çalıştırın (YOUR_USERNAME yerine GitHub kullanıcı adınızı yazın):

```bash
# GitHub repository'i remote olarak ekle
git remote add origin https://github.com/YOUR_USERNAME/tarot-yorum.git

# Branch'i main olarak ayarla
git branch -M main

# İlk push
git push -u origin main
```

## 3️⃣ Deployment Script Güncelleme

Repository oluşturduktan sonra, deployment scripti güncelleyin:

```bash
# ubuntu25-setup.sh dosyasında güncelleme yapın:
wget https://raw.githubusercontent.com/YOUR_USERNAME/tarot-yorum/main/ubuntu25-setup.sh
```

## 4️⃣ README.md Güncelleme

README.md dosyasında YOUR_USERNAME'i kendi GitHub kullanıcı adınızla değiştirin:

```markdown
git clone https://github.com/YOUR_USERNAME/tarot-yorum.git
```

## 5️⃣ Repository Hazır!

✅ Repository linki: `https://github.com/YOUR_USERNAME/tarot-yorum`
✅ Deployment script: `https://raw.githubusercontent.com/YOUR_USERNAME/tarot-yorum/main/ubuntu25-setup.sh`

## 🎉 Sonraki Adımlar

1. DigitalOcean droplet oluşturun
2. Domain DNS ayarlarını yapın  
3. Deployment scripti çalıştırın:
   ```bash
   wget https://raw.githubusercontent.com/YOUR_USERNAME/tarot-yorum/main/ubuntu25-setup.sh
   chmod +x ubuntu25-setup.sh
   sudo ./ubuntu25-setup.sh
   ```

## 📝 Git Komutları (Gelecekteki Güncellemeler)

```bash
# Değişiklikleri takip et
git add .
git commit -m "Update: description of changes"
git push origin main

# Sunucuda güncelle
cd /var/www/tarot-yorum.fun
git pull origin main
systemctl restart tarot-yorum-backend
systemctl restart tarot-yorum-frontend
```