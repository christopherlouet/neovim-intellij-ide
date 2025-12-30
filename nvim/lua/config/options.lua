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

-- Undo / backups
vim.opt.undofile = true

-- Sessions: keep localoptions so filetype/highlighting restore correctly
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Ensure Node/npm installed via NVM are visible to Neovim (especially when launched from GUI)
do
  local home = vim.fn.expand("~")
  local localbin = home .. "/.local/bin"

  if not (vim.env.PATH or ""):find(localbin, 1, true) then
    vim.env.PATH = (vim.env.PATH or "") .. ":" .. localbin
  end

  -- Add all installed NVM node bins, if present
  local nvm_glob = home .. "/.nvm/versions/node/*/bin"
  local bins = vim.fn.glob(nvm_glob, false, true)
  for _, b in ipairs(bins) do
    if vim.fn.isdirectory(b) == 1 and not (vim.env.PATH or ""):find(b, 1, true) then
      vim.env.PATH = (vim.env.PATH or "") .. ":" .. b
    end
  end
end

-- Neovim >= 0.11: avoid deprecated LSP APIs used by some plugins (e.g. project.nvim).
-- Override deprecated function name to new API to suppress warnings.
if vim.lsp and vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
end
