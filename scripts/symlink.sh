#!/bin/bash

# ===========================================
#  Symlink Creation Script
# ===========================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${CYAN}Creating symlinks from ${DOTFILES_DIR}...${NC}"

# Backup function
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup"
        echo -e "${YELLOW}[!] Backed up: $target -> $backup${NC}"
    elif [ -L "$target" ]; then
        rm "$target"
    fi
}

# Create ~/.config directory if not exists
mkdir -p "$HOME/.config"

# Config directories to symlink
declare -A CONFIG_DIRS=(
    ["hypr"]="Hyprland config"
    ["kitty"]="Kitty terminal"
    ["nvim"]="Neovim config"
    ["waybar"]="Waybar status bar"
    ["fuzzel"]="Fuzzel launcher"
    ["btop"]="Btop monitor"
    ["gtk-3.0"]="GTK3 settings"
    ["gtk-4.0"]="GTK4 settings"
    ["qt5ct"]="Qt5 settings"
    ["qt6ct"]="Qt6 settings"
    ["zshrc.d"]="ZSH snippets"
    ["foot"]="Foot terminal"
    ["cava"]="Cava visualizer"
)

for dir in "${!CONFIG_DIRS[@]}"; do
    if [ -d "$DOTFILES_DIR/config/$dir" ]; then
        backup_if_exists "$HOME/.config/$dir"
        ln -sf "$DOTFILES_DIR/config/$dir" "$HOME/.config/$dir"
        echo -e "${GREEN}[✓] Linked: ~/.config/$dir (${CONFIG_DIRS[$dir]})${NC}"
    fi
done

# Config files to symlink
declare -A CONFIG_FILES=(
    ["starship.toml"]="Starship prompt"
    ["chrome-flags.conf"]="Chrome flags"
    ["code-flags.conf"]="VS Code flags"
)

for file in "${!CONFIG_FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/config/$file" ]; then
        backup_if_exists "$HOME/.config/$file"
        ln -sf "$DOTFILES_DIR/config/$file" "$HOME/.config/$file"
        echo -e "${GREEN}[✓] Linked: ~/.config/$file (${CONFIG_FILES[$file]})${NC}"
    fi
done

# Home directory files
declare -A HOME_FILES=(
    [".zshrc"]="ZSH config"
    [".p10k.zsh"]="Powerlevel10k"
    [".gitconfig"]="Git config"
    [".gtkrc-2.0"]="GTK2 settings"
)

for file in "${!HOME_FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/home/$file" ]; then
        backup_if_exists "$HOME/$file"
        ln -sf "$DOTFILES_DIR/home/$file" "$HOME/$file"
        echo -e "${GREEN}[✓] Linked: ~/$file (${HOME_FILES[$file]})${NC}"
    fi
done

echo ""
echo -e "${GREEN}All symlinks created successfully!${NC}"
