#!/usr/bin/env bash
set -euo pipefail

# clean-restart.sh: Clean Neovim cache and restart fresh
# This script safely cleans cache, swap, and temporary files without touching your configuration

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }
info() { printf "\033[0;36m%s\033[0m\n" "$*"; }
warn() { printf "\033[0;33m%s\033[0m\n" "$*"; }
error() { printf "\033[0;31m%s\033[0m\n" "$*"; }
success() { printf "\033[0;32m%s\033[0m\n" "$*"; }

# Parse arguments
DEEP_CLEAN=false
DRY_RUN=false
AUTO_YES=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --deep)
      DEEP_CLEAN=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    -h|--help)
      cat << EOF
Usage: $0 [OPTIONS]

Clean Neovim cache and temporary files for a fresh start.

OPTIONS:
  --deep       Deep clean: also remove plugins and reinstall (preserves config)
  --dry-run    Show what would be removed without actually doing it
  -y, --yes    Skip confirmation prompts
  -h, --help   Show this help message

EXAMPLES:
  $0                    # Standard cache clean
  $0 --deep             # Full clean including plugins
  $0 --dry-run          # Preview what will be removed
  $0 --deep -y          # Deep clean without prompts

WHAT GETS CLEANED:
  Standard clean:
    - ~/.cache/nvim/*
    - ~/.local/state/nvim/*
    - Swap files
    - Shada files

  Deep clean (--deep):
    - Everything from standard clean
    - ~/.local/share/nvim/lazy/* (all plugins)
    - Plugin cache and lock files

SAFE:
  - Your configuration (~/.config/nvim) is NEVER touched
  - Backups are created before deep cleaning
EOF
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check if Neovim is running
if pgrep -x nvim >/dev/null 2>&1; then
  error "Neovim is currently running!"
  warn "Please close all Neovim instances before running this script."
  exit 1
fi

# Directories to clean
NVIM_CACHE="$HOME/.cache/nvim"
NVIM_STATE="$HOME/.local/state/nvim"
NVIM_DATA="$HOME/.local/share/nvim"
BACKUP_DIR="$HOME/.nvim-backups/clean-$(date +%Y%m%d-%H%M%S)"

say "Neovim Clean & Restart"
echo ""

if [ "$DRY_RUN" = true ]; then
  warn "[DRY RUN MODE - No changes will be made]"
  echo ""
fi

# Show what will be cleaned
say "The following will be cleaned:"
echo ""
info "Cache directory:"
echo "  $NVIM_CACHE"
echo ""
info "State directory (logs, swap, shada):"
echo "  $NVIM_STATE"
echo ""

if [ "$DEEP_CLEAN" = true ]; then
  warn "Deep clean enabled - plugins will be removed:"
  echo "  $NVIM_DATA/lazy"
  echo "  $NVIM_DATA/lazy-lock.json (if exists)"
  echo ""
  info "Backup will be created at:"
  echo "  $BACKUP_DIR"
  echo ""
fi

# Calculate sizes
if [ -d "$NVIM_CACHE" ]; then
  CACHE_SIZE=$(du -sh "$NVIM_CACHE" 2>/dev/null | cut -f1 || echo "N/A")
  info "Cache size: $CACHE_SIZE"
fi

if [ -d "$NVIM_STATE" ]; then
  STATE_SIZE=$(du -sh "$NVIM_STATE" 2>/dev/null | cut -f1 || echo "N/A")
  info "State size: $STATE_SIZE"
fi

if [ "$DEEP_CLEAN" = true ] && [ -d "$NVIM_DATA/lazy" ]; then
  LAZY_SIZE=$(du -sh "$NVIM_DATA/lazy" 2>/dev/null | cut -f1 || echo "N/A")
  info "Plugins size: $LAZY_SIZE"
fi

echo ""

# Confirmation
if [ "$AUTO_YES" = false ] && [ "$DRY_RUN" = false ]; then
  read -p "Continue? [y/N] " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Cancelled by user"
    exit 0
  fi
fi

# Function to safely remove directory
safe_remove() {
  local dir="$1"
  local name="$2"

  if [ ! -d "$dir" ]; then
    info "✓ $name: not found (nothing to clean)"
    return
  fi

  if [ "$DRY_RUN" = true ]; then
    warn "Would remove: $dir"
    return
  fi

  if rm -rf "$dir" 2>/dev/null; then
    success "✓ $name cleaned"
  else
    error "✗ Failed to clean $name"
    return 1
  fi
}

# Start cleaning
say "Cleaning..."
echo ""

# Standard clean
safe_remove "$NVIM_CACHE" "Cache"
safe_remove "$NVIM_STATE/swap" "Swap files"
safe_remove "$NVIM_STATE/shada" "Shada files"

# Deep clean
if [ "$DEEP_CLEAN" = true ]; then
  echo ""
  say "Deep cleaning..."
  echo ""

  # Create backup
  if [ "$DRY_RUN" = false ]; then
    if [ -d "$NVIM_DATA/lazy" ]; then
      info "Creating backup..."
      mkdir -p "$BACKUP_DIR"

      if [ -f "$NVIM_DATA/lazy-lock.json" ]; then
        cp "$NVIM_DATA/lazy-lock.json" "$BACKUP_DIR/" 2>/dev/null || true
      fi

      success "✓ Backup created: $BACKUP_DIR"
    fi
  fi

  # Remove plugins
  safe_remove "$NVIM_DATA/lazy" "Plugins"
  safe_remove "$NVIM_DATA/lazy-rocks" "Lazy rocks"

  # Remove lock file
  if [ -f "$NVIM_DATA/lazy-lock.json" ]; then
    if [ "$DRY_RUN" = false ]; then
      rm -f "$NVIM_DATA/lazy-lock.json" 2>/dev/null && success "✓ Lock file removed" || warn "Failed to remove lock file"
    else
      warn "Would remove: $NVIM_DATA/lazy-lock.json"
    fi
  fi
fi

echo ""

if [ "$DRY_RUN" = true ]; then
  warn "[DRY RUN COMPLETE - No changes were made]"
  exit 0
fi

# Reinstall plugins if deep clean
if [ "$DEEP_CLEAN" = true ]; then
  say "Reinstalling plugins..."
  echo ""

  info "Running: nvim --headless '+Lazy! sync' +qa"
  if timeout 300s nvim --headless "+Lazy! sync" +qa 2>&1 | tee /tmp/nvim-clean-lazy.log; then
    success "✓ Plugins reinstalled"
  else
    warn "⚠ Plugin installation may have issues. Check log: /tmp/nvim-clean-lazy.log"
  fi

  echo ""
  info "Installing Treesitter parsers..."
  if timeout 300s nvim --headless "+TSUpdate" +qa 2>&1 | tee /tmp/nvim-clean-ts.log; then
    success "✓ Treesitter parsers installed"
  else
    warn "⚠ Treesitter installation may have issues. Check log: /tmp/nvim-clean-ts.log"
  fi
fi

echo ""
success "✅ Clean complete!"
echo ""

if [ "$DEEP_CLEAN" = true ]; then
  info "Next steps:"
  echo "  1. Start Neovim: nvim"
  echo "  2. Check health: :checkhealth"
  echo "  3. Install LSP servers: :Mason"
  echo ""
  info "Backup location: $BACKUP_DIR"
else
  info "You can now start Neovim normally"
fi

echo ""
info "To verify everything is working:"
echo "  ./healthcheck.sh"
echo ""

# Ask if user wants to start Neovim
if [ "$AUTO_YES" = false ]; then
  read -p "Start Neovim now? [Y/n] " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    info "Starting Neovim..."
    exec nvim
  fi
else
  info "Run 'nvim' to start Neovim"
fi
