-- Custom Lua ftplugin to prevent treesitter loading
-- This replaces the default Neovim 0.12 ftplugin that tries to use treesitter

-- Only load once
if vim.b.did_ftplugin_lua then
  return
end
vim.b.did_ftplugin_lua = 1

-- Use native syntax highlighting instead of treesitter
vim.bo.syntax = "lua"

-- Basic Lua-specific settings
vim.bo.commentstring = "-- %s"
vim.bo.formatoptions = "croql"
vim.bo.suffixesadd = ".lua"

-- Set include pattern for 'gf' and similar commands
vim.bo.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.bo.includeexpr = "substitute(v:fname,'\\.','/','g')"

-- Define pattern for matching functions
vim.bo.define = [[^\s*\%(local\s\+\)\=function]]
