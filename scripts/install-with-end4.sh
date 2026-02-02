#!/bin/bash

# ===========================================
#  Install end-4 dotfiles then apply custom configs
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

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║  Install end-4 dotfiles + Custom Configs          ║"
echo "║  Step 1: Install illogical-impulse (end-4)        ║"
echo "║  Step 2: Apply your custom configs                ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root!"
    exit 1
fi

# ===== STEP 1: Install end-4 dotfiles =====
print_step "Installing end-4/dots-hyprland (illogical-impulse)..."

echo ""
echo "This will run the official end-4 installer first."
echo "After that, your custom configs will be applied."
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Cancelled"
    exit 0
fi

# Clone and run end-4 installer
print_step "Cloning end-4/dots-hyprland..."

if [ -d "/tmp/dots-hyprland" ]; then
    rm -rf /tmp/dots-hyprland
fi

git clone --depth=1 https://github.com/end-4/dots-hyprland.git /tmp/dots-hyprland

print_step "Running end-4 installer..."
echo -e "${YELLOW}Follow the prompts from the end-4 installer.${NC}"
echo -e "${YELLOW}When asked, install recommended packages.${NC}"
echo ""

cd /tmp/dots-hyprland
./install.sh

print_success "end-4 dotfiles installed!"

# ===== STEP 2: Apply custom configs =====
print_step "Applying your custom configs..."

# Backup end-4 configs before overwriting
backup_and_copy() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ]; then
        mv "$dest" "${dest}.end4-backup"
    fi
    
    if [ -d "$src" ]; then
        cp -r "$src" "$dest"
    elif [ -f "$src" ]; then
        cp "$src" "$dest"
    fi
}

# Apply custom Hyprland configs
if [ -d "$DOTFILES_DIR/config/hypr" ]; then
    print_step "Applying custom Hyprland config..."
    backup_and_copy "$DOTFILES_DIR/config/hypr" "$HOME/.config/hypr"
    print_success "Hyprland config applied"
fi

# Apply custom Kitty config
if [ -d "$DOTFILES_DIR/config/kitty" ]; then
    print_step "Applying custom Kitty config..."
    backup_and_copy "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"
    print_success "Kitty config applied"
fi

# Apply custom Neovim config
if [ -d "$DOTFILES_DIR/config/nvim" ]; then
    print_step "Applying custom Neovim config..."
    backup_and_copy "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    print_success "Neovim config applied"
fi

# Apply custom Fcitx5 config (Vietnamese input)
if [ -d "$DOTFILES_DIR/config/fcitx5" ]; then
    print_step "Applying Fcitx5 config..."
    backup_and_copy "$DOTFILES_DIR/config/fcitx5" "$HOME/.config/fcitx5"
    print_success "Fcitx5 config applied"
fi

# Apply custom Fuzzel config
if [ -d "$DOTFILES_DIR/config/fuzzel" ]; then
    print_step "Applying Fuzzel config..."
    backup_and_copy "$DOTFILES_DIR/config/fuzzel" "$HOME/.config/fuzzel"
    print_success "Fuzzel config applied"
fi

# Apply GTK configs
if [ -d "$DOTFILES_DIR/config/gtk-3.0" ]; then
    backup_and_copy "$DOTFILES_DIR/config/gtk-3.0" "$HOME/.config/gtk-3.0"
    print_success "GTK3 config applied"
fi

if [ -d "$DOTFILES_DIR/config/gtk-4.0" ]; then
    backup_and_copy "$DOTFILES_DIR/config/gtk-4.0" "$HOME/.config/gtk-4.0"
    print_success "GTK4 config applied"
fi

# Apply Qt configs
if [ -d "$DOTFILES_DIR/config/qt5ct" ]; then
    backup_and_copy "$DOTFILES_DIR/config/qt5ct" "$HOME/.config/qt5ct"
    print_success "Qt5 config applied"
fi

if [ -d "$DOTFILES_DIR/config/qt6ct" ]; then
    backup_and_copy "$DOTFILES_DIR/config/qt6ct" "$HOME/.config/qt6ct"
    print_success "Qt6 config applied"
fi

# Apply Starship config
if [ -f "$DOTFILES_DIR/config/starship.toml" ]; then
    backup_and_copy "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
    print_success "Starship config applied"
fi

# Apply home dotfiles
if [ -f "$DOTFILES_DIR/home/.zshrc" ]; then
    backup_and_copy "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
    print_success ".zshrc applied"
fi

if [ -f "$DOTFILES_DIR/home/.p10k.zsh" ]; then
    backup_and_copy "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"
    print_success ".p10k.zsh applied"
fi

if [ -f "$DOTFILES_DIR/home/.gitconfig" ]; then
    backup_and_copy "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
    print_success ".gitconfig applied"
fi

if [ -f "$DOTFILES_DIR/home/.gtkrc-2.0" ]; then
    backup_and_copy "$DOTFILES_DIR/home/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
    print_success ".gtkrc-2.0 applied"
fi

# ===== STEP 3: Install additional packages =====
print_step "Installing additional packages..."

# Vietnamese input
yay -S --needed --noconfirm fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-bamboo-git 2>/dev/null || true

# GNOME for dual session
sudo pacman -S --needed --noconfirm gnome gdm nautilus 2>/dev/null || true

# Enable GDM
sudo systemctl enable gdm.service 2>/dev/null || true

print_success "Additional packages installed"

# ===== STEP 4: Apply system configs =====
print_step "Applying system configs (GRUB, GDM, GNOME)..."

if [ -f "$DOTFILES_DIR/system/dconf-settings.ini" ]; then
    dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini" 2>/dev/null || true
    print_success "GNOME settings applied"
fi

# ===== DONE =====
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Installation Complete! 🎉               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo "What was installed:"
echo "  ✓ end-4 dotfiles (illogical-impulse)"
echo "  ✓ Your custom Hyprland config"
echo "  ✓ Your custom terminal/editor configs"
echo "  ✓ Vietnamese input (Fcitx5)"
echo "  ✓ GNOME + GDM for dual session"
echo ""
echo -e "${YELLOW}Please reboot to apply all changes.${NC}"
echo ""

read -p "Reboot now? [y/N] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
