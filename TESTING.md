# Tests Automatisés

Ce projet utilise plusieurs niveaux de tests pour garantir la qualité et la cohérence de la configuration Neovim.

## 🧪 Tests disponibles

### 1. Tests Unitaires Lua (scripts/run-tests.sh)

**Objectif** : Tester les modules de configuration Lua avec plenary.nvim

**Type** : Tests unitaires avec assertions

**Couverture** :

- `config/options` : Options Neovim (line numbers, indentation, etc.)
- `config/keymaps` : Keymaps globaux (save, quit, navigation, etc.)

**Exécution locale** :

```bash
# Tous les tests
./scripts/run-tests.sh

# Test spécifique
./scripts/run-tests.sh config/options
./scripts/run-tests.sh config/keymaps
```

**Prérequis** :

- Neovim >= 0.11
- plenary.nvim installé (`~/.local/share/nvim/lazy/plenary.nvim`)

**Intégration CI** :

- ✅ GitHub Actions (workflow `lua-tests.yml`)
- ✅ Benchmark temps de démarrage

---

### 2. Test des Keymaps (scripts/test-keymaps.sh)

**Objectif** : Vérifier que tous les keymaps critiques sont définis dans les fichiers de configuration.

**Type** : Analyse statique (grep des fichiers source)

**Performance** : ⚡ **~32ms** (ultra-rapide)

**Couverture** :

- 3 keymaps terminal (`<leader>tf`, `<leader>th`, `<leader>tv`)
- 3 keymaps telescope (`<leader>fw`, `<leader>fh`, `<leader>fp`)
- 3 keymaps git (`]c`, `[c`, `<leader>hs`)
- 2 keymaps LSP (`gr`, `<C-k>`)
- 3 keymaps debug (`<leader>dc`, `<leader>di`, `<leader>du`)

**Exécution locale** :

```bash
./scripts/test-keymaps.sh
```

**Intégration CI** :

- ✅ Pre-commit hook (automatique sur modifications de `nvim/lua/plugins/*.lua`)
- ✅ GitHub Actions (workflow `neovim-smoke.yml`)

---

### 3. Neovim Smoke Test (GitHub Actions)

**Objectif** : Vérifier que Neovim démarre correctement avec la configuration.

**Workflow** : `.github/workflows/neovim-smoke.yml`

**Tests inclus** :

1. Installation de Neovim (AppImage)
2. Démarrage headless (`nvim --headless +qall`)
3. Checkhealth (`nvim --headless +checkhealth +qa`)
4. Test des keymaps (`scripts/test-keymaps.sh`)

**Déclenchement** :

- Push sur `main`, `master`, `lazyvim`
- Pull requests
- Manuel (workflow_dispatch)

---

### 4. Pre-commit Hooks

**Configuration** : `.pre-commit-config.yaml`

**Hooks actifs** :

- ✅ **Shellcheck** - Linting des scripts shell
- ✅ **StyLua** - Formatage du code Lua
- ✅ **Luacheck** - Linting du code Lua (optionnel)
- ✅ **Markdownlint** - Linting des fichiers Markdown
- ✅ **YAML Lint** - Validation des fichiers YAML
- ✅ **Keymaps test** - Validation des keymaps (nouveau)
- ✅ Vérifications générales (trailing whitespace, end-of-file, etc.)

**Installation** :

```bash
pip install pre-commit
pre-commit install
```

**Exécution manuelle** :

```bash
# Tous les fichiers
pre-commit run --all-files

# Fichiers modifiés
pre-commit run

# Hook spécifique
pre-commit run neovim-keymap-test
```

---

## 📊 Matrice de tests

| Test | Local | Pre-commit | CI | Durée |
|------|-------|------------|----|----|
| **Lua unit tests** | ✅ | ❌ | ✅ | ~2s |
| Keymaps | ✅ | ✅ | ✅ | ~32ms |
| Smoke test | ⚠️ | ❌ | ✅ | ~30s |
| Benchmark | ⚠️ | ❌ | ✅ | ~5s |
| Shellcheck | ✅ | ✅ | ✅ | ~100ms |
| StyLua | ✅ | ✅ | ✅ | ~200ms |
| Luacheck | ✅ | ✅ | ✅ | ~500ms |

