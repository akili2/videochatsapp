# 🚀 Guide de Publication GitHub - akili2/videochatsapp-template

## ⚡ Publication en 1 Commande

```bash
chmod +x publish-to-github.sh && ./publish-to-github.sh
```

## 🎯 Configuration Automatique

**Repository cible :**
- **Utilisateur** : `akili2`
- **Repository** : `videochatsapp-template`
- **URL finale** : `https://github.com/akili2/videochatsapp-template`

## 📋 Processus Automatique

### **Le script `publish-to-github.sh` fait tout pour vous :**

1. ✅ **Vérification de l'authentification GitHub**
2. ✅ **Configuration git** (nom, email)
3. ✅ **Initialisation du repository** si nécessaire
4. ✅ **Configuration des URLs** (akili2/videochatsapp-template)
5. ✅ **Commit automatique** avec message détaillé
6. ✅ **Push vers GitHub** (branche main)
7. ✅ **Instructions post-déploiement**

## 🔧 Commandes Manuelles (si le script échoue)

### **1. Création du repository GitHub**
```bash
# Aller sur https://github.com/new
# Repository name: videochatsapp-template
# Owner: akili2
# Public (requis pour GitHub Pages)
# Ne pas initialiser avec README
```

### **2. Configuration git**
```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"
```

### **3. Push manuel**
```bash
git init
git add .
git commit -m "🚀 Initial commit: VideoChatsApp Template"
git branch -M main
git remote add origin https://github.com/akili2/videochatsapp-template.git
git push -u origin main
```

## 📁 Fichiers Configurés Automatiquement

Le script configure ces fichiers pour `akili2/videochatsapp-template` :

- **`package.json`** : URLs du repository et homepage
- **`server/index.js`** : CORS origins pour GitHub Pages
- **`public/script.js`** : Configuration du backend
- **README.md** : Badges et liens vers votre repository

## 🌐 Après la Publication

### **URLs Attendues**
- **Repository** : `https://github.com/akili2/videochatsapp-template`
- **GitHub Pages** : `https://akili2.github.io/videochatsapp-template/`
- **Backend Railway** : `https://votre-app.railway.app` (à déployer)

### **Étapes Post-Publication**

1. **Activer GitHub Pages**
   ```
   Repository > Settings > Pages > Source: main / (root) > Folder: /public
   ```

2. **Déployer le Backend sur Railway**
   ```
   railway.app > New Project > Deploy from GitHub repo
   > Sélectionner: akili2/videochatsapp-template
   > Dossier: server
   ```

3. **Configuration Finale**
   ```javascript
   // Modifier public/script.js ligne 2
   const BACKEND_URL = "https://VOTRE-APP.railway.app";
   ```

## 🛡️ Dépannage

### **Erreur d'authentification**
```bash
# Utiliser un Personal Access Token au lieu du mot de passe
# Ou configurer les SSH keys
ssh-keygen -t ed25519 -C "votre.email@exemple.com"
```

### **Repository n'existe pas**
```bash
# Créer le repository manuellement sur GitHub.com
# Puis relancer le script
```

### **Erreur de remote**
```bash
# Vérifier le remote
git remote -v

# Changer le remote si nécessaire
git remote set-url origin https://github.com/akili2/videochatsapp-template.git
```

## ✅ Vérification du Déploiement

```bash
# Vérifier le repository
curl -I https://github.com/akili2/videochatsapp-template

# Vérifier GitHub Pages (après activation)
curl -I https://akili2.github.io/videochatsapp-template/

# Vérifier le backend (après déploiement Railway)
curl https://VOTRE-APP.railway.app/health
```

## 🎉 Résultat Final

Après exécution réussie :

```
🎊 FÉLICITATIONS !
==================
✅ Repository: https://github.com/akili2/videochatsapp-template
✅ Code poussé avec succès

🔗 Prochaines étapes :
1. Activer GitHub Pages
2. Déployer le backend sur Railway  
3. Configurer l'URL Railway
4. Tester l'application
```

**Votre VideoChatsApp template sera accessible à :**
- **Interface** : `https://akili2.github.io/videochatsapp-template/`
- **Backend** : `https://votre-app.railway.app`

---

**💡 Astuce :** Relancez `./publish-to-github.sh` si vous modifiez des fichiers et souhaitez les pousser à nouveau.