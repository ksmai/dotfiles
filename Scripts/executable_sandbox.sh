#!/bin/sh
set -e

WORKSPACE=$(realpath .)

if [ "$#" -eq 0 ]; then
    set -- fish
fi

bwrap \
    --unshare-all \
    --share-net \
    --die-with-parent \
    --clearenv \
    --setenv HOME "$HOME" \
    --setenv USER "$USER" \
    --setenv PATH "$PATH" \
    --setenv TERM "$TERM" \
    --setenv EDITOR "$EDITOR" \
    --setenv IS_IN_BWRAP_SANDBOX 1 \
    --ro-bind /etc /etc \
    --ro-bind /usr /usr \
    --symlink usr/bin /bin \
    --symlink usr/lib /lib \
    --symlink usr/lib /lib64 \
    --symlink usr/bin /sbin \
    --dev /dev \
    --proc /proc \
    --tmpfs /tmp \
    --tmpfs /run \
    --tmpfs "$HOME" \
    --ro-bind "$HOME/.rustup" "$HOME/.rustup" \
    --ro-bind "$HOME/.config/fish" "$HOME/.config/fish" \
    --ro-bind "$HOME/.config/nvim" "$HOME/.config/nvim" \
    --ro-bind "$HOME/.local/share/chezmoi/dot_config/nvim/.nvim-pack-lock.json" "$HOME/.local/share/chezmoi/dot_config/nvim/.nvim-pack-lock.json" \
    --ro-bind "$HOME/.local/share/nvim" "$HOME/.local/share/nvim" \
    --tmpfs "$HOME/.local/share/nvim/fzf-lua-frecency" \
    --bind "$WORKSPACE" "$WORKSPACE" \
    --chdir "$WORKSPACE" \
    "$@"
