#!/bin/bash

# Install required packages
sudo pacman -S rofi-emoji noto-fonts-emoji imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin xfce4-session --noconfirm

# Configure Thunar
sudo mkdir /usr/share/thumbnailers/
cp .thunar/audiocovers.thumbnailer /usr/share/thumbnailers/

# Remove old configurations
rm -rf ~/.config/fastfetch ~/.config/kitty /usr/share/sddm/themes/Candy/theme.conf

# Copy new configurations
cp -r .config .local .themes ~/
cp .sddm/theme.conf /usr/share/sddm/themes/Candy/

# Remove existing sddm backgrounds
rm -f /usr/share/sddm/themes/Candy/backgrounds/*

# Copy new wallpapers to sddm backgrounds
cp .config/hyde/themes/Electra/wallpapers/1.Thunder-Grey.jpg /usr/share/sddm/themes/Candy/backgrounds/bg.jpg
cp .config/hyde/themes/Electra/wallpapers/2.Thunder-Purple.jpg /usr/share/sddm/themes/Candy/backgrounds/bg4.jpg
cp .config/hyde/themes/Electra/wallpapers/3.Thunder-Purple.jpg /usr/share/sddm/themes/Candy/backgrounds/bg5.jpg
cp .config/hyde/themes/Electra/wallpapers/4.Thunder-Purple.jpg /usr/share/sddm/themes/Candy/backgrounds/bg6.jpg
cp .config/hyde/themes/Electra/wallpapers/5.Thunder-Purple.jpg /usr/share/sddm/themes/Candy/backgrounds/bg7.jpg
cp .config/hyde/themes/Electra/wallpapers/6.Thunder-Purple.jpg /usr/share/sddm/themes/Candy/backgrounds/bg8.jpg
cp .config/hyde/themes/Electra/wallpapers/8.Thunder-Blue.jpg /usr/share/sddm/themes/Candy/backgrounds/bg3.jpg
cp .config/hyde/themes/Electra/wallpapers/9.Thunder-Blue2.jpg /usr/share/sddm/themes/Candy/backgrounds/bg2.jpg

echo "XBEAST Hyprdots Setup complete!"