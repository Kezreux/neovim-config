#!/usr/bin/env bash
# Pull the latest config from GitHub and sync plugins.
#
# Usage:
#   bash ~/.config/nvim/update.sh
#
# GitHub is the source of truth. Local edits in ~/.config/nvim that aren't
# committed and pushed will be stashed (not lost) so the pull can succeed.

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

say() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

[ -d "$CONFIG_DIR/.git" ] || die "$CONFIG_DIR is not a git repo — clone it first."

cd "$CONFIG_DIR"

# 1. Stash any uncommitted local edits so `git pull` won't refuse
STASHED=0
if ! git diff-index --quiet HEAD -- || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    say "Stashing local changes before pull"
    git stash push -u -m "update.sh auto-stash $(date -Iseconds)"
    STASHED=1
fi

# 2. Pull latest from origin
say "Pulling latest from origin"
git pull --ff-only origin "$(git rev-parse --abbrev-ref HEAD)"

# 3. Restore local edits (if any). Conflicts leave the stash in place for manual resolution.
if [ "$STASHED" -eq 1 ]; then
    say "Restoring stashed local changes"
    if ! git stash pop; then
        warn "Stash pop had conflicts — resolve manually. Your changes are in 'git stash list'."
    fi
fi

# 4. Sync plugins headlessly
if command -v nvim >/dev/null 2>&1; then
    say "Syncing plugins"
    nvim --headless "+Lazy! sync" +qa
    say "Updating treesitter parsers"
    nvim --headless "+TSUpdateSync" +qa || warn "TSUpdateSync failed — parsers will update lazily"
else
    warn "nvim not installed — skipping plugin sync"
fi

say "Done."
