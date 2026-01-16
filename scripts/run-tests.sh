#!/usr/bin/env bash
set -euo pipefail

# Run Lua tests with plenary.nvim
# Usage: ./scripts/run-tests.sh [test_file]
# Examples:
#   ./scripts/run-tests.sh                    # Run all tests
#   ./scripts/run-tests.sh config/options     # Run specific test file

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

say() { printf "\n\033[1m%s\033[0m\n" "$*"; }
success() { printf "\033[0;32m%s\033[0m\n" "$*"; }
error() { printf "\033[0;31m%s\033[0m\n" "$*"; }
info() { printf "\033[0;36m%s\033[0m\n" "$*"; }

# Check if nvim is available
if ! command -v nvim &>/dev/null; then
  error "Neovim not found. Please install Neovim first."
  exit 1
fi

# Check if plenary is available
PLENARY_PATH="${HOME}/.local/share/nvim/lazy/plenary.nvim"
if [ ! -d "$PLENARY_PATH" ]; then
  error "plenary.nvim not found at $PLENARY_PATH"
  info "Please install it first:"
  echo "  nvim -c 'Lazy install plenary.nvim' -c 'qa'"
  exit 1
fi

say "Running Lua Tests"
echo ""

TEST_FILE="${1:-}"
TESTS_DIR="$PROJECT_ROOT/tests"
MINIMAL_INIT="$TESTS_DIR/minimal_init.lua"

if [ -n "$TEST_FILE" ]; then
  # Run specific test file
  TEST_PATH="$TESTS_DIR/${TEST_FILE}_spec.lua"
  if [ ! -f "$TEST_PATH" ]; then
    error "Test file not found: $TEST_PATH"
    exit 1
  fi
  info "Running: $TEST_PATH"
  nvim --headless -u "$MINIMAL_INIT" \
    -c "PlenaryBustedFile $TEST_PATH" \
    2>&1
else
  # Run all tests
  info "Running all tests in: $TESTS_DIR"
  nvim --headless -u "$MINIMAL_INIT" \
    -c "PlenaryBustedDirectory $TESTS_DIR {minimal_init = '$MINIMAL_INIT', sequential = true}" \
    2>&1
fi

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
  success "All tests passed!"
else
  error "Some tests failed (exit code: $EXIT_CODE)"
fi

exit $EXIT_CODE
