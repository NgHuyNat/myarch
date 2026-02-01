#!/bin/bash

# ===========================================
#  Apply System Configs Script
#  For GRUB, GDM, and GNOME settings
# ===========================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_step() {
    echo -e "\n${CYAN}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if running as root for system configs
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some operations require sudo. You may be prompted for password."
    fi
}

# Apply GRUB config
apply_grub() {
    print_step "Applying GRUB configuration..."
    
    if [ -f "$DOTFILES_DIR/system/etc/default/grub" ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)
        sudo cp "$DOTFILES_DIR/system/etc/default/grub" /etc/default/grub
        
        print_warning "Regenerating GRUB config..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        
        print_success "GRUB config applied"
    else
        print_error "GRUB config not found"
    fi
}

# Apply GDM config
apply_gdm() {
    print_step "Applying GDM configuration..."
    
    if [ -f "$DOTFILES_DIR/system/etc/gdm/custom.conf" ]; then
        if [ -d "/etc/gdm" ]; then
            sudo cp /etc/gdm/custom.conf /etc/gdm/custom.conf.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
            sudo cp "$DOTFILES_DIR/system/etc/gdm/custom.conf" /etc/gdm/custom.conf
            print_success "GDM config applied"
        else
            print_warning "GDM not installed, skipping..."
        fi
    else
        print_error "GDM config not found"
    fi
}

# Apply dconf/GNOME settings
apply_gnome() {
    print_step "Applying GNOME/dconf settings..."
    
    if [ -f "$DOTFILES_DIR/system/dconf-settings.ini" ]; then
        # Backup current settings
        dconf dump / > "$HOME/.dconf-backup-$(date +%Y%m%d_%H%M%S).ini"
        
        # Load new settings
        dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini"
        
        print_success "GNOME settings applied"
        print_warning "You may need to log out and back in for all changes to take effect"
    else
        print_error "dconf settings not found"
    fi
}

# Enable GDM service
enable_gdm() {
    print_step "Enabling GDM as display manager..."
    
    # Disable other display managers
    sudo systemctl disable sddm.service 2>/dev/null || true
    sudo systemctl disable lightdm.service 2>/dev/null || true
    
    # Enable GDM
    sudo systemctl enable gdm.service
    
    print_success "GDM enabled as display manager"
}

# Main menu
main() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║     System Configuration Applier          ║"
    echo "║     GRUB + GDM + GNOME Settings           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_sudo
    
    echo "Select what to apply:"
    echo "  1) All (GRUB + GDM + GNOME)"
    echo "  2) GRUB only"
    echo "  3) GDM only"
    echo "  4) GNOME/dconf settings only"
    echo "  5) Enable GDM as display manager"
    echo "  6) Exit"
    echo ""
    
    read -p "Enter choice [1-6]: " choice
    
    case $choice in
        1)
            apply_grub
            apply_gdm
            apply_gnome
            ;;
        2)
            apply_grub
            ;;
        3)
            apply_gdm
            ;;
        4)
            apply_gnome
            ;;
        5)
            enable_gdm
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Done!"
}

main "$@"
