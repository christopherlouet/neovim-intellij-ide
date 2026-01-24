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
- `<leader>ut` = Sélecteur de thème
- `gd` = Go to definition
- `K` = Hover doc
- `<leader>ca` = Code actions

## Thèmes disponibles

7 thèmes avec persistance du choix :

| Thème | Description |
|-------|-------------|
| `tokyo-night` | Clean dark theme (défaut) |
| `dracula` | Dark theme with vibrant colors |
| `catppuccin` | Soothing pastel theme |
| `nord` | Arctic, north-bluish palette |
| `gruvbox` | Retro warm colors |
| `cyberpunk` | Neon cyberpunk aesthetic |
| `matrix` | Matrix-inspired green terminal |

Changer de thème : `<leader>ut` ou `:lua require("utils.theme_selector").select_theme()`
