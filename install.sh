#!/usr/bin/env bash
if [ -z "${BASH_VERSION:-}" ]; then exec /usr/bin/env bash "$0" "$@"; fi
set -euo pipefail

DRY_RUN=0
VERBOSE=0
LAZY_TIMEOUT=600
TS_TIMEOUT=900
AUTO_YES=0
PREFIX="${HOME}/.local/bin"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) AUTO_YES=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    --lazy-timeout=*) LAZY_TIMEOUT="${arg#*=}" ;;
    --ts-timeout=*) TS_TIMEOUT="${arg#*=}" ;;
    --prefix=*) PREFIX="${arg#*=}" ;;
  esac
done

if [ "$VERBOSE" -eq 1 ] && [ "$DRY_RUN" -eq 0 ]; then
  set -x
fi

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }
timestamp() { date +"%Y%m%d-%H%M%S"; }

run() {
  # Run a shell command string.
  local cmd="$*"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $cmd"
  else
    bash -lc "$cmd"
  fi
}

retry_cmd() {
  local retries="$1"; shift
  local delay="$1"; shift
  local cmd="$*"
  local i=1
  while [ "$i" -le "$retries" ]; do
    if run "$cmd"; then
      return 0
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      return 0
    fi
    echo "   [warn] attempt $i/$retries failed. Retrying in ${delay}s..."
    sleep "$delay"
    i=$((i+1))
  done
  return 1
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
NVIM_SRC="$SCRIPT_DIR/nvim"

NVIM_CFG="${HOME}/.config/nvim"
NVIM_DATA="${HOME}/.local/share/nvim"
NVIM_CACHE="${HOME}/.cache/nvim"
BACKUP_DIR="${HOME}/.nvim-backups/$(timestamp)"
LOG_DIR="${HOME}/.nvim-install-logs"

# Detect distro
OS_ID=""
OS_LIKE=""
if [ -f /etc/os-release ]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  OS_ID="${ID:-}"
  OS_LIKE="${ID_LIKE:-}"
fi

is_debian_like() {
  [[ "$OS_ID" == "debian" || "$OS_ID" == "ubuntu" || "$OS_LIKE" == *debian* ]]
}
is_fedora_like() {
  [[ "$OS_ID" == "fedora" || "$OS_LIKE" == *fedora* || "$OS_LIKE" == *rhel* ]]
}

# Cleanup legacy lazy-rocks (avoid :checkhealth lazy luarocks error)
run "rm -rf \"${HOME}/.local/share/nvim/lazy-rocks\""

say "0) Backup Neovim existant -> $BACKUP_DIR"
if [ "$DRY_RUN" -eq 1 ]; then
  echo "[dry-run] mkdir -p \"$BACKUP_DIR\""
  [ -d "$NVIM_CFG" ]  && echo "[dry-run] cp -a \"$NVIM_CFG\"  \"$BACKUP_DIR/config.nvim\""
  [ -d "$NVIM_DATA" ] && echo "[dry-run] cp -a \"$NVIM_DATA\" \"$BACKUP_DIR/share.nvim\""
  [ -d "$NVIM_CACHE" ]&& echo "[dry-run] cp -a \"$NVIM_CACHE\" \"$BACKUP_DIR/cache.nvim\""
else
  mkdir -p "$BACKUP_DIR"
  [ -d "$NVIM_CFG" ]  && cp -a "$NVIM_CFG"  "$BACKUP_DIR/config.nvim"
  [ -d "$NVIM_DATA" ] && cp -a "$NVIM_DATA" "$BACKUP_DIR/share.nvim"
  [ -d "$NVIM_CACHE" ]&& cp -a "$NVIM_CACHE" "$BACKUP_DIR/cache.nvim"
fi

say "1) Dépendances système"
if is_debian_like; then
  run "sudo apt update"
  run "sudo apt install -y git curl unzip zip build-essential ripgrep fd-find xclip wl-clipboard python3 python3-pip ca-certificates software-properties-common"
  run "python3 -m pip install --user -U pynvim"
  if ! need_cmd fd && need_cmd fdfind; then
    run "mkdir -p \"${HOME}/.local/bin\""
    run "ln -sf \"$(command -v fdfind)\" \"${HOME}/.local/bin/fd\""
  fi
elif is_fedora_like; then
  run "sudo dnf -y update"
  run "sudo dnf -y install git curl unzip zip gcc gcc-c++ make ripgrep fd-find xclip wl-clipboard python3 python3-pip ca-certificates"
  run "python3 -m pip install --user -U pynvim"
else
  echo "OS non supporté automatiquement (ID=$OS_ID, LIKE=$OS_LIKE)."
  echo "Support attendu: Debian/Ubuntu/Fedora."
  exit 1
fi

say "2) Installation Neovim"
if is_debian_like; then
  if [[ "$OS_ID" == "ubuntu" ]]; then
    # Ubuntu: PPA gives more recent builds
    if ! apt-cache policy 2>/dev/null | grep -q "neovim-ppa/unstable" ; then
      run "sudo add-apt-repository ppa:neovim-ppa/unstable -y || true"
      run "sudo apt update"
    fi
    run "sudo apt install -y neovim"
  else
    # Debian: use AppImage for a recent Neovim (repos can lag)
    run "sudo apt install -y fuse3 || true"
    run "tmp=\"$(mktemp -d)\" && curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o \"$tmp/nvim.appimage\" && chmod +x \"$tmp/nvim.appimage\" && sudo install -m 0755 \"$tmp/nvim.appimage\" \"${PREFIX}/nvim\" && rm -rf \"$tmp\""
  fi
elif is_fedora_like; then
  run "sudo dnf -y install neovim"
fi

say "3) Installation NVM + Node (si nécessaire) + pnpm"
export NVM_DIR="${HOME}/.nvm"
# NOTE: nvm is a shell function. Because run() spawns a fresh `bash -lc` each time,
# we must install + source nvm and run nvm commands in a single shell invocation.
run '
  set -euo pipefail
  export NVM_DIR="$HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "   -> Installation NVM"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi
  # Ensure login shells will load nvm (run() uses bash -lc)
  if [ -f "$HOME/.bashrc" ] && ! grep -q "nvm.sh" "$HOME/.bashrc"; then
    {
      echo "";
      echo "export NVM_DIR=\"$HOME/.nvm\"";
      echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\"  # This loads nvm";
    } >> "$HOME/.bashrc"
  fi
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
  nvm install 20
  nvm use 20
  nvm alias default 20
  command -v pnpm >/dev/null 2>&1 || npm i -g pnpm
'

say "3d) Providers Node (neovim) + tree-sitter-cli (non-bloquant + retry + logs)"
run "mkdir -p \"${LOG_DIR}\""

export NPM_CONFIG_AUDIT="${NPM_CONFIG_AUDIT:-false}"
export NPM_CONFIG_FUND="${NPM_CONFIG_FUND:-false}"
export NPM_CONFIG_PROGRESS="${NPM_CONFIG_PROGRESS:-false}"

PROVIDERS_LOG="${LOG_DIR}/npm-providers.log"

say "   -> installing global npm providers (may be slow depending on network/registry)"
if ! retry_cmd 2 10 "npm i -g neovim tree-sitter-cli >>\"${PROVIDERS_LOG}\" 2>&1"; then
  echo "   [warn] npm providers install failed (non-bloquant). See: ${PROVIDERS_LOG}"
  echo "          You can retry later: npm i -g neovim tree-sitter-cli"
else
  [ "$DRY_RUN" -eq 1 ] || echo "   ok. log: ${PROVIDERS_LOG}"
fi

say "4) Police (FiraCode) - optionnelle"
if is_debian_like; then
  run "sudo apt install -y fonts-firacode || true"
elif is_fedora_like; then
  run "sudo dnf -y install fira-code-fonts || true"
fi

say "5) Déploiement config Neovim dans ~/.config/nvim"
run "mkdir -p \"${HOME}/.config\""
run "rm -rf \"${NVIM_CFG}\""
run "cp -a \"${NVIM_SRC}\" \"${NVIM_CFG}\""

say "6) Installation plugins (lazy.nvim) + Treesitter (séparé, avec logs)"
run "mkdir -p \"${LOG_DIR}\""

say "   -> Lazy sync (peut prendre du temps la 1ère fois)"
run "timeout ${LAZY_TIMEOUT}s nvim --headless \"+Lazy! sync\" +qa >\"${LOG_DIR}/lazy-sync.log\" 2>&1 || true"
[ "$DRY_RUN" -eq 1 ] || echo "     log: ${LOG_DIR}/lazy-sync.log"

say "   -> Treesitter update (parsers compilés, peut être long)"
run "timeout ${TS_TIMEOUT}s nvim --headless \"+TSUpdate\" +qa >\"${LOG_DIR}/treesitter-update.log\" 2>&1 || true"
[ "$DRY_RUN" -eq 1 ] || echo "     log: ${LOG_DIR}/treesitter-update.log"

say "Terminé ✅"

echo "Backup: $BACKUP_DIR"
echo "Ouvre Neovim: nvim"
echo "Healthcheck: ./healthcheck.sh"
