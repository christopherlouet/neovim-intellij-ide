return {
  -- Lecture logs améliorée avec highlight
  {
    "MTDL9/vim-log-highlighting",
    ft = "log",
  },

  -- Highlight JSON dans logs et amélioration syntaxe JSON
  {
    "elzr/vim-json",
    ft = { "json", "log" },
    config = function()
      vim.g.vim_json_syntax_conceal = 0
      vim.g.vim_json_warnings = 1
    end,
  },

  -- Log viewer amélioré pour fichiers volumineux
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    keys = {
      {
        "<leader>fl",
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Find Log Files",
            find_command = { "fd", "-e", "log", "-t", "f" },
          })
        end,
        desc = "Find log files",
      },
    },
  },
}
