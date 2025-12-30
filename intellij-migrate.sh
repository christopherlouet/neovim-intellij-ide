#!/usr/bin/env bash
set -euo pipefail

# IntelliJ → Neovim migration helper.
# - Installs an optional keymap layer approximating common IntelliJ shortcuts
# - Writes a cheatsheet (habits + mappings) next to your Neovim config
#
# Usage:
#   ./intellij-migrate.sh
#   ./intellij-migrate.sh --remove

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }

REMOVE=0
for arg in "$@"; do
  case "$arg" in
    --remove) REMOVE=1 ;;
  esac
done

NVIM_CFG="${HOME}/.config/nvim"
LUA_DIR="${NVIM_CFG}/lua/config"
TARGET_LUA="${LUA_DIR}/intellij_migration.lua"
CHEATSHEET="${NVIM_CFG}/INTELLIJ_MIGRATION.md"

if [ "$REMOVE" -eq 1 ]; then
  say "Remove IntelliJ migration layer"
  rm -f "$TARGET_LUA" "$CHEATSHEET"
  echo "Removed: $TARGET_LUA"
  echo "Removed: $CHEATSHEET"
  echo "Note: config/keymaps.lua keeps a safe pcall(require, ...) line."
  exit 0
fi

say "Install IntelliJ migration layer into: $TARGET_LUA"
mkdir -p "$LUA_DIR"

cat > "$TARGET_LUA" <<'LUA'
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

-- Rename (Shift+F6)
map("n", "<S-F6>", vim.lsp.buf.rename, { desc = "IntelliJ: Rename (Shift+F6)" })

-- Code actions (Alt+Enter) – terminal-dependent, often works as Meta+Enter
map({ "n", "i" }, "<M-CR>", function()
  vim.lsp.buf.code_action()
end, { desc = "IntelliJ: Quick fix (Alt+Enter)" })

-- Reformat code (Ctrl+Alt+L) – terminal-dependent; use Alt+L fallback
map("n", "<M-l>", function()
  pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
end, { desc = "IntelliJ: Reformat (Alt+L fallback)" })

-- Toggle project view (Alt+1)
map("n", "<M-1>", "<cmd>NvimTreeToggle<cr>", { desc = "IntelliJ: Project (Alt+1)" })

-- Terminal (Alt+F12)
map("n", "<M-F12>", "<cmd>ToggleTerm<cr>", { desc = "IntelliJ: Terminal (Alt+F12)" })

-- Run/Debug (Shift+F10 / Shift+F9)
map("n", "<S-F10>", "<cmd>OverseerRun<cr>", { desc = "IntelliJ: Run (Shift+F10)" })
map("n", "<S-F9>", function()
  local ok, dap = pcall(require, "dap")
  if ok then dap.continue() end
end, { desc = "IntelliJ: Debug (Shift+F9)" })
LUA

say "Write cheatsheet: $CHEATSHEET"
cat > "$CHEATSHEET" <<'MD'
# IntelliJ → Neovim : migration (raccourcis + habitudes)

Ce fichier explique comment retrouver rapidement tes réflexes IntelliJ dans Neovim.

## 1) Raccourcis installés (layer optionnel)

> Note terminal : selon ton terminal, certaines combinaisons (Alt/Shift+Fn) peuvent varier.

- **Ctrl+S** : Save
- **Ctrl+Q** : Quit
- **Ctrl+P** : Go to File (Telescope find_files)
- **Ctrl+Shift+F** : Find in Files (Telescope live_grep)
- **Ctrl+E** : Recent files (buffers)
- **Ctrl+B** : Go to definition
- **Alt+F7** : Find usages (references)
- **Shift+F6** : Rename
- **Alt+Enter** : Code actions (Quick fix)
- **Alt+L** : Reformat (fallback)
- **Alt+1** : Project view (NvimTree)
- **Alt+F12** : Terminal
- **Shift+F10** : Run task (Overseer)
- **Shift+F9** : Debug continue (DAP)

## 2) Habitudes IntelliJ → Neovim

### “Project view”
- IntelliJ : Project (Alt+1)
- Neovim : NvimTree (Alt+1 ou `Space e`)

### “Search Everywhere”
- IntelliJ : Shift+Shift
- Neovim : `Space ff` (files) + `Space fg` (grep)
- Bonus : `Space fs` / `Space fS` (symbols)

### “Actions”
- IntelliJ : Ctrl+Shift+A
- Neovim : Which-key (appuie sur `Space` puis regarde les catégories)

### “Refactor”
- IntelliJ : Refactor This
- Neovim : `Space rn` (rename), `Space ca` (code action), `Space re` (refactoring.nvim)

### “Run configurations”
- IntelliJ : Run/Debug configs
- Neovim : Overseer (`Space or` run, `Space ot` tasks)

### “Debug”
- IntelliJ : breakpoints + step
- Neovim : F5/F10/F11/F12 + `Space db`

### “Tests”
- IntelliJ : runner tests
- Neovim : `Space tt` (file), `Space tT` (nearest), `Space ts` (summary)

## 3) Désactivation
Pour supprimer ce layer :
```bash
./intellij-migrate.sh --remove
```
MD

say "Done ✅"
echo "Next:"
echo "  - Open Neovim and try the shortcuts."
echo "  - If Alt/Meta keys don't work, configure your terminal to send Meta."
