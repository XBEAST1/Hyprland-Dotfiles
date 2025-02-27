#  Startup 
# Commands on startup (before the prompt is shown)
# This is a good place to load graphic/ascii art, display system information, etc.

#  Aliases 
# Override aliases here or in '~/.zshrc' (already set in .zshenv)

# # Helpful aliases
# alias c='clear'                                                        # clear terminal
# alias l='eza -lh --icons=auto'                                         # long list
# alias ls='eza -1 --icons=auto'                                         # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias ld='eza -lhD --icons=auto'                                       # long list dirs
# alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pi='$aurhelper -S --noconfirm'                                   # install package
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias pinfo='$aurhelper -Qi'                                           # list package details
# alias pu='$aurhelper -Qtdq | $aurhelper -Rns - --noconfirm'            # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code .'                                                      # gui code editor

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
# alias mkdir='mkdir -p'

#  Plugins 
# manually add your oh-my-zsh plugins here
plugins=(
    "sudo"
    # "git"                     # (default)
    # "zsh-autosuggestions"     # (default)
    # "zsh-syntax-highlighting" # (default)
    # "zsh-completions"         # (default)
)
