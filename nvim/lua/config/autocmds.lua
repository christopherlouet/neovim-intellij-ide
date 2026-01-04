vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    pcall(vim.cmd, "checktime")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Force native syntax highlighting for Lua files (disable treesitter)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    -- Désactiver treesitter pour ce buffer
    pcall(vim.treesitter.stop)
    -- Forcer la syntaxe native
    vim.bo.syntax = "lua"
  end,
})