⚠️ Tests locaux nécessitent Neovim et plenary.nvim installés

---

## 🚀 Workflow de développement recommandé

### Avant de committer

1. **Modifier les fichiers** de configuration Neovim
2. **Tester localement** (optionnel) :

   ```bash
   nvim  # Vérifier que tout fonctionne
   ```

3. **Committer** :

   ```bash
   git add .
   git commit -m "feat(keymaps): add new terminal shortcuts"
   ```

4. Les **pre-commit hooks s'exécutent automatiquement** :
   - Formatage du code (StyLua)
   - Linting (Shellcheck, Luacheck, Markdownlint)
   - Validation des keymaps (si modification de plugins)

### Après le push / PR

1. **GitHub Actions s'exécute** automatiquement
2. **Vérifications CI** :
   - Neovim démarre correctement
   - Checkhealth passe
   - Keymaps sont valides
3. Si tout est vert ✅ → Merge

---

## 🔧 Ajouter un nouveau test

### Test de keymaps

Éditer `scripts/test-keymaps.sh` :

```bash
echo "Checking my new plugin..."
check_keymap "$PROJECT_ROOT/nvim/lua/plugins/myplugin.lua" "<leader>xx" "My action"
```

### Pre-commit hook

Ajouter dans `.pre-commit-config.yaml` :

```yaml
- repo: local
  hooks:
    - id: my-custom-test
      name: My custom test
      entry: ./scripts/my-test.sh
      language: system
      files: \.lua$
```

### GitHub Actions

Ajouter une étape dans `.github/workflows/neovim-smoke.yml` :

```yaml
- name: My custom test
  run: |
    ./scripts/my-test.sh
```

---

## 📚 Documentation

- **Keymaps** : `KEYMAPS_AUDIT.md` - Audit complet des keymaps
- **Scripts** : `scripts/README.md` - Documentation des scripts
- **Getting Started** : `GETTING_STARTED.md` - Guide utilisateur

---

## ✅ Checklist de qualité

Avant de merger une PR, vérifier :

- [ ] Les tests locaux passent (`./scripts/test-keymaps.sh`)
- [ ] Pre-commit hooks passent (`pre-commit run --all-files`)
- [ ] GitHub Actions est vert ✅
- [ ] La documentation est à jour (`GETTING_STARTED.md`, `KEYMAPS_AUDIT.md`)
- [ ] Les nouveaux keymaps sont documentés
- [ ] Les nouveaux keymaps sont testés

---

## 🐛 Déboguer un test qui échoue

### Test de keymaps échoue

```bash
# Vérifier quel keymap manque
./scripts/test-keymaps.sh

# Exemple de sortie :
# ✗ <leader>xx - My action NOT FOUND in myplugin.lua

# Solution : Ajouter le keymap dans le fichier
vim nvim/lua/plugins/myplugin.lua
```

### Smoke test échoue

```bash
# Tester localement
nvim --headless "+checkhealth" +qa

# Voir les erreurs
nvim --headless "+messages" +qa
```

### Pre-commit échoue

```bash
# Voir les détails
pre-commit run --all-files --verbose

# Fixer le formatage
stylua nvim/lua/

# Fixer shellcheck
shellcheck scripts/*.sh
```

---

## 📈 Amélioration continue

### Idées futures

- [x] ~~Tests unitaires Lua~~ ✅ Implémenté
- [x] ~~Tests de performance (temps de démarrage)~~ ✅ Benchmark CI
- [ ] Tests d'intégration (vérifier que les keymaps fonctionnent réellement)
- [ ] Tests de régression visuelle (capture d'écran)
- [ ] Coverage des keymaps (% de keymaps documentés vs définis)
- [ ] Tests de plugins (vérifier que tous les plugins se chargent)

### Métriques actuelles

- ✅ **14 keymaps critiques** testés automatiquement
- ✅ **100% de couverture** des keymaps ajoutés récemment
- ✅ **< 1 seconde** temps d'exécution des tests de keymaps
- ✅ **< 30 secondes** temps d'exécution du smoke test complet

---

**Contributeurs** : Assurez-vous de lire ce document avant de soumettre une PR ! 🚀
