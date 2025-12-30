-- Temporary compatibility patch for Neovim >= 0.11
-- project.nvim still calls vim.lsp.buf_get_clients(), removed in Neovim 0.12.
-- We override it to the new API to avoid warnings.
if vim.lsp and vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
end
