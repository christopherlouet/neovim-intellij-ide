-- Theme selector module for Neovim
-- Provides theme selection with persistence across sessions
local M = {}

-- Storage path for theme persistence
local storage_path = vim.fn.stdpath("data") .. "/theme_choice.json"

-- Available themes configuration
local themes = {
  {
    name = "cyberpunk",
    colorscheme = "cyberdream",
    plugin = "scottmckendry/cyberdream.nvim",
    description = "Neon cyberpunk aesthetic",
  },
  {
    name = "matrix",
    colorscheme = "matrix",
    plugin = "Jeosas/matrix.nvim",
    description = "Matrix-inspired green terminal",
  },
  {
    name = "dracula",
    colorscheme = "dracula",
    plugin = "Mofiqul/dracula.nvim",
    description = "Dark theme with vibrant colors",
  },
  {
    name = "catppuccin",
    colorscheme = "catppuccin",
    plugin = "catppuccin/nvim",
    description = "Soothing pastel theme",
  },
  {
    name = "nord",
    colorscheme = "nord",
    plugin = "shaunsingh/nord.nvim",
    description = "Arctic, north-bluish color palette",
  },
  {
    name = "gruvbox",
    colorscheme = "gruvbox",
    plugin = "ellisonleao/gruvbox.nvim",
    description = "Retro groove color scheme",
  },
  {
    name = "tokyo-night",
    colorscheme = "tokyonight",
    plugin = "folke/tokyonight.nvim",
    description = "Clean, dark Tokyo Night theme",
  },
}

--- Get all available themes
---@return table[] List of theme configurations
function M.get_themes()
  return themes
end

--- Get theme names for display in vim.ui.select
---@return string[] List of formatted theme names
function M.get_theme_names()
  local names = {}
  for _, theme in ipairs(themes) do
    table.insert(names, string.format("%s - %s", theme.name, theme.description))
  end
  return names
end

--- Get theme configuration by name
---@param name string Theme name
---@return table|nil Theme configuration or nil if not found
function M.get_theme_by_name(name)
  for _, theme in ipairs(themes) do
    if theme.name == name then
      return theme
    end
  end
  return nil
end

--- Get the storage path for theme persistence
---@return string Path to storage file
function M.get_storage_path()
  return storage_path
end

--- Set storage path (for testing purposes)
---@param path string New storage path
function M._set_storage_path(path)
  storage_path = path
end

--- Save theme choice to file
---@param theme_name string Name of theme to save
---@return boolean True if save successful
function M.save_theme(theme_name)
  local data = vim.fn.json_encode({ theme = theme_name })
  local ok = pcall(vim.fn.writefile, { data }, storage_path)
  return ok
end

--- Load saved theme choice from file
---@return string|nil Saved theme name or nil if not found
function M.load_saved_theme()
  if vim.fn.filereadable(storage_path) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(storage_path)
  if #lines == 0 then
    return nil
  end

  local ok, data = pcall(vim.fn.json_decode, lines[1])
  if not ok or type(data) ~= "table" then
    return nil
  end

  return data.theme
end

--- Get current colorscheme
---@return string Current colorscheme name
function M.get_current_theme()
  return vim.g.colors_name or "default"
end

--- Apply a theme by name
---@param theme_name string Name of theme to apply
---@param save boolean|nil Whether to persist the choice (default: true)
function M.apply_theme(theme_name, save)
  local theme = M.get_theme_by_name(theme_name)
  if not theme then
    vim.notify("Theme not found: " .. theme_name, vim.log.levels.ERROR)
    return
  end

  -- Apply colorscheme
  local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
  if not ok then
    vim.notify("Failed to apply theme: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.notify("Theme: " .. theme.name, vim.log.levels.INFO)

  -- Persist choice if requested (default: true)
  if save ~= false then
    M.save_theme(theme_name)
  end
end

--- Open theme selector using vim.ui.select
function M.select_theme()
  local names = M.get_theme_names()

  vim.ui.select(names, {
    prompt = "Select Theme:",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if not choice then
      return
    end

    -- Extract theme name from choice (before " - ")
    local theme_name = choice:match("^([^%s]+)")
    if theme_name then
      M.apply_theme(theme_name)
    end
  end)
end

--- Initialize theme selector - load saved theme on startup
function M.setup()
  local saved = M.load_saved_theme()
  if saved then
    -- Apply saved theme without re-saving
    M.apply_theme(saved, false)
  end
end

return M
