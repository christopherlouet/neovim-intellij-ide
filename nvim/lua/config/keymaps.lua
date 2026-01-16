-- Keymaps pour améliorer la productivité quotidienne
local map = vim.keymap.set

-- ============================
-- Sauvegardes et quitter
-- ============================
map("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })

-- ============================
-- Navigation fenêtres
-- ============================
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ============================
-- Redimensionnement fenêtres
-- ============================
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ============================
-- Déplacer lignes
-- ============================
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- ============================
-- Indentation
-- ============================
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ============================
-- Navigation dans le buffer
-- ============================
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- ============================
-- Copier/Coller amélioré
-- ============================
-- Garder le registre après coller sur sélection
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Copier dans le clipboard système
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Supprimer sans copier
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete without yanking" })

-- ============================
-- Recherche et remplacement
-- ============================
-- Désactiver highlight recherche avec Esc
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Remplacement rapide du mot sous le curseur
map("n", "<leader>sR", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- ============================
-- Gestion des onglets
-- ============================
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- ============================
-- Quickfix & Location list
-- ============================
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- ============================
-- Terminal mode
-- ============================
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================
-- Diagnostics LSP
-- ============================
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- IncRename (preview live)
map("n", "<leader>rN", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename (IncRename preview)" })

-- ============================
-- Formatage
-- ============================
map("n", "<leader>cf", function()
  vim.lsp.buf.format({ timeout_ms = 2000 })
end, { desc = "Format document" })

map("v", "<leader>cf", function()
  vim.lsp.buf.format({ timeout_ms = 2000 })
end, { desc = "Format range" })

-- ============================
-- Ligne à 80 caractères (toggle)
-- ============================
map("n", "<leader>u8", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"
  else
    vim.wo.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn 80" })

-- ============================
-- Toggle options
-- ============================
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

map("n", "<leader>ul", function()
  vim.wo.number = not vim.wo.number
end, { desc = "Toggle line numbers" })

map("n", "<leader>uR", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })

-- ============================
-- Splits
-- ============================
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- Optional IntelliJ migration keymaps (created by intellij-migrate.sh)
pcall(require, "config.intellij_migration")
