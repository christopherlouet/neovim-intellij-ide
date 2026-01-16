-- Fallback syntax support for languages not fully covered by treesitter
-- Primary highlighting is handled by nvim-treesitter (see treesitter.lua)

return {
  -- vim-polyglot: fallback for niche filetypes not in treesitter
  {
    "sheerun/vim-polyglot",
    event = "VeryLazy",
    init = function()
      -- Disable languages fully handled by treesitter
      vim.g.polyglot_disabled = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "html",
        "css",
        "json",
        "jsonc",
        "bash",
        "markdown",
        "prisma",
        "yaml",
        "toml",
        "dockerfile",
        "graphql",
      }

      -- Keep JSDoc/Flow support for edge cases
      vim.g.javascript_plugin_jsdoc = 1
      vim.g.javascript_plugin_flow = 1
      vim.g.jsx_ext_required = 0
    end,
  },

  -- NOTE: The following ft-based plugins are kept as fallbacks.
  -- Treesitter handles most of these, but these provide additional
  -- features like better indentation or filetype detection.

  -- Support pour les fichiers .env (no treesitter parser)
  {
    "tpope/vim-dotenv",
    ft = { "env", "dotenv" },
  },

  -- Support pour les templates (handlebars, etc.)
  {
    "mustache/vim-mustache-handlebars",
    ft = { "html.handlebars", "handlebars", "hbs" },
  },
}
