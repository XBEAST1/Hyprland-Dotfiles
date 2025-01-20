#!/bin/bash

# Install required packages
sudo pacman -S rofi-emoji noto-fonts-emoji btop imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin xfce4-session --noconfirm

# Fix thunar thumbnails issue
pkill -9 tumblerd
/usr/lib/tumbler-1/tumblerd
sudo bash -c 'echo -e "[Thumbnailer Entry]\nTryExec=ffmpeg\nExec=ffmpeg -y -i %i %o -fs %s\nMimeType=audio/mpeg" > /usr/share/thumbnailers/audiocovers.thumbnailer'

# Remove old configurations
sudo rm -rf ~/.config/fastfetch ~/.config/kitty /etc/sddm.conf.d/kde_settings.conf

# Copy new configurations
sudo cp -r .config .local .themes ~/
sudo cp -r .sddm/themes /usr/share/sddm
cp -f .sddm/themes/Electra/kde_settings.conf /etc/sddm.conf.d/

echo "XBEAST Hyprdots Setup complete!"