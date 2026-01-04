return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "horizontal",
        float_opts = { border = "curved" },
      })
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle terminal flottant" })
      vim.keymap.set(
        "n",
        "<leader>th",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        { desc = "Toggle terminal horizontal" }
      )
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle terminal vertical" })
    end,
  },

  {
    "stevearc/overseer.nvim",
    opts = {},
    config = function()
      require("overseer").setup()
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
    end,
  },
}
