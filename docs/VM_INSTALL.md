# 🖥️ Hướng dẫn Test Dotfiles trên Máy Ảo

## Bước 1: Tạo máy ảo Arch Linux

### Option A: VirtualBox
```bash
# Tạo VM mới:
# - Name: arch-test
# - Type: Linux, Version: Arch Linux (64-bit)
# - RAM: 4GB+ (recommend 8GB)
# - Disk: 40GB+
# - Enable EFI (Settings > System > Enable EFI)
# - Video Memory: 128MB, Enable 3D Acceleration
```

### Option B: VMware Workstation
```bash
# Tạo VM mới:
# - Guest OS: Other Linux 6.x kernel 64-bit
# - RAM: 4GB+
# - Disk: 40GB+
# - Enable 3D Graphics
```

### Option C: QEMU/KVM (Virt-Manager)
```bash
# Tốt nhất cho Wayland/Hyprland
virt-manager
# Tạo VM với UEFI firmware
```

## Bước 2: Cài Arch Linux cơ bản

### Download ISO
- **EndeavourOS** (recommend - có Hyprland sẵn): https://endeavouros.com/
- **Arch Linux**: https://archlinux.org/download/

### Nếu dùng EndeavourOS:
1. Boot ISO
2. Chọn **Online Install**
3. Chọn **Hyprland** trong Desktop selection
4. Hoàn thành cài đặt

### Nếu dùng Arch Linux thuần:
```bash
# Sau khi cài base system, cài thêm:
pacman -S git base-devel networkmanager
systemctl enable NetworkManager
```

## Bước 3: Cài Dotfiles

Sau khi boot vào Arch/EndeavourOS:

```bash
# 1. Mở terminal (Ctrl+Alt+T hoặc Super+Return)

# 2. Clone dotfiles
git clone https://github.com/NgHuyNat/myarch.git ~/myarch

# 3. Chạy script cài đặt
cd ~/myarch
chmod +x scripts/*.sh
./scripts/install.sh

# 4. Chọn option 1 (Full installation)

# 5. Đợi cài đặt xong và reboot
```

## Bước 4: Sau khi reboot

```bash
# 1. Login vào Hyprland

# 2. Cấu hình màn hình (nếu cần)
nwg-displays

# 3. Cấu hình input tiếng Việt
fcitx5-configtool

# 4. Thay đổi wallpaper
# Super + Shift + W (hoặc qua sidebar)
```

## ⚠️ Lưu ý cho máy ảo

### VirtualBox:
```bash
# Cài Guest Additions
sudo pacman -S virtualbox-guest-utils
sudo systemctl enable vboxservice
```

### VMware:
```bash
# Cài VMware tools
sudo pacman -S open-vm-tools
sudo systemctl enable vmtoolsd
```

### Hyprland trên máy ảo:
```bash
# Nếu gặp lỗi GPU, thêm vào ~/.config/hypr/hyprland.conf:
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_RENDERER_ALLOW_SOFTWARE,1
```

## 🔧 Troubleshooting

### Không boot được vào Hyprland:
```bash
# Kiểm tra Hyprland
Hyprland

# Nếu lỗi, xem log
cat ~/.local/share/hyprland/hyprland.log
```

### Thiếu fonts/icons:
```bash
# Chạy lại cài fonts
cd ~/myarch
yay -S ttf-jetbrains-mono-nerd ttf-material-symbols-variable-git
fc-cache -fv
```

### Quickshell không chạy:
```bash
# Kiểm tra quickshell
quickshell -c ~/.config/quickshell/ii/shell.qml
```

## ✅ Checklist sau khi cài

- [ ] Hyprland chạy được
- [ ] Bar/Widgets hiển thị (quickshell)
- [ ] Terminal (Kitty) mở được với Super+Return
- [ ] App launcher (Fuzzel) hoạt động với Super+D
- [ ] Fonts hiển thị đúng
- [ ] Tiếng Việt gõ được (Ctrl+Space để chuyển)
- [ ] Theme Dracula áp dụng cho apps
