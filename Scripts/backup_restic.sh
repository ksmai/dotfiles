#!/bin/sh
set -euo pipefail

info() { printf "[%s] %s\n" "$(date)" "$*" >&2; }

trap 'echo [$(date)] Interrupted >&2; exit 2' INT TERM

read -p "Enter password: " -s RESTIC_PASSWORD
echo ""
export RESTIC_PASSWORD
export RCLONE_CONFIG_PASS="$RESTIC_PASSWORD"

dobackup() {
    while read repo; do
        if ! restic --repo "$repo" cat config >/dev/null 2>&1; then
            info "Repo does not exist: $repo. Skipping..."
            continue
        fi

        info "Backing up to repo: $repo"

        restic backup \
            --repo "$repo" \
            --files-from "$2" \
            --verbose

        restic forget \
            --repo "$repo" \
            --keep-last 20 \
            --keep-daily 14 \
            --keep-weekly 8 \
            --keep-monthly 12 \
            --prune

    done <"$1"
}

dobackup ~/Scripts/.config/restic-full-repos ~/Scripts/.config/restic-full-files
dobackup ~/Scripts/.config/restic-small-repos ~/Scripts/.config/restic-small-files
