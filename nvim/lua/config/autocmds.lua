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
