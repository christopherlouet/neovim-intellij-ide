# Profiles - Configuration par cas d'usage

Ce projet supporte plusieurs **profils** permettant d'adapter la configuration Neovim à différents usages.

## Profils disponibles

| Profil | Description | Plugins | Cas d'usage |
|--------|-------------|---------|-------------|
| `minimal` | Core IDE | 9 | Édition basique, LSP, completion |
| `javascript` | JS/TS dev | 13 | Développement frontend/Node.js |
| `devops` | Infrastructure | 15 | K8s, Terraform, Docker, Ansible |
| `full` | Tout | 19 | Configuration complète (défaut) |

## Utilisation

### Définir un profil

Ajoutez dans votre `init.lua` **avant** le chargement des plugins :

```lua
-- Choisir un profil (avant require("plugins.lazy"))
vim.g.nvim_profile = "javascript"  -- ou "minimal", "devops", "full"
```

### Profil par variable d'environnement

```bash
# Dans votre shell
export NVIM_PROFILE=devops
nvim
```

Puis dans `init.lua` :

```lua
vim.g.nvim_profile = vim.env.NVIM_PROFILE or "full"
```

### Vérifier le profil actif

```vim
:NvimProfile info
:NvimProfile list
```

## Détail des profils

### minimal (9 modules)

Idéal pour : édition rapide, machines avec ressources limitées, SSH.

```
plugins.ui          # Interface (theme, statusline)
plugins.lsp         # Language servers
plugins.completion  # Autocomplétion
plugins.telescope   # Recherche fuzzy
plugins.treesitter  # Syntax highlighting
plugins.git         # Git basique
plugins.formatting  # Formatters
plugins.syntax      # Coloration supplémentaire
```

**Ce qui n'est PAS inclus** : Debug, tests, Docker, DevOps, AI, HTTP client.

### javascript (13 modules)

Idéal pour : développement JS/TS, React, Vue, Node.js.

Inclut `minimal` plus :

```
plugins.terminal    # Terminal intégré
plugins.debug       # Debugging (DAP)
plugins.tests       # Test runners (Jest)
plugins.navigation  # Navigation avancée (Leap, Harpoon)
```

### devops (15 modules)

Idéal pour : DevOps, Platform engineering, SRE.

Inclut `minimal` plus :

```
plugins.terminal    # Terminal intégré
plugins.devops      # K8s, Terraform, Ansible, Helm
plugins.docker      # Docker containers
plugins.database    # SQL, vim-dadbod
plugins.http        # REST client
plugins.logs        # Log viewer
```

### full (19 modules)

Configuration complète avec tous les plugins.

Inclut tout : `minimal` + `javascript` + `devops` + AI.

## Créer un profil personnalisé

1. Éditez `nvim/lua/profiles/init.lua`
2. Ajoutez votre profil dans `M.profiles` :

```lua
M.profiles = {
  -- ... autres profils ...

  -- Mon profil personnalisé
  my_profile = {
    "plugins.lazy",
    "plugins.ui",
    "plugins.lsp",
    -- Ajoutez les modules souhaités
  },
}
```

3. Utilisez-le :

```lua
vim.g.nvim_profile = "my_profile"
```

## Performance

| Profil | Modules | Temps démarrage estimé |
|--------|---------|------------------------|
| minimal | 9 | ~150ms |
| javascript | 13 | ~200ms |
| devops | 15 | ~220ms |
| full | 19 | ~250ms |

*Temps mesurés sur une machine moderne (SSD, 16GB RAM)*

## FAQ

### Comment savoir quels plugins sont chargés ?

```vim
:Lazy
```

### Comment changer de profil temporairement ?

Lancez Neovim avec :

```bash
nvim --cmd "let g:nvim_profile='minimal'"
```

### Les keymaps changent-ils selon le profil ?

Non, les keymaps de base restent identiques. Seuls les keymaps spécifiques aux plugins désactivés ne seront pas disponibles.

### Puis-je avoir plusieurs configurations ?

Oui, utilisez `NVIM_APPNAME` :

```bash
# Configuration devops
NVIM_APPNAME=nvim-devops NVIM_PROFILE=devops nvim

# Configuration minimal
NVIM_APPNAME=nvim-minimal NVIM_PROFILE=minimal nvim
```

## Voir aussi

- [GETTING_STARTED.md](GETTING_STARTED.md) - Guide de démarrage
- [ARCHITECTURE.md](ARCHITECTURE.md) - Architecture du projet
- [README.md](README.md) - Documentation principale
