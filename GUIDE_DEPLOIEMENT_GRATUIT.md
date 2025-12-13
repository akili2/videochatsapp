# Guide de Déploiement Gratuit - VideoChatsApp
## Budget 0€ : GitHub Pages + Railway + STUN gratuit

### 🎯 Architecture de Déploiement

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Pages  │    │     Railway      │    │  Serveur STUN   │
│   (Frontend)    │◄──►│    (Backend)     │    │   (Google)      │
│                 │    │                  │    │                 │
│ • HTML/CSS/JS   │    │ • Node.js        │    │ • STUN gratuit  │
│ • Interface     │    │ • Socket.io      │    │ • Multi-serveur │
│ • Static files  │    │ • API Routes     │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 📋 Étapes de Déploiement

#### **Étape 1 : Préparation du Repository GitHub**

1. **Créer un nouveau repository sur GitHub**
   ```bash
   # Cloner le repository
   git clone https://github.com/VOTRE-USERNAME/videochatsapp.git
   cd videochatsapp
   ```

2. **Structure des fichiers pour GitHub Pages**
   ```
   videochatsapp/
   ├── public/          # Contenu pour GitHub Pages
   │   ├── index.html
   │   ├── room.html
   │   ├── script.js
   │   └── style.css
   ├── server/          # Backend pour Railway
   │   ├── server.js
   │   └── package.json
   ├── README.md
   └── DEPLOIEMENT.md
   ```

#### **Étape 2 : Configuration du Backend (Railway)**

1. **Créer le dossier `server/` et y déplacer les fichiers backend**
   ```bash
   mkdir server
   mv server.js server/
   ```

2. **Créer `server/package.json`**
   ```json
   {
     "name": "videochatsapp-server",
     "version": "1.0.0",
     "main": "server.js",
     "scripts": {
       "start": "node server.js"
     },
     "dependencies": {
       "express": "^4.19.2",
       "socket.io": "^4.7.5"
     }
   }
   ```

3. **Modifier `server/server.js` pour l'environnement de production**
   ```javascript
   const express = require("express");
   const app = express();
   const http = require("http");
   const server = http.createServer(app);
   const { Server } = require("socket.io");
   
   // Configuration CORS pour GitHub Pages
   const io = new Server(server, {
     cors: {
       origin: ["https://VOTRE-USERNAME.github.io", "http://localhost:3000"],
       methods: ["GET", "POST"]
     }
   });

   // Le reste du code reste identique...
   ```

4. **Déployer sur Railway**
   - Aller sur [railway.app](https://railway.app)
   - Se connecter avec GitHub
   - Créer un nouveau projet
   - Connecter le repository GitHub
   - Sélectionner le dossier `server/`
   - Déployer automatiquement

#### **Étape 3 : Configuration du Frontend (GitHub Pages)**

1. **Modifier les URLs dans `public/script.js`**
   ```javascript
   // Remplacer cette ligne :
   const socket = io();
   
   // Par celle-ci (URL Railway) :
   const socket = io("https://VOTRE-APP.railway.app");
   ```

2. **Activer GitHub Pages**
   - Aller dans Settings > Pages du repository
   - Source : Deploy from a branch
   - Branch : main / root
   - Folder : /public

3. **Publier le frontend**
   ```bash
   git add public/
   git commit -m "Frontend pour GitHub Pages"
   git push origin main
   ```

#### **Étape 4 : Configuration HTTPS et Domaines**

1. **URLs finales**
   - **Frontend** : `https://VOTRE-USERNAME.github.io/videochatsapp/`
   - **Backend** : `https://VOTRE-APP.railway.app`

2. **Modifier les redirections dans les fichiers HTML**
   ```javascript
   // Dans public/index.html et public/script.js
   // Remplacer toutes les occurrences de "/" par l'URL GitHub Pages
   window.location.href = "https://VOTRE-USERNAME.github.io/videochatsapp/";
   ```

### 🔧 Configuration STUN Gratuite

Le code est déjà configuré avec plusieurs serveurs STUN Google :

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

### ⚠️ Limitations du Budget Gratuit

#### **GitHub Pages**
- ❌ Pas de support serveur-side
- ❌ HTTPS requis pour WebRTC (mais fourni automatiquement)
- ✅ CDN global rapide
- ✅ Gratuit avec domaine personnalisé optionnel

#### **Railway**
- ✅ 500 heures/mois gratuites
- ✅ SSL automatique
- ✅ Base de données incluse
- ⚠️ Mise en veille après 30 minutes d'inactivité
- ⚠️ Limite de 1GB RAM, 1GB stockage

#### **STUN Google**
- ✅ Gratuit et fiable
- ❌ Pas de serveur TURN (peut limiter les connexions derrière certains NAT)
- ✅ Suffisant pour la plupart des connexions

### 🚀 Commandes de Déploiement

```bash
# 1. Cloner et préparer
git clone https://github.com/VOTRE-USERNAME/videochatsapp.git
cd videochatsapp

# 2. Déployer le backend sur Railway
cd server
npm install
railway login
railway link
railway deploy

# 3. Déployer le frontend sur GitHub
cd ../
git add public/
git commit -m "Frontend mis à jour"
git push origin main

# 4. Vérifier les déploiements
curl https://VOTRE-APP.railway.app
# Vérifier GitHub Pages : https://VOTRE-USERNAME.github.io/videochatsapp/
```

### 🔍 Tests de Fonctionnement

1. **Tester le backend**
   ```bash
   curl https://VOTRE-APP.railway.app
   # Doit retourner "Cannot GET /"
   ```

2. **Tester le frontend**
   - Ouvrir `https://VOTRE-USERNAME.github.io/videochatsapp/`
   - Vérifier que l'interface s'affiche

3. **Tester WebRTC**
   - Ouvrir l'application dans 2 onglets différents
   - Créer une salle dans l'un
   - Rejoindre avec l'autre
   - Vérifier la connexion vidéo

### 🛠️ Dépannage

#### **Problème : WebRTC ne fonctionne pas**
- Vérifier que les URLs sont en HTTPS
- Vérifier la console du navigateur pour les erreurs CORS
- Tester avec différents navigateurs

#### **Problème : Connexion Socket.io échoue**
- Vérifier que l'URL Railway est correcte
- Vérifier que le CORS est configuré dans server.js
- Vérifier les logs Railway

#### **Problème : Performance dégradée**
- Les services gratuits peuvent avoir des limites
- Railway peut se mettre en veille
- Considérer une upgrade payante si nécessaire

### 📊 Coûts Finaux

| Service | Coût | Limites |
|---------|------|---------|
| GitHub Pages | 0€ | Public repository |
| Railway | 0€ | 500h/mois, mise en veille |
| STUN Google | 0€ | Illimité |
| **Total** | **0€** | **Usage personnel/modéré** |

### 🎉 Félicitations !

Votre application VideoChatsApp est maintenant en ligne et accessible gratuitement dans le monde entier !

**URLs finales :**
- Interface : `https://VOTRE-USERNAME.github.io/videochatsapp/`
- API : `https://VOTRE-APP.railway.app`