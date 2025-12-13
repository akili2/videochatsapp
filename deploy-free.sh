#!/bin/bash

# Script de déploiement automatique pour VideoChatsApp
# Configuration gratuite : GitHub Pages + Railway + STUN gratuit

echo "🚀 Déploiement VideoChatsApp - Configuration Gratuite"
echo "=================================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage colorisé
print_status() {
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
    print_info "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js n'est pas installé. Installez Node.js d'abord."
        exit 1
    fi
    print_status "Node.js $(node --version) détecté"
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        print_error "npm n'est pas installé."
        exit 1
    fi
    print_status "npm $(npm --version) détecté"
    
    # Vérifier git
    if ! command -v git &> /dev/null; then
        print_error "git n'est pas installé."
        exit 1
    fi
    print_status "git détecté"
}

# Configuration interactive
configure_project() {
    print_info "Configuration du projet..."
    
    echo ""
    echo "Veuillez fournir les informations suivantes :"
    read -p "Votre nom d'utilisateur GitHub: " GITHUB_USERNAME
    read -p "Nom du repository (laisser vide pour 'videochatsapp'): " REPO_NAME
    
    if [ -z "$REPO_NAME" ]; then
        REPO_NAME="videochatsapp"
    fi
    
    echo ""
    print_info "Configuration :"
    echo "  - Utilisateur GitHub: $GITHUB_USERNAME"
    echo "  - Repository: $REPO_NAME"
    echo ""
    
    read -p "Confirmer ? (y/N): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        print_error "Déploiement annulé."
        exit 1
    fi
}

# Installation des dépendances
install_dependencies() {
    print_info "Installation des dépendances..."
    
    # Dépendances du backend
    cd server
    npm install
    if [ $? -eq 0 ]; then
        print_status "Dépendances backend installées"
    else
        print_error "Erreur lors de l'installation des dépendances backend"
        exit 1
    fi
    cd ..
    
    # Installation Railway CLI
    if ! command -v railway &> /dev/null; then
        print_info "Installation de Railway CLI..."
        npm install -g @railway/cli
    fi
    print_status "Railway CLI prêt"
}

# Configuration du serveur pour la production
configure_server() {
    print_info "Configuration du serveur pour la production..."
    
    # Sauvegarde du serveur original
    cp server/server.js server/server.js.backup
    
    # Configuration CORS pour GitHub Pages
    sed -i.bak "s|VOTRE-USERNAME|$GITHUB_USERNAME|g" server/server.js
    
    print_status "Configuration CORS mise à jour"
}

# Configuration du client
configure_client() {
    print_info "Configuration du client..."
    
    # Créer un fichier de configuration temporaire
    cat > client-config.js << EOF
// Configuration pour le déploiement gratuit
window.APP_CONFIG = {
    backendUrl: "REPLACE_WITH_RAILWAY_URL",
    githubPagesUrl: "https://$GITHUB_USERNAME.github.io/$REPO_NAME"
};
EOF
    
    sed -i.bak "s|REPLACE_WITH_RAILWAY_URL|https://YOUR-RAILWAY-APP.railway.app|g" client-config.js
    sed -i.bak "s|VOTRE-USERNAME|$GITHUB_USERNAME|g" client-config.js
    sed -i.bak "s|videochatsapp|$REPO_NAME|g" client-config.js
    
    print_status "Configuration client créée"
}

# Instructions de déploiement
show_deployment_instructions() {
    echo ""
    print_info "🎯 Étapes de déploiement suivantes :"
    echo ""
    echo "1️⃣  BACKEND (Railway) :"
    echo "   cd server"
    echo "   railway login"
    echo "   railway init"
    echo "   railway up"
    echo ""
    echo "2️⃣  FRONTEND (GitHub Pages) :"
    echo "   git init"
    echo "   git add ."
    echo "   git commit -m 'VideoChatsApp - Configuration gratuite'"
    echo "   git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo "   git push -u origin main"
    echo ""
    echo "3️⃣  CONFIGURATION FINALE :"
    echo "   - Récupérer l'URL Railway"
    echo "   - Modifier public/script.js ligne 1 :"
    echo "     const socket = io('URL_RAILWAY');"
    echo "   - Activer GitHub Pages dans Settings > Pages"
    echo ""
    echo "4️⃣  TEST :"
    echo "   - Ouvrir https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
    echo "   - Créer une salle et tester la connexion"
    echo ""
}

# Menu principal
show_menu() {
    echo ""
    echo "🔧 Options de déploiement :"
    echo "1. Déploiement automatique complet"
    echo "2. Configuration manuelle (recommandé)"
    echo "3. Afficher les instructions"
    echo "4. Quitter"
    echo ""
    read -p "Choisissez une option (1-4): " choice
    
    case $choice in
        1)
            print_warning "Mode automatique sélectionné"
            configure_project
            check_prerequisites
            install_dependencies
            configure_server
            configure_client
            show_deployment_instructions
            ;;
        2)
            print_warning "Mode manuel sélectionné"
            configure_project
            check_prerequisites
            show_deployment_instructions
            ;;
        3)
            cat << EOF

📚 GUIDE DE DÉPLOIEMENT GRATUIT

🌐 Architecture :
  Frontend (GitHub Pages) ←→ Backend (Railway) ←→ STUN (Google)

💰 Coût total : 0€

📋 Étapes :

1. GitHub Pages :
   - Créer repository public
   - Pousser le dossier 'public/'
   - Activer GitHub Pages

2. Railway :
   - railway.app
   - Connecter repository
   - Déployer dossier 'server/'

3. Configuration :
   - Modifier URLs dans public/script.js
   - Configurer CORS dans server/server.js

✅ Test final :
   - Ouvrir l'application
   - Créer/rejoindre une salle
   - Vérifier vidéo + chat

EOF
            ;;
        4)
            print_info "Au revoir !"
            exit 0
            ;;
        *)
            print_error "Option invalide"
            show_menu
            ;;
    esac
}

# Script principal
main() {
    echo ""
    print_info "Script de déploiement VideoChatsApp - Budget 0€"
    echo "GitHub Pages + Railway + STUN gratuit"
    echo ""
    
    show_menu
}

# Vérification si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi