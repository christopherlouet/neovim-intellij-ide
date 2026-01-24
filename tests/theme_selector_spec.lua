-- Tests for theme selector module
-- TDD: These tests should FAIL initially (RED phase)
local assert = require("luassert")
local helpers = require("tests.helpers")

-- Set up package path
local nvim_lua_path = helpers.get_nvim_config_path() .. "/lua/?.lua"
local nvim_lua_init_path = helpers.get_nvim_config_path() .. "/lua/?/init.lua"
if not package.path:find(nvim_lua_path, 1, true) then
  package.path = package.path .. ";" .. nvim_lua_path .. ";" .. nvim_lua_init_path
end

describe("theme_selector", function()
  local theme_selector

  before_each(function()
    -- Clear cached module
    package.loaded["utils.theme_selector"] = nil
    theme_selector = require("utils.theme_selector")
  end)

  describe("module structure", function()
    it("should return a table", function()
      assert.is_table(theme_selector)
    end)

    it("should have get_themes function", function()
      assert.is_function(theme_selector.get_themes)
    end)

    it("should have select_theme function", function()
      assert.is_function(theme_selector.select_theme)
    end)

    it("should have apply_theme function", function()
      assert.is_function(theme_selector.apply_theme)
    end)

    it("should have get_current_theme function", function()
      assert.is_function(theme_selector.get_current_theme)
    end)

    it("should have load_saved_theme function", function()
      assert.is_function(theme_selector.load_saved_theme)
    end)

    it("should have save_theme function", function()
      assert.is_function(theme_selector.save_theme)
    end)
  end)

  describe("get_themes", function()
    it("should return a table of themes", function()
      local themes = theme_selector.get_themes()
      assert.is_table(themes)
    end)

    it("should include cyberpunk theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "cyberpunk" then
          found = true
          break
        end
      end
      assert.is_true(found, "cyberpunk theme should be available")
    end)

    it("should include matrix theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "matrix" then
          found = true
          break
        end
      end
      assert.is_true(found, "matrix theme should be available")
    end)

    it("should include dracula theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "dracula" then
          found = true
          break
        end
      end
      assert.is_true(found, "dracula theme should be available")
    end)

    it("should include catppuccin theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "catppuccin" then
          found = true
          break
        end
      end
      assert.is_true(found, "catppuccin theme should be available")
    end)

    it("should include nord theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "nord" then
          found = true
          break
        end
      end
      assert.is_true(found, "nord theme should be available")
    end)

    it("should include gruvbox theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "gruvbox" then
          found = true
          break
        end
      end
      assert.is_true(found, "gruvbox theme should be available")
    end)

    it("should include tokyo-night theme", function()
      local themes = theme_selector.get_themes()
      local found = false
      for _, theme in ipairs(themes) do
        if theme.name == "tokyo-night" then
          found = true
          break
        end
      end
      assert.is_true(found, "tokyo-night theme should be available")
    end)

    it("should have exactly 7 themes", function()
      local themes = theme_selector.get_themes()
      assert.equals(7, #themes)
    end)

    it("each theme should have name and colorscheme", function()
      local themes = theme_selector.get_themes()
      for _, theme in ipairs(themes) do
        assert.is_string(theme.name, "theme should have name")
        assert.is_string(theme.colorscheme, "theme should have colorscheme")
      end
    end)

    it("each theme should have a plugin reference", function()
      local themes = theme_selector.get_themes()
      for _, theme in ipairs(themes) do
        assert.is_string(theme.plugin, "theme should have plugin reference")
      end
    end)
  end)

  describe("get_theme_names", function()
    it("should return theme names for vim.ui.select", function()
      local names = theme_selector.get_theme_names()
      assert.is_table(names)
      assert.equals(7, #names)
    end)

    it("should return formatted display names", function()
      local names = theme_selector.get_theme_names()
      -- Each name should be a string suitable for display
      for _, name in ipairs(names) do
        assert.is_string(name)
        assert.is_true(#name > 0, "name should not be empty")
      end
    end)
  end)

  describe("get_theme_by_name", function()
    it("should return theme config for valid name", function()
      local theme = theme_selector.get_theme_by_name("dracula")
      assert.is_table(theme)
      assert.equals("dracula", theme.name)
    end)

    it("should return nil for invalid name", function()
      local theme = theme_selector.get_theme_by_name("nonexistent")
      assert.is_nil(theme)
    end)
  end)

  describe("get_storage_path", function()
    it("should return a path in data directory", function()
      local path = theme_selector.get_storage_path()
      assert.is_string(path)
      assert.is_true(path:find("theme_choice") ~= nil, "should contain theme_choice in path")
    end)
  end)

  describe("save_theme and load_saved_theme", function()
    local test_path

    before_each(function()
      -- Use a test-specific path
      test_path = vim.fn.tempname() .. "_theme_test.json"
      theme_selector._set_storage_path(test_path)
    end)

    after_each(function()
      -- Clean up test file
      vim.fn.delete(test_path)
    end)

    it("should save theme choice to file", function()
      local result = theme_selector.save_theme("dracula")
      assert.is_true(result)
      assert.equals(1, vim.fn.filereadable(test_path))
    end)

    it("should load saved theme choice", function()
      theme_selector.save_theme("catppuccin")
      local loaded = theme_selector.load_saved_theme()
      assert.equals("catppuccin", loaded)
    end)

    it("should return nil when no saved theme", function()
      local loaded = theme_selector.load_saved_theme()
      assert.is_nil(loaded)
    end)

    it("should return nil for invalid saved file", function()
      vim.fn.writefile({ "invalid json" }, test_path)
      local loaded = theme_selector.load_saved_theme()
      assert.is_nil(loaded)
    end)
  end)

  describe("get_current_theme", function()
    it("should return current colorscheme name", function()
      local current = theme_selector.get_current_theme()
      assert.is_string(current)
    end)
  end)
end)

describe("plugins.ui.theme with selector", function()
  local theme_path

  before_each(function()
    theme_path = helpers.get_nvim_config_path() .. "/lua/plugins/ui/theme.lua"
  end)

  it("should include all theme colorscheme plugins", function()
    local spec = dofile(theme_path)
    local required_plugins = {
      "folke/tokyonight.nvim",
      "Mofiqul/dracula.nvim",
      "catppuccin/nvim",
      "shaunsingh/nord.nvim",
      "ellisonleao/gruvbox.nvim",
    }

    for _, plugin_name in ipairs(required_plugins) do
      local found = false
      for _, plugin in ipairs(spec) do
        if plugin[1] == plugin_name then
          found = true
          break
        end
      end
      assert.is_true(found, plugin_name .. " should be in theme.lua")
    end
  end)

  it("should have theme selector keymap defined in keys", function()
    local spec = dofile(theme_path)
    local found_keymap = false

    for _, plugin in ipairs(spec) do
      if plugin.keys then
        for _, key in ipairs(plugin.keys) do
          if type(key) == "table" and key[1] == "<leader>ut" then
            found_keymap = true
            break
          end
        end
      end
      if found_keymap then
        break
      end
    end

    assert.is_true(found_keymap, "should have <leader>ut keymap for theme selector")
  end)
end)
