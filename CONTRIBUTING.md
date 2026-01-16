# Contributing

Merci de contribuer !

## Pré-requis

- Neovim >= 0.11
- Bash (Linux / macOS)
- Git, curl
- Python 3.x (pour pre-commit)
- Optionnel (recommandé) : node, ripgrep (`rg`), `fd`

## Setup développement

### 1. Fork et clone

```bash
git clone https://github.com/votre-username/neovim-intellij-ide.git
cd neovim-intellij-ide
```

### 2. Installer pre-commit

```bash
pip install pre-commit
pre-commit install
pre-commit install --hook-type commit-msg
```

### 3. Vérifier l'installation

```bash
./install.sh --dry-run --yes
./healthcheck.sh
```

### 4. Tester les hooks

```bash
# Tester tous les hooks sur tous les fichiers
pre-commit run --all-files

# Tester un hook spécifique
pre-commit run shellcheck --all-files
pre-commit run stylua --all-files
```

## Workflow de développement

### 1. Créer une branche

```bash
git checkout -b feat/ma-feature
# ou
git checkout -b fix/bug-description
```

### 2. Faire vos modifications

- Éditez les fichiers nécessaires
- Testez localement : `nvim` ou `./install.sh --dry-run`

### 3. Valider avant commit

```bash
# Les hooks pre-commit s'exécutent automatiquement
git add .
git commit -m "feat(plugin): add new feature"

# Si échec des hooks, corrigez puis recommencez
# Pour auto-fix certains problèmes :
stylua nvim/lua        # Format Lua
markdownlint --fix *.md  # Fix Markdown
```

### 4. Pousser et créer PR

```bash
git push origin feat/ma-feature
```

Puis ouvrez une Pull Request sur GitHub.

## Conventions

### Messages de commit (Conventional Commits)

Format : `type(scope): message`

Types valides :

- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation uniquement
- `style`: Formatage (pas de changement de code)
- `refactor`: Refactoring
- `test`: Ajout/modification tests
- `chore`: Maintenance (build, CI, etc.)
- `perf`: Amélioration performance

Exemples :

```bash
feat(lsp): add terraformls support
fix(install): correct uninstall script paths
docs(readme): update devops section
chore(ci): migrate to pre-commit
```

### Standards de code

#### Lua

- **Format** : stylua (120 colonnes)
- **Lint** : luacheck
- **Convention** : snake_case pour variables, PascalCase pour classes
- **Quotes** : Préférer double quotes `"text"`

#### Shell

- **Format** : suivre Google Shell Style Guide
- **Lint** : shellcheck
- **Convention** :
  - `set -euo pipefail` en début de script
  - Variables en MAJUSCULES pour globales
  - Quotes systématiques : `"$VAR"`
  - Fonctions : `function_name() { ... }`

#### Markdown

- **Lint** : markdownlint
- **Convention** :
  - Max 120 caractères/ligne (sauf code/tables)
  - Headings avec hiérarchie correcte
  - Code blocks avec langage spécifié

#### YAML

- **Lint** : yamllint
- **Convention** :
  - Indentation 2 espaces
  - Max 120 caractères/ligne
  - Clés en kebab-case

## Tests

### Tests locaux

```bash
# Installation dry-run
./install.sh --dry-run

# Healthcheck
./healthcheck.sh

# Pre-commit tous fichiers
pre-commit run --all-files

# Syntaxe Lua
lua -e "dofile('nvim/lua/plugins/nouveau.lua')"
```

### Tests CI

Les GitHub Actions s'exécutent automatiquement sur :

- Chaque push sur main/master/lazyvim
- Chaque Pull Request

Workflows :

- **Lint** : pre-commit hooks (shellcheck, stylua, luacheck, markdownlint)
- **Install** : test installation Ubuntu/Debian/Fedora
- **Smoke** : tests de base Neovim

## Structure du projet

```
.
├── .github/workflows/     # CI/CD
├── nvim/                  # Configuration Neovim
│   ├── lua/
│   │   ├── config/       # Options, keymaps, autocmds
│   │   └── plugins/      # Plugins par domaine
│   └── init.lua
├── install.sh            # Installation
├── healthcheck.sh        # Vérification
├── clean-restart.sh      # Nettoyage
└── .pre-commit-config.yaml  # Configuration pre-commit
```

## Ajouter un nouveau plugin

### 1. Choisir le domaine

Identifiez le fichier approprié dans `nvim/lua/plugins/` :

- `ui.lua` : Interface utilisateur
- `lsp.lua` : Language servers
- `git.lua` : Git workflow
- `devops.lua` : K8s, Terraform, etc.
- `navigation.lua` : Navigation/recherche
- Etc.

### 2. Ajouter la configuration

```lua
-- nvim/lua/plugins/domaine.lua
return {
  -- ... plugins existants ...

  -- Nouveau plugin
  {
    "auteur/nom-plugin",
    dependencies = { "autre/plugin" },
    event = "VeryLazy",  -- ou ft, cmd, keys
    opts = {
      -- options
    },
    keys = {
      { "<leader>x", "<cmd>Command<cr>", desc = "Description" },
    },
  },
}
```

### 3. Tester

```bash
# Relancer Neovim
nvim

# Synchroniser plugins
:Lazy sync

# Vérifier santé
:checkhealth
```

### 4. Documenter

Mettre à jour `README.md` section correspondante.

## Pre-commit - Référence détaillée

### Hooks configurés

| Hook | Description | Auto-fix |
|------|-------------|----------|
| shellcheck | Lint scripts shell | Non |
| stylua | Format Lua | Oui |
| luacheck | Lint Lua (optionnel) | Non |
| markdownlint | Lint/fix Markdown | Oui |
| yamllint | Lint YAML | Non |
| conventional-pre-commit | Valide messages commit | Non |

### Fichiers de configuration

- `.pre-commit-config.yaml` - Hooks pre-commit
- `.stylua.toml` - Format Lua (120 cols, 2 spaces)
- `.luacheckrc` - Lint Lua (globals: vim)
- `.markdownlint.yaml` - Lint Markdown
- `.yamllint.yaml` - Lint YAML
- `.shellcheckrc` - Lint shell

### Maintenance

```bash
# Mettre à jour les hooks
pre-commit autoupdate

# Nettoyer le cache
pre-commit clean

# Réinstaller
pre-commit uninstall && pre-commit install
```

### Dépannage

```bash
# Hook échoue ? Vérifier manuellement
shellcheck -x script.sh      # Shell
stylua --check nvim/lua      # Lua
luacheck nvim/lua            # Lua lint
markdownlint *.md            # Markdown

# Auto-fix et re-commit
stylua nvim/lua && markdownlint --fix *.md
git add . && git commit -m "style: fix formatting"
```

## Ressources

- [Lazy.nvim docs](https://github.com/folke/lazy.nvim)
- [Pre-commit docs](https://pre-commit.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Neovim LSP guide](https://neovim.io/doc/user/lsp.html)

## Questions ?

Ouvrez une issue sur GitHub avec le tag `question`.
