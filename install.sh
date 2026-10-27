#!/usr/bin/env bash
# Bootstrap this neovim config (LazyVim) on a fresh machine / VM.
#
# Usage (one-liner):
#   git clone https://github.com/Kezreux/neovim-config ~/.config/nvim && bash ~/.config/nvim/install.sh
#
# The repo may also be cloned elsewhere; it will be symlinked to ~/.config/nvim
# (an existing config there is moved aside to ~/.config/nvim.bak-<timestamp>).
#
# Does NOT need root for nvim itself: if the system nvim is missing or too old,
# the official release is installed to ~/.local. sudo is only used for distro
# packages (git, ripgrep, fd, compiler, node, ...).

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
MIN_NVIM="0.11.2" # LazyVim requirement

say() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    have sudo && SUDO="sudo" || warn "sudo not found — system package install may fail"
fi

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64 | amd64) NVIM_ARCH="x86_64"; TS_ARCH="x64" ;;
    aarch64 | arm64) NVIM_ARCH="arm64"; TS_ARCH="arm64" ;;
    *) die "Unsupported architecture: $ARCH" ;;
esac

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"
export PATH="$LOCAL_BIN:$PATH"

# 1. Put the config in place
[ -f "$REPO_DIR/init.lua" ] || die "$REPO_DIR/init.lua missing — run this from the repo."
if [ "$(readlink -f "$CONFIG_DIR" 2>/dev/null)" != "$REPO_DIR" ]; then
    if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
        BAK="$CONFIG_DIR.bak-$(date +%Y%m%d%H%M%S)"
        say "Moving existing $CONFIG_DIR to $BAK"
        mv "$CONFIG_DIR" "$BAK"
    fi
    say "Linking $CONFIG_DIR -> $REPO_DIR"
    mkdir -p "$(dirname "$CONFIG_DIR")"
    ln -s "$REPO_DIR" "$CONFIG_DIR"
fi

# 2. System dependencies
say "Installing system dependencies"
if have apt-get; then
    $SUDO apt-get update
    $SUDO apt-get install -y git curl unzip tar gzip build-essential ripgrep fd-find fzf \
        nodejs npm python3 python3-venv xclip
    # Debian names the binary fdfind
    if have fdfind && ! have fd; then ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"; fi
elif have dnf; then
    $SUDO dnf install -y git curl unzip tar gzip gcc gcc-c++ make ripgrep fd-find fzf \
        nodejs npm python3 xclip
elif have pacman; then
    $SUDO pacman -S --needed --noconfirm git curl unzip tar gzip base-devel ripgrep fd fzf \
        nodejs npm python neovim tree-sitter-cli lazygit xclip
else
    warn "No supported package manager (apt/dnf/pacman). Install manually:"
    warn "  git curl unzip tar gcc make ripgrep fd fzf nodejs npm python3"
fi

# 3. Neovim >= $MIN_NVIM (install official release to ~/.local if needed)
version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }
nvim_version() { nvim --version 2>/dev/null | head -1 | sed -E 's/^NVIM v([0-9.]+).*/\1/'; }

if ! have nvim || ! version_ge "$(nvim_version)" "$MIN_NVIM"; then
    say "Installing latest stable Neovim to $LOCAL_OPT/nvim"
    tmp="$(mktemp -d)"
    curl -fL --retry 3 -o "$tmp/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
    rm -rf "$LOCAL_OPT/nvim"
    mkdir -p "$LOCAL_OPT/nvim"
    tar -xzf "$tmp/nvim.tar.gz" -C "$LOCAL_OPT/nvim" --strip-components=1
    ln -sf "$LOCAL_OPT/nvim/bin/nvim" "$LOCAL_BIN/nvim"
    rm -rf "$tmp"
    hash -r
fi
say "Using nvim $(nvim_version) ($(command -v nvim))"

# 4. tree-sitter CLI (nvim-treesitter main branch needs it to build parsers)
if ! have tree-sitter; then
    say "Installing tree-sitter CLI to $LOCAL_BIN"
    if curl -fL --retry 3 -o "$LOCAL_BIN/tree-sitter.gz" \
        "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${TS_ARCH}.gz"; then
        gunzip -f "$LOCAL_BIN/tree-sitter.gz"
        chmod +x "$LOCAL_BIN/tree-sitter"
    else
        warn "Could not download tree-sitter CLI — parser installs may fail"
    fi
fi

# 5. Make sure ~/.local/bin is on PATH in future shells
case ":$(bash -lc 'echo $PATH' 2>/dev/null):" in
    *":$LOCAL_BIN:"*) ;;
    *)
        say "Adding ~/.local/bin to PATH in ~/.bashrc"
        printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >>"$HOME/.bashrc"
        ;;
esac

# 6. Install plugins at the exact versions in lazy-lock.json
say "Installing plugins from lazy-lock.json (this may take a minute)"
nvim --headless "+Lazy! restore" +qa

# 7. Pre-install LSPs / formatters / parsers so first launch is quiet
say "Installing language servers and treesitter parsers"
nvim --headless "+luafile $REPO_DIR/scripts/bootstrap.lua" +qa \
    || warn "Pre-install incomplete — the rest will install on first launch"

cat <<'EOF'

Done. Open a new shell (or `export PATH="$HOME/.local/bin:$PATH"`) and run:
    nvim

Mason installs any remaining LSPs on first launch. Space h opens the cheatsheet.

Icons need a Nerd Font in your *local* terminal (the laptop side if you SSH in):
https://www.nerdfonts.com/font-downloads
EOF
