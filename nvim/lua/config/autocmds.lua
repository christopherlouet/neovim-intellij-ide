local augroup = vim.api.nvim_create_augroup("NeovimIntelliJIDE", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  callback = function()
    pcall(vim.cmd, "checktime")
  end,
  desc = "Check if file changed outside of Neovim",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
  desc = "Highlight on yank",
})

-- Force native syntax highlighting for Lua files (disable treesitter)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "lua",
  callback = function()
    -- Désactiver treesitter pour ce buffer
    pcall(vim.treesitter.stop)
    -- Forcer la syntaxe native
    vim.bo.syntax = "lua"
  end,
  desc = "Use native Lua syntax instead of treesitter",
})
