-- Keymaps are loaded on the VeryLazy event.
-- LazyVim defaults: https://www.lazyvim.org/keymaps

-- Space h: open the cheatsheet in a floating window (q to close)
vim.keymap.set("n", "<leader>h", function()
  Snacks.win({
    file = vim.fn.stdpath("config") .. "/cheatsheet.md",
    title = " Cheatsheet ",
    width = 0.7,
    height = 0.85,
    border = "rounded",
    bo = { modifiable = false, readonly = true },
    wo = { wrap = true, conceallevel = 2, spell = false },
    keys = { q = "close" },
  })
end, { desc = "Cheatsheet" })

-- Space pv: swap the current window for neo-tree, revealing the current file
vim.keymap.set("n", "<leader>pv", "<cmd>Neotree position=current reveal<cr>", { desc = "Project View (neo-tree)" })

-- Ctrl-Z to undo (overrides terminal-suspend inside nvim; use :suspend if needed)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set("v", "<C-z>", "<Esc>u", { desc = "Undo" })
