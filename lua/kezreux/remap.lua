
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Ctrl-Z to undo (overrides terminal-suspend inside nvim; use :suspend if needed)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set("v", "<C-z>", "<Esc>u", { desc = "Undo" })
