-- Test helpers for neovim-intellij-ide
-- Provides utility functions for testing Neovim configurations

local M = {}

-- Get project root directory
function M.get_project_root()
  return vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h")
end

-- Get path to nvim config directory
function M.get_nvim_config_path()
  return M.get_project_root() .. "/nvim"
end

-- Load a config module safely
function M.load_config(module_name)
  local path = M.get_nvim_config_path() .. "/lua/" .. module_name:gsub("%.", "/") .. ".lua"
  local ok, result = pcall(dofile, path)
  if not ok then
    error("Failed to load " .. module_name .. ": " .. tostring(result))
  end
  return result
end

-- Get a keymap by mode and lhs
function M.get_keymap(mode, lhs)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs == lhs then
      return keymap
    end
  end
  return nil
end

-- Check if a keymap exists
function M.keymap_exists(mode, lhs)
  return M.get_keymap(mode, lhs) ~= nil
end

-- Get buffer-local keymap
function M.get_buf_keymap(bufnr, mode, lhs)
  local keymaps = vim.api.nvim_buf_get_keymap(bufnr, mode)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs == lhs then
      return keymap
    end
  end
  return nil
end

-- Clear all keymaps for a mode (useful for test isolation)
function M.clear_keymaps(mode)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, keymap in ipairs(keymaps) do
    pcall(vim.keymap.del, mode, keymap.lhs)
  end
end

-- Reset vim options to sensible defaults
function M.reset_options()
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.termguicolors = false
  vim.opt.expandtab = false
  vim.opt.tabstop = 8
  vim.opt.shiftwidth = 8
  vim.opt.undofile = false
  vim.opt.clipboard = ""
  vim.opt.scrolloff = 0
  vim.opt.ignorecase = false
  vim.opt.smartcase = false
end

-- Create a temporary buffer for testing
function M.create_test_buffer(content)
  local bufnr = vim.api.nvim_create_buf(false, true)
  if content then
    local lines = type(content) == "table" and content or vim.split(content, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
  return bufnr
end

-- Delete a test buffer
function M.delete_test_buffer(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

-- Check if a plugin spec is valid (basic structure check)
function M.is_valid_plugin_spec(spec)
  if type(spec) ~= "table" then
    return false, "spec must be a table"
  end

  for _, plugin in ipairs(spec) do
    if type(plugin) ~= "table" then
      return false, "each plugin must be a table"
    end
    if type(plugin[1]) ~= "string" then
      return false, "plugin must have a string name as first element"
    end
  end

  return true, nil
end

-- Count keymaps with a specific prefix
function M.count_keymaps_with_prefix(mode, prefix)
  local count = 0
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, keymap in ipairs(keymaps) do
    if vim.startswith(keymap.lhs, prefix) then
      count = count + 1
    end
  end
  return count
end

return M
