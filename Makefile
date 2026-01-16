# Neovim Config - Makefile
# Cross-platform automation for development and installation
#
# Usage:
#   make help        - Show available targets
#   make install     - Full installation
#   make test        - Run all tests
#   make lint        - Run linters
#   make format      - Format code

SHELL := /usr/bin/env bash

.PHONY: help install install-deps install-nvim install-config \
        test test-lua test-keymaps lint lint-lua lint-shell format \
        clean clean-plugins clean-cache clean-all \
        check health backup update doctor release dev-setup pre-commit \
        profile-minimal profile-javascript profile-devops profile-full

# Default target
.DEFAULT_GOAL := help

# Release settings
VERSION ?= v1.0.0
ARCHIVE ?= neovim-intellij-ide-$(VERSION).tgz
RELEASE_PREFIX ?= neovim-intellij-ide-$(VERSION)/

# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS := linux
    # Detect distro
    ifneq ($(wildcard /etc/os-release),)
        DISTRO_ID := $(shell . /etc/os-release && echo $$ID)
        DISTRO_LIKE := $(shell . /etc/os-release && echo $$ID_LIKE)
    endif
endif
ifeq ($(UNAME_S),Darwin)
    OS := macos
endif

# Directories
SCRIPT_DIR := $(shell pwd)
NVIM_SRC := $(SCRIPT_DIR)/nvim
NVIM_CFG := $(HOME)/.config/nvim
NVIM_DATA := $(HOME)/.local/share/nvim
NVIM_CACHE := $(HOME)/.cache/nvim
TESTS_DIR := $(SCRIPT_DIR)/tests
SCRIPTS_DIR := $(SCRIPT_DIR)/scripts

# Tools
NVIM := $(shell command -v nvim 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
LUACHECK := $(shell command -v luacheck 2>/dev/null)
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)

# Colors for output
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

#------------------------------------------------------------------------------
# Help
#------------------------------------------------------------------------------

help: ## Show this help
	@echo "$(CYAN)Neovim Config - Makefile$(RESET)"
	@echo ""
	@echo "$(GREEN)OS detected:$(RESET) $(OS)"
ifeq ($(OS),linux)
	@echo "$(GREEN)Distro:$(RESET) $(DISTRO_ID) ($(DISTRO_LIKE))"
endif
	@echo ""
	@echo "$(CYAN)Usage:$(RESET) make [target]"
	@echo ""
	@echo "$(CYAN)Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

#------------------------------------------------------------------------------
# Installation
#------------------------------------------------------------------------------

install: ## Full installation (deps + nvim + config + plugins)
	@echo "$(CYAN)Starting full installation...$(RESET)"
	@./install.sh
	@echo "$(GREEN)Installation complete!$(RESET)"

install-deps: ## Install system dependencies only
	@echo "$(CYAN)Installing system dependencies...$(RESET)"
ifeq ($(OS),linux)
ifeq ($(DISTRO_ID),ubuntu)
	sudo apt update
	sudo apt install -y git curl unzip zip build-essential ripgrep fd-find xclip wl-clipboard python3 python3-pip
else ifeq ($(DISTRO_ID),debian)
	sudo apt update
	sudo apt install -y git curl unzip zip build-essential ripgrep fd-find xclip wl-clipboard python3 python3-pip
else ifeq ($(DISTRO_ID),fedora)
	sudo dnf -y install git curl unzip zip gcc gcc-c++ make ripgrep fd-find xclip wl-clipboard python3 python3-pip
else
	@echo "$(YELLOW)Unsupported distro: $(DISTRO_ID). Install dependencies manually.$(RESET)"
endif
else ifeq ($(OS),macos)
	brew install git curl ripgrep fd neovim node python3 stylua luacheck
else
	@echo "$(RED)Unsupported OS: $(UNAME_S)$(RESET)"
	@exit 1
endif
	@echo "$(GREEN)Dependencies installed!$(RESET)"

install-nvim: ## Install Neovim only
	@echo "$(CYAN)Installing Neovim...$(RESET)"
ifeq ($(OS),linux)
ifeq ($(DISTRO_ID),ubuntu)
	@if ! apt-cache policy 2>/dev/null | grep -q "neovim-ppa/unstable"; then \
		sudo add-apt-repository ppa:neovim-ppa/unstable -y || true; \
		sudo apt update; \
	fi
	sudo apt install -y neovim
else ifeq ($(DISTRO_ID),debian)
	@echo "Installing Neovim AppImage for Debian..."
	@NVIM_TMP=$$(mktemp -d) && \
	curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -o $$NVIM_TMP/nvim.appimage && \
	curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage.sha256sum -o $$NVIM_TMP/nvim.appimage.sha256sum && \
	cd $$NVIM_TMP && sha256sum -c nvim.appimage.sha256sum && \
	chmod +x nvim.appimage && \
	sudo install -m 0755 nvim.appimage /usr/local/bin/nvim && \
	rm -rf $$NVIM_TMP
