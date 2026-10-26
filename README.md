# neovim-config
Personal Neovim config ([LazyVim](https://www.lazyvim.org) + portal theme), mirrored from my Arch dotfiles so any VM gets the same setup.

## Install

```sh
git clone https://github.com/Kezreux/neovim-config ~/.config/nvim && bash ~/.config/nvim/install.sh
```

Works on apt (Debian/Ubuntu), dnf (Fedora) and pacman (Arch) systems. If the distro's Neovim is older than 0.11.2, the latest release is installed to `~/.local` (same for the `tree-sitter` CLI). An existing `~/.config/nvim` is moved to `~/.config/nvim.bak-<timestamp>`. Plugins are installed at the exact versions in `lazy-lock.json`.

## Update

```sh
bash ~/.config/nvim/update.sh
```

`<leader>h` (Space h) opens the cheatsheet.
