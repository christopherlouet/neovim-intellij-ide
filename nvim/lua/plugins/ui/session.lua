-- Session management and profiling
return {
  -- Sessions (restore project state)
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_restore = true,
      suppressed_dirs = { "~/", "~/Downloads", "/" },
      git_use_branch_name = true,
    },
    keys = {
      { "<leader>qs", "<cmd>SessionSave<cr>", desc = "Save Session" },
      { "<leader>qr", "<cmd>SessionRestore<cr>", desc = "Restore Session" },
      { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete Session" },
    },
  },

  -- Startup time profiling
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    keys = {
      { "<leader>us", "<cmd>StartupTime<cr>", desc = "Startup Time" },
    },
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
