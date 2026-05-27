return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        preset = "modern",
        spec = {
            { "<leader>p", group = "project / picker" },
            { "<leader>g", group = "git" },
            { "<leader>f", group = "format / find" },
            { "<leader>v", group = "view / vim" },
        },
    },
}
