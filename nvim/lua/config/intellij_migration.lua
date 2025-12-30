-- IntelliJ → Neovim migration layer (optional)
-- This file is safe to delete if you don't want IntelliJ-like shortcuts.

local map = vim.keymap.set
local b = function()
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then return builtin end
  return nil
end

-- Save / quit
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "IntelliJ: Save" })
map("n", "<C-q>", "<cmd>q<cr>", { desc = "IntelliJ: Quit" })

-- Navigation / search (Ctrl+P, Ctrl+Shift+F, Ctrl+E)
map("n", "<C-p>", function()
  local builtin = b(); if builtin then builtin.find_files() end
end, { desc = "IntelliJ: Go to File (Ctrl+P)" })

map("n", "<C-S-f>", function()
  local builtin = b(); if builtin then builtin.live_grep() end
end, { desc = "IntelliJ: Find in Files (Ctrl+Shift+F)" })

map("n", "<C-e>", function()
  local builtin = b(); if builtin then builtin.buffers() end
end, { desc = "IntelliJ: Recent files (buffers)" })

-- Go to definition (Ctrl+B)
map("n", "<C-b>", vim.lsp.buf.definition, { desc = "IntelliJ: Go to Declaration/Definition (Ctrl+B)" })

-- Find usages (Alt+F7)
map("n", "<M-F7>", vim.lsp.buf.references, { desc = "IntelliJ: Find Usages (Alt+F7)" })

-- Rename (Shift+F6) → leader rn already; add F6 variant
map("n", "<S-F6>", vim.lsp.buf.rename, { desc = "IntelliJ: Rename (Shift+F6)" })

-- Code actions (Alt+Enter)
map({ "n", "i" }, "<M-CR>", function()
  vim.lsp.buf.code_action()
end, { desc = "IntelliJ: Quick fix (Alt+Enter)" })

-- Reformat code (Ctrl+Alt+L) – terminal-dependent; use Alt+L as fallback
map("n", "<M-l>", function()
  pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
end, { desc = "IntelliJ: Reformat (Alt+L fallback)" })

-- Toggle project view (Alt+1) – map to file tree (leader e)
map("n", "<M-1>", "<cmd>NvimTreeToggle<cr>", { desc = "IntelliJ: Project (Alt+1)" })

-- Terminal (Alt+F12) – open toggleterm (Ctrl+\ already)
map("n", "<M-F12>", "<cmd>ToggleTerm<cr>", { desc = "IntelliJ: Terminal (Alt+F12)" })

-- Run/Debug (Shift+F10 / Shift+F9) – using Overseer and DAP
map("n", "<S-F10>", "<cmd>OverseerRun<cr>", { desc = "IntelliJ: Run (Shift+F10)" })
map("n", "<S-F9>", function()
  local ok, dap = pcall(require, "dap")
  if ok then dap.continue() end
end, { desc = "IntelliJ: Debug (Shift+F9)" })
