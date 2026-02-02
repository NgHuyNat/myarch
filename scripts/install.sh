#!/bin/bash

# ===========================================
#  Arch Linux Dotfiles Installation Script
# ===========================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_banner() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║     🏠 Arch Linux Dotfiles Installer      ║"
    echo "║         Hyprland + ZSH + Neovim           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
}

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

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please don't run this script as root!"
        exit 1
    fi
}

# Check if yay is installed
check_yay() {
    if ! command -v yay &> /dev/null; then
        print_warning "yay not found. Installing..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd - > /dev/null
        print_success "yay installed successfully"
    else
        print_success "yay is already installed"
    fi
}

# Install packages
install_packages() {
    print_step "Installing packages from official repositories..."
    
    # Filter comments and empty lines
    grep -v '^#' "$DOTFILES_DIR/packages/pacman.txt" | grep -v '^$' | \
        sudo pacman -S --needed --noconfirm -
    
    print_success "Official packages installed"
    
    print_step "Installing AUR packages..."
    
    # Filter comments and empty lines
    grep -v '^#' "$DOTFILES_DIR/packages/aur.txt" | grep -v '^$' | \
        yay -S --needed --noconfirm -
    
    print_success "AUR packages installed"
    
    # Install fonts
    print_step "Installing fonts..."
    
    # Font packages from fonts.txt (mix of pacman and AUR)
    FONT_PACKAGES=(
        "noto-fonts"
        "noto-fonts-cjk"
        "noto-fonts-emoji"
        "ttf-dejavu"
        "ttf-liberation"
        "ttf-opensans"
        "cantarell-fonts"
        "ttf-google-sans"
        "ttf-gabarito-git"
        "ttf-readex-pro"
        "ttf-rubik"
        "otf-space-grotesk"
        "ttf-jetbrains-mono-nerd"
        "ttf-material-symbols-variable-git"
    )
    
    yay -S --needed --noconfirm "${FONT_PACKAGES[@]}"
    
    # Refresh font cache
    fc-cache -fv
    
    print_success "Fonts installed"
}

# Install Oh-My-Zsh
install_ohmyzsh() {
    print_step "Installing Oh-My-Zsh..."
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_warning "Oh-My-Zsh already installed, skipping..."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh-My-Zsh installed"
    fi
    
    # Install Powerlevel10k
    print_step "Installing Powerlevel10k..."
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        print_success "Powerlevel10k installed"
    else
        print_warning "Powerlevel10k already installed"
    fi
    
    # Install zsh-autosuggestions plugin
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "zsh-autosuggestions plugin installed"
    fi
    
    # Install zsh-syntax-highlighting plugin
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting plugin installed"
    fi
    
    # Create custom alias directory and file
    if [ ! -d "$ZSH_CUSTOM/alias" ]; then
        mkdir -p "$ZSH_CUSTOM/alias"
        touch "$ZSH_CUSTOM/alias/alias.zsh"
        print_success "Custom alias directory created"
    fi
}

# Create symlinks
create_symlinks() {
    print_step "Creating symlinks..."
    
    # Backup function
    backup_if_exists() {
        if [ -e "$1" ] && [ ! -L "$1" ]; then
            mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
            print_warning "Backed up $1"
        elif [ -L "$1" ]; then
            rm "$1"
        fi
    }
    
    # Config directory symlinks
    CONFIG_DIRS=(
        "hypr"
        "kitty"
        "nvim"
        "waybar"
        "fuzzel"
        "btop"
        "gtk-3.0"
        "gtk-4.0"
        "qt5ct"
        "qt6ct"
        "zshrc.d"
    )
    
    for dir in "${CONFIG_DIRS[@]}"; do
        if [ -d "$DOTFILES_DIR/config/$dir" ]; then
            backup_if_exists "$HOME/.config/$dir"
            ln -sf "$DOTFILES_DIR/config/$dir" "$HOME/.config/$dir"
            print_success "Linked ~/.config/$dir"
        fi
    done
    
    # Config files symlinks
    CONFIG_FILES=(
        "starship.toml"
        "chrome-flags.conf"
        "code-flags.conf"
    )
    
    for file in "${CONFIG_FILES[@]}"; do
        if [ -f "$DOTFILES_DIR/config/$file" ]; then
            backup_if_exists "$HOME/.config/$file"
            ln -sf "$DOTFILES_DIR/config/$file" "$HOME/.config/$file"
            print_success "Linked ~/.config/$file"
        fi
    done
    
    # Home directory dotfiles
    HOME_FILES=(
        ".zshrc"
        ".p10k.zsh"
        ".gitconfig"
        ".gtkrc-2.0"
    )
    
    for file in "${HOME_FILES[@]}"; do
        if [ -f "$DOTFILES_DIR/home/$file" ]; then
            backup_if_exists "$HOME/$file"
            ln -sf "$DOTFILES_DIR/home/$file" "$HOME/$file"
            print_success "Linked ~/$file"
        fi
    done
    
    print_success "All symlinks created"
}

