#!/bin/bash

# 🚀 Script de Publication GitHub - VideoChatsApp Template
# Repository: akili2/videochatsapp-template

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
    echo "║               🚀 Publication GitHub                          ║"
    echo "║            akili2/videochatsapp-template                     ║"
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

# Vérification de l'authentification GitHub
check_github_auth() {
    print_step "Vérification de l'authentification GitHub..."
    
    if ! command -v git &> /dev/null; then
        print_error "git. Installez git n'est pas installé d'abord."
        exit 1
    fi
    
    # Vérifier si l'utilisateur est connecté à GitHub
    if ! git config user.name &> /dev/null || ! git config user.email &> /dev/null; then
        print_warning "Configuration git manquante. Configuration..."
        read -p "Votre nom pour git: " git_name
        read -p "Votre email pour git: " git_email
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        print_success "Configuration git mise à jour"
    else
        print_success "Configuration git détectée:"
        echo "  Nom: $(git config user.name)"
        echo "  Email: $(git config user.email)"
    fi
    
    # Vérifier l'authentification GitHub
    print_info "Vérification de l'authentification GitHub..."
    if ! gh auth status &> /dev/null; then
        print_warning "GitHub CLI (gh) non configuré ou non connecté."
        print_info "Vous devrez vous authentifier manuellement ou utiliser un token."
    else
        print_success "GitHub CLI configuré"
    fi
}

# Préparation du repository
prepare_repository() {
    print_step "Préparation du repository..."
    
    # Initialiser git si nécessaire
    if [ ! -d .git ]; then
        print_info "Initialisation du repository git..."
        git init
        print_success "Repository git initialisé"
    else
        print_info "Repository git déjà initialisé"
    fi
    
    # Vérifier si le remote existe déjà
    if git remote get-url origin &> /dev/null; then
        print_info "Remote origin déjà configuré"
        current_remote=$(git remote get-url origin)
        if [[ "$current_remote" != *"akili2/videochatsapp-template"* ]]; then
            print_warning "Remote actuel différent du repository attendu"
            read -p "Voulez-vous changer le remote ? (y/N): " change_remote
            if [[ $change_remote == [yY] || $change_remote == [yY][eE][sS] ]]; then
                git remote set-url origin https://github.com/akili2/videochatsapp-template.git
                print_success "Remote mis à jour"
            fi
        fi
    else
        print_info "Ajout du remote origin..."
        git remote add origin https://github.com/akili2/videochatsapp-template.git
        print_success "Remote origin ajouté"
    fi
}

