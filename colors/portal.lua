-- Portal: Rick and Morty / hacker green. Built on mini.base16.
-- base00-07 run dark -> light; base08-0F are the accent colours.
require("mini.base16").setup({
  palette = {
    base00 = "#080a0b", -- background
    base01 = "#0c0e10", -- statusline, floats
    base02 = "#101315", -- selection, cursorline
    base03 = "#8a9294", -- comments
    base04 = "#8a9294", -- line numbers, dark foreground
    base05 = "#cacccc", -- foreground
    base06 = "#bfc4c4",
    base07 = "#b6f24a", -- portal green
    base08 = "#e0954a", -- variables, tags (red/orange)
    base09 = "#eaa864", -- numbers, constants
    base0A = "#edd83d", -- types, search (Morty yellow)
    base0B = "#7fd44f", -- strings (green)
    base0C = "#4fd4a0", -- regex, escapes (cyan)
    base0D = "#74b6d2", -- functions (Rick's hair blue)
    base0E = "#afa2d9", -- keywords (magenta)
    base0F = "#b6f24a", -- portal green
  },
  use_cterm = true,
})
vim.g.colors_name = "portal"

-- A few touches mini.base16 doesn't do
local hl = vim.api.nvim_set_hl
hl(0, "CursorLineNr", { fg = "#b6f24a", bold = true })
hl(0, "Visual", { bg = "#1c2124" })
hl(0, "WinSeparator", { fg = "#1c2124" })
hl(0, "FloatBorder", { fg = "#b6f24a", bg = "#0c0e10" })
