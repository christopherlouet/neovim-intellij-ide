return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local utils = require("null-ls.utils").make_conditional_utils()

      local sources = {
        null_ls.builtins.formatting.prettier.with({
          condition = function()
            return utils.executable("prettier") or utils.executable("prettierd")
          end,
        }),

        null_ls.builtins.diagnostics.markdownlint.with({
          condition = function()
            return utils.executable("markdownlint")
          end,
        }),

        null_ls.builtins.formatting.prisma_format.with({
          condition = function()
            return utils.executable("prisma")
          end,
        }),
      }

      -- eslint_d is not guaranteed to be a core builtin across none-ls versions.
      -- Prefer none-ls-extras when available; fallback to eslint builtin.
      do
        local ok, eslint_d = pcall(require, "none-ls.diagnostics.eslint_d")
        if ok and eslint_d then
          table.insert(
            sources,
            eslint_d.with({
              condition = function()
                return utils.executable("eslint_d")
              end,
            })
          )
        elseif null_ls.builtins.diagnostics.eslint then
          table.insert(
            sources,
            null_ls.builtins.diagnostics.eslint.with({
              condition = function()
                return utils.executable("eslint")
              end,
            })
          )
        end
      end

      null_ls.setup({ sources = sources })

      -- Format on save (safe)
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          pcall(vim.lsp.buf.format, { timeout_ms = 2000 })
        end,
      })

      -- Helper: install external tools
      vim.api.nvim_create_user_command("MasonInstallDevTools", function()
        vim.cmd("MasonInstall prettier eslint_d markdownlint prisma")
      end, { desc = "Install dev tools (prettier/eslint_d/markdownlint/prisma)" })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      local mason_null_ls = require("mason-null-ls")

      -- In headless mode (CI / checkhealth), do NOT start async installs (Neovim exits immediately).
      local is_headless = (#vim.api.nvim_list_uis() == 0)

      mason_null_ls.setup({
        ensure_installed = is_headless and {} or { "prettier", "eslint_d", "markdownlint", "prisma" },
        automatic_installation = false,
      })
    end,
  },
}
