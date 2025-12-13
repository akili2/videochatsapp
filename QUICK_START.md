# ⚡ Démarrage Rapide - VideoChatsApp

## 🚀 Déploiement en 3 Minutes

### **Commande Unique**
```bash
git clone https://github.com/YOUR_USERNAME/videochatsapp-template.git && cd videochatsapp-template && chmod +x deploy.sh && ./deploy.sh
```

### **Ou Manuellement**

#### 1️⃣ **Railway (Backend)**
```bash
# 1. railway.app > Login with GitHub
# 2. New Project > Deploy from GitHub repo
# 3. Sélectionner ce repository
# 4. Choisir dossier "server"
# 5. Deploy (2-3 min)
```

#### 2️⃣ **GitHub Pages (Frontend)**
```bash
git init && git add . && git commit -m "Deploy" && git remote add origin https://github.com/YOUR_USERNAME/videochatsapp.git && git push -u origin main
# Puis: Settings > Pages > Source: main > Folder: /public
```

#### 3️⃣ **Configuration**
Modifier `public/script.js` ligne 2 :
```javascript
const BACKEND_URL = 'https://VOTRE_APP.railway.app';
```

## 🎯 Résultat Final
- **App** : `https://YOUR_USERNAME.github.io/videochatsapp/`
- **Backend** : `https://YOUR_APP.railway.app`

## 💰 Coût : 0€

## 🆘 Support
- 📖 README.md complet
- 🚀 deploy.sh automatique
- 🔧 Configuration guidée