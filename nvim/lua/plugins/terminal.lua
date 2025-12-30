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
    end
  },

  {
    "stevearc/overseer.nvim",
    opts = {},
    config = function()
      require("overseer").setup()
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
    end
  },
}
