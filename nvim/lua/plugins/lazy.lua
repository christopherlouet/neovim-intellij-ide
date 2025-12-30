local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  rocks = { enabled = false, hererocks = false },
{ import = "plugins.ui" },
  { import = "plugins.telescope" },
  { import = "plugins.treesitter" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.formatting" },
  { import = "plugins.git" },
  { import = "plugins.terminal" },
  { import = "plugins.debug" },
  { import = "plugins.docker" },
  { import = "plugins.tests" },
  { import = "plugins.ai" },
  }, {
  ui = { border = "rounded" },
  checker = { enabled = true },
})
