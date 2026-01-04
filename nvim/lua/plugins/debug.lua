return {
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- F-keys
      vim.keymap.set("n", "<F5>", function()
        dap.continue()
      end, { desc = "Debug continue" })
      vim.keymap.set("n", "<F10>", function()
        dap.step_over()
      end, { desc = "Step over" })
      vim.keymap.set("n", "<F11>", function()
        dap.step_into()
      end, { desc = "Step into" })
      vim.keymap.set("n", "<F12>", function()
        dap.step_out()
      end, { desc = "Step out" })

      -- Leader keymaps
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, { desc = "Step over" })
      vim.keymap.set("n", "<leader>dO", function()
        dap.step_out()
      end, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
      end, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.run_last()
      end, { desc = "Run last" })
      vim.keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>dt", function()
        dap.terminate()
      end, { desc = "Terminate" })
    end,
  },
  { "theHamsta/nvim-dap-virtual-text", opts = {} },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = { automatic_installation = true },
  },
}
