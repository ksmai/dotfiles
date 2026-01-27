#!/bin/sh
set -euo pipefail

info() { printf "[%s] %s\n" "$(date)" "$*" >&2; }

trap 'echo [$(date)] Interrupted >&2; exit 2' INT TERM

read -p "Enter password: " -s RCLONE_CONFIG_PASS
echo ""
export RCLONE_CONFIG_PASS


while read dest; do
    while read file; do
        dest_file="$dest/$(basename "$file")"

        info "Rcloning $file to $dest_file"

        rclone copyto "$file" "$dest_file" \
            --backup-dir "$dest_file-old" \
            --suffix "-$(date '+%FT%T')" \
            --suffix-keep-extension

        if ! diff -q "$file" <(rclone cat "$dest_file"); then
            info "$file and $dest_file do not match"
            exit 1
        fi

    done <~/Scripts/.config/rclone-files
done <~/Scripts/.config/rclone-dests
