return {
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug continue" })
      vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step over" })
      vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Step into" })
      vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step out" })
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Breakpoint" })
    end
  },
  { "theHamsta/nvim-dap-virtual-text", opts = {} },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = { automatic_installation = true },
  },
}
