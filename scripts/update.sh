#!/bin/bash

# ===========================================
#  Update Dotfiles Script
#  Sync current configs back to dotfiles repo
# ===========================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${CYAN}Updating dotfiles from current system...${NC}"

# Config directories to sync
CONFIG_DIRS=(
    "hypr"
    "kitty"
    "nvim"
    "fuzzel"
    "gtk-3.0"
    "gtk-4.0"
    "qt5ct"
    "qt6ct"
    "zshrc.d"
    "foot"
    "btop"
    "waybar"
    "cava"
    "quickshell"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        rm -rf "$DOTFILES_DIR/config/$dir"
        cp -r "$HOME/.config/$dir" "$DOTFILES_DIR/config/"
        # Remove any .git subdirectories
        rm -rf "$DOTFILES_DIR/config/$dir/.git" 2>/dev/null || true
        echo -e "${GREEN}[✓] Synced: ~/.config/$dir${NC}"
    fi
done

# Config files
CONFIG_FILES=(
    "starship.toml"
    "chrome-flags.conf"
    "code-flags.conf"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$HOME/.config/$file" ]; then
        cp "$HOME/.config/$file" "$DOTFILES_DIR/config/"
        echo -e "${GREEN}[✓] Synced: ~/.config/$file${NC}"
    fi
done

# Home files
HOME_FILES=(
    ".zshrc"
    ".p10k.zsh"
    ".gitconfig"
    ".gtkrc-2.0"
)

for file in "${HOME_FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$DOTFILES_DIR/home/"
        echo -e "${GREEN}[✓] Synced: ~/$file${NC}"
    fi
done

# Update system configs
echo -e "\n${CYAN}Updating system configs...${NC}"
mkdir -p "$DOTFILES_DIR/system/etc/default" "$DOTFILES_DIR/system/etc/gdm"

# GRUB config (requires sudo)
if [ -f "/etc/default/grub" ]; then
    sudo cp /etc/default/grub "$DOTFILES_DIR/system/etc/default/grub"
    echo -e "${GREEN}[✓] Synced: /etc/default/grub${NC}"
fi

# GDM config
if [ -f "/etc/gdm/custom.conf" ]; then
    sudo cp /etc/gdm/custom.conf "$DOTFILES_DIR/system/etc/gdm/custom.conf"
    echo -e "${GREEN}[✓] Synced: /etc/gdm/custom.conf${NC}"
fi

# GNOME/dconf settings
dconf dump / > "$DOTFILES_DIR/system/dconf-settings.ini"
echo -e "${GREEN}[✓] Synced: dconf settings${NC}"

# Update package lists
echo -e "\n${CYAN}Updating package lists...${NC}"
pacman -Qqen > "$DOTFILES_DIR/packages/pacman.txt"
pacman -Qqem > "$DOTFILES_DIR/packages/aur.txt"
echo -e "${GREEN}[✓] Package lists updated${NC}"

# Show git status
echo -e "\n${CYAN}Git status:${NC}"
cd "$DOTFILES_DIR"
git status --short

echo -e "\n${GREEN}Dotfiles updated!${NC}"
echo -e "${YELLOW}Run 'git add -A && git commit -m \"Update dotfiles\"' to commit changes${NC}"

