#!/bin/sh
set -euo pipefail

info() { printf "[%s] %s\n" "$(date)" "$*" >&2; }

trap 'echo [$(date)] Interrupted >&2; exit 2' INT TERM

read -p "Enter password: " -s RESTIC_PASSWORD
export RESTIC_PASSWORD
echo ""

docheck() {
    while read repo; do
        if ! restic --repo "$repo" cat config >/dev/null 2>&1; then
            info "Repo does not exist: $repo. Skipping..."
            continue
        fi

        info "Checking repo: $repo"

        restic check \
            --read-data \
            --repo "$repo"

        TEST_DIR=`mktemp -d`

        if [ ! -d "$TEST_DIR" ]; then
            info "Failed to create temp directory"
            exit 1
        fi

        trap 'rm -rf "$TEST_DIR"' EXIT

        while read file; do
            if [ ! -f "$file" ]; then
                info "File not found locally: $file"
                exit 1
            fi

            restic restore latest \
                --repo "$repo" \
                --target "$TEST_DIR" \
                --include "$file"

            if ! diff -q "$file" "$TEST_DIR/$file" >/dev/null 2>&1; then
                info "File $file from $repo is not the same as local"
                exit 1
            fi

        done <"$2"

        rm -rf "$TEST_DIR"

    done <"$1"
}

docheck ~/Scripts/.config/restic-full-repos ~/Scripts/.config/restic-full-checks
docheck ~/Scripts/.config/restic-small-repos ~/Scripts/.config/restic-small-checks
