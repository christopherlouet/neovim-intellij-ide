-- Enable byte-compiled cache (Neovim 0.9+)
if vim.loader then
  vim.loader.enable()
end

-- Leader keys MUST be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- init.lua
require("plugins.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.doctor")
