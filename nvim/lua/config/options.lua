-- Core editor options

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- UI / behavior
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 200
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cmdheight = 1
vim.opt.shortmess:append("sWcC") -- Suppress startup messages

-- Performance
vim.opt.lazyredraw = false
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = 300 -- Faster which-key

-- Recherche
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- UI améliorée
vim.opt.conceallevel = 0 -- Voir JSON/Markdown brut
vim.opt.pumheight = 10 -- Popup menu plus petit
vim.opt.showmode = false -- Mode déjà dans lualine
vim.opt.splitkeep = "screen" -- Keep screen position on split

-- Undo / backups
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Sessions: keep localoptions so filetype/highlighting restore correctly
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Environment setup: ensure development tools are in PATH
local env = require("utils.env")
env.setup_dev_paths()
env.apply_lsp_compat()
