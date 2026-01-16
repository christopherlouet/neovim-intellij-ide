-- Profile system for neovim-intellij-ide
-- Allows users to select a subset of plugins based on their use case
--
-- Usage:
--   Set vim.g.nvim_profile before loading plugins:
--   vim.g.nvim_profile = "minimal"  -- or "javascript", "devops", "full"
--
-- Available profiles:
--   - minimal: Core IDE features only (LSP, completion, navigation)
--   - javascript: Minimal + JS/TS tooling
--   - devops: Minimal + K8s, Terraform, Docker, Ansible
--   - full: All plugins (default)

local M = {}

-- Profile definitions
-- Each profile lists the plugin modules to load
M.profiles = {
  -- Minimal: Core IDE experience
  minimal = {
    "plugins.lazy",
    "plugins.ui",
    "plugins.lsp",
    "plugins.completion",
    "plugins.telescope",
    "plugins.treesitter",
    "plugins.git",
    "plugins.formatting",
    "plugins.syntax",
  },

  -- JavaScript/TypeScript development
  javascript = {
    "plugins.lazy",
    "plugins.ui",
    "plugins.lsp",
    "plugins.completion",
    "plugins.telescope",
    "plugins.treesitter",
    "plugins.git",
    "plugins.formatting",
    "plugins.syntax",
    "plugins.terminal",
    "plugins.debug",
    "plugins.tests",
    "plugins.navigation",
  },

  -- DevOps/Infrastructure
  devops = {
    "plugins.lazy",
    "plugins.ui",
    "plugins.lsp",
    "plugins.completion",
    "plugins.telescope",
    "plugins.treesitter",
    "plugins.git",
    "plugins.formatting",
    "plugins.syntax",
    "plugins.terminal",
    "plugins.devops",
    "plugins.docker",
    "plugins.database",
    "plugins.http",
    "plugins.logs",
  },

  -- Full: Everything
  full = {
    "plugins.lazy",
    "plugins.ui",
    "plugins.lsp",
    "plugins.completion",
    "plugins.telescope",
    "plugins.treesitter",
    "plugins.git",
    "plugins.formatting",
    "plugins.syntax",
    "plugins.terminal",
    "plugins.debug",
    "plugins.tests",
    "plugins.navigation",
    "plugins.devops",
    "plugins.docker",
    "plugins.database",
    "plugins.http",
    "plugins.logs",
    "plugins.ai",
  },
}

-- Get current profile name
function M.get_profile()
  return vim.g.nvim_profile or "full"
end

-- Get modules for current profile
function M.get_modules()
  local profile = M.get_profile()
  local modules = M.profiles[profile]

  if not modules then
    vim.notify(string.format("Unknown profile '%s', falling back to 'full'", profile), vim.log.levels.WARN)
    return M.profiles.full
  end

  return modules
end

-- Check if a module should be loaded for current profile
function M.should_load(module_name)
  local modules = M.get_modules()
  for _, mod in ipairs(modules) do
    if mod == module_name then
      return true
    end
  end
  return false
end

-- List available profiles
function M.list_profiles()
  local profiles = {}
  for name, _ in pairs(M.profiles) do
    table.insert(profiles, name)
  end
  table.sort(profiles)
  return profiles
end

-- Get profile info
function M.get_info()
  local profile = M.get_profile()
  local modules = M.get_modules()
  return {
    name = profile,
    modules = modules,
    module_count = #modules,
  }
end

-- Print profile info (for debugging)
function M.print_info()
  local info = M.get_info()
  print(string.format("Profile: %s (%d modules)", info.name, info.module_count))
  print("Modules:")
  for _, mod in ipairs(info.modules) do
    print("  - " .. mod)
  end
end

-- Create user command to show/switch profiles
vim.api.nvim_create_user_command("NvimProfile", function(opts)
  if opts.args == "" or opts.args == "info" then
    M.print_info()
  elseif opts.args == "list" then
    print("Available profiles: " .. table.concat(M.list_profiles(), ", "))
  else
    print("Usage: :NvimProfile [info|list]")
    print("To change profile, set vim.g.nvim_profile in init.lua before loading plugins")
  end
end, {
  nargs = "?",
  complete = function()
    return { "info", "list" }
  end,
  desc = "Show Neovim profile info",
})

return M
