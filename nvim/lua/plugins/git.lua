return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({ current_line_blame = true })

      -- Keymaps pour les hunks
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Next hunk" })

      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous hunk" })

      vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
      vim.keymap.set("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
      vim.keymap.set("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
      vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame line" })
      vim.keymap.set("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neogit").setup({ integrations = { diffview = true } })
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
    },
  },

  -- GitHub intégration (PRs, Issues)
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      default_remote = { "upstream", "origin" },
      ssh_aliases = {},
    },
    keys = {
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "PR list" },
      { "<leader>gP", "<cmd>Octo pr create<cr>", desc = "Create PR" },
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Issues" },
      { "<leader>gI", "<cmd>Octo issue create<cr>", desc = "Create issue" },
      { "<leader>gr", "<cmd>Octo review start<cr>", desc = "Review start" },
    },
  },

  -- Recherche Git avancée
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
    },
    cmd = { "AdvancedGitSearch" },
    keys = {
      { "<leader>gc", "<cmd>AdvancedGitSearch<cr>", desc = "Advanced Git Search" },
      { "<leader>gl", "<cmd>AdvancedGitSearch search_log_content<cr>", desc = "Git log search" },
      { "<leader>gf", "<cmd>AdvancedGitSearch diff_commit_file<cr>", desc = "Git file history" },
    },
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
  },

  -- Git fugitive (commandes Git intégrées)
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gD", "<cmd>Gdiffsplit<cr>", desc = "Git diff (fugitive)" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame (full)" },
    },
  },
}
