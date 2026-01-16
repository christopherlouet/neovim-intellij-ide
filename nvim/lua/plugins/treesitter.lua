return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "bash",
        "markdown",
        "markdown_inline",
        "prisma",
      },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    enabled = true,
    event = "InsertEnter",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "jsx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  },
}
