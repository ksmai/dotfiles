if status is-interactive
    # Commands to run in interactive sessions can go here
end

# bind \t accept-autosuggestion

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
    base16-default-dark
end
