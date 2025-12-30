return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = { require("neotest-jest")({}) },
      })
      vim.keymap.set("n", "<leader>tt", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Test file" })
      vim.keymap.set("n", "<leader>tT", function() neotest.run.run() end, { desc = "Test nearest" })
      vim.keymap.set("n", "<leader>to", neotest.output.open, { desc = "Test output" })
      vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Test summary" })
    end
  },

  -- Refactor assist
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("refactoring").setup({})
      vim.keymap.set({ "n", "x" }, "<leader>re", function()
        require("refactoring").select_refactor()
      end, { desc = "Refactor menu" })
    end
  },
}
