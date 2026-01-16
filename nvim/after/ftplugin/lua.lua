-- Lua-specific settings (treesitter handles syntax highlighting)
vim.bo.commentstring = "-- %s"
vim.bo.formatoptions = "croql"
vim.bo.suffixesadd = ".lua"
vim.bo.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.bo.includeexpr = "substitute(v:fname,'\\.','/','g')"
