# 🚀 VideoChatsApp - Template de Déploiement Gratuit

[![Deploy to GitHub Pages](https://img.shields.io/badge/GitHub-Pages-blue?logo=github)](https://pages.github.com/)
[![Deploy to Railway](https://img.shields.io/badge/Railway-Deploy-green?logo=railway)](https://railway.app/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green?logo=node.js)](https://nodejs.org/)
[![WebRTC](https://img.shields.io/badge/WebRTC-Supported-red?logo=webrtc)](https://webrtc.org/)

> **Application de chat vidéo en temps réel**  
> Déployable **100% gratuitement** avec GitHub Pages + Railway + STUN Google

## 🎯 Démarrage Ultra-Rapide

### ⚡ Déploiement en 3 Commandes

```bash
# 1. Cloner et configurer
git clone https://github.com/YOUR_USERNAME/videochatsapp-template.git
cd videochatsapp-template

# 2. Déployer le backend (Railway)
cd server && npm install && railway up && cd ..

# 3. Déployer le frontend (GitHub Pages)
git push origin main
# Puis activer GitHub Pages dans Settings > Pages
```

### 🔗 Configuration Finale

Après le déploiement, modifier ces 2 lignes :

**`public/script.js` ligne 2 :**
```javascript
const BACKEND_URL = 'https://VOTRE_APP.railway.app'; // Votre URL Railway
```

**`server/index.js` ligne 11 :**
```javascript
"https://VOTRE_USERNAME.github.io", // Votre utilisateur GitHub
```

## 🏗️ Architecture du Template

```
📦 videochatsapp-template/
├── 🌐 public/           # Frontend (GitHub Pages)
│   ├── index.html       # Page d'accueil
│   ├── room.html        # Interface chat vidéo
│   ├── script.js        # Client WebRTC + Socket.io
│   └── style.css        # Styles Tailwind CSS
├── ⚙️ server/           # Backend (Railway)
│   ├── index.js         # Serveur Express + Socket.io
│   └── package.json     # Dépendances Node.js
├── 📚 docs/             # Documentation
├── 🚀 scripts/          # Scripts de déploiement
└── 📄 README.md         # Ce fichier
```

## 💰 Coût Total : 0€

| Service | Coût | Limites | Avantages |
|---------|------|---------|-----------|
| **GitHub Pages** | 0€ | Repository public | CDN global, HTTPS automatique |
| **Railway** | 0€ | 500h/mois | SSL, base de données, mise en veille |
| **STUN Google** | 0€ | Illimité | 5 serveurs, haute disponibilité |

**Total : 100% GRATUIT** ✅

## 🎬 Fonctionnalités

- ✅ **Chat vidéo** en temps réel (WebRTC)
- ✅ **Chat textuel** intégré
- ✅ **Audio/vidéo** avec contrôles (mute/unmute)
- ✅ **Interface responsive** (Tailwind CSS)
- ✅ **Séparation frontend/backend** optimisée
- ✅ **HTTPS automatique** sur les deux services
- ✅ **CORS configuré** pour la production
- ✅ **Gestion d'erreurs** robuste

## 🛠️ Installation Locale

```bash
# 1. Installer les dépendances
npm install
cd server && npm install && cd ..

# 2. Lancer en développement
npm run dev
# Backend: http://localhost:3000
# Frontend: http://localhost:3000

# 3. Tester l'application
# Ouvrir 2 onglets sur http://localhost:3000
# Créer une salle dans l'un, rejoindre avec l'autre
```

## 🚀 Déploiement Détaillé

### **Option 1 : Déploiement Manuel**

#### Backend (Railway)
```bash
# 1. Aller sur railway.app
# 2. Se connecter avec GitHub
# 3. "New Project" > "Deploy from GitHub repo"
# 4. Sélectionner ce repository
# 5. Choisir le dossier "server"
# 6. Attendre le déploiement (2-3 minutes)
```

#### Frontend (GitHub Pages)
```bash
# 1. Pousser ce code sur GitHub
git remote add origin https://github.com/VOTRE_USERNAME/videochatsapp-template.git
git push -u origin main

# 2. GitHub > Settings > Pages
# 3. Source: Deploy from a branch
# 4. Branch: main / (root)
# 5. Folder: /public
```

### **Option 2 : Script Automatique**

```bash
# Utiliser le script de déploiement automatique
chmod +x deploy.sh
./deploy.sh
```

## 🔧 Configuration Avancée

### Variables d'Environnement (Railway)

```bash
NODE_ENV=production
PORT=3000
```

### Serveurs STUN Configurés

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

## 🧪 Test de l'Application

### Tests Manuels

1. **Backend** : `curl https://VOTRE_APP.railway.app/health`
2. **Frontend** : Ouvrir `https://VOTRE_USERNAME.github.io/videochatsapp-template/`
3. **WebRTC** : Créer une salle, rejoindre avec un autre navigateur

### Tests Automatisés

```bash
# Test de l'API backend
curl https://VOTRE_APP.railway.app/health
# Doit retourner: {"status":"OK",...}

# Test de l'interface
curl -I https://VOTRE_USERNAME.github.io/videochatsapp-template/
# Doit retourner: HTTP/2 200
```

## 🛡️ Sécurité

- ✅ **HTTPS obligatoire** sur les deux services
- ✅ **CORS configuré** pour les domaines autorisés
- ✅ **Validation des inputs** côté serveur
- ✅ **Gestion d'erreurs** sans fuite d'informations
- ✅ **WebRTC sécurisé** par défaut

## 🔍 Dépannage

### Problèmes Courants

**❌ Socket.io ne se connecte pas**
```bash
# Vérifier que l'URL Railway est correcte dans public/script.js
# Vérifier les logs Railway: railway logs
```

**❌ WebRTC ne fonctionne pas**
```bash
# Vérifier HTTPS sur les deux services
# Tester avec Chrome/Firefox récents
# Vérifier la console navigateur
```

**❌ CORS Error**
```bash
# Vérifier les origins dans server/index.js ligne 11
# Ajouter votre domaine GitHub Pages
```

### Logs et Debugging

```bash
# Logs Railway
railway logs

# Test local
npm run dev
# Ouvrir http://localhost:3000

# Test des endpoints
curl http://localhost:3000/health
curl http://localhost:3000/info
```

## 📈 Monitoring

### URLs de Surveillance

- **Backend Health** : `https://VOTRE_APP.railway.app/health`
- **Backend Info** : `https://VOTRE_APP.railway.app/info`
- **Frontend** : `https://VOTRE_USERNAME.github.io/videochatsapp-template/`

### Métriques

- **Uptime** : Disponible dans `/health`
- **Connexions WebSocket** : Logs du serveur
- **Erreurs** : Console navigateur + logs Railway

## 🤝 Contribution

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🆘 Support

- 📖 **Documentation** : Consultez les fichiers dans `docs/`
- 🐛 **Bugs** : Ouvrir une issue sur GitHub
- 💬 **Questions** : Discussions GitHub
- 📧 **Contact** : [Votre email]

---

## 🎉 Félicitations !

**Votre VideoChatsApp est maintenant déployée gratuitement et accessible dans le monde entier !**

🌐 **URLs finales :**
- **Application** : `https://VOTRE_USERNAME.github.io/videochatsapp-template/`
- **API Backend** : `https://VOTRE_APP.railway.app`

**⭐ N'oubliez pas de star ce repository si il vous a été utile !**