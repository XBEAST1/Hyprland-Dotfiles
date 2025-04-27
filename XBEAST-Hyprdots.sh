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

# Install Required Packages
sudo pacman -S rofi-emoji noto-fonts-emoji btop imagemagick tumbler ffmpegthumbnailer thunar thunar-archive-plugin xfce4-session preload --noconfirm --needed

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

# Extract Cursors And Icons
mkdir -p ~/.icons
for tar in .icons/*.tar.gz; do
    tar -xzf "$tar" -C ~/.icons/
done

# Copy New Configurations
cp -r .config .local .hyde.zshrc .zshenv ~/
sudo cp -r .sddm/themes /usr/share/sddm
sudo cp -f .sddm/themes/Electra/kde_settings.conf /etc/sddm.conf.d/the_hyde_project.conf

# Prioritize Chaotic AUR
cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i '/\[chaotic-aur\]/,/^$/d' /etc/pacman.conf
sed -i '/\[core\]/i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' /etc/pacman.conf

echo "XBEAST Hyprdots Setup Complete!"