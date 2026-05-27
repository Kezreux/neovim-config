return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
            untracked    = { text = "▎" },
        },
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
            end
            map("n", "]h", gs.next_hunk, "Next hunk")
            map("n", "[h", gs.prev_hunk, "Prev hunk")
            map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
            map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
            map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        end,
    },
}
