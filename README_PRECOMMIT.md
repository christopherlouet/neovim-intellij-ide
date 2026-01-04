# Guide Pre-commit

Ce projet utilise [pre-commit](https://pre-commit.com/) pour garantir la qualité du code avant chaque commit.

## 🚀 Installation rapide

```bash
# Installer pre-commit
pip install pre-commit

# Installer les hooks Git
pre-commit install
pre-commit install --hook-type commit-msg

# Tester sur tous les fichiers
pre-commit run --all-files
```

## 🔍 Hooks configurés

### 1. **Shellcheck** - Lint shell scripts

Vérifie tous les scripts `.sh` avec shellcheck.

```bash
# Manuel
shellcheck -x install.sh
```

### 2. **StyLua** - Format Lua

Formate automatiquement les fichiers Lua selon `.stylua.toml`.

```bash
# Manuel - check
stylua --check nvim/lua

# Manuel - fix
stylua nvim/lua
```

### 3. **Luacheck** - Lint Lua (optionnel)

Vérifie la qualité du code Lua. Ce hook est optionnel et skip automatiquement si luacheck n'est pas installé.

```bash
# Installation (optionnel)
sudo apt install luarocks  # Ubuntu/Debian
luarocks install luacheck

# Manuel
luacheck nvim/lua
```

### 4. **Markdownlint** - Lint Markdown

Vérifie et corrige automatiquement les fichiers Markdown.

```bash
# Manuel - fix
markdownlint --fix *.md
```

### 5. **YAML Lint** - Lint YAML

Vérifie la syntaxe des fichiers YAML (GitHub Actions, etc.).

```bash
# Manuel
yamllint .github/workflows/*.yml
```

### 6. **Hooks généraux**

- Trailing whitespace
- End of file fixer
- Check YAML syntax
- Check large files (>500KB)
- Check merge conflicts
- Mixed line endings

### 7. **Conventional Commits**

Valide que les messages de commit suivent le format conventional.

Format : `type(scope): message`

Exemples valides :

```
feat(lsp): add yamlls support
fix(install): correct path in uninstall
docs(readme): update devops section
```

## 📋 Workflow typique

### Commit normal (hooks automatiques)

```bash
git add .
git commit -m "feat(plugin): add kubectl support"
# ✓ Les hooks s'exécutent automatiquement
# ✓ Si échec, le commit est annulé
```

### Correction après échec

```bash
# Si stylua échoue
stylua nvim/lua

# Si markdownlint échoue
markdownlint --fix *.md

# Re-commit
git add .
git commit -m "feat(plugin): add kubectl support"
```

### Tester avant commit

```bash
# Tester tous les hooks
pre-commit run --all-files

# Tester un hook spécifique
pre-commit run shellcheck
pre-commit run stylua
pre-commit run luacheck
```

### Skip hooks (déconseillé)

```bash
# Skip tous les hooks (ÉVITER)
git commit -m "message" --no-verify

# Skip un hook spécifique
SKIP=shellcheck git commit -m "message"
```

## 🔧 Configuration

Tous les fichiers de configuration sont à la racine du projet :

- `.pre-commit-config.yaml` - Configuration principale des hooks
- `.shellcheckrc` - Règles Shellcheck (warnings désactivés)
- `.stylua.toml` - Style de formatage Lua
- `.luacheckrc` - Règles de lint Lua
- `.markdownlint.yaml` - Règles Markdown (limite 150 chars)
- `.yamllint.yaml` - Règles YAML (permet on/off pour GitHub Actions)

### .pre-commit-config.yaml

Configuration principale des hooks.

```yaml
repos:
  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.10.0
    hooks:
      - id: shellcheck
```

### .stylua.toml

Configuration StyLua.

```toml
column_width = 120
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferDouble"
```

### .luacheckrc

Configuration Luacheck.

```lua
std = "lua51+luajit"
globals = { "vim" }
ignore = { "212" }  -- Unused arguments
```

### .markdownlint.yaml

Configuration Markdownlint.

```yaml
MD013:
  line_length: 120
MD033:
  allowed_elements: [br, img, details]
```

## 🛠️ Maintenance

### Mettre à jour les hooks

```bash
pre-commit autoupdate
```

### Nettoyer le cache

```bash
pre-commit clean
```

### Réinstaller les hooks

```bash
pre-commit uninstall
pre-commit install
pre-commit install --hook-type commit-msg
```

## 🐛 Dépannage

### Hook shellcheck échoue

```bash
# Vérifier manuellement
shellcheck -x script.sh

# Corriger et recommencer
git add script.sh
git commit -m "fix(script): correct shellcheck issues"
```

### Hook stylua échoue

```bash
# Auto-fix
stylua nvim/lua

# Vérifier
stylua --check nvim/lua

# Commit
git add nvim/lua
git commit -m "style(lua): format with stylua"
```

### Hook luacheck échoue

```bash
# Vérifier
luacheck nvim/lua

# Corriger le code puis
git add nvim/lua
git commit -m "fix(lua): resolve luacheck warnings"
```

### Hook conventional-pre-commit échoue

```bash
# Message invalide
git commit -m "Added feature"  # ❌

# Message valide
git commit -m "feat(plugin): add feature"  # ✅
```

### Pre-commit trop lent

```bash
# Skip hooks temporairement (local uniquement)
git commit -m "message" --no-verify

# Puis corriger et amender
pre-commit run --all-files
git add .
git commit --amend --no-edit
```

## 📊 CI/CD

Les mêmes hooks s'exécutent dans GitHub Actions :

```yaml
# .github/workflows/lint.yml
- name: Run pre-commit
  run: pre-commit run --all-files
```

Avantages :

- ✅ Validation identique local et CI
- ✅ Pas de surprise en PR
- ✅ Feedback rapide

## 💡 Tips

### Auto-fix avant commit

Créer un alias Git :

```bash
# ~/.gitconfig
[alias]
    precommit = !pre-commit run --all-files && git add -u
```

Usage :

```bash
git precommit
git commit -m "message"
```

### Pre-commit dans VSCode

Extension recommandée : "Pre-commit Helper"

### Pre-commit avec commitizen

Pour messages de commit assistés :

```bash
pip install commitizen
cz commit
```

## 📚 Ressources

- [Pre-commit docs](https://pre-commit.com/)
- [Shellcheck wiki](https://github.com/koalaman/shellcheck/wiki)
- [StyLua docs](https://github.com/JohnnyMorganz/StyLua)
- [Luacheck docs](https://luacheck.readthedocs.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ Questions

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour plus de détails sur le workflow de développement.
