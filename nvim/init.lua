-- Leader keys MUST be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- init.lua
require("plugins.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.doctor")
