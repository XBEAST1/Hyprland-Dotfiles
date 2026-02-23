#!/bin/bash

cat << "EOF"

  _    _                  _                 _   _____        _    __ _ _           
 | |  | |                | |               | | |  __ \      | |  / _(_) |          
 | |__| |_   _ _ __  _ __| | __ _ _ __   __| | | |  | | ___ | |_| |_ _| | ___  ___ 
 |  __  | | | | '_ \| '__| |/ _` | '_ \ / _` | | |  | |/ _ \| __|  _| | |/ _ \/ __|
 | |  | | |_| | |_) | |  | | (_| | | | | (_| | | |__| | (_) | |_| | | | |  __/\__ \
 |_|  |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |_____/ \___/ \__|_| |_|_|\___||___/
          __/ | |                                                                  
         |___/|_|                                                                  
                                                                            By XBEAST

                                     Installing...
EOF

# ==============================================================================
# 1. INSTALL REQUIRED PACKAGES
# ==============================================================================
sudo pacman -S rofi-emoji noto-fonts-emoji btop imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin zsh zram-generator chaotic-keyring chaotic-mirrorlist --noconfirm --needed

# ==============================================================================
# 2. CHANGE SHELL TO ZSH
# ==============================================================================
if grep -q "/bin/zsh" /etc/shells; then
    chsh -s /bin/zsh
    echo "✓ Shell changed to zsh"
else
    echo "⚠ Zsh not found in /etc/shells, skipping chsh"
fi

# ==============================================================================
# 3. PERFORMANCE TWEAKS
# ==============================================================================

TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_RAM_MB=$((TOTAL_RAM_KB / 1024))

if [ "$TOTAL_RAM_MB" -le 4096 ]; then
    ZRAM_SIZE_MB=2048        # Max 2GB ZRAM for 4GB PHYSICAL RAM
    SWAPPINESS=60

elif [ "$TOTAL_RAM_MB" -le 8192 ]; then
    ZRAM_SIZE_MB=3072        # Max 3GB ZRAM for 8GB PHYSICAL RAM
    SWAPPINESS=45

elif [ "$TOTAL_RAM_MB" -le 16384 ]; then
    ZRAM_SIZE_MB=6144        # Max 6GB ZRAM for 16GB PHYSICAL RAM
    SWAPPINESS=35

elif [ "$TOTAL_RAM_MB" -le 32768 ]; then
    ZRAM_SIZE_MB=8192        # Max 8GB ZRAM for 32GB PHYSICAL RAM
    SWAPPINESS=25

else
    ZRAM_SIZE_MB=10240       # Max 10GB ZRAM for 64GB PHYSICAL RAM
    SWAPPINESS=10
fi

cat << ZRAM_EOF | sudo tee /etc/systemd/zram-generator.conf > /dev/null
[zram0]
zram-size=${ZRAM_SIZE_MB}
compression-algorithm=lz4
swap-priority=100
ZRAM_EOF

sudo systemctl restart systemd-zram-setup@zram0

sudo sed -i '/vm\.swappiness/d' /etc/sysctl.conf
sudo sed -i '/vm\.vfs_cache_pressure/d' /etc/sysctl.conf
sudo sed -i '/vm\.page-cluster/d' /etc/sysctl.conf

echo "vm.swappiness=${SWAPPINESS}" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "vm.page-cluster=0" | sudo tee -a /etc/sysctl.conf

sudo sysctl --system

sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

echo "✓ Performance tweaks applied"

# ==============================================================================
# 5. CONFIGURE THUMBNAILERS
# ==============================================================================
if [ -f .thunar/audiocovers.thumbnailer ]; then
    sudo mkdir -p /usr/share/thumbnailers
    sudo cp .thunar/audiocovers.thumbnailer /usr/share/thumbnailers/
    echo "✓ Thunar thumbnailers configured"
fi

# ==============================================================================
# 6. CLEANUP OLD CONFIGURATIONS
# ==============================================================================
rm -rf "$HOME/.config/fastfetch" \
       "$HOME/.config/kitty/hyde.conf" \
       "$HOME/.config/zsh/conf.d/binds.zsh" \
       "$HOME/.config/waybar/layouts/backup/" 2>/dev/null || true

sudo rm -f /etc/sddm.conf.d/kde_settings.conf \
           /etc/sddm.conf.d/the_hyde_project.conf 2>/dev/null || true

echo "✓ Old configurations cleaned"

# ==============================================================================
# 7. EXTRACT CURSORS AND ICONS
# ==============================================================================
mkdir -p "$HOME/.icons"

for tar in .icons/*.tar.gz; do
    if [ -f "$tar" ]; then
        tar -xzf "$tar" -C "$HOME/.icons/"
    fi
done

echo "✓ Icons extracted"

# ==============================================================================
# 8. COPY NEW CONFIGURATIONS
# ==============================================================================
cp -r .config .local "$HOME/"
sudo cp -r .sddm/themes /usr/share/sddm
sudo cp -f .sddm/themes/Electra/kde_settings.conf /etc/sddm.conf.d/the_hyde_project.conf

echo "✓ Configurations applied"

# ==============================================================================
# 9. CONFIGURE CHAOTIC AUR
# ==============================================================================
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo sed -i '/\[chaotic-aur\]/,/^$/d' /etc/pacman.conf
sudo sed -i '/\[core\]/i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' /etc/pacman.conf
sudo pacman -Sy chaotic-keyring chaotic-mirrorlist --noconfirm --needed

echo "✓ Chaotic AUR configured"

# ==============================================================================
# 10. FINALIZATION
# ==============================================================================
TOTAL_RAM_GB=$((TOTAL_RAM_MB / 1024))
ZRAM_SIZE_GB=$((ZRAM_SIZE_MB / 1024))
CURRENT_SHELL=$(basename "$SHELL")

echo ""
echo "=========================================="
echo "     XBEAST Hyprdots Setup Complete!      "
echo "=========================================="
echo ""
echo "📊 System Info:"
echo "   • RAM: ${TOTAL_RAM_GB} GB"
echo "   • ZRAM: ${ZRAM_SIZE_GB} GB"
echo "   • Swappiness: ${SWAPPINESS}"
echo "   • Shell: ${CURRENT_SHELL}"
echo ""
echo "⚠  IMPORTANT:"
echo "   • Reboot required for full changes"
echo ""