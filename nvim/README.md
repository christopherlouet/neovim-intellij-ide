# Neovim IntelliJ-IDE Configuration

Configuration Neovim moderne inspirée d'IntelliJ IDEA.

## Structure

```
nvim/
├── init.lua              # Bootstrap
├── lua/
│   ├── config/           # Core (options, keymaps, autocmds)
│   └── plugins/          # Specs lazy.nvim (18 modules)
└── after/ftplugin/       # Per-filetype settings
```

## Commandes personnalisées

| Commande | Description |
|----------|-------------|
| `:IdeDoctor` | Vérifier les dépendances |
| `:MasonInstallDevTools` | Installer formatters/linters |
| `:Lazy` | Gérer les plugins |
| `:Mason` | Gérer les LSP servers |

## Keymaps principaux

- `<leader>` = Space
- `<leader>ff` = Find files
- `<leader>fg` = Live grep
- `<leader>e` = File explorer
- `gd` = Go to definition
- `K` = Hover doc
- `<leader>ca` = Code actions
