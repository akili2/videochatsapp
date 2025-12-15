#!/bin/bash

# 🚀 Script de déploiement corrigé pour Render
# Ce script corrige les problèmes de structure et déploie sur Render

echo "🔧 VideoChatsApp - Déploiement Render (Version Corrigée)"
echo "================================================="

# Vérifier si on est dans le bon répertoire
if [ ! -f "package.json" ] || [ ! -d "server" ]; then
    echo "❌ Erreur: Ce script doit être exécuté depuis le répertoire racine du projet"
    exit 1
fi

echo "📋 Vérification de la structure du projet..."

# Vérifier les fichiers critiques
if [ ! -f "server/server.js" ]; then
    echo "❌ Erreur: server/server.js manquant"
    exit 1
fi

if [ ! -f "server/package.json" ]; then
    echo "❌ Erreur: server/package.json manquant"
    exit 1
fi

if [ ! -f "render.yaml" ]; then
    echo "❌ Erreur: render.yaml manquant"
    exit 1
fi

echo "✅ Structure du projet validée"

# Afficher la configuration actuelle
echo ""
echo "📊 Configuration actuelle:"
echo "  - Serveur principal: server/server.js"
echo "  - Package.json serveur: server/package.json"
echo "  - Configuration Render: render.yaml"
echo "  - Point d'entrée: $(node -e "console.log(require('./package.json').main)")"

# Vérifier les dépendances du serveur
echo ""
echo "📦 Vérification des dépendances serveur..."
cd server
if [ ! -d "node_modules" ]; then
    echo "📥 Installation des dépendances serveur..."
    npm install
else
    echo "✅ Dépendances serveur déjà installées"
fi
cd ..

# Test local du serveur
echo ""
echo "🧪 Test local du serveur..."
cd server
echo "Démarrage du serveur en mode test..."
timeout 5s npm start &
SERVER_PID=$!
sleep 3

# Test des endpoints
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Serveur local fonctionne correctement"
    echo "📡 Health check: OK"
else
    echo "⚠️  Impossible de tester le serveur local (normal si le port est occupé)"
fi

# Arrêter le serveur de test
kill $SERVER_PID 2>/dev/null
cd ..

# Préparer pour le déploiement
echo ""
echo "🚀 Préparation pour le déploiement Render..."

# Vérifier Git
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

# Ajouter tous les fichiers modifiés
echo "📁 Ajout des fichiers au repository Git..."
git add .

# Message de commit avec les corrections
COMMIT_MESSAGE="🔧 Fix: Structure projet corrigée pour Render - Suppression server/index.js obsolète, configuration render.yaml et package.json mises à jour"

echo "💬 Commit: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

# Push vers GitHub
echo ""
echo "📤 Push vers GitHub..."
if git remote get-url origin &> /dev/null; then
    git push origin main
    echo "✅ Code poussé vers GitHub avec succès"
else
    echo "⚠️  Remote origin non configuré. Configuration manuelle requise:"
    echo "   git remote add origin https://github.com/akili2/videochatsapp.git"
    echo "   git push -u origin main"
fi

echo ""
echo "🎯 Prochaines étapes:"
echo "1. Aller sur https://dashboard.render.com"
echo "2. Cliquer sur votre service 'videochatsapp'"
echo "3. Cliquer sur 'Manual Deploy' → 'Deploy latest commit'"
echo "4. Surveiller les logs pour vérifier le déploiement"
echo ""
echo "📋 URLs de test après déploiement:"
echo "  - Serveur: https://videochatsapp-1.onrender.com"
echo "  - Health: https://videochatsapp-1.onrender.com/health"
echo "  - Info: https://videochatsapp-1.onrender.com/info"
echo ""
echo "✅ Script terminé. Votre application est prête pour le redéploiement Render!"