# Configuration des fichiers
configure_files() {
    print_step "Configuration des fichiers pour akili2/videochatsapp-template..."
    
    # Mettre à jour package.json
    print_info "Mise à jour de package.json..."
    sed -i.bak 's|"repository": {|"repository": {\
    "type": "git",\
    "url": "https://github.com/akili2/videochatsapp-template.git"|' package.json
    sed -i.bak 's|"homepage": "https://YOUR_USERNAME.github.io/|"homepage": "https://akili2.github.io/|' package.json
    sed -i.bak 's|"bugs": {|"bugs": {\
    "url": "https://github.com/akili2/videochatsapp-template/issues"|' package.json
    
    # Nettoyer les fichiers de sauvegarde
    rm -f *.bak server/*.bak public/*.bak
    
    print_success "Fichiers configurés pour akili2/videochatsapp-template"
}

# Commit et push
commit_and_push() {
    print_step "Commit et push vers GitHub..."
    
    # Ajouter tous les fichiers
    print_info "Ajout des fichiers..."
    git add .
    
    # Vérifier s'il y a des changements
    if git diff --staged --quiet; then
        print_warning "Aucun changement à commiter"
        return 0
    fi
    
    # Commit
    print_info "Création du commit..."
    git commit -m "🚀 Initial commit: VideoChatsApp Template

✨ Features:
- WebRTC video chat application
- Socket.io real-time communication  
- Free deployment: GitHub Pages + Railway + STUN
- Interactive deployment script
- Complete documentation

🌐 Deploy at: akili2.github.io/videochatsapp-template"
    
    # Push vers GitHub
    print_info "Push vers GitHub..."
    
    # Créer la branche main si elle n'existe pas
    git branch -M main
    
    # Tenter le push
    if git push -u origin main; then
        print_success "Repository publié avec succès !"
        echo ""
        echo "🎉 FÉLICITATIONS !"
        echo "=================="
        echo "✅ Repository: https://github.com/akili2/videochatsapp-template"
        echo "✅ Code poussé avec succès"
        echo ""
        echo "🔗 Prochaines étapes :"
        echo "1. Activez GitHub Pages :"
        echo "   - Allez sur https://github.com/akili2/videochatsapp-template/settings/pages"
        echo "   - Source: Deploy from a branch"
        echo "   - Branch: main / (root)"
        echo "   - Folder: /public"
        echo ""
        echo "2. Déployez le backend sur Railway :"
        echo "   - railway.app > New Project > Deploy from GitHub repo"
        echo "   - Sélectionnez: akili2/videochatsapp-template"
        echo "   - Choisir dossier: server"
        echo ""
        echo "3. Configurez l'URL Railway dans public/script.js ligne 2"
        echo ""
        print_success "Votre repository est prêt ! 🎊"
    else
        print_error "Erreur lors du push. Solutions possibles :"
        echo ""
        echo "🔧 Solutions :"
        echo "1. Vérifiez que le repository existe sur GitHub :"
        echo "   https://github.com/akili2/videochatsapp-template"
        echo ""
        echo "2. Si le repository n'existe pas, créez-le manuellement :"
        echo "   - Allez sur https://github.com/new"
        echo "   - Repository name: videochatsapp-template"
        echo "   - Owner: akili2"
        echo "   - Public (requis pour GitHub Pages)"
        echo "   - Ne pas initialiser avec README"
        echo ""
        echo "3. Authentification GitHub :"
        echo "   - Utilisez un Personal Access Token au lieu du mot de passe"
        echo "   - Ou configurez SSH keys"
        echo ""
        echo "4. Relancez ce script après avoir créé le repository"
        echo ""
    fi
}

# Affichage des instructions post-déploiement
show_post_deployment_instructions() {
    echo ""
    print_step "📋 Instructions Post-Déploiement"
    echo ""
    echo "🎯 Après avoir publié sur GitHub :"
    echo ""
    echo "1️⃣  GITHUB PAGES (Frontend)"
    echo "   🔗 URL: https://akili2.github.io/videochatsapp-template/"
    echo "   📋 Actions:"
    echo "      • Aller sur Settings > Pages"
    echo "      • Source: Deploy from a branch"
    echo "      • Branch: main / (root)"
    echo "      • Folder: /public"
    echo ""
    echo "2️⃣  RAILWAY (Backend)"
    echo "   🔗 URL: https://votre-app.railway.app"
    echo "   📋 Actions:"
    echo "      • railway.app > Login with GitHub"
    echo "      • New Project > Deploy from GitHub repo"
    echo "      • Sélectionner: akili2/videochatsapp-template"
    echo "      • Dossier: server"
    echo "      • Déployer (2-3 minutes)"
    echo ""
    echo "3️⃣  CONFIGURATION FINALE"
    echo "   📋 Modifier public/script.js ligne 2 :"
    echo '      const BACKEND_URL = "https://VOTRE-APP.railway.app";'
    echo ""
    echo "4️⃣  TEST FINAL"
    echo "   🔗 Ouvrir: https://akili2.github.io/videochatsapp-template/"
    echo "   🧪 Créer une salle et tester avec 2 navigateurs"
    echo ""
    print_success "Repository configuré pour akili2/videochatsapp-template !"
}

# Menu principal
main_menu() {
    print_banner
    echo ""
    print_step "Sélectionnez une action :"
    echo ""
    echo "1. 🚀 Publication automatique complète"
    echo "2. 🔧 Configuration git uniquement"
    echo "3. 📋 Afficher les instructions"
    echo "4. ❌ Quitter"
    echo ""
    read -p "Votre choix (1-4): " choice
    
    case $choice in
        1)
            print_warning "Publication automatique sélectionnée"
            check_github_auth
            prepare_repository
            configure_files
            commit_and_push
            show_post_deployment_instructions
            ;;
        2)
            print_warning "Configuration git uniquement"
            check_github_auth
            prepare_repository
            configure_files
            print_success "Configuration terminée"
            ;;
        3)
            show_post_deployment_instructions
            ;;
        4)
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