# Enable services
enable_services() {
    print_step "Enabling systemd services..."
    
    # User services
    systemctl --user enable --now pipewire.service 2>/dev/null || true
    systemctl --user enable --now pipewire-pulse.service 2>/dev/null || true
    systemctl --user enable --now wireplumber.service 2>/dev/null || true
    
    # System services
    sudo systemctl enable --now bluetooth.service 2>/dev/null || true
    sudo systemctl enable --now NetworkManager.service 2>/dev/null || true
    sudo systemctl enable --now docker.service 2>/dev/null || true
    
    # Display manager - GDM (for GNOME + Hyprland dual session)
    sudo systemctl disable sddm.service 2>/dev/null || true
    sudo systemctl disable lightdm.service 2>/dev/null || true
    sudo systemctl enable gdm.service 2>/dev/null || true
    
    print_success "Services enabled"
}

# Apply system configs (GRUB, GDM, GNOME)
apply_system_configs() {
    print_step "Applying system configurations..."
    
    # GRUB
    if [ -f "$DOTFILES_DIR/system/etc/default/grub" ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup 2>/dev/null || true
        sudo cp "$DOTFILES_DIR/system/etc/default/grub" /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        print_success "GRUB config applied"
    fi
    
    # GDM
    if [ -f "$DOTFILES_DIR/system/etc/gdm/custom.conf" ] && [ -d "/etc/gdm" ]; then
        sudo cp "$DOTFILES_DIR/system/etc/gdm/custom.conf" /etc/gdm/custom.conf
        print_success "GDM config applied"
    fi
    
    # GNOME dconf settings
    if [ -f "$DOTFILES_DIR/system/dconf-settings.ini" ]; then
        dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini"
        print_success "GNOME settings applied"
    fi
}

# Set ZSH as default shell
set_zsh_default() {
    print_step "Setting ZSH as default shell..."
    
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        chsh -s /usr/bin/zsh
        print_success "ZSH set as default shell"
    else
        print_warning "ZSH is already the default shell"
    fi
}

# Main installation
main() {
    print_banner
    
    check_root
    
    echo -e "${YELLOW}This script will install and configure:${NC}"
    echo "  • Hyprland (Wayland compositor)"
    echo "  • Waybar (Status bar)"
    echo "  • Kitty (Terminal)"
    echo "  • Neovim (Editor)"
    echo "  • ZSH + Oh-My-Zsh + Powerlevel10k"
    echo "  • And many more packages..."
    echo ""
    
    read -p "Do you want to continue? [y/N] " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Installation cancelled"
        exit 0
    fi
    
    echo ""
    echo "Select installation options:"
    echo "  1) Full installation (packages + configs + system)"
    echo "  2) Packages only"
    echo "  3) Configs only (symlinks)"
    echo "  4) System configs only (GRUB + GDM + GNOME)"
    echo "  5) Exit"
    echo ""
    
    read -p "Enter choice [1-5]: " choice
    
    case $choice in
        1)
            check_yay
            install_packages
            install_ohmyzsh
            create_symlinks
            apply_system_configs
            enable_services
            set_zsh_default
            ;;
        2)
            check_yay
            install_packages
            install_ohmyzsh
            ;;
        3)
            create_symlinks
            ;;
        4)
            apply_system_configs
            enable_services
            ;;
        5)
            print_warning "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Installation completed!"
    echo ""
    echo -e "${YELLOW}Please reboot your system to apply all changes.${NC}"
    echo ""
    
    read -p "Would you like to reboot now? [y/N] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
}

main "$@"
