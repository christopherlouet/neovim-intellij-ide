#!/usr/bin/env bash
# Test rapide des keymaps - vérification statique des fichiers de configuration
# Usage: ./scripts/test-keymaps.sh

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🧪 Test des keymaps (static analysis)..."
echo ""

# Compteurs
PASS=0
FAIL=0

# Fonction pour vérifier qu'un keymap existe dans un fichier
check_keymap() {
  local file="$1"
  local keymap="$2"
  local desc="$3"

  # Échapper les caractères spéciaux pour grep
  local escaped_keymap
  escaped_keymap=$(printf '%s\n' "$keymap" | sed 's/[[\.*^$/]/\\&/g')

  if grep -qF "\"$keymap\"" "$file" 2>/dev/null; then
    echo "✓ $keymap - $desc"
    ((PASS++))
  else
    echo "✗ $keymap - $desc NOT FOUND in $(basename "$file")"
    ((FAIL++))
  fi
}

echo "Checking terminal keymaps..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/terminal.lua" "<leader>tf" "Terminal float (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/terminal.lua" "<leader>th" "Terminal horizontal (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/terminal.lua" "<leader>tv" "Terminal vertical (NEW)"

echo ""
echo "Checking telescope keymaps..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/telescope.lua" "<leader>fw" "Find word (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/telescope.lua" "<leader>fh" "Recent files (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/telescope.lua" "<leader>fp" "Projects (NEW)"

echo ""
echo "Checking git keymaps..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/git.lua" "]c" "Next hunk (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/git.lua" "[c" "Prev hunk (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/git.lua" "<leader>hs" "Stage hunk (NEW)"

echo ""
echo "Checking LSP keymaps..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/lsp.lua" "gr" "References (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/lsp.lua" "<C-k>" "Signature help (NEW)"

echo ""
echo "Checking debug keymaps..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/debug.lua" "<leader>dc" "Continue (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/debug.lua" "<leader>di" "Step into (NEW)"
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/debug.lua" "<leader>du" "Toggle UI (NEW)"

echo ""
echo "============================================"
echo "Results: ✅ $PASS passed, ❌ $FAIL failed"
echo "============================================"

if [ $FAIL -eq 0 ]; then
  echo ""
  echo "✅ All keymap definitions found in config files!"
  exit 0
else
  echo ""
  echo "❌ Some keymap definitions are missing"
  exit 1
fi