else ifeq ($(DISTRO_ID),fedora)
	sudo dnf -y install neovim
endif
else ifeq ($(OS),macos)
	brew install neovim
endif
	@echo "$(GREEN)Neovim installed: $$(nvim --version | head -1)$(RESET)"

install-config: ## Deploy config to ~/.config/nvim
	@echo "$(CYAN)Deploying Neovim config...$(RESET)"
	@mkdir -p $(HOME)/.config
	@if [ -d "$(NVIM_CFG)" ]; then \
		echo "$(YELLOW)Backing up existing config...$(RESET)"; \
		mv "$(NVIM_CFG)" "$(NVIM_CFG).bak.$$(date +%Y%m%d-%H%M%S)"; \
	fi
	@cp -a "$(NVIM_SRC)" "$(NVIM_CFG)"
	@echo "$(GREEN)Config deployed to $(NVIM_CFG)$(RESET)"

install-plugins: ## Install plugins with lazy.nvim
	@echo "$(CYAN)Installing plugins...$(RESET)"
	@nvim --headless "+Lazy! sync" +qa
	@echo "$(GREEN)Plugins installed!$(RESET)"

install-treesitter: ## Install Treesitter parsers
	@echo "$(CYAN)Installing Treesitter parsers...$(RESET)"
	@nvim --headless "+TSUpdate" +qa
	@echo "$(GREEN)Treesitter parsers installed!$(RESET)"

install-tools: ## Install dev tools via Mason
	@echo "$(CYAN)Installing dev tools via Mason...$(RESET)"
	@nvim --headless "+MasonInstallDevTools" +qa
	@echo "$(GREEN)Dev tools installed!$(RESET)"

#------------------------------------------------------------------------------
# Testing
#------------------------------------------------------------------------------

test: test-keymaps test-lua ## Run all tests
	@echo "$(GREEN)All tests passed!$(RESET)"

test-keymaps: ## Run keymap validation tests
	@echo "$(CYAN)Running keymap tests...$(RESET)"
	@$(SCRIPTS_DIR)/test-keymaps.sh

test-lua: ## Run Lua unit tests with plenary.nvim
	@echo "$(CYAN)Running Lua tests...$(RESET)"
	@if [ -f "$(SCRIPTS_DIR)/run-tests.sh" ]; then \
		$(SCRIPTS_DIR)/run-tests.sh; \
	else \
		echo "$(YELLOW)Lua tests not configured yet$(RESET)"; \
	fi

#------------------------------------------------------------------------------
# Linting
#------------------------------------------------------------------------------

lint: lint-lua lint-shell ## Run all linters
	@echo "$(GREEN)Linting complete!$(RESET)"

lint-lua: ## Lint Lua files with luacheck
	@echo "$(CYAN)Linting Lua files...$(RESET)"
ifdef LUACHECK
	@$(LUACHECK) $(NVIM_SRC)/lua --no-color || true
else
	@echo "$(YELLOW)luacheck not found. Install with: luarocks install luacheck$(RESET)"
endif

lint-shell: ## Lint shell scripts with shellcheck
	@echo "$(CYAN)Linting shell scripts...$(RESET)"
