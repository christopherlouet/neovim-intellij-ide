return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      -- Helper: reliably check whether a binary exists in PATH.
      -- Do NOT rely on null-ls conditional utils (their API isn't stable across
      -- null-ls/none-ls versions, which caused "attempt to call field 'executable'".
      local function has(bin)
        return vim.fn.exepath(bin) ~= ""
      end

      local sources = {
        null_ls.builtins.formatting.prettier.with({
          condition = function()
            return has("prettier") or has("prettierd")
          end,
        }),

        null_ls.builtins.diagnostics.markdownlint.with({
          condition = function()
            return has("markdownlint")
          end,
        }),

        null_ls.builtins.formatting.prisma_format.with({
          condition = function()
            return has("prisma")
          end,
        }),

        -- PHP
        null_ls.builtins.formatting.phpcsfixer.with({
          condition = function()
            return has("php-cs-fixer")
          end,
        }),

        -- Shell
        null_ls.builtins.formatting.shfmt.with({
          condition = function()
            return has("shfmt")
          end,
        }),

        -- Python
        null_ls.builtins.formatting.black.with({
          condition = function()
            return has("black")
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
                return has("eslint_d")
              end,
            })
          )
        elseif null_ls.builtins.diagnostics.eslint then
          table.insert(
            sources,
            null_ls.builtins.diagnostics.eslint.with({
              condition = function()
                return has("eslint")
              end,
            })
          )
        end
      end

      null_ls.setup({
        sources = sources,
        on_attach = function(client, bufnr)
          if not client.supports_method("textDocument/formatting") then
            return
          end

          local group = vim.api.nvim_create_augroup("NeovimIntelliJIDE_FormatOnSave", { clear = false })
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
              pcall(vim.lsp.buf.format, {
                bufnr = bufnr,
                timeout_ms = 2000,
                filter = function(c)
                  return c.name == "null-ls"
                end,
              })
            end,
          })
        end,
      })

      -- Helper: install external tools
      vim.api.nvim_create_user_command("MasonInstallDevTools", function()
        local ok_registry, registry = pcall(require, "mason-registry")
        if not ok_registry then
          vim.notify("mason.nvim not available", vim.log.levels.WARN)
          return
        end

        local wanted = {
          "stylua",
          "prettier",
          "eslint_d",
          "markdownlint",
          "prisma",
          "php-cs-fixer",
          "shfmt",
          "black",
        }

        registry.refresh(function()
          for _, name in ipairs(wanted) do
            local ok_pkg, pkg = pcall(registry.get_package, name)
            if ok_pkg and pkg then
              if pkg:is_installed() then
                -- noop
              elseif pkg:is_installing() then
                -- avoid "Package is already installing."
              else
                pkg:install()
              end
            end
          end
        end)
      end, { desc = "Install dev tools (formatters/linters)" })
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
        -- Avoid concurrent installs (and annoying "already installing" messages).
        -- Provide a single explicit entrypoint: :MasonInstallDevTools
        ensure_installed = {},
        automatic_installation = false,
      })
    end,
  },
}
