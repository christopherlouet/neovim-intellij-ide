# 🔧 Guide de dépannage — Neovim IntelliJ IDE

Guide complet pour résoudre les problèmes courants.

---

## 🚨 Problèmes courants et solutions

### Neovim ne démarre pas / Erreurs au lancement

**Solution rapide :**

```bash
./clean-restart.sh --deep -y
```

Ce script :

- Nettoie tous les caches
- Réinstalle les plugins
- Crée un backup automatique

---

### Erreur "module not found" ou problèmes de cache

**Symptômes :**

- Messages d'erreur "module 'xxx' not found"
- Plugins qui ne se chargent pas
- Comportements erratiques

**Solution :**

```bash
# Nettoyage du cache
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim

# Redémarrage de Neovim
nvim
```

---

### LSP ne démarre pas

**Vérification :**

```vim
:LspInfo
:LspLog
```

**Solutions :**

1. **Vérifier que le serveur est installé :**

```vim
:Mason
```

2. **Réinstaller le serveur LSP :**

```vim
:MasonUninstall typescript-language-server
:MasonInstall typescript-language-server
```

3. **Vérifier la configuration :**

```bash
nvim ~/.config/nvim/lua/plugins/lsp.lua
```

---

### Plugins ne s'installent pas

**Solutions :**

1. **Synchroniser manuellement :**

```vim
:Lazy sync
```

2. **Nettoyer et réinstaller :**

```bash
./clean-restart.sh --deep
```

3. **Vérifier les logs :**

```vim
:Lazy log
```

---

### Coloration syntaxique manquante

**Note** : Treesitter est désactivé par défaut dans cette configuration.

**Neovim utilise la coloration native** qui fonctionne très bien pour :

- JavaScript / TypeScript
- HTML / CSS
- Lua
- JSON / Markdown
- Bash

**Pour activer Treesitter (optionnel) :**

1. Éditer `nvim/lua/plugins/treesitter.lua`
2. Décommenter le bloc de configuration
3. Exécuter :

```vim
:Lazy sync
:TSUpdate
```

---

### Formatage ne fonctionne pas

**Vérifications :**

1. **Vérifier que none-ls fonctionne :**

```vim
:lua print(vim.inspect(require("null-ls").get_sources()))
```

2. **Vérifier que prettier/eslint sont installés :**

```vim
:Mason
```

3. **Installer les outils manquants :**

```bash
npm install -g prettier eslint_d
```

4. **Vérifier Node.js :**

```vim
:!which node
```

---

### Git (Gitsigns, Neogit) ne fonctionne pas

**Vérifications :**

1. **Vérifier que vous êtes dans un repo Git :**

```bash
git status
```

2. **Réinitialiser Gitsigns :**

```vim
:Gitsigns refresh
```

3. **Vérifier les logs :**

```vim
:messages
```

---

### Performances lentes

**Solutions :**

1. **Profiler le démarrage :**

```vim
:Lazy profile
```

2. **Désactiver les plugins non utilisés :**

Éditer les fichiers dans `~/.config/nvim/lua/plugins/` et ajouter `enabled = false`

3. **Nettoyer les anciens fichiers :**

```bash
./clean-restart.sh
```

---

### Notifications qui disparaissent trop vite

**Solution :**

Éditer `nvim/lua/plugins/ui.lua` et augmenter le timeout :

```lua
opts = {
  timeout = 5000, -- 5 secondes au lieu de 3
  ...
}
```

---

### Completion ne fonctionne pas

**Vérifications :**

1. **Vérifier que nvim-cmp est chargé :**

```vim
:lua print(vim.inspect(require('cmp')))
```

2. **Vérifier les sources :**

```vim
:CmpStatus
```

3. **Réinstaller LuaSnip :**

```bash
./clean-restart.sh --deep -y
```

---

### Sessions ne se restaurent pas

**Solution :**

1. **Vérifier la configuration :**

```vim
:lua print(vim.inspect(require('auto-session').conf))
```

2. **Sauvegarder manuellement :**

```vim
:SessionSave
```

3. **Vérifier le dossier des sessions :**

```bash
ls ~/.local/share/nvim/sessions/
```

---

## 🛠️ Commandes utiles

### Diagnostic général

```bash
# Vérification complète
./healthcheck.sh

# Nettoyage léger
./clean-restart.sh

# Nettoyage complet
./clean-restart.sh --deep

# Preview sans modifications
./clean-restart.sh --dry-run
```

### Dans Neovim

```vim
" Santé générale
:checkhealth

" Plugins
:Lazy
:Lazy sync
:Lazy clean
:Lazy profile

" LSP
:LspInfo
:LspLog
:LspRestart

" Mason
:Mason
:MasonLog

" Diagnostics
:Trouble

" Git
:Neogit
:Gitsigns refresh

" Messages
:messages
:Noice
```

---

## 📝 Fichiers de log

Les logs sont disponibles dans :

```bash
# Logs d'installation
~/.nvim-install-logs/

# Logs Neovim
~/.local/state/nvim/lsp.log

# Logs des plugins
:Lazy log
:MasonLog
```

---

## 🔍 Debugging avancé

### Mode verbose

Lancer Neovim avec :

```bash
nvim -V9nvim.log
```

Puis consulter `nvim.log` pour les détails.

### Désactiver tous les plugins

```bash
nvim -u NONE
```

### Tester une configuration minimale

```bash
nvim -u ~/.config/nvim/init.lua --noplugin
```

---

## 🆘 Réinitialisation complète

Si rien ne fonctionne :

```bash
# Backup complet
cp -r ~/.config/nvim ~/.config/nvim.backup

# Nettoyage total
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim

# Réinstallation
cd ~/path/to/neovim-intellij-ide
./install.sh
```

---

## 📞 Support

Si le problème persiste :

1. Consulter les issues GitHub
2. Exécuter `:checkhealth` et noter les erreurs
3. Vérifier les logs
4. Créer une issue avec :
   - Version de Neovim : `:version`
   - OS et version
   - Logs pertinents
   - Étapes pour reproduire

---

## ✅ Checklist après résolution

- [ ] `:checkhealth` sans erreurs critiques
- [ ] `:Lazy` montre tous les plugins OK
- [ ] `:Mason` affiche les outils installés
- [ ] LSP fonctionne : `:LspInfo`
- [ ] Formatage fonctionne : sauvegarder un fichier
- [ ] Git fonctionne : ouvrir un repo
- [ ] Pas d'erreurs dans `:messages`
