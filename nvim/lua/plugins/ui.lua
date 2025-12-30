return {
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight")
    end
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "nvim-neotest/nvim-nio" },

  { "echasnovski/mini.icons", opts = {} },

  { "rcarriga/nvim-notify", opts = { background_colour = "#000000" } },

  { "folke/which-key.nvim",
    config = function()
      require("which-key").setup({ win = { border = "rounded" } })
    end
  },

  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup({ options = { theme = "auto" } }) end
  },

  { "akinsho/bufferline.nvim", version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("bufferline").setup() end
  },

  { "stevearc/dressing.nvim", opts = {} },

  { "folke/noice.nvim", event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = { presets = { bottom_search = true, command_palette = true } }
  },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  { "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Trouble" })
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = "Workspace diagnostics" })
    end
  },

  -- Sessions (restore project state)
  { "rmagatti/auto-session",
    opts = {
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
    },
    config = function(_, opts)
      require("auto-session").setup(opts)
      vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Session save" })
      vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "Session restore" })
    end
  },
}
