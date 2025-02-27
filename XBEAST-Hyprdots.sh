#!/bin/bash

# Install required packages
sudo pacman -S rofi-emoji noto-fonts-emoji btop imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin xfce4-session --noconfirm

# Configure Thunar
sudo cp .thunar/audiocovers.thumbnailer /usr/share/thumbnailers/

# Remove old configurations
sudo rm -rf ~/.config/fastfetch ~/.config/kitty /etc/sddm.conf.d/kde_settings.conf ~/.config/waybar/config.ctl ~/.hyde.zshrc ~/.zshenv /etc/sddm.conf.d/the_hyde_project.conf

# Copy new configurations
cp -r .config .local .themes .icons .hyde.zshrc .zshenv ~/
sudo cp -r .sddm/themes /usr/share/sddm
sudo cp -f .sddm/themes/Electra/kde_settings.conf /etc/sddm.conf.d/the_hyde_project.conf

echo "XBEAST Hyprdots Setup complete!"