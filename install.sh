#!/usr/bin/env bash
# Bootstrap this neovim config on a fresh machine.
#
# Usage:
#   bash install.sh
#
# Assumes the repo is already cloned to ~/.config/nvim. If not, run:
#   gh repo clone Kezreux/neovim-config ~/.config/nvim
#   bash ~/.config/nvim/install.sh

set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"

say() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

# 1. Sanity checks
[ -d "$CONFIG_DIR" ] || die "$CONFIG_DIR not found — clone the repo there first."
[ -f "$CONFIG_DIR/init.lua" ] || die "$CONFIG_DIR/init.lua missing — wrong directory?"

# 2. Install system deps (Debian/Ubuntu only)
if command -v apt >/dev/null 2>&1; then
    say "Installing system dependencies via apt"
    sudo apt update
    sudo apt install -y \
        neovim \
        git \
        build-essential \
        unzip \
        ripgrep \
        fd-find \
        curl
else
    warn "apt not found. Install these manually for your distro:"
    warn "  neovim (>= 0.10), git, build-essential/gcc+make, unzip, ripgrep, fd-find, curl"
fi

# 3. Symlink fd → fdfind (Debian names the binary fdfind)
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    say "Symlinking fd → fdfind in $LOCAL_BIN"
    mkdir -p "$LOCAL_BIN"
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
fi

# 4. Verify nvim version
if command -v nvim >/dev/null 2>&1; then
    NVIM_VER=$(nvim --version | head -1 | awk '{print $2}')
    say "Detected $NVIM_VER"
    case "$NVIM_VER" in
        v0.[0-9].* | v0.10.*) ;;  # known-good
        *) warn "Unfamiliar nvim version — config tested on 0.10.x" ;;
    esac
else
    die "nvim not installed."
fi

# 5. Bootstrap lazy.nvim and install plugins headlessly
say "Bootstrapping plugins (this may take a minute)"
nvim --headless "+Lazy! sync" +qa

# 6. Install treesitter parsers (also runs on first buffer-open, but pre-warming avoids surprises)
say "Pre-installing treesitter parsers"
nvim --headless "+TSUpdateSync" +qa || warn "TSUpdateSync failed — parsers will install lazily on file open"

# 7. Final notes
cat <<'EOF'

Done. Launch with:
    nvim

Reminder: icons (lualine, neo-tree, bufferline, gitsigns) require a Nerd Font
on the terminal you're using. If you see □ boxes, install a Nerd Font from
https://www.nerdfonts.com/font-downloads and set it as your terminal font.

If you SSH'd in, the font goes on the laptop side, not this server.

EOF
