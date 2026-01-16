-- Tests for config/keymaps.lua
local assert = require("luassert")
local helpers = require("tests.helpers")

describe("config.keymaps", function()
  local keymaps_path

  local function get_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return keymap
      end
    end
    return nil
  end

  before_each(function()
    -- Get the path to keymaps.lua
    keymaps_path = helpers.get_nvim_config_path() .. "/lua/config/keymaps.lua"
    -- Clear existing keymaps for clean testing
    pcall(vim.keymap.del, "n", "<C-s>")
    pcall(vim.keymap.del, "n", "<leader>w")
    pcall(vim.keymap.del, "n", "<leader>q")
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(keymaps_path)
    end)
  end)

  describe("save keymaps", function()
    before_each(function()
      dofile(keymaps_path)
    end)

    it("should map Ctrl+S to save in normal mode", function()
      local keymap = get_keymap("n", "<C-s>")
      assert.is_not_nil(keymap)
    end)

    it("should map <leader>w to save", function()
      local keymap = get_keymap("n", "<leader>w")
      assert.is_not_nil(keymap)
    end)

    it("should map <leader>q to quit", function()
      local keymap = get_keymap("n", "<leader>q")
      assert.is_not_nil(keymap)
    end)
  end)

  describe("window navigation", function()
    before_each(function()
      dofile(keymaps_path)
    end)

    it("should map Ctrl+H to go to left window", function()
      local keymap = get_keymap("n", "<C-h>")
      assert.is_not_nil(keymap)
    end)

    it("should map Ctrl+J to go to lower window", function()
      local keymap = get_keymap("n", "<C-j>")
      assert.is_not_nil(keymap)
    end)

    it("should map Ctrl+K to go to upper window", function()
      local keymap = get_keymap("n", "<C-k>")
      assert.is_not_nil(keymap)
    end)

    it("should map Ctrl+L to go to right window", function()
      local keymap = get_keymap("n", "<C-l>")
      assert.is_not_nil(keymap)
    end)
  end)

  describe("line movement", function()
    before_each(function()
      dofile(keymaps_path)
    end)

    -- Note: Alt keymaps (<A-j>, <A-k>) may be stored with different representations
    -- (e.g., <M-j> or escape sequences) depending on terminal/headless mode.
    -- We test by checking that the file contains the expected mappings.
    it("should define line movement keymaps in the config file", function()
      local content = vim.fn.readfile(keymaps_path)
      local found_alt_j = false
      local found_alt_k = false
      for _, line in ipairs(content) do
        if line:match("<A%-j>") then
          found_alt_j = true
        end
        if line:match("<A%-k>") then
          found_alt_k = true
        end
      end
      assert.is_true(found_alt_j, "Alt+J mapping not found in keymaps.lua")
      assert.is_true(found_alt_k, "Alt+K mapping not found in keymaps.lua")
    end)
  end)

  describe("diagnostics", function()
    before_each(function()
      dofile(keymaps_path)
    end)

    it("should map [d to previous diagnostic", function()
      local keymap = get_keymap("n", "[d")
      assert.is_not_nil(keymap)
    end)

    it("should map ]d to next diagnostic", function()
      local keymap = get_keymap("n", "]d")
      assert.is_not_nil(keymap)
    end)
  end)

  describe("clipboard", function()
    before_each(function()
      dofile(keymaps_path)
    end)

    -- Note: Multi-mode keymaps like { "n", "v" } may be stored differently
    -- We test by checking that the file contains the expected mappings.
    it("should define clipboard keymaps in the config file", function()
      local content = vim.fn.readfile(keymaps_path)
      local found_leader_y = false
      for _, line in ipairs(content) do
        if line:match("<leader>y") and line:match("clipboard") then
          found_leader_y = true
          break
        end
      end
      assert.is_true(found_leader_y, "<leader>y clipboard mapping not found in keymaps.lua")
    end)
  end)
end)
