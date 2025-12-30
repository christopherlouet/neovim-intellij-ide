SHELL := /usr/bin/env bash

VERSION ?= v1.0.0
ARCHIVE ?= neovim-intellij-ide-indus-$(VERSION).tgz
PREFIX ?= neovim-intellij-ide-indus-$(VERSION)/

.PHONY: release
release:
	@echo "Building $(ARCHIVE) from current working tree"
	@tar --exclude-vcs --exclude='.DS_Store' -czf $(ARCHIVE) --transform 's#^#$(PREFIX)#' .
	@echo "Created: $(ARCHIVE)"
