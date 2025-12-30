return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        git = { enable = true },
        diagnostics = { enable = true },
        view = { width = 32 },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", b.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>fb", b.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fs", b.lsp_document_symbols, { desc = "Symbols (file)" })
      vim.keymap.set("n", "<leader>fS", b.lsp_workspace_symbols, { desc = "Symbols (workspace)" })
    end
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make",
    config = function() require("telescope").load_extension("fzf") end
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({})
    end,
  },

  {
    "stevearc/aerial.nvim",
    opts = {},
    config = function()
      require("aerial").setup()
      vim.keymap.set("n", "<leader>so", "<cmd>AerialToggle<cr>", { desc = "Outline / Structure" })
    end
  },

  -- LSP file operations (rename/move with LSP awareness)
  { "antosha417/nvim-lsp-file-operations", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-tree.lua" }, opts = {} },
}
