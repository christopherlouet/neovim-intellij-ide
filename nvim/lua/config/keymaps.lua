local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- LSP “IntelliJ-like”
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename (Refactor)" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gR", vim.lsp.buf.references, { desc = "Find references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Quick doc" })

-- IncRename (preview live)
map("n", "<leader>rN", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename (IncRename preview)" })

-- Optional IntelliJ migration keymaps (created by intellij-migrate.sh)
pcall(require, "config.intellij_migration")
