#!/bin/bash

# 🚀 Push vers Repository Existant - VideoChatsApp
# Repository: https://github.com/akili2/videochatsapp

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
    echo "║              🚀 Push vers Repository Existant               ║"
    echo "║            https://github.com/akili2/videochatsapp          ║"
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

# Configuration du repository
configure_repository() {
    print_step "Configuration du repository https://github.com/akili2/videochatsapp..."
    
    # Initialiser git si nécessaire
    if [ ! -d .git ]; then
        print_info "Initialisation du repository git..."
        git init
        print_success "Repository git initialisé"
    else
        print_info "Repository git déjà initialisé"
    fi
    
    # Vérifier/ajouter le remote
    if git remote get-url origin &> /dev/null; then
        current_remote=$(git remote get-url origin)
        if [[ "$current_remote" == *"akili2/videochatsapp"* ]]; then
            print_info "Remote origin déjà configuré pour akili2/videochatsapp"
        else
            print_warning "Changement du remote origin..."
            git remote set-url origin https://github.com/akili2/videochatsapp.git
            print_success "Remote origin mis à jour"
        fi
    else
        print_info "Ajout du remote origin..."
        git remote add origin https://github.com/akili2/videochatsapp.git
        print_success "Remote origin ajouté"
    fi
}

# Configuration git utilisateur
configure_git_user() {
    print_step "Configuration de l'utilisateur git..."
    
    # Vérifier si l'utilisateur est configuré
    if ! git config user.name &> /dev/null || ! git config user.email &> /dev/null; then
        print_warning "Configuration git manquante."
        echo ""
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
}

