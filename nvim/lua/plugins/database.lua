return {
  -- Interface UI pour bases de données (PostgreSQL, MySQL, SQLite, etc.)
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "DB Find buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "DB Rename buffer" },
      { "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = "DB Last query info" },
    },
    init = function()
      -- Configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_winwidth = 40

      vim.g.db_ui_table_helpers = {
        mysql = {
          Count = "select count(1) from {optional_schema}{table}",
          Explain = "explain {last_query}",
        },
        postgres = {
          Count = "select count(1) from {optional_schema}{table}",
          Explain = "explain analyze {last_query}",
        },
      }

      -- Sauvegarde des connexions (à configurer par l'utilisateur)
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
    end,
  },

  -- Complétion SQL pour nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
      },
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "vim-dadbod-completion" })
    end,
  },
}
