-- Make markdownlint (linting + format on save) use our relaxed rules
-- from .markdownlint-cli2.yaml, for every Markdown file.
local config = vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml"

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = { prepend_args = { "--config", config } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = { prepend_args = { "--config", config } },
      },
    },
  },
}