# Configuration des fichiers pour le repository videochatsapp
configure_files_for_videochatsapp() {
    print_step "Configuration des fichiers pour akili2/videochatsapp..."
    
    # Sauvegarder les fichiers originaux
    [ -f public/script.js ] && cp public/script.js public/script.js.backup
    [ -f server/index.js ] && cp server/index.js server/index.js.backup
    [ -f package.json ] && cp package.json package.json.backup
    
    # Configuration du client pour videochatsapp
    if [ -f public/script.js ]; then
        print_info "Configuration de public/script.js..."
        sed -i.bak 's|akili2.github.io/videochatsapp-template|akili2.github.io/videochatsapp|g' public/script.js
        sed -i.bak 's|YOUR_RAILWAY_APP_URL|YOUR_RAILWAY_APP_URL|g' public/script.js
    fi
    
    # Configuration du serveur pour videochatsapp
    if [ -f server/index.js ]; then
        print_info "Configuration de server/index.js..."
        sed -i.bak 's|akili2.github.io/videochatsapp-template|akili2.github.io/videochatsapp|g' server/index.js
    fi
    
    # Configuration de package.json pour videochatsapp
    if [ -f package.json ]; then
        print_info "Configuration de package.json..."
        sed -i.bak 's|"repository": {|"repository": {\
    "type": "git",\
    "url": "https://github.com/akili2/videochatsapp.git"|' package.json
        sed -i.bak 's|"homepage": "https://akili2.github.io/videochatsapp-template/|"homepage": "https://akili2.github.io/videochatsapp/"|' package.json
        sed -i.bak 's|"bugs": {|"bugs": {\
    "url": "https://github.com/akili2/videochatsapp/issues"|' package.json
    fi
    
    # Nettoyer les fichiers de sauvegarde
    rm -f *.bak server/*.bak public/*.bak
    
    print_success "Fichiers configurés pour akili2/videochatsapp"
}

# Vérification des fichiers à pousser
check_files_to_push() {
    print_step "Vérification des fichiers à pousser..."
    
    echo ""
    echo "📁 Structure des fichiers qui seront poussés :"
    echo "=============================================="
    
    # Lister les fichiers et dossiers
    find . -type f -not -path './.git/*' -not -name '*.backup' -not -path './node_modules/*' | sort | while read file; do
        echo "📄 $file"
    done
    
    echo ""
    echo "📊 Statistiques :"
    total_files=$(find . -type f -not -path './.git/*' -not -name '*.backup' -not -path './node_modules/*' | wc -l)
    total_size=$(du -sh . 2>/dev/null | cut -f1)
    echo "  📄 Fichiers: $total_files"
    echo "  💾 Taille: $total_size"
    echo ""
}

# Commit et push
commit_and_push() {
    print_step "Ajout des fichiers, commit et push..."
    
    # Ajouter tous les fichiers
    print_info "Ajout de tous les fichiers..."
    git add .
    
    # Vérifier s'il y a des changements
    if git diff --staged --quiet; then
        print_warning "Aucun changement à commiter"
        return 0
    fi
    
    # Créer le commit
    print_info "Création du commit..."
    git commit -m "🚀 Initial commit: VideoChatsApp - Application complète

✨ Fonctionnalités incluses:
- Chat vidéo en temps réel (WebRTC)
- Communication temps réel (Socket.io)
- Interface responsive (Tailwind CSS)
- Déploiement gratuit: GitHub Pages + Railway + STUN
- Scripts de déploiement automatisés
- Documentation complète

🌐 Application déployable sur:
- GitHub Pages: https://akili2.github.io/videochatsapp/
- Backend Railway: https://votre-app.railway.app

🛠️ Scripts inclus:
- deploy.sh: Déploiement automatique
- publish-to-github.sh: Publication GitHub
- Configuration STUN avec serveurs Google

📚 Documentation complète fournie"
    
    # Configurer la branche main
    print_info "Configuration de la branche main..."
    git branch -M main
    
    # Push vers GitHub
    print_info "Push vers https://github.com/akili2/videochatsapp..."
    
    if git push -u origin main; then
        print_success "🎉 SUCCÈS ! Repository mis à jour avec succès !"
        echo ""
        echo "🎊 FÉLICITATIONS !"
        echo "=================="
        echo "✅ Repository: https://github.com/akili2/videochatsapp"
        echo "✅ Branche: main"
        echo "✅ Code poussé avec succès"
        echo ""
        echo "🔗 Prochaines étapes :"
        echo "1. GitHub Pages (Frontend):"
        echo "   - https://github.com/akili2/videochatsapp/settings/pages"
        echo "   - Source: Deploy from a branch"
        echo "   - Branch: main / (root)"
        echo "   - Folder: /public"
        echo ""
        echo "2. Railway (Backend):"
        echo "   - railway.app > New Project > Deploy from GitHub repo"
        echo "   - Sélectionner: akili2/videochatsapp"
        echo "   - Dossier: server"
        echo ""
        echo "3. Configuration finale:"
        echo "   - Modifier public/script.js ligne 2:"
        echo '     const BACKEND_URL = "https://VOTRE-APP.railway.app";'
        echo ""
        print_success "Votre VideoChatsApp est prêt ! 🚀"
    else
        print_error "Erreur lors du push. Solutions possibles :"
        echo ""
        echo "🔧 Solutions :"
        echo "1. Vérifiez votre authentification GitHub :"
        echo "   - Utilisez un Personal Access Token au lieu du mot de passe"
        echo "   - Ou configurez SSH keys"
        echo ""
        echo "2. Vérifiez les permissions du repository :"
        echo "   - Vous devez avoir les droits d'écriture sur le repository"
        echo ""
        echo "3. Testez la connexion :"
        echo "   curl -I https://github.com/akili2/videochatsapp"
        echo ""
        echo "4. Push manuel :"
        echo "   git push -u origin main --force"
        echo ""
    fi
}

# Affichage des instructions post-push
show_post_push_instructions() {
    echo ""
    print_step "📋 Instructions Post-Push"
    echo ""
    echo "🎯 Votre repository est maintenant à jour :"
    echo "   https://github.com/akili2/videochatsapp"
    echo ""
    echo "📱 URLs finales attendues après déploiement :"
    echo "   Frontend: https://akili2.github.io/videochatsapp/"
    echo "   Backend:  https://VOTRE-APP.railway.app"
    echo ""
    echo "🧪 Test rapide :"
    echo "   curl -I https://github.com/akili2/videochatsapp"
    echo ""
    print_success "Repository akili2/videochatsapp configuré et poussé !"
}

# Menu principal
main_menu() {
    print_banner
    echo ""
    print_step "Sélectionnez une action :"
    echo ""
    echo "1. 🚀 Push complet automatique (recommandé)"
    echo "2. 🔧 Configuration uniquement"
    echo "3. 📋 Afficher les fichiers qui seront poussés"
    echo "4. 📖 Afficher les instructions"
    echo "5. ❌ Quitter"
    echo ""
    read -p "Votre choix (1-5): " choice
    
    case $choice in
        1)
            print_warning "Push complet automatique sélectionné"
            configure_git_user
            configure_repository
            configure_files_for_videochatsapp
            check_files_to_push
            commit_and_push
            show_post_push_instructions
            ;;
        2)
            print_warning "Configuration uniquement"
            configure_git_user
            configure_repository
            configure_files_for_videochatsapp
            print_success "Configuration terminée"
            ;;
        3)
            print_warning "Affichage des fichiers"
            check_files_to_push
            ;;
        4)
            show_post_push_instructions
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