-- Environment and PATH utilities
local M = {}

--- Add a directory to PATH if it exists and is not already present
---@param dir string The directory to add
---@return boolean True if the directory was added
function M.add_to_path(dir)
  if vim.fn.isdirectory(dir) == 1 and not (vim.env.PATH or ""):find(dir, 1, true) then
    vim.env.PATH = (vim.env.PATH or "") .. ":" .. dir
    return true
  end
  return false
end

--- Setup common development paths (local bin, NVM, etc.)
--- This is especially useful when Neovim is launched from a GUI
--- and doesn't inherit the shell's PATH configuration
function M.setup_dev_paths()
  local home = vim.fn.expand("~")

  -- Add ~/.local/bin
  M.add_to_path(home .. "/.local/bin")

  -- Add all installed NVM node versions
  local nvm_glob = home .. "/.nvm/versions/node/*/bin"
  local bins = vim.fn.glob(nvm_glob, false, true)
  for _, bin_dir in ipairs(bins) do
    M.add_to_path(bin_dir)
  end
end

--- Apply Neovim 0.11+ API compatibility shims
--- Some plugins use deprecated LSP APIs; this provides forwards compatibility
function M.apply_lsp_compat()
  if vim.lsp and vim.lsp.get_clients then
    vim.lsp.buf_get_clients = function(bufnr)
      return vim.lsp.get_clients({ bufnr = bufnr })
    end
  end
end

return M
