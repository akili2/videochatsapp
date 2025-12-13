#!/bin/bash

# 🚀 Script de Déploiement Automatique - VideoChatsApp Template
# Configuration: GitHub Pages + Railway + STUN gratuit

set -e  # Arrêter en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction d'affichage
print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 VideoChatsApp Template                ║"
    echo "║                  Déploiement Automatique                     ║"
    echo "║                   GitHub Pages + Railway                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}📋 $1${NC}"
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

# Vérification des prérequis
check_prerequisites() {
    print_step "Vérification des prérequis..."
    
    local errors=0
    
    # Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js n'est pas installé. Installez Node.js 18+ depuis https://nodejs.org"
        errors=$((errors + 1))
    else
        local node_version=$(node --version | cut -d'v' -f2)
        print_success "Node.js $node_version détecté"
    fi
    
    # npm
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé"
        errors=$((errors + 1))
    else
        print_success "npm $(npm --version) détecté"
    fi
    
    # git
    if ! command -v git &> /dev/null; then
        print_error "git n'est pas installé"
        errors=$((errors + 1))
    else
        print_success "git détecté"
    fi
    
    # Railway CLI (optionnel mais recommandé)
    if ! command -v railway &> /dev/null; then
        print_warning "Railway CLI non trouvé. Installation recommandée."
        print_info "npm install -g @railway/cli"
    else
        print_success "Railway CLI détecté"
    fi
    
    if [ $errors -gt 0 ]; then
        print_error "Prérequis manquants. Installez-les avant de continuer."
        exit 1
    fi
}

# Configuration interactive
interactive_setup() {
    print_step "Configuration interactive..."
    
    echo ""
    echo "🔧 Configuration du projet"
    echo "========================="
    
    read -p "Votre nom d'utilisateur GitHub: " GITHUB_USERNAME
    read -p "Nom du repository (défaut: videochatsapp): " REPO_NAME
    
    if [ -z "$REPO_NAME" ]; then
        REPO_NAME="videochatsapp"
    fi
    
    echo ""
    print_info "Configuration sélectionnée :"
    echo "  👤 Utilisateur GitHub: $GITHUB_USERNAME"
    echo "  📦 Repository: $REPO_NAME"
    echo "  🌐 Frontend: https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
    echo "  ⚙️  Backend: Railway (URL sera fournie après déploiement)"
    
    echo ""
    read -p "Confirmer la configuration ? (y/N): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        print_error "Déploiement annulé."
        exit 1
    fi
}

# Préparation du projet
prepare_project() {
    print_step "Préparation du projet..."
    
    # Créer le dossier docs s'il n'existe pas
    mkdir -p docs
    
    # Créer un fichier .gitignore s'il n'existe pas
    if [ ! -f .gitignore ]; then
        cat > .gitignore << EOF
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Dependency directories
node_modules/
.pnp
.pnp.js

# Testing
coverage/

# Production builds
dist/
build/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Railway
.railway
EOF
        print_success "Fichier .gitignore créé"
    fi
    
    print_success "Projet préparé"
}

# Installation des dépendances
install_dependencies() {
    print_step "Installation des dépendances..."
    
    # Dépendances du projet principal
    npm install
    if [ $? -eq 0 ]; then
        print_success "Dépendances principales installées"
    else
        print_error "Erreur lors de l'installation des dépendances principales"
        exit 1
    fi
    
    # Dépendances du backend
    cd server
    npm install
    if [ $? -eq 0 ]; then
        print_success "Dépendances backend installées"
    else
        print_error "Erreur lors de l'installation des dépendances backend"
        exit 1
    fi
    cd ..
    
    # Installation Railway CLI si pas déjà fait
    if ! command -v railway &> /dev/null; then
        print_info "Installation de Railway CLI..."
        npm install -g @railway/cli
        if [ $? -eq 0 ]; then
            print_success "Railway CLI installé"
        else
            print_warning "Impossible d'installer Railway CLI. Vous devrez l'installer manuellement."
        fi
    fi
}

