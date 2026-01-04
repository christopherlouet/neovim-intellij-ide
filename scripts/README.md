# Scripts

## test-keymaps.sh

Script de validation des keymaps pour CI/CD.

### Description

Ce script effectue une **analyse statique** des fichiers de configuration Neovim pour vérifier que tous les keymaps critiques sont bien définis.

### Fonctionnement

- ✅ **Rapide** : < 1 seconde (pas de démarrage Neovim)
- ✅ **Fiable** : Analyse statique des fichiers source
- ✅ **Complet** : Vérifie 14 keymaps essentiels

### Keymaps testés

#### Terminal (3 keymaps)

- `<leader>tf` - Terminal flottant
- `<leader>th` - Terminal horizontal  
- `<leader>tv` - Terminal vertical

#### Telescope (3 keymaps)

- `<leader>fw` - Find word
- `<leader>fh` - Recent files
- `<leader>fp` - Projects

#### Git (3 keymaps)

- `]c` - Next hunk
- `[c` - Prev hunk
- `<leader>hs` - Stage hunk

#### LSP (2 keymaps)

- `gr` - References
- `<C-k>` - Signature help

#### Debug (3 keymaps)

- `<leader>dc` - Continue
- `<leader>di` - Step into
- `<leader>du` - Toggle UI

### Usage

```bash
# Exécution locale
./scripts/test-keymaps.sh

# Via pre-commit (automatique)
git commit -m "..." # Le hook se déclenche automatiquement

# En CI (GitHub Actions)
# Automatiquement exécuté dans le workflow neovim-smoke.yml
```

### Intégration CI/CD

#### Pre-commit Hook

Le test s'exécute automatiquement avant chaque commit si vous modifiez un fichier `nvim/lua/plugins/*.lua`.

Configuration : `.pre-commit-config.yaml`

```yaml
- id: neovim-keymap-test
  name: Neovim keymap validation
  entry: ./scripts/test-keymaps.sh
  files: ^nvim/lua/plugins/.*\.lua$
```

#### GitHub Actions

Le test s'exécute dans le workflow `neovim-smoke.yml` après les tests de base.

### Sortie exemple

```
🧪 Test des keymaps (static analysis)...

Checking terminal keymaps...
✓ <leader>tf - Terminal float (NEW)
✓ <leader>th - Terminal horizontal (NEW)
✓ <leader>tv - Terminal vertical (NEW)

Checking telescope keymaps...
✓ <leader>fw - Find word (NEW)
✓ <leader>fh - Recent files (NEW)
✓ <leader>fp - Projects (NEW)

...

============================================
Results: ✅ 14 passed, ❌ 0 failed
============================================

✅ All keymap definitions found in config files!
```

### Ajouter un nouveau keymap au test

Pour ajouter un keymap à tester, éditez `scripts/test-keymaps.sh` :

```bash
echo "Checking my new plugin..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/myplugin.lua" "<leader>xx" "My action"
```

### Pourquoi une analyse statique ?

Les plugins Neovim utilisent lazy-loading, ce qui signifie qu'ils ne se chargent qu'à la demande. Tester les keymaps de manière dynamique (en démarrant Neovim) nécessiterait :

1. Attendre que tous les plugins se chargent (~5-10 secondes)
2. Forcer le chargement de plugins qui ne sont pas utilisés immédiatement
3. Gérer les timeouts et les états de chargement

L'analyse statique est :

- **10x plus rapide** : < 1 seconde vs 10+ secondes
- **Plus fiable** : Pas de problèmes de timing ou de lazy-loading
- **Plus simple** : Pas besoin de gérer l'état de Neovim

Elle vérifie que le **code source définit bien les keymaps**, ce qui est suffisant pour détecter les régressions.
