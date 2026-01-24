-- Tests for UI plugin modules
local assert = require("luassert")
local helpers = require("tests.helpers")

-- Set up package path to allow require() to find modules
local nvim_lua_path = helpers.get_nvim_config_path() .. "/lua/?.lua"
local nvim_lua_init_path = helpers.get_nvim_config_path() .. "/lua/?/init.lua"
if not package.path:find(nvim_lua_path, 1, true) then
  package.path = package.path .. ";" .. nvim_lua_path .. ";" .. nvim_lua_init_path
end

describe("plugins.ui", function()
  local ui_modules = {
    "theme",
    "statusline",
    "feedback",
    "noice",
    "diagnostics",
    "session",
  }

  describe("module structure", function()
    for _, module_name in ipairs(ui_modules) do
      local full_path

      before_each(function()
        full_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/" .. module_name .. ".lua"
      end)

      it("should load " .. module_name .. " without errors", function()
        assert.has_no.errors(function()
          dofile(full_path)
        end)
      end)

      it(module_name .. " should return a table", function()
        local spec = dofile(full_path)
        assert.is_table(spec)
      end)

      it(module_name .. " should have valid plugin spec structure", function()
        local spec = dofile(full_path)
        local is_valid, err = helpers.is_valid_plugin_spec(spec)
        assert.is_true(is_valid, err)
      end)
    end
  end)

  describe("init.lua orchestrator", function()
    local init_path

    before_each(function()
      init_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/init.lua"
    end)

    it("should load without errors", function()
      assert.has_no.errors(function()
        dofile(init_path)
      end)
    end)

    it("should return a table with imports", function()
      local spec = dofile(init_path)
      assert.is_table(spec)
      assert.is_true(#spec > 0, "UI init should have imports")
    end)

    it("should import all UI submodules", function()
      local spec = dofile(init_path)
      local expected_imports = {
        "plugins.ui.theme",
        "plugins.ui.statusline",
        "plugins.ui.feedback",
        "plugins.ui.noice",
        "plugins.ui.diagnostics",
        "plugins.ui.session",
      }

      for _, expected in ipairs(expected_imports) do
        local found = false
        for _, item in ipairs(spec) do
          if item.import == expected then
            found = true
            break
          end
        end
        assert.is_true(found, "Missing import for " .. expected)
      end
    end)
  end)

  describe("theme.lua", function()
    local theme_path

    before_each(function()
      theme_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/theme.lua"
    end)

    it("should include tokyonight colorscheme", function()
      local spec = dofile(theme_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "folke/tokyonight.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "tokyonight should be in theme.lua")
    end)

    it("should include nvim-web-devicons", function()
      local spec = dofile(theme_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "nvim-tree/nvim-web-devicons" then
          found = true
          break
        end
      end
      assert.is_true(found, "nvim-web-devicons should be in theme.lua")
    end)

    it("should include mini.icons", function()
      local spec = dofile(theme_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "echasnovski/mini.icons" then
          found = true
          break
        end
      end
      assert.is_true(found, "mini.icons should be in theme.lua")
    end)
  end)

  describe("statusline.lua", function()
    local statusline_path

    before_each(function()
      statusline_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/statusline.lua"
    end)

    it("should include lualine", function()
      local spec = dofile(statusline_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "nvim-lualine/lualine.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "lualine should be in statusline.lua")
    end)

    it("should include bufferline", function()
      local spec = dofile(statusline_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "akinsho/bufferline.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "bufferline should be in statusline.lua")
    end)

    it("should include mini.bufremove", function()
      local spec = dofile(statusline_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "echasnovski/mini.bufremove" then
          found = true
          break
        end
      end
      assert.is_true(found, "mini.bufremove should be in statusline.lua")
    end)
  end)

  describe("feedback.lua", function()
    local feedback_path

    before_each(function()
      feedback_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/feedback.lua"
    end)

    it("should include nvim-notify", function()
      local spec = dofile(feedback_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "rcarriga/nvim-notify" then
          found = true
          break
        end
      end
      assert.is_true(found, "nvim-notify should be in feedback.lua")
    end)

    it("should include which-key", function()
      local spec = dofile(feedback_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "folke/which-key.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "which-key should be in feedback.lua")
    end)

    it("should include dressing.nvim", function()
      local spec = dofile(feedback_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "stevearc/dressing.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "dressing.nvim should be in feedback.lua")
    end)
  end)

  describe("noice.lua", function()
    local noice_path

    before_each(function()
      noice_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/noice.lua"
    end)

    it("should include noice.nvim", function()
      local spec = dofile(noice_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "folke/noice.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "noice.nvim should be in noice.lua")
    end)
  end)

  describe("diagnostics.lua", function()
    local diagnostics_path

    before_each(function()
      diagnostics_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/diagnostics.lua"
    end)

    it("should include indent-blankline", function()
      local spec = dofile(diagnostics_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "lukas-reineke/indent-blankline.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "indent-blankline should be in diagnostics.lua")
    end)

    it("should include trouble.nvim", function()
      local spec = dofile(diagnostics_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "folke/trouble.nvim" then
          found = true
          break
        end
      end
      assert.is_true(found, "trouble.nvim should be in diagnostics.lua")
    end)
  end)

  describe("session.lua", function()
    local session_path

    before_each(function()
      session_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/session.lua"
    end)

    it("should include auto-session", function()
      local spec = dofile(session_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "rmagatti/auto-session" then
          found = true
          break
        end
      end
      assert.is_true(found, "auto-session should be in session.lua")
    end)

    it("should include vim-startuptime", function()
      local spec = dofile(session_path)
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == "dstein64/vim-startuptime" then
          found = true
          break
        end
      end
      assert.is_true(found, "vim-startuptime should be in session.lua")
    end)
  end)
end)
