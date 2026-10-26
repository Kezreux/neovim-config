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
