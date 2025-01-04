<h2>Copy And Paste Into Terminal To Install My Dot Files
<br>
<br>
  
```
git clone https://github.com/XBEAST1/Hyprland-Dotfiles.git
cd Hyprland-Dotfiles
rm -rf .config/fastfetch .config/kitty .config/hyde/themes/Catppuccin\ Mocha/
rsync -av --exclude=".git" ./ ~/
```

<br>

Note: You Need <a href="https://github.com/prasanthrangan/hyprdots">HyDE</a> For These Dotfiles To Work
