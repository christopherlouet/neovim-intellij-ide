-- Patch project.nvim to avoid deprecated vim.lsp.buf_get_clients() on Neovim >= 0.11
-- Safe no-op if internals change.
pcall(function()
  local project = require("project_nvim.project")
  if type(project) ~= "table" then return end
  -- Some versions keep a local helper; we can only patch exported functions.
  -- project.update_lsp_clients may exist; if so, rewrite it to use vim.lsp.get_clients.
  if type(project.update_lsp_clients) == "function" and vim.lsp.get_clients then
    project.update_lsp_clients = function()
      return vim.lsp.get_clients()
    end
  end
end)