ifdef SHELLCHECK
	@$(SHELLCHECK) *.sh $(SCRIPTS_DIR)/*.sh 2>/dev/null || true
else
	@echo "$(YELLOW)shellcheck not found. Install with: apt install shellcheck$(RESET)"
endif

#------------------------------------------------------------------------------
# Formatting
#------------------------------------------------------------------------------

format: format-lua ## Format all code
	@echo "$(GREEN)Formatting complete!$(RESET)"

format-lua: ## Format Lua files with stylua
	@echo "$(CYAN)Formatting Lua files...$(RESET)"
ifdef STYLUA
	@$(STYLUA) $(NVIM_SRC)/lua
	@echo "$(GREEN)Lua files formatted!$(RESET)"
else
	@echo "$(YELLOW)stylua not found. Install with: cargo install stylua$(RESET)"
endif

#------------------------------------------------------------------------------
# Cleaning
#------------------------------------------------------------------------------

clean: clean-cache ## Clean cache only
	@echo "$(GREEN)Clean complete!$(RESET)"

clean-cache: ## Clean Neovim cache
	@echo "$(CYAN)Cleaning Neovim cache...$(RESET)"
	@rm -rf $(NVIM_CACHE)
	@echo "$(GREEN)Cache cleaned!$(RESET)"

clean-plugins: ## Clean lazy.nvim plugins
	@echo "$(CYAN)Cleaning plugins...$(RESET)"
	@rm -rf $(NVIM_DATA)/lazy
	@echo "$(GREEN)Plugins cleaned!$(RESET)"

clean-all: clean-cache clean-plugins ## Clean everything (cache + plugins)
	@echo "$(CYAN)Cleaning Mason tools...$(RESET)"
	@rm -rf $(NVIM_DATA)/mason
	@echo "$(GREEN)Full clean complete!$(RESET)"

#------------------------------------------------------------------------------
# Utilities
#------------------------------------------------------------------------------

check: ## Check if all required tools are installed
	@echo "$(CYAN)Checking required tools...$(RESET)"
	@echo ""
	@printf "  %-15s" "nvim:"
	@if command -v nvim >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET) $$(nvim --version | head -1)"; \
	else \
		echo "$(RED)✗ not found$(RESET)"; \
	fi
	@printf "  %-15s" "node:"
	@if command -v node >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET) $$(node --version)"; \
	else \
		echo "$(YELLOW)✗ not found (optional)$(RESET)"; \
	fi
	@printf "  %-15s" "ripgrep:"
	@if command -v rg >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET) $$(rg --version | head -1)"; \
	else \
		echo "$(RED)✗ not found$(RESET)"; \
	fi
	@printf "  %-15s" "fd:"
	@if command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗ not found$(RESET)"; \
	fi
	@printf "  %-15s" "stylua:"
	@if command -v stylua >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET) $$(stylua --version)"; \
	else \
		echo "$(YELLOW)✗ not found (optional)$(RESET)"; \
	fi
	@printf "  %-15s" "luacheck:"
	@if command -v luacheck >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(YELLOW)✗ not found (optional)$(RESET)"; \
	fi
	@printf "  %-15s" "shellcheck:"
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET) $$(shellcheck --version | grep version:)"; \
	else \
		echo "$(YELLOW)✗ not found (optional)$(RESET)"; \
	fi
	@echo ""

health: ## Run Neovim checkhealth
	@echo "$(CYAN)Running checkhealth...$(RESET)"
	@nvim --headless "+checkhealth" +qa

doctor: ## Run project doctor (verify installation)
	@echo "$(CYAN)Running project doctor...$(RESET)"
	@./healthcheck.sh

backup: ## Backup current Neovim config
	@echo "$(CYAN)Creating backup...$(RESET)"
	@BACKUP_DIR="$(HOME)/.nvim-backups/$$(date +%Y%m%d-%H%M%S)" && \
	mkdir -p "$$BACKUP_DIR" && \
	[ -d "$(NVIM_CFG)" ] && cp -a "$(NVIM_CFG)" "$$BACKUP_DIR/config.nvim" || true && \
	[ -d "$(NVIM_DATA)" ] && cp -a "$(NVIM_DATA)" "$$BACKUP_DIR/share.nvim" || true && \
	echo "$(GREEN)Backup created: $$BACKUP_DIR$(RESET)"

update: ## Update plugins and Treesitter
	@echo "$(CYAN)Updating plugins...$(RESET)"
	@nvim --headless "+Lazy! sync" +qa
	@echo "$(CYAN)Updating Treesitter...$(RESET)"
	@nvim --headless "+TSUpdate" +qa
	@echo "$(GREEN)Update complete!$(RESET)"

#------------------------------------------------------------------------------
# Development
#------------------------------------------------------------------------------

dev-setup: ## Setup development environment
	@echo "$(CYAN)Setting up development environment...$(RESET)"
	@pip install --user pre-commit || pip3 install --user pre-commit
	@pre-commit install
	@pre-commit install --hook-type commit-msg
	@echo "$(GREEN)Development environment ready!$(RESET)"

pre-commit: ## Run pre-commit on all files
	@echo "$(CYAN)Running pre-commit...$(RESET)"
	@pre-commit run --all-files

#------------------------------------------------------------------------------
# Profiles
#------------------------------------------------------------------------------

profile-minimal: ## Test with minimal profile
	@echo "$(CYAN)Launching Neovim with minimal profile...$(RESET)"
	@NVIM_PROFILE=minimal nvim

profile-javascript: ## Test with javascript profile
	@echo "$(CYAN)Launching Neovim with javascript profile...$(RESET)"
	@NVIM_PROFILE=javascript nvim

profile-devops: ## Test with devops profile
	@echo "$(CYAN)Launching Neovim with devops profile...$(RESET)"
	@NVIM_PROFILE=devops nvim

profile-full: ## Test with full profile
	@echo "$(CYAN)Launching Neovim with full profile...$(RESET)"
	@NVIM_PROFILE=full nvim

#------------------------------------------------------------------------------
# Release
#------------------------------------------------------------------------------

release: ## Build release archive
	@echo "$(CYAN)Building $(ARCHIVE) from current working tree$(RESET)"
	@tar --exclude-vcs --exclude='.DS_Store' --exclude='*.tgz' \
		-czf $(ARCHIVE) --transform 's#^#$(RELEASE_PREFIX)#' .
	@echo "$(GREEN)Created: $(ARCHIVE)$(RESET)"
