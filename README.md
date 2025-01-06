<h3>Copy And Paste Into Terminal To Install My Dot Files.</h3>
<br>
  
```
sudo pacman -S rofi-emoji noto-fonts-emoji
git clone https://github.com/XBEAST1/Hyprland-Dotfiles.git
cd Hyprland-Dotfiles
rm -rf .config/fastfetch .config/kitty .config/hyde/themes/Catppuccin\ Mocha/
cp -r .config .local .themes ~/
```
<br>

Note: You Need <a href="https://github.com/prasanthrangan/hyprdots">HyDE</a> For These Dotfiles To Work.