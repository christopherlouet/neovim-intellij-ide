-- Minimal init.lua for running tests with plenary.nvim
-- Usage: nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"

-- Set leader keys (required by keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add project root to runtimepath
local project_root = vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h")
vim.opt.rtp:prepend(project_root)
vim.opt.rtp:prepend(project_root .. "/nvim")

-- Add plenary to runtimepath (installed via lazy.nvim or system)
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 1 then
  vim.opt.rtp:prepend(plenary_path)
end

-- Fallback: check if plenary is in lazy plugins directory relative to nvim config
local lazy_plenary = vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim")
if vim.fn.isdirectory(lazy_plenary) == 1 then
  vim.opt.rtp:prepend(lazy_plenary)
end

-- Load plenary
local ok, plenary = pcall(require, "plenary")
if not ok then
  print("ERROR: plenary.nvim not found. Please install it first:")
  print("  :Lazy install plenary.nvim")
  print("  or: git clone https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/lazy/plenary.nvim")
  vim.cmd("cquit 1")
end

-- Basic vim options for testing
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false
vim.opt.termguicolors = true

-- Suppress messages during tests
vim.opt.shortmess:append("sWcC")

print("Test environment initialized successfully")
