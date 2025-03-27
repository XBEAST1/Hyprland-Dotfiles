#!/bin/bash

# Install Required Packages
sudo pacman -S rofi-emoji noto-fonts-emoji btop imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin xfce4-session preload --noconfirm

# Change Shell to zsh
chsh -s /bin/zsh

# Change Some Settings For Better Performance
sudo systemctl enable preload
sudo systemctl start preload
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf

# Configure Thunar
sudo cp .thunar/audiocovers.thumbnailer /usr/share/thumbnailers/

# Remove Old Configurations
sudo rm -rf ~/.config/fastfetch ~/.config/kitty /etc/sddm.conf.d/kde_settings.conf ~/.config/waybar/config.ctl ~/.hyde.zshrc ~/.zshenv /etc/sddm.conf.d/the_hyde_project.conf

# Copy New Configurations
cp -r .config .local .hyde.zshrc .zshenv ~/
sudo cp -r .sddm/themes /usr/share/sddm
sudo cp -f .sddm/themes/Electra/kde_settings.conf /etc/sddm.conf.d/the_hyde_project.conf

echo "XBEAST Hyprdots Setup Complete!"