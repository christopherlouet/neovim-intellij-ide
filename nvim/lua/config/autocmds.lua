vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function() pcall(vim.cmd, "checktime") end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})
