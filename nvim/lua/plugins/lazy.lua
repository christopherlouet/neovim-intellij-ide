local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local EXPECTED_REMOTE = "https://github.com/folke/lazy.nvim.git"

-- Verify lazy.nvim installation integrity
local function verify_lazy_install()
  if vim.fn.isdirectory(lazypath .. "/.git") == 0 then
    return false, "Not a git repository"
  end

  -- Verify remote URL matches expected
  local remote = vim.fn.system("git -C " .. vim.fn.shellescape(lazypath) .. " remote get-url origin"):gsub("%s+$", "")
  if remote ~= EXPECTED_REMOTE then
    return false, "Unexpected remote URL: " .. remote
  end

  return true, nil
end

if not vim.loop.fs_stat(lazypath) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    EXPECTED_REMOTE,
    "--branch=stable",
    lazypath,
  })

  -- Verify the fresh clone
  local ok, err = verify_lazy_install()
  if not ok then
    vim.notify("lazy.nvim verification failed: " .. tostring(err), vim.log.levels.ERROR)
    -- Remove potentially compromised installation
    vim.fn.delete(lazypath, "rf")
    error("lazy.nvim installation failed verification")
  end
else
  -- Verify existing installation
  local ok, err = verify_lazy_install()
  if not ok then
    vim.notify("lazy.nvim verification failed: " .. tostring(err) .. ". Consider reinstalling.", vim.log.levels.WARN)
  end
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
