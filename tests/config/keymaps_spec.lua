-- Tests for config/keymaps.lua
local assert = require("luassert")
local helpers = require("tests.helpers")

describe("config.keymaps", function()
  local keymaps_path
  local keymaps_content

  before_each(function()
    -- Get the path to keymaps.lua
    keymaps_path = helpers.get_nvim_config_path() .. "/lua/config/keymaps.lua"
    -- Read file content for pattern matching tests
    keymaps_content = table.concat(vim.fn.readfile(keymaps_path), "\n")
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(keymaps_path)
    end)
  end)

  -- Helper function to check if a keymap pattern exists in the file
  local function has_keymap(pattern)
    return keymaps_content:match(pattern) ~= nil
  end

  describe("save keymaps", function()
    it("should define Ctrl+S save keymap", function()
      assert.is_true(has_keymap("<C%-s>"), "Ctrl+S mapping not found")
    end)

    it("should define <leader>w save keymap", function()
      assert.is_true(has_keymap("<leader>w"), "<leader>w mapping not found")
    end)

    it("should define <leader>q quit keymap", function()
      assert.is_true(has_keymap("<leader>q"), "<leader>q mapping not found")
    end)
  end)

  describe("window navigation", function()
    it("should define Ctrl+H for left window", function()
      assert.is_true(has_keymap("<C%-h>"), "Ctrl+H mapping not found")
    end)

    it("should define Ctrl+J for lower window", function()
      assert.is_true(has_keymap("<C%-j>"), "Ctrl+J mapping not found")
    end)

    it("should define Ctrl+K for upper window", function()
      assert.is_true(has_keymap("<C%-k>"), "Ctrl+K mapping not found")
    end)

    it("should define Ctrl+L for right window", function()
      assert.is_true(has_keymap("<C%-l>"), "Ctrl+L mapping not found")
    end)
  end)

  describe("line movement", function()
    it("should define Alt+J to move line down", function()
      assert.is_true(has_keymap("<A%-j>"), "Alt+J mapping not found")
    end)

    it("should define Alt+K to move line up", function()
      assert.is_true(has_keymap("<A%-k>"), "Alt+K mapping not found")
    end)
  end)

  describe("diagnostics", function()
    it("should define [d for previous diagnostic", function()
      assert.is_true(has_keymap("%[d"), "[d mapping not found")
    end)

    it("should define ]d for next diagnostic", function()
      assert.is_true(has_keymap("%]d"), "]d mapping not found")
    end)
  end)

  describe("clipboard", function()
    it("should define <leader>y for system clipboard", function()
      assert.is_true(has_keymap("<leader>y"), "<leader>y mapping not found")
    end)
  end)

  describe("expected keymap categories", function()
    it("should have save/quit section", function()
      assert.is_true(has_keymap("Sauvegardes"), "Save section not found")
    end)

    it("should have window navigation section", function()
      assert.is_true(has_keymap("Navigation fen"), "Window navigation section not found")
    end)

    it("should have line movement section", function()
      assert.is_true(has_keymap("placer lignes"), "Line movement section not found")
    end)

    it("should have diagnostics section", function()
      assert.is_true(has_keymap("Diagnostics LSP"), "Diagnostics section not found")
    end)
  end)
end)
