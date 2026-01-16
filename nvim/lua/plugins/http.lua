return {
  -- REST client pour tester APIs directement depuis Neovim
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Ouvre les résultats dans un buffer horizontal
        result_split_horizontal = false,
        result_split_in_place = false,
        -- Sauter au résultat après exécution
        skip_ssl_verification = false,
        -- Encodage
        encode_url = true,
        -- Highlight des résultats
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- Afficher les statistiques de la requête
          show_url = true,
          show_http_info = true,
          show_headers = true,
          show_curl_command = false,
          -- Formatage automatique de la réponse
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Saut automatique au résultat
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { desc = "Run HTTP request" })
      vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", { desc = "Preview HTTP request" })
      vim.keymap.set("n", "<leader>rl", "<Plug>RestNvimLast", { desc = "Rerun last HTTP request" })
    end,
  },
}
