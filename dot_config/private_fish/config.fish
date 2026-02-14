if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings
end

# bind \t accept-autosuggestion

# Base16 Shell
# if status --is-interactive
#     set BASE16_SHELL "$HOME/.config/base16-shell/"
#     source "$BASE16_SHELL/profile_helper.fish"
#     base16-default-dark
# end

set PATH $HOME/.cargo/bin $PATH

direnv hook fish | source
