#!/usr/bin/env bash
set -euo pipefail

# Healthcheck: verifies Neovim + plugins/LSP plumbing.
# Runs: checkhealth, Lazy sync, TSUpdate, MasonUpdate (best-effort)
# Logs are written to ~/.nvim-install-logs/

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }

LAZY_TIMEOUT="${LAZY_TIMEOUT:-600}"
TS_TIMEOUT="${TS_TIMEOUT:-900}"

if ! command -v nvim >/dev/null 2>&1; then
  echo "nvim not found. Install first."
  exit 1
fi

LOG_DIR="${HOME}/.nvim-install-logs"
mkdir -p "$LOG_DIR"

say "Neovim version"
nvim --version | head -n 2

say "checkhealth"
nvim --headless "+checkhealth" +qa >"${LOG_DIR}/checkhealth.log" 2>&1 || true
echo "log: ${LOG_DIR}/checkhealth.log"

say "Lazy sync (headless, timeout)"
timeout "${LAZY_TIMEOUT}s" nvim --headless "+Lazy! sync" +qa >"${LOG_DIR}/lazy-sync.log" 2>&1 || true
echo "log: ${LOG_DIR}/lazy-sync.log"

say "Treesitter update (headless, timeout)"
timeout "${TS_TIMEOUT}s" nvim --headless "+TSUpdate" +qa >"${LOG_DIR}/treesitter-update.log" 2>&1 || true
echo "log: ${LOG_DIR}/treesitter-update.log"

say "Mason update (if installed)"
nvim --headless "+lua pcall(function() vim.cmd('MasonUpdate') end)" +qa >"${LOG_DIR}/mason-update.log" 2>&1 || true
echo "log: ${LOG_DIR}/mason-update.log"

say "Done ✅"
