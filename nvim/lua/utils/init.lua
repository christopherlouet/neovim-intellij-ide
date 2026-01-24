-- Utility functions for Neovim IntelliJ IDE
local M = {}

--- Check if a binary executable exists in PATH
--- Uses vim.fn.executable() which is the most reliable method
---@param bin string The binary name to check
---@return boolean True if the binary is found in PATH
function M.has(bin)
  return vim.fn.executable(bin) == 1
end

return M
