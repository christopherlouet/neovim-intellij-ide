# Configuration par Projet

Ce projet supporte les configurations spécifiques par projet via un fichier `.nvim.lua` à la racine de chaque projet.

## Sécurité

Le système utilise un modèle de confiance explicite :

- Les fichiers `.nvim.lua` ne sont **jamais** exécutés automatiquement
- Vous devez **explicitement faire confiance** à chaque projet
- La liste des projets de confiance est stockée dans `~/.local/share/nvim/trusted_projects.json`

## Utilisation

### Créer une configuration projet

Créez un fichier `.nvim.lua` à la racine de votre projet :

```lua
-- .nvim.lua - Configuration spécifique au projet

-- Options locales
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Variables de projet
vim.g.project_name = "mon-projet"

-- Keymaps spécifiques
vim.keymap.set("n", "<leader>pt", function()
  vim.cmd("!npm test")
end, { desc = "Run project tests" })

-- Configuration LSP spécifique
vim.g.lsp_settings = {
  python = { pythonPath = ".venv/bin/python" },
}
```

### Faire confiance à un projet

Lorsque vous ouvrez un projet avec un fichier `.nvim.lua`, vous serez invité à :

1. **Faire confiance** - Le fichier sera exécuté
2. **Ignorer** - Le fichier ne sera pas exécuté
3. **Voir le fichier** - Ouvrir le fichier pour inspection

Ou utilisez les commandes :

```vim
:ProjectConfig trust    " Faire confiance au répertoire courant
:ProjectConfig untrust  " Retirer la confiance
```

### Commandes disponibles

| Commande | Description |
|----------|-------------|
| `:ProjectConfig` | Afficher le statut du projet |
| `:ProjectConfig status` | Afficher le statut du projet |
| `:ProjectConfig trust` | Faire confiance au répertoire courant |
| `:ProjectConfig untrust` | Retirer la confiance |
| `:ProjectConfig reload` | Recharger la config (si trusted) |
| `:ProjectConfig list` | Lister les répertoires de confiance |
| `:ProjectConfig edit` | Éditer le fichier .nvim.lua |

## Exemples de configuration

### Projet Python

```lua
-- .nvim.lua
-- Utiliser l'environnement virtuel local
local venv = vim.fn.getcwd() .. "/.venv"
if vim.fn.isdirectory(venv) == 1 then
  vim.env.VIRTUAL_ENV = venv
  vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
end

-- Commande pour lancer les tests
vim.keymap.set("n", "<leader>pt", "<cmd>!pytest<cr>", { desc = "Run pytest" })
```

### Projet JavaScript/TypeScript

```lua
-- .nvim.lua
-- Formatage avec le formatter du projet
vim.g.project_formatter = "prettier"

-- Commandes npm
vim.keymap.set("n", "<leader>pd", "<cmd>!npm run dev<cr>", { desc = "npm dev" })
vim.keymap.set("n", "<leader>pb", "<cmd>!npm run build<cr>", { desc = "npm build" })
vim.keymap.set("n", "<leader>pt", "<cmd>!npm test<cr>", { desc = "npm test" })
```

### Projet Go

```lua
-- .nvim.lua
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false  -- Go utilise des tabs

vim.keymap.set("n", "<leader>pt", "<cmd>!go test ./...<cr>", { desc = "go test" })
vim.keymap.set("n", "<leader>pb", "<cmd>!go build<cr>", { desc = "go build" })
```

### Projet avec Docker

```lua
-- .nvim.lua
-- Commandes Docker
vim.keymap.set("n", "<leader>du", "<cmd>!docker-compose up -d<cr>", { desc = "docker up" })
vim.keymap.set("n", "<leader>dd", "<cmd>!docker-compose down<cr>", { desc = "docker down" })
vim.keymap.set("n", "<leader>dl", "<cmd>!docker-compose logs -f<cr>", { desc = "docker logs" })
```

## Mode verbeux

Pour voir les notifications de chargement :

```lua
-- Dans votre init.lua
vim.g.nvim_project_verbose = true
```

## Bonnes pratiques

1. **Ne jamais stocker de secrets** dans `.nvim.lua`
2. **Versionner** le fichier `.nvim.lua` avec le projet
3. **Documenter** les configurations spéciales dans le README du projet
4. **Utiliser des chemins relatifs** quand possible
5. **Tester** la configuration avant de committer

## Dépannage

### Le fichier n'est pas chargé

1. Vérifiez que le fichier existe : `:ProjectConfig status`
2. Vérifiez que le projet est trusted : `:ProjectConfig list`
3. Rechargez manuellement : `:ProjectConfig reload`

### Erreur de syntaxe

Si le fichier `.nvim.lua` contient une erreur, un message sera affiché. Corrigez l'erreur et utilisez `:ProjectConfig reload`.

### Réinitialiser la confiance

Pour supprimer tous les projets de confiance :

```bash
rm ~/.local/share/nvim/trusted_projects.json
```

## Voir aussi

- [PROFILES.md](PROFILES.md) - Profils de plugins
- [GETTING_STARTED.md](GETTING_STARTED.md) - Guide de démarrage
