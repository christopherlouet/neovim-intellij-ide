return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        if #vim.api.nvim_list_uis() > 0 then
          vim.notify(
            "nvim-treesitter not available yet. Run :Lazy sync then restart Neovim.",
            vim.log.levels.WARN
          )
        end
        return
      end

      configs.setup({
        ensure_installed = {
          "lua","javascript","typescript","tsx","html","css","json","bash","markdown","prisma"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
