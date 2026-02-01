# 🏠 My Arch Linux Dotfiles

<p align="center">
  <img src="https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white"/>
  <img src="https://img.shields.io/badge/WM-Hyprland-58a6ff?style=for-the-badge&logo=wayland&logoColor=white"/>
  <img src="https://img.shields.io/badge/Shell-ZSH-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white"/>
  <img src="https://img.shields.io/badge/Editor-Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white"/>
</p>

## 📸 Screenshots

<!-- Thêm screenshots của bạn vào đây -->
![Desktop](./screenshots/desktop.png)

## ⚙️ System Info

| Component | Details |
|-----------|---------|
| **OS** | Arch Linux (EndeavourOS base) |
| **Window Manager** | Hyprland |
| **Bar** | Waybar |
| **Terminal** | Kitty |
| **Shell** | ZSH + Oh-My-Zsh + Powerlevel10k |
| **Prompt** | Starship |
| **Editor** | Neovim (LazyVim) |
| **Launcher** | Fuzzel |
| **File Manager** | Nautilus |
| **Theme** | Dracula |
| **Cursors** | Breeze Snow / Capitaine |
| **Icons** | Papirus |
| **Input Method** | Fcitx5 + Bamboo (Vietnamese) |

## 📁 Structure

```
myarch/
├── config/                 # ~/.config files
│   ├── hypr/              # Hyprland config
│   ├── kitty/             # Kitty terminal
│   ├── nvim/              # Neovim config
│   ├── waybar/            # Waybar config
│   ├── fuzzel/            # Fuzzel launcher
│   ├── btop/              # Btop system monitor
│   ├── gtk-3.0/           # GTK3 settings
│   ├── gtk-4.0/           # GTK4 settings
│   ├── qt5ct/             # Qt5 settings
│   ├── qt6ct/             # Qt6 settings
│   └── starship.toml      # Starship prompt
├── home/                   # Home directory dotfiles
│   ├── .zshrc             # ZSH config
│   ├── .p10k.zsh          # Powerlevel10k
│   ├── .gitconfig         # Git config
│   └── .gtkrc-2.0         # GTK2 settings
├── scripts/               # Installation & utility scripts
│   ├── install.sh         # Main install script
│   ├── packages.sh        # Package installation
│   └── symlink.sh         # Create symlinks
├── packages/              # Package lists
│   ├── pacman.txt         # Official repo packages
│   └── aur.txt            # AUR packages
├── wallpapers/            # Wallpaper collection
├── fonts/                 # Custom fonts
└── screenshots/           # Desktop screenshots
```

## 🚀 Quick Install

### Prerequisites

Make sure you have `git` and `yay` (or any AUR helper) installed:

```bash
sudo pacman -S git
# Install yay if not present
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

### Installation

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/myarch.git ~/myarch

# Run the installer
cd ~/myarch
chmod +x scripts/*.sh
./scripts/install.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# 1. Install packages
./scripts/packages.sh

# 2. Create symlinks
./scripts/symlink.sh

# 3. Reboot
reboot
```

## 📦 Packages

### Core Packages (Official)
- `hyprland` - Wayland compositor
- `waybar` - Status bar
- `kitty` - Terminal emulator
- `nautilus` - File manager
- `fuzzel` - Application launcher
- `neovim` - Text editor
- `zsh` - Shell
- `starship` - Prompt
- And more...

### AUR Packages
- `visual-studio-code-bin` - Code editor
- `google-chrome` - Browser
- `cursor-bin` - AI IDE
- `warp-terminal-bin` - Terminal
- And more...

## ⌨️ Keybindings

| Keybind | Action |
|---------|--------|
| `SUPER + Return` | Open Terminal |
| `SUPER + Q` | Close Window |
| `SUPER + D` | App Launcher (Fuzzel) |
| `SUPER + E` | File Manager |
| `SUPER + 1-9` | Switch Workspace |
| `SUPER + Shift + 1-9` | Move to Workspace |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle Floating |

## 🎨 Theming

The setup uses **Dracula** theme consistently across:
- GTK apps (gtk-3.0, gtk-4.0)
- Qt apps (qt5ct, qt6ct, Kvantum)
- Terminal (Kitty)
- Neovim

## 🔧 Post-Install

After installation, you may need to:

1. **Configure displays**: Use `nwg-displays`
2. **Set wallpaper**: Edit `~/.config/hypr/hyprland.conf`
3. **Input method**: Configure Fcitx5 for Vietnamese input
4. **Docker**: `sudo systemctl enable --now docker`

## 📝 Notes

- This dotfiles is based on EndeavourOS with Hyprland
- Uses `illogical-impulse` packages for widgets
- Vietnamese input via Fcitx5 + Bamboo

## 🤝 Credits

- [Hyprland](https://hyprland.org/)
- [illogical-impulse](https://github.com/end-4/dots-hyprland)
- [LazyVim](https://www.lazyvim.org/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

## 📄 License

MIT License - feel free to use and modify!
