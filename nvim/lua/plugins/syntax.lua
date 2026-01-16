-- Configuration pour la coloration syntaxique native
-- Utilise les capacités natives de Neovim sans treesitter

return {
  -- Amélioration de la coloration syntaxique pour plusieurs langages
  {
    "sheerun/vim-polyglot",
    lazy = false,
    init = function()
      -- Désactiver les langages gérés par treesitter
      vim.g.polyglot_disabled = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "bash",
        "markdown",
        "prisma",
      }

      -- Configuration pour TypeScript/JavaScript
      vim.g.javascript_plugin_jsdoc = 1
      vim.g.javascript_plugin_flow = 1

      -- Configuration pour JSX/TSX
      vim.g.jsx_ext_required = 0
    end,
  },

  -- Support amélioré pour les fichiers de config courants
  {
    "cespare/vim-toml",
    ft = "toml",
  },

  {
    "stephpy/vim-yaml",
    ft = { "yaml", "yml" },
  },

  -- Support pour Prisma
  {
    "prisma/vim-prisma",
    ft = "prisma",
  },

  -- Support pour Docker
  {
    "ekalinin/Dockerfile.vim",
    ft = { "dockerfile", "Dockerfile" },
  },

  -- Support pour GraphQL
  {
    "jparise/vim-graphql",
    ft = { "graphql", "gql" },
  },

  -- Note: Lua utilise la coloration native de Neovim (excellente qualité)
  -- vim-polyglot est désactivé pour Lua pour éviter les conflits

  -- Support pour les fichiers .env
  {
    "tpope/vim-dotenv",
    ft = { "env", "dotenv" },
  },

  -- Support amélioré pour JSON avec commentaires
  {
    "neoclide/jsonc.vim",
    ft = { "json", "jsonc" },
  },

  -- Support pour les templates (handlebars, etc.)
  {
    "mustache/vim-mustache-handlebars",
    ft = { "html.handlebars", "handlebars", "hbs" },
  },
}
