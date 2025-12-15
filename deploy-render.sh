#!/bin/bash

# 🚀 Script de Déploiement Render - VideoChatsApp
# Configuration: GitHub Pages + Render + STUN gratuit

set -e  # Arrêter en cas d'erreur

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║               🚀 Déploiement Render                          ║"
    echo "║            VideoChatsApp - Hébergement Gratuit              ║"
    echo "║               GitHub Pages + Render + STUN                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${CYAN}📋 $1${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    print_step "Vérification des prérequis..."
    
    local errors=0
    
    # Git
    if ! command -v git &> /dev/null; then
        print_error "git n'est pas installé"
        errors=$((errors + 1))
    else
        print_success "git détecté"
    fi
    
    # Node.js pour les tests locaux
    if command -v node &> /dev/null; then
        print_success "Node.js $(node --version) détecté"
    else
        print_warning "Node.js non installé (optionnel pour déploiement)"
    fi
    
    # Vérifier le repository GitHub
    print_info "Vérification du repository akili2/videochatsapp..."
    if curl -s -f https://github.com/akili2/videochatsapp > /dev/null; then
        print_success "Repository GitHub accessible"
    else
        print_warning "Repository GitHub non trouvé ou privé"
        print_info "Assurez-vous que le repository existe et est public"
    fi
}

# Préparation des fichiers pour Render
prepare_for_render() {
    print_step "Préparation des fichiers pour Render..."
    
    # Vérifier que render.yaml existe
    if [ ! -f render.yaml ]; then
        print_error "Fichier render.yaml manquant"
        exit 1
    fi
    
    # Vérifier la structure du serveur
    if [ ! -d server ]; then
        print_error "Dossier server/ manquant"
        exit 1
    fi
    
    if [ ! -f server/package.json ]; then
        print_error "server/package.json manquant"
        exit 1
    fi
    
    # Vérifier le serveur principal
    if [ ! -f server/index.js ]; then
        print_error "server/index.js manquant"
        exit 1
    fi
    
    # Vérifier les fichiers frontend
    if [ ! -d public ]; then
        print_error "Dossier public/ manquant"
        exit 1
    fi
    
    print_success "Structure des fichiers validée"
}

# Configuration des variables d'environnement
configure_environment() {
    print_step "Configuration des variables d'environnement..."
    
    # Créer un fichier .env pour les tests locaux
    cat > .env << EOF
# Configuration VideoChatsApp
NODE_ENV=production
PORT=3000

# URLs de déploiement (à modifier après déploiement)
RENDER_URL=https://videochatsapp.onrender.com
GITHUB_PAGES_URL=https://akili2.github.io/videochatsapp

# Configuration STUN
STUN_SERVERS=stun:stun.l.google.com:19302,stun:stun1.l.google.com:19302
EOF
    
    print_success "Fichier .env créé pour les tests locaux"
}

# Test local (optionnel)
test_locally() {
    print_step "Test local (optionnel)..."
    
    if command -v node &> /dev/null; then
        read -p "Voulez-vous tester l'application localement ? (y/N): " test_local
        
        if [[ $test_local == [yY] || $test_local == [yY][eE][sS] ]]; then
            print_info "Installation des dépendances..."
            cd server
            npm install
            cd ..
            
            print_info "Lancement du serveur local..."
            print_warning "Ouvrez http://localhost:3000 dans votre navigateur"
            print_warning "Appuyez sur Ctrl+C pour arrêter"
            
            cd server
            npm start
            cd ..
        fi
    else
        print_warning "Node.js non installé, test local ignoré"
    fi
}

