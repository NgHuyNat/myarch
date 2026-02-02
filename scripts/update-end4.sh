#!/bin/bash

# ===========================================
#  Update end-4 while keeping your custom configs
# ===========================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔═════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Update end-4 (keep custom configs)     ║${NC}"
echo -e "${CYAN}╚═════════════════════════════════════════╝${NC}"

# Configs to preserve
PRESERVE_CONFIGS=(
    "hypr"
    "quickshell"
    "kitty"
    "nvim"
    "fuzzel"
    "foot"
)

BACKUP_DIR="/tmp/config-backup-$$"
mkdir -p "$BACKUP_DIR"

# Step 1: Backup current configs
echo -e "\n${CYAN}[1/4]${NC} Backing up your configs..."
for config in "${PRESERVE_CONFIGS[@]}"; do
    if [ -d "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
        echo -e "  ${GREEN}✓${NC} Backed up: $config"
    fi
done

# Step 2: Update end-4
echo -e "\n${CYAN}[2/4]${NC} Updating end-4 dotfiles..."
if [ -d "$HOME/.cache/dots-hyprland" ]; then
    cd "$HOME/.cache/dots-hyprland"
    git stash 2>/dev/null || true
    git pull
    ./setup install
else
    echo -e "${YELLOW}end-4 not found in cache, running fresh install...${NC}"
    bash <(curl -s https://ii.clsty.link/get)
fi

# Step 3: Restore your configs
echo -e "\n${CYAN}[3/4]${NC} Restoring your configs..."
for config in "${PRESERVE_CONFIGS[@]}"; do
    if [ -d "$BACKUP_DIR/$config" ]; then
        # Merge: copy your files over the new ones
        cp -r "$BACKUP_DIR/$config"/* "$HOME/.config/$config/" 2>/dev/null || true
        echo -e "  ${GREEN}✓${NC} Restored: $config"
    fi
done

# Step 4: Cleanup
echo -e "\n${CYAN}[4/4]${NC} Cleaning up..."
rm -rf "$BACKUP_DIR"

echo -e "\n${GREEN}╔═════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Update complete! Configs preserved.    ║${NC}"
echo -e "${GREEN}╚═════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Restart Hyprland to apply changes (Super+Shift+E or logout)${NC}"
