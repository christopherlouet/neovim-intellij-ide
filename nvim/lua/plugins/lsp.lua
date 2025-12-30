return {
  -- Mason still used only as installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mlsp = require("mason-lspconfig")
      mlsp.setup({
        ensure_installed = {
          "ts_ls",
          "prismals",
          "tailwindcss",
          "jsonls",
          "html",
          "cssls",
          "eslint",
          "dockerls",
          "bashls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- Neovim 0.11 native LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local navic = require("nvim-navic")

      local function on_attach(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gR", vim.lsp.buf.references, "Find references")
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>fd", function()
          vim.lsp.buf.format({ timeout_ms = 2000 })
        end, "Format file")

        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
      end

      local servers = {
        ts_ls = {},
        prismals = {},
        tailwindcss = {},
        jsonls = {},
        html = {},
        cssls = {},
        eslint = {},
        dockerls = {},
        bashls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        vim.lsp.config(server, config)
      end
    end,
  },

  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = { highlight = true },
  },

  { "prisma/vim-prisma", ft = "prisma" },
}