# Configuration des fichiers
configure_files() {
    print_step "Configuration des fichiers pour le déploiement..."
    
    # Sauvegarder les fichiers originaux
    cp public/script.js public/script.js.backup
    cp server/index.js server/index.js.backup
    
    # Configuration du client
    print_info "Configuration du client pour $GITHUB_USERNAME..."
    sed -i.bak "s|YOUR_USERNAME|$GITHUB_USERNAME|g" public/script.js
    sed -i.bak "s|videochatsapp|$REPO_NAME|g" public/script.js
    
    # Configuration du serveur
    print_info "Configuration du serveur pour $GITHUB_USERNAME..."
    sed -i.bak "s|YOUR_USERNAME|$GITHUB_USERNAME|g" server/index.js
    sed -i.bak "s|videochatsapp-template|$REPO_NAME|g" server/index.js
    
    # Configuration package.json principal
    sed -i.bak "s|YOUR_USERNAME|$GITHUB_USERNAME|g" package.json
    sed -i.bak "s|videochatsapp-template|$REPO_NAME|g" package.json
    
    print_success "Fichiers configurés"
}

# Instructions de déploiement
show_deployment_instructions() {
    echo ""
    print_banner
    echo ""
    print_step "🎯 Instructions de Déploiement"
    echo ""
    
    echo "📋 ÉTAPE 1: Backend sur Railway"
    echo "==============================="
    echo "1. Allez sur https://railway.app"
    echo "2. Connectez-vous avec votre compte GitHub"
    echo "3. Cliquez sur 'New Project'"
    echo "4. Sélectionnez 'Deploy from GitHub repo'"
    echo "5. Choisissez ce repository: $GITHUB_USERNAME/$REPO_NAME"
    echo "6. Sélectionnez le dossier 'server'"
    echo "7. Cliquez sur 'Deploy'"
    echo ""
    echo "⏱️  Attendez 2-3 minutes pour le déploiement..."
    echo "📋 Une fois déployé, notez l'URL Railway (ex: https://app-name.railway.app)"
    echo ""
    
    echo "📋 ÉTAPE 2: Configuration de l'URL Railway"
    echo "=========================================="
    echo "Après avoir récupéré l'URL Railway, exécutez cette commande :"
    echo ""
    echo -e "${YELLOW}# Modifiez public/script.js ligne 2 :${NC}"
    echo 'const BACKEND_URL = "https://VOTRE-URL-RAILWAY.railway.app";'
    echo ""
    
    echo "📋 ÉTAPE 3: Frontend sur GitHub Pages"
    echo "====================================="
    echo "1. Poussez le code sur GitHub :"
    echo "   git init"
    echo "   git add ."
    echo "   git commit -m 'Initial deployment'"
    echo "   git branch -M main"
    echo "   git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo "   git push -u origin main"
    echo ""
    echo "2. Activez GitHub Pages :"
    echo "   - Allez dans Settings > Pages"
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main / (root)"
    echo "   - Folder: /public"
    echo ""
    echo "⏱️  Attendez 2-5 minutes pour l'activation..."
    echo ""
    
    echo "🎉 ÉTAPE 4: Test Final"
    echo "======================"
    echo "1. Backend: https://VOTRE-URL-RAILWAY.railway.app/health"
    echo "2. Frontend: https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
    echo ""
    print_success "Votre application sera accessible aux URLs ci-dessus !"
    echo ""
    
    echo "🔧 Commandes Utiles"
    echo "==================="
    echo "# Voir les logs Railway"
    echo "railway logs"
    echo ""
    echo "# Redéployer Railway"
    echo "railway up"
    echo ""
    echo "# Tester localement"
    echo "npm run dev"
    echo ""
}

# Menu principal
main_menu() {
    echo ""
    print_step "Sélectionnez une action :"
    echo ""
    echo "1. 🚀 Déploiement automatique complet"
    echo "2. 🔧 Configuration manuelle (recommandé)"
    echo "3. 📋 Afficher les instructions de déploiement"
    echo "4. 🧪 Test en local"
    echo "5. ❌ Quitter"
    echo ""
    read -p "Votre choix (1-5): " choice
    
    case $choice in
        1)
            print_warning "Mode automatique sélectionné"
            interactive_setup
            check_prerequisites
            prepare_project
            install_dependencies
            configure_files
            show_deployment_instructions
            ;;
        2)
            print_warning "Mode manuel sélectionné"
            interactive_setup
            check_prerequisites
            prepare_project
            show_deployment_instructions
            ;;
        3)
            show_deployment_instructions
            ;;
        4)
            print_info "Lancement du test local..."
            npm run dev
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
    print_banner
    main_menu
}

# Exécution si le script est lancé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi