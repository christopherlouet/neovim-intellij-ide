# Changelog

Ce projet suit un changelog simple, orienté releases GitHub.

## Unreleased

## v2.1.0 (2026-01-16)

### 🚀 Nouvelles Fonctionnalités

- **Feat**: Tests Lua avec plenary.nvim - Framework de tests unitaires pour la configuration (#7)
- **Feat**: Système de profils utilisateur - Activation/désactivation de groupes de plugins (minimal, full, devops) (#8)
- **Feat**: Configuration spécifique par projet - `.nvim/config.lua` pour personnaliser par projet (#9)
- **Feat**: Makefile multi-OS complet - Installation, tests et maintenance simplifiés (#10)
- **Feat**: Tests d'installation multi-OS - Ubuntu, Debian, Fedora et macOS officiellement testés (#11)

### 🔧 Améliorations

- **Feat**: Filetype-specific settings pour Python, JS, TS, Markdown, JSON
- **Refactor**: Simplification de la configuration eslint_d dans none-ls
- **Fix**: Résolution du conflit `<C-k>`, utilisation de `gK` pour signature help
- **Fix**: Gestion des environnements Python PEP 668 (Debian 12+)
- **Fix**: Détection de version Neovim pour éviter réinstallation si >= 0.11

### 🔒 Sécurité & Qualité

- **Fix**: Améliorations de sécurité et qualité des scripts shell (#6)
- **Feat**: Validation automatique des keymaps en CI
- **Feat**: Tests d'options et keymaps avec plenary.nvim

### 📚 Documentation

- **Docs**: Mise à jour README avec matrice de compatibilité des plateformes
- **Docs**: Ajout de badges dynamiques CI et version Neovim

### 📊 Statistiques

- 5 PRs mergées (#7, #8, #9, #10, #11)
- 4 plateformes officiellement testées (Ubuntu, Debian, Fedora, macOS)
- Tests Lua automatisés (keymaps, options)
- 3 systèmes de configuration (base, profils, projet)

## v2.0.1 (2026-01-04)

### 🎯 Keymaps & Testing

- **Feat**: Added 31 missing keymaps across all plugins (terminal, telescope, git, LSP, debug)
- **Feat**: Automated keymap validation system (32ms execution time)
- **Feat**: Pre-commit hook for keymap validation
- **Feat**: GitHub Actions integration for continuous testing

### 📚 Documentation

- **Added**: KEYMAPS_AUDIT.md - Complete audit report with statistics
- **Added**: TESTING.md - Comprehensive testing documentation
- **Added**: scripts/README.md - Script documentation
- **Improved**: README.md - Cleaned up duplicates and obsolete sections
- **Improved**: GETTING_STARTED.md - Updated with all new keymaps

### 🧹 Maintenance

- **Fix**: Removed duplicate sections in README
- **Fix**: Cleaned up temporary and backup files
- **Improved**: Documentation structure and cross-references

### 📊 Statistics

- 31 keymaps added
- 14 keymaps tested automatically
- 100% code/documentation synchronization
- 3 new documentation files
- 10 files modified

## v1.0.0

- Fix: none-ls eslint_d (guard + none-ls-extras + fallback eslint)
- CI: ajout workflow lint (Lua/Shell/Markdown)
- Docs: durcissement installation (bash) + fichiers OSS (LICENSE/CONTRIBUTING/templates)

## v0.3.2

- Archive de configuration publiée (tag/packaging)
