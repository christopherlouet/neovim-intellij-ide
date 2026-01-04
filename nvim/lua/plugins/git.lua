return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ current_line_blame = true })
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
  { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

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
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    },
  },
}
