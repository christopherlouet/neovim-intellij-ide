#!/usr/bin/env bash
set -euo pipefail


DRY_RUN=0
AUTO_YES=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) AUTO_YES=1 ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $*"
  else
    eval "$@"
  fi
}


# Flags:
#   --dry-run : affiche les commandes sans les exécuter
#   --yes/-y  : mode non-interactif (utile CI)

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }
timestamp() { date +"%Y%m%d-%H%M%S"; }

NVIM_CFG="${HOME}/.config/nvim"
NVIM_DATA="${HOME}/.local/share/nvim"
NVIM_CACHE="${HOME}/.cache/nvim"
BACKUP_DIR="${HOME}/.nvim-backups/uninstall-$(timestamp)"

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

say "0) Backup -> $BACKUP_DIR"
run "mkdir -p "$BACKUP_DIR""
[ -d "$NVIM_CFG" ] && cp -a "$NVIM_CFG" "$BACKUP_DIR/config.nvim"
[ -d "$NVIM_DATA" ] && cp -a "$NVIM_DATA" "$BACKUP_DIR/share.nvim"
[ -d "$NVIM_CACHE" ] && cp -a "$NVIM_CACHE" "$BACKUP_DIR/cache.nvim"

say "1) Suppression Neovim"
if is_debian_like; then
  if dpkg -s neovim >/dev/null 2>&1; then
    run "sudo apt remove -y"
    run "sudo apt autoremove -y"
  fi
  # If Debian AppImage was installed:
  if [ -f /usr/local/bin/nvim ]; then
    run "sudo rm -f "
  fi
elif is_fedora_like; then
  run "sudo dnf -y remove"
else
  echo "OS non supporté automatiquement (ID=$OS_ID, LIKE=$OS_LIKE)."
  echo "Suppression manuelle requise."
fi

say "2) Nettoyage dossiers Neovim"
run "rm -rf "$NVIM_CFG" "$NVIM_DATA" "$NVIM_CACHE""

say "Terminé ✅"
echo "Backup conservé: $BACKUP_DIR"
