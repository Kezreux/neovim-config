-- Training wheels. Delete this file once you don't need them.
return {
  -- Faint hints showing where w, b, e, ^, $, % ... would jump. Off by default.
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = { startVisible = false },
    keys = {
      { "<leader>uP", function() require("precognition").toggle() end, desc = "Toggle Motion Hints" },
    },
  },

  -- Practice game: run :VimBeGood
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
}