# Instructions de déploiement Render
show_render_instructions() {
    echo ""
    print_step "🚀 Instructions de Déploiement Render"
    echo ""
    
    echo "📋 ÉTAPE 1: Création du Service"
    echo "==============================="
    echo "1. Allez sur https://render.com"
    echo "2. Connectez-vous avec votre compte GitHub"
    echo "3. Cliquez sur 'New +' puis 'Web Service'"
    echo "4. Sélectionnez 'Build and deploy from a Git repository'"
    echo "5. Choisissez: akili2/videochatsapp"
    echo ""
    
    echo "📋 ÉTAPE 2: Configuration du Service"
    echo "==================================="
    echo "Configurez ces paramètres :"
    echo ""
    echo "  📝 Name: videochatsapp"
    echo "  🌎 Region: Frankfurt (EU) ou Oregon (US)"
    echo "  🌿 Branch: main"
    echo "  📁 Root Directory: (laisser vide)"
    echo "  🔧 Runtime: Node"
    echo "  ⚙️  Build Command: cd server && npm install"
    echo "  ▶️  Start Command: cd server && npm start"
    echo "  💰 Plan: Free"
    echo ""
    
    echo "📋 ÉTAPE 3: Variables d'Environnement"
    echo "====================================="
    echo "Ajoutez ces variables dans la section 'Environment' :"
    echo ""
    echo "  NODE_ENV=production"
    echo "  PORT=10000"
    echo ""
    
    echo "📋 ÉTAPE 4: Déploiement"
    echo "======================="
    echo "1. Cliquez sur 'Create Web Service'"
    echo "2. Attendez le build (2-3 minutes)"
    echo "3. Votre app sera disponible à l'URL fournie"
    echo ""
    
    echo "🎯 URL attendue : https://videochatsapp.onrender.com"
    echo ""
    
    echo "📋 ÉTAPE 5: Configuration Frontend"
    echo "=================================="
    echo "Après le déploiement Render :"
    echo "1. Activez GitHub Pages :"
    echo "   - https://github.com/akili2/videochatsapp/settings/pages"
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main / (root)"
    echo "   - Folder: /public"
    echo ""
    echo "2. Modifiez public/script.js ligne 2 :"
    echo '   const BACKEND_URL = "https://videochatsapp.onrender.com";'
    echo ""
    
    print_success "Instructions Render affichées"
}

# Affichage des tests post-déploiement
show_post_deployment_tests() {
    echo ""
    print_step "🧪 Tests Post-Déploiement"
    echo ""
    
    echo "🔗 URLs à tester :"
    echo "=================="
    echo ""
    echo "1. Backend Render :"
    echo "   curl https://videochatsapp.onrender.com/health"
    echo "   # Doit retourner: {\"status\":\"OK\",...}"
    echo ""
    echo "2. Frontend GitHub Pages :"
    echo "   curl -I https://akili2.github.io/videochatsapp/"
    echo "   # Doit retourner: HTTP 200"
    echo ""
    echo "3. Application complète :"
    echo "   - Ouvrir: https://akili2.github.io/videochatsapp/"
    echo "   - Créer une salle dans un onglet"
    echo "   - Rejoindre avec un autre navigateur"
    echo "   - Vérifier la connexion vidéo"
    echo ""
    
    echo "🎊 Résultat Final Attendu :"
    echo "==========================="
    echo "✅ Backend: https://videochatsapp.onrender.com"
    echo "✅ Frontend: https://akili2.github.io/videochatsapp/"
    echo "✅ WebRTC: Fonctionnel avec STUN Google"
    echo "✅ Chat: Temps réel avec Socket.io"
    echo ""
    print_success "Votre VideoChatsApp sera accessible mondialement !"
}

# Menu principal
main_menu() {
    print_banner
    echo ""
    print_step "Sélectionnez une action :"
    echo ""
    echo "1. 🚀 Préparation complète pour Render"
    echo "2. 🧪 Test local (optionnel)"
    echo "3. 📋 Afficher les instructions de déploiement"
    echo "4. 🧪 Afficher les tests post-déploiement"
    echo "5. ❌ Quitter"
    echo ""
    read -p "Votre choix (1-5): " choice
    
    case $choice in
        1)
            print_warning "Préparation complète sélectionnée"
            check_prerequisites
            prepare_for_render
            configure_environment
            show_render_instructions
            show_post_deployment_tests
            ;;
        2)
            print_warning "Test local sélectionné"
            check_prerequisites
            prepare_for_render
            test_locally
            ;;
        3)
            show_render_instructions
            ;;
        4)
            show_post_deployment_tests
            ;;
        5)
            print_info "Au revoir ! 👋"
            exit 0
            ;;
        *)
            print_error "Option invalide"
            main_menu
            ;;
    esac
}

# Script principal
main() {
    main_menu
}

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi