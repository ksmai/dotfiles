#!/bin/sh

export BORG_REPO=~/backup/borg/personal

read -p "Enter passphrase: " -s BORG_PASSPHRASE
export BORG_PASSPHRASE
echo ""

info() { printf "[%s] %s\n" "$(date)" "$*" >&2; }
trap 'echo [$(date)] Backup interrupted >&2; exit 2' INT TERM

info "Backing up ~/personal"

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression zlib,3            \
                                    \
    ::'{now}'                       \
    ~/personal                      

backup_exit=$?

info "Pruning repository"

borg prune                          \
    --list                          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

info "Compacting repository"

borg compact

compact_exit=$?

global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
