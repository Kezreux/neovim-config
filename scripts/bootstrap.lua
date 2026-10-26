-- Headless pre-install of treesitter parsers and Mason tools, waiting for both
-- to finish. Run by install.sh / update.sh:
--   nvim --headless "+luafile scripts/bootstrap.lua" +qa
local Config = require("lazy.core.config")
local Plugin = require("lazy.core.plugin")

local function opts(name)
  local p = Config.plugins[name]
  if not p then return {} end
  require("lazy").load({ plugins = { p } })
  return Plugin.values(p, "opts", false)
end

-- Treesitter parsers
local parsers = opts("nvim-treesitter").ensure_installed or {}
print(("treesitter: %d parsers\n"):format(#parsers))
require("nvim-treesitter").install(parsers, { summary = true }):wait(600000)

-- Mason tools (LSPs, formatters, linters)
local tools = opts("mason.nvim").ensure_installed or {}
local registry = require("mason-registry")
local done = false
registry.refresh(function() done = true end)
vim.wait(120000, function() return done end, 200)

local pending = {}
for _, name in ipairs(tools) do
  local ok, pkg = pcall(registry.get_package, name)
  if ok and not pkg:is_installed() then
    -- LazyVim's mason config may have already kicked this off on load
    if not pkg:is_installing() then pkg:install() end
    print(("mason: installing %s\n"):format(name))
    table.insert(pending, pkg)
  end
end
vim.wait(900000, function()
  for _, pkg in ipairs(pending) do
    if pkg:is_installing() then return false end
  end
  return true
end, 500)
for _, pkg in ipairs(pending) do
  print(("mason: %s %s\n"):format(pkg.name, pkg:is_installed() and "ok" or "FAILED"))
end
