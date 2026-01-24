# Changelog

Ce projet suit un changelog simple, orienté releases GitHub.

## Unreleased

## v2.2.0 (2026-01-24)

### 🔒 Sécurité

- **Feat**: Sandbox pour `.nvim.lua` - Exécution restreinte des configs projet avec APIs limitées
- **Feat**: Security logging - Audit des événements trust/load dans `~/.local/state/nvim/security.log`
- **Feat**: Bootstrap verification - Vérification de l'intégrité de lazy.nvim au démarrage
- **Fix**: Permissions trust database - Fichier `trusted_projects.json` restreint (0600)
- **Fix**: Validation taille body HTTP - Protection contre les payloads malveillants

### 🏗️ Architecture

- **Refactor**: Décomposition `ui.lua` (472 lignes) → 7 modules spécialisés
  - `theme.lua` - Colorscheme et icônes
  - `statusline.lua` - Lualine et bufferline
  - `feedback.lua` - Notifications et which-key
  - `noice.lua` - Interface messages
  - `diagnostics.lua` - Indentation et trouble
  - `session.lua` - Sessions et startuptime
- **Refactor**: Création module `utils/` avec fonctions partagées
  - `utils/init.lua` - Fonction `has()` unifiée
  - `utils/env.lua` - Gestion PATH/NVM et compatibilité LSP
  - `utils/sandbox.lua` - Environnement d'exécution restreint
  - `utils/security_log.lua` - Logging d'audit
- **Refactor**: Extraction constantes → `config/defaults.lua`
- **Refactor**: Simplification `lsp.lua` on_attach (keymaps et navic extraits)

### 🧪 Tests

- **Feat**: 43 nouveaux tests pour modules utils (sandbox, security_log, env, defaults)
- **Feat**: 35 nouveaux tests pour modules UI (structure et plugin specs)
- **Total**: 104 tests passants

### 📚 Documentation

- **Docs**: `docs/SECURITY.md` - Documentation complète du modèle de sécurité

### 🧹 Maintenance

- **Chore**: Exclusion config Claude Code du versionning

### 📊 Statistiques

- 23 fichiers modifiés
- +1798 / -519 lignes
- Couverture tests: 104 tests
- Score sécurité: 8.5/10

## v2.1.1 (2026-01-16)

### 📚 Documentation

- **Cleanup**: Suppression de `ANALYSIS_REPORT.md` (rapport obsolète)
- **Consolidation**: Fusion de `README_PRECOMMIT.md` dans `CONTRIBUTING.md`
- **Amélioration**: Ajout section Profils dans README pour meilleure découvrabilité
- **Références**: Ajout liens vers `PROFILES.md` et `PROJECT_CONFIG.md` dans README
- **FAQ**: Mise à jour avec options de personnalisation (profils, config projet)

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
