# VideoChatsApp - Configuration Gratuite
## GitHub Pages + Railway + STUN Gratuit

### 🚀 Démarrage Rapide

Cette configuration vous permet de déployer VideoChatsApp **gratuitement** avec :
- **Frontend** : Hébergé sur GitHub Pages
- **Backend** : Hébergé sur Railway  
- **STUN** : Serveurs Google gratuits

### 📁 Structure du Projet

```
videochatsapp/
├── public/              # Frontend (GitHub Pages)
│   ├── index.html
│   ├── room.html
│   ├── script.js        # Client Socket.io + WebRTC
│   └── style.css
├── server/              # Backend (Railway)
│   ├── server.js        # Serveur Express + Socket.io
│   └── package.json     # Dépendances Node.js
├── GUIDE_DEPLOIEMENT_GRATUIT.md
└── README_CONFIGURATION.md
```

### 🔧 Configuration Automatique

#### 1. **Déploiement Backend (Railway)**

```bash
# 1. Aller dans le dossier server
cd server

# 2. Installer les dépendances
npm install

# 3. Se connecter à Railway (première fois)
npm install -g @railway/cli
railway login

# 4. Déployer
railway init
railway up
```

**Variables d'environnement Railway :**
```
NODE_ENV=production
PORT=3000
```

#### 2. **Déploiement Frontend (GitHub Pages)**

```bash
# 1. Pousser le code vers GitHub
git init
git add .
git commit -m "VideoChatsApp - Configuration gratuite"
git remote add origin https://github.com/VOTRE-USERNAME/videochatsapp.git
git push -u origin main

# 2. Activer GitHub Pages
# Aller dans Settings > Pages > Source: main branch > /public folder
```

#### 3. **Configuration des URLs**

**Après déploiement, modifier ces fichiers :**

**`public/script.js`** - Ligne 1 :
```javascript
// Remplacer cette ligne :
const socket = io();

// Par celle-ci (URL Railway) :
const socket = io("https://VOTRE-RAILWAY-APP.railway.app");
```

**`server/server.js`** - Lignes CORS :
```javascript
origin: [
  "http://localhost:3000",
  "https://VOTRE-USERNAME.github.io",
  "https://VOTRE-USERNAME.github.io/videochatsapp"
]
```

### 🌐 URLs Finales

Après configuration, vos URLs seront :
- **Application** : `https://VOTRE-USERNAME.github.io/videochatsapp/`
- **API Backend** : `https://VOTRE-RAILWAY-APP.railway.app`
- **Santé API** : `https://VOTRE-RAILWAY-APP.railway.app/health`

### ✅ Test de Fonctionnement

1. **Vérifier le backend :**
   ```bash
   curl https://VOTRE-RAILWAY-APP.railway.app/health
   # Doit retourner {"status":"OK",...}
   ```

2. **Tester l'application :**
   - Ouvrir `https://VOTRE-USERNAME.github.io/videochatsapp/`
   - Créer une salle dans un onglet
   - Rejoindre avec un autre onglet/navigateur
   - Vérifier la vidéo et le chat

### 🔧 Configuration STUN

Le serveur utilise plusieurs serveurs STUN Google pour la fiabilité :

```javascript
const config = {
  iceServers: [
    { urls: "stun:stun.l.google.com:19302" },
    { urls: "stun:stun1.l.google.com:19302" },
    { urls: "stun:stun2.l.google.com:19302" },
    { urls: "stun:stun3.l.google.com:19302" },
    { urls: "stun:stun4.l.google.com:19302" }
  ],
};
```

### 📊 Limitations du Plan Gratuit

| Service | Limite | Impact |
|---------|--------|--------|
| **GitHub Pages** | Repository public | ✅ Aucun impact |
| **Railway** | 500h/mois, 1GB RAM | ⚠️ Mise en veille après 30min |
| **STUN Google** | Illimité | ✅ Suffisant pour usage normal |

### 🛠️ Dépannage

#### **Erreur CORS**
```javascript
// Vérifier les origins dans server/server.js
origin: [
  "https://VOTRE-USERNAME.github.io",
  "https://VOTRE-USERNAME.github.io/videochatsapp"
]
```

#### **Socket.io ne se connecte pas**
```bash
# Vérifier que Railway fonctionne
curl https://VOTRE-RAILWAY-APP.railway.app/health

# Vérifier les logs Railway
railway logs
```

#### **WebRTC ne fonctionne pas**
- Vérifier HTTPS sur les deux services
- Tester avec Chrome/Firefox récents
- Vérifier la console navigateur pour erreurs

### 🔄 Mises à Jour

Pour mettre à jour l'application :

```bash
# 1. Mettre à jour le code
git add .
git commit -m "Mise à jour"
git push origin main

# 2. Redéployer Railway (automatique)
railway up

# 3. GitHub Pages se met à jour automatiquement
```

### 🎯 Avantages de cette Configuration

✅ **100% Gratuit** - Aucun frais d'hébergement  
✅ **HTTPS automatique** - Sécurisé par défaut  
✅ **CDN global** - GitHub Pages worldwide  
✅ **SSL automatique** - Railway + GitHub  
✅ **Fiable** - Serveurs STUN multiples  
✅ **Scalable** - Upgrade facile si nécessaire  

### 📞 Support

En cas de problème :
1. Consulter `GUIDE_DEPLOIEMENT_GRATUIT.md`
2. Vérifier les logs Railway : `railway logs`
3. Tester les endpoints de santé
4. Vérifier la console navigateur

---

**🎉 Félicitations ! Votre VideoChatsApp est maintenant en ligne gratuitement !**