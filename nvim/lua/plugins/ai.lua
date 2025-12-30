return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        window = { position = "botright", split_ratio = 0.33, enter_insert = true },
        refresh = { enable = true },
        keymaps = { toggle = { normal = "<leader>cc", terminal = "<leader>cc" } },
      })
      vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Claude Code" })
    end
  },
}
