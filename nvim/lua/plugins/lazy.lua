local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load profile system
local profiles = require("profiles")
local profile_modules = profiles.get_modules()

-- Build plugin imports based on profile
local plugin_imports = {}
for _, module in ipairs(profile_modules) do
  -- Skip lazy.lua itself (it's this file)
  if module ~= "plugins.lazy" then
    table.insert(plugin_imports, { import = module })
  end
end

-- Show profile info on startup (only in verbose mode)
if vim.g.nvim_profile_verbose then
  vim.notify(
    string.format("Neovim profile: %s (%d modules)", profiles.get_profile(), #profile_modules),
    vim.log.levels.INFO
  )
end

require("lazy").setup(plugin_imports, {
  ui = { border = "rounded" },
  checker = { enabled = true },
  rocks = { enabled = false, hererocks = false },
})
