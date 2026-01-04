-- Override pour désactiver treesitter sur les fichiers Lua
-- Neovim 0.12 essaie d'utiliser treesitter par défaut, mais nous utilisons la syntaxe native

-- Désactiver treesitter explicitement pour ce buffer
vim.b.ts_highlight = false
vim.treesitter.stop()

-- S'assurer que la coloration syntaxique native est activée
vim.bo.syntax = "lua"
