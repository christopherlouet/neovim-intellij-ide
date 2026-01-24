-- Theme and icons configuration
-- Provides multiple colorscheme options with persistent selection via <leader>ut
--
-- Available themes:
--   - tokyo-night (default)
--   - dracula
--   - catppuccin
--   - nord
--   - gruvbox
--   - cyberpunk
--   - matrix

--- Helper to apply saved theme if it matches
---@param theme_name string Theme identifier
---@param colorscheme string Colorscheme command name
local function apply_if_saved(theme_name, colorscheme)
  if vim.g._theme_to_apply == theme_name then
    vim.cmd.colorscheme(colorscheme)
    vim.g._theme_to_apply = nil
  end
end

return {
  -- Tokyo Night (default colorscheme)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        colors.border = colors.blue
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("syntax on")

      -- Check for saved theme preference
      local theme_selector = require("utils.theme_selector")
      local saved = theme_selector.load_saved_theme()

      if saved and saved ~= "tokyo-night" then
        -- Store for lazy-loaded theme plugins to apply
        vim.g._theme_to_apply = saved
      else
        -- Apply tokyonight as default
        vim.cmd.colorscheme("tokyonight")
      end
    end,
    keys = {
      {
        "<leader>ut",
        function()
          require("utils.theme_selector").select_theme()
        end,
        desc = "Select theme",
      },
    },
  },

  -- Dracula - Dark theme with vibrant colors
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_bg = false,
      italic_comment = true,
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      apply_if_saved("dracula", "dracula")
    end,
  },

  -- Catppuccin - Soothing pastel theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true },
        cmp = true,
        gitsigns = true,
        telescope = { enabled = true },
        indent_blankline = { enabled = true },
        mini = { enabled = true },
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      apply_if_saved("catppuccin", "catppuccin")
    end,
  },

  -- Nord - Arctic, north-bluish color palette
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_italic = true
      apply_if_saved("nord", "nord")
    end,
  },

  -- Gruvbox - Retro groove color scheme
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      terminal_colors = true,
      contrast = "hard",
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      apply_if_saved("gruvbox", "gruvbox")
    end,
  },

  -- Cyberdream - Neon cyberpunk aesthetic
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      borderless_telescope = false,
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      apply_if_saved("cyberpunk", "cyberdream")
    end,
  },

  -- Matrix - Matrix-inspired green terminal
  {
    "iruzo/matrix-nvim",
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.matrix_contrast = true
      vim.g.matrix_borders = true
      apply_if_saved("matrix", "matrix")
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
