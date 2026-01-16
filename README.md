![Build Status](https://img.shields.io/github/actions/workflow/status/christopherlouet/neovim-intellij-ide/install-check.yml?branch=main&label=CI)
![License: GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)
![Neovim](https://img.shields.io/badge/Neovim-%3E%3D0.11-green?logo=neovim)

# Neovim IntelliJ‑like IDE

Configuration **Neovim ≥ 0.11** clé en main visant à reproduire l'expérience **IntelliJ Ultimate** :
navigation rapide, refactorings, debug, tests, Docker, LSP complet et workflow DevOps-friendly.

Ce setup est pensé pour :

- développeurs backend / full‑stack
- DevOps / Platform engineers
- utilisateurs IntelliJ souhaitant migrer progressivement vers Neovim

---

## 🚀 Démarrage rapide

```bash
# Installation
chmod +x install.sh
./install.sh

# Vérification
./healthcheck.sh

# Guide utilisateur complet
Voir GETTING_STARTED.md
```

---

## 🧩 Fonctionnalités

### Interface & UX (IDE-like)

- Thème **Tokyonight**
- Statusline **Lualine**
- Onglets **Bufferline**
- Explorateur de fichiers **NvimTree**
- Notifications & cmdline avancés (**Noice**)
- Menus contextuels améliorés (**Dressing**)
- Aide dynamique des raccourcis (**Which‑key**)
- Icônes (**nvim-web-devicons**, **mini.icons**)

### Navigation & Projet

- Recherche fichiers / texte / symboles (**Telescope**)
- Détection automatique de projet (**project.nvim**)
- Diagnostics centralisés (**Trouble**)
- Navigation rapide (**Leap**, **Harpoon**)

### LSP & Intelligence de code

- Gestion des serveurs via **Mason**
- Configuration LSP native Neovim 0.11 (`vim.lsp.config`)
- Breadcrumbs (symboles) dans la winbar (**nvim-navic**)
- Complétion (**nvim-cmp**) + snippets (**LuaSnip**)

### Qualité & formatage

- **none-ls (ex null-ls)** pour formatters & linters
- Format on save
- Installation outillage via Mason (on‑demand)

### Git

- Gitsigns (blame, hunks)
- Neogit (UI Git)
- Diffview
- Octo (PRs/Issues GitHub)
- Advanced Git Search

### Run / Debug / Tests

- Terminal intégré (**ToggleTerm**)
- Runner de tâches (**Overseer**)
- Debug (**nvim-dap**, dap-ui, dap-virtual-text)

### Docker & DevOps

- Intégration Docker via Telescope
- **Kubernetes** : kubectl.nvim, yamlls avec schémas
- **Terraform** : terraformls, formatage auto
- **Ansible** : ansiblels, syntax highlighting
- **Helm** : helm_ls, support charts

### Base de données

- **SQL** : sqlls, vim-dadbod-ui (interface graphique)
- Support : PostgreSQL, MySQL, SQLite, etc.

### AI

- Intégration **Claude Code** (agent IA de développement)

---

## 🧠 Langages supportés

### JavaScript / TypeScript

- LSP : `ts_ls`
- Lint : ESLint
- Format : Prettier
- Frameworks : React / Vue / Next.js

### HTML / CSS / Tailwind

- LSP : `html`, `cssls`, `tailwindcss`
- Format : Prettier
- Autotag JSX/HTML

### JSON / YAML / Markdown

- LSP : `jsonls`, `yamlls` (avec schémas K8s/Docker/GitHub Actions)
- Lint : markdownlint
- Format : Prettier

### Prisma

- LSP : `prismals`
- Format : prisma_format

### Bash / Shell

- LSP : `bashls`
- Format : shfmt

### Docker

- LSP : `dockerls`
- Exploration : containers / images / volumes

### Lua

- Configuration Neovim native

> D'autres langages peuvent être ajoutés facilement via `:Mason`.

---

## 🚀 Installation

```bash
chmod +x install.sh
./install.sh
```

Options utiles :

```bash
./install.sh --dry-run
./install.sh --prefix=$HOME/.local/bin
```

> ⚠️ **Important :** Lance les scripts avec **bash** (`./install.sh` ou `bash install.sh`), pas avec `sh`.

---

## 🔁 Migration IntelliJ → Neovim

Script fourni : **`intellij-migrate.sh`**

Fonctionnalités :

- Keymaps proches d'IntelliJ (Ctrl+P, Ctrl+Shift+F, Alt+Enter, etc.)
- Cheatsheet généré dans `~/.config/nvim/INTELLIJ_MIGRATION.md`
- Activation / désactivation simple

```bash
./intellij-migrate.sh
./intellij-migrate.sh --remove
```

---

## 📚 Documentation

- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Guide complet pour démarrer avec Neovim
- **[KEYMAPS_AUDIT.md](KEYMAPS_AUDIT.md)** - Audit complet des keymaps disponibles
- **[TESTING.md](TESTING.md)** - Documentation des tests automatisés
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Guide de dépannage détaillé
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guide pour contribuer au projet
- **[ROADMAP.md](ROADMAP.md)** - Plan d'évolution du projet
- **[VERSIONING.md](VERSIONING.md)** - Politique de versioning
- **[CHANGELOG.md](CHANGELOG.md)** - Historique des versions

---

## 🧪 Tests et qualité

### Vérification de santé

```bash
./healthcheck.sh
```

### Nettoyage du cache

```bash
# Nettoyage standard (cache uniquement)
./clean-restart.sh

# Nettoyage complet avec réinstallation des plugins
./clean-restart.sh --deep

# Voir ce qui serait nettoyé sans rien supprimer
./clean-restart.sh --dry-run

# Nettoyage profond sans confirmation
./clean-restart.sh --deep -y
```

### Tests automatisés

Le projet inclut des tests automatisés pour garantir la qualité :

- ✅ Tests des keymaps (< 1 seconde)
- ✅ Smoke tests Neovim
- ✅ Pre-commit hooks (shellcheck, stylua, luacheck)
- ✅ GitHub Actions CI

Voir [TESTING.md](TESTING.md) pour plus de détails.

---

## 🩺 Dépannage

### Mason en headless (CI / `nvim --headless "+checkhealth"`)

Mason installe des outils **de façon asynchrone**. En mode headless, Neovim peut quitter avant la fin.

✅ Ce dépôt évite désormais tout auto-install en headless (ensure_installed vide), et recommande d'installer les outils **à la demande** :

```vim
:MasonInstallDevTools
```

### `:checkhealth lazy` — erreur `lazy-rocks/hererocks/bin/luarocks` not installed

✅ Fix :

```bash
rm -rf ~/.local/share/nvim/lazy-rocks
```

Le script `install.sh` le fait automatiquement.

### Installation des providers Node très lente

L'étape `npm i -g neovim tree-sitter-cli` peut être lente (réseau, proxy, registry).

Le script `install.sh` :

- tente l'installation avec **retry**
- écrit un log dans `~/.nvim-install-logs/npm-providers.log`
- est **non-bloquant** : en cas d'échec, l'installation continue.

Tu peux aussi accélérer via variables :

```bash
export NPM_CONFIG_AUDIT=false
export NPM_CONFIG_FUND=false
export NPM_CONFIG_PROGRESS=false
```

### `[none-ls/null-ls] failed to load builtin eslint`

`none-ls` fournit nativement **eslint_d** (plus rapide et plus courant en local).

✅ Fix :

```vim
:MasonInstall eslint_d
# ou
:MasonInstallDevTools
```

### Warning `vim.lsp.buf_get_clients()` deprecated (project.nvim)

`project.nvim` utilise encore `vim.lsp.buf_get_clients()` (supprimé en Neovim 0.12).

Un patch de compatibilité est appliqué automatiquement via :

- `nvim/after/plugin/project-nvim-compat.lua`
- et une surcharge dans `lua/config/options.lua`

Ce patch n'affecte pas le comportement (il redirige vers `vim.lsp.get_clients()`), et pourra être retiré quand `project.nvim` aura été mis à jour.

### Lazy / Treesitter "figée" en mode headless

En mode headless, Neovim est souvent **silencieux** et donne l'impression d'être bloqué, surtout quand Treesitter compile les parsers.

La procédure la plus fiable est de **séparer** l'installation :

```bash
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdate" +qa
```

Le script `install.sh` fait maintenant exactement ça, avec :

- logs dans `~/.nvim-install-logs/`
- timeouts configurables : `--lazy-timeout=600`, `--ts-timeout=900`
- mode verbeux : `./install.sh --verbose`

### Mason ne trouve pas prettier / markdownlint

```vim
:echo exepath("node")
```

Si vide, relancer Neovim depuis un shell avec NVM actif.

### Treesitter et plugins dépendants

**Note** : Treesitter et les plugins qui en dépendent sont **actifs** dans cette configuration.

**Plugins actifs** :

- `nvim-treesitter` - Coloration syntaxique avancée
- `nvim-ts-autotag` - Auto-fermeture des balises HTML/JSX
- `aerial.nvim` - Vue structure/outline
- `neotest` - Framework de tests
- `refactoring.nvim` - Outils de refactoring

**Parsers installés automatiquement** : lua, javascript, typescript, tsx, html, css, json, bash, markdown, prisma

**Pour ajouter des parsers** :

```vim
:TSInstall <langage>
```

---

## 🧹 Désinstallation

```bash
./uninstall.sh
```

Un backup complet est toujours effectué avant suppression.

---

## ✅ Plateformes supportées

| Plateforme | Status | Installation | Notes |
|------------|--------|--------------|-------|
| ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white) | ✅ Tested | `./install.sh` | Via PPA neovim-ppa/unstable |
| ![Debian](https://img.shields.io/badge/Debian-A81D33?logo=debian&logoColor=white) | ✅ Tested | `./install.sh` | Via AppImage |
| ![Fedora](https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=white) | ✅ Tested | `./install.sh` | Via DNF |
| ![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white) | ✅ Tested | Homebrew | `brew install neovim` + config |
| ![Arch](https://img.shields.io/badge/Arch-1793D1?logo=archlinux&logoColor=white) | 🔧 Manual | pacman | Non testé automatiquement |
| ![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=white) | 🔧 WSL | WSL2 + Ubuntu | Utiliser le guide Ubuntu |

### CI / Tests automatisés

Chaque PR et push sur `main` déclenche des tests complets sur :

- **Ubuntu** : Installation complète + healthcheck
- **Debian** : Installation complète en container
- **Fedora** : Installation complète en container
- **macOS** : Installation via Homebrew + config

Voir [`.github/workflows/install-check.yml`](.github/workflows/install-check.yml) pour les détails

---

## ❓ FAQ

### ❔ Pourquoi Neovim ≥ 0.11 est requis ?

Cette configuration utilise :

- l'API LSP native `vim.lsp.config`
- des améliorations Lazy.nvim récentes
- une gestion moderne des diagnostics et capacités

Les versions antérieures (0.9 / 0.10) ne sont **pas supportées**.

### ❔ Puis-je utiliser cette config sans Node.js ?

Oui **partiellement**.

Sans Node.js :

- LSP fonctionne
- Git / Debug / Tests fonctionnent
- UI complète disponible

Mais tu perds :

- Prettier
- ESLint diagnostics
- Markdownlint

Pour une expérience IntelliJ-like complète, **Node.js est recommandé**.

### ❔ Pourquoi utiliser Mason plutôt que des installs système ?

Mason permet :

- des versions cohérentes par projet
- une installation isolée utilisateur
- aucun impact sur le système
- une config reproductible (CI / onboarding)

C'est l'équivalent de ce qu'IntelliJ fait en interne.

### ❔ Est-ce que cette config est adaptée à une équipe ?

Oui.

Avantages :

- versionnable (Git)
- reproductible
- documentation intégrée
- tests automatisés

C'est parfaitement adapté à un usage **équipe / entreprise**.

### ❔ Comment ajouter un nouveau langage ?

1. Installer le serveur :

```vim
:Mason
```

2. Ajouter la config LSP dans `lua/plugins/lsp.lua` :

```lua
vim.lsp.config("mon_langage_ls", {})
```

3. (Optionnel) Ajouter formatter/linter via `none-ls`.

### ❔ Puis-je désactiver certaines fonctionnalités ?

Oui.

Plusieurs options :

- commenter un plugin dans `lua/plugins/`
- supprimer le layer IntelliJ (`./intellij-migrate.sh --remove`)

### ❔ Pourquoi Lazy.nvim plutôt que Packer ?

Lazy.nvim apporte :

- lazy-loading réel (events, ft, keys)
- meilleure performance au démarrage
- gestion native des dépendances
- diagnostics clairs

C'est aujourd'hui le **standard de facto**.

### ❔ Cette config remplace-t-elle IntelliJ ?

Fonctionnellement : **oui dans la majorité des cas**.

Différences :

- Neovim est plus léger et scriptable
- IntelliJ reste plus plug-and-play pour Java/Kotlin
- Neovim est supérieur pour SSH / serveurs distants / DevOps

Beaucoup utilisent les deux selon le contexte.

### ❔ Où sont stockés mes paramètres ?

- Config : `~/.config/nvim`
- Plugins : `~/.local/share/nvim`
- Cache : `~/.cache/nvim`

Les scripts fournis font toujours un **backup** avant modification.

---

## 💡 Philosophie

> Neovim comme IntelliJ…
> mais scriptable, portable, versionnable, et sous ton contrôle.

---

## 🤔 Pourquoi ce repo plutôt que LazyVim/AstroNvim ?

- **Approche "IntelliJ-like"** : keymaps, UX et plugins choisis pour une expérience IDE cohérente (pas un framework généraliste).
- **Indus-friendly** : scripts d'installation, CI (lint + smoke test), fichiers OSS standards, SemVer.
- **Lisible** : plugins organisés par domaine (`lua/plugins/*`), conventions simples, configuration explicite.
- **Opt-in** : les features avancées (ex: AI) restent modulaires et évitent le lock-in.
- **Tests automatisés** : Validation continue des keymaps et de la configuration.

---

## 📜 License (GPLv3)

This project is distributed under the **GNU General Public License v3.0**.

```
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) 2007 Free Software Foundation, Inc.
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

---

## 📦 Notes techniques

- `eslint_d` est chargé via `none-ls-extras` (fallback vers `eslint` si nécessaire).
- `nvim/lazy-lock.json` est fourni comme point de départ : exécute `:Lazy sync` puis commit le lock pour figer les versions.
- Les keymaps sont validés automatiquement via CI (`scripts/test-keymaps.sh`)

---

## 📌 Ressources

- **Versioning** : `VERSIONING.md`
- **Roadmap** : `ROADMAP.md`
- **Releases** : Voir `releases/v1.0.0.md`
