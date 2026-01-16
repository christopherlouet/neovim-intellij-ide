-- Tests for config/keymaps.lua
local assert = require("luassert")

describe("config.keymaps", function()
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
    -- Clear existing keymaps for clean testing
    pcall(vim.keymap.del, "n", "<C-s>")
    pcall(vim.keymap.del, "n", "<leader>w")
    pcall(vim.keymap.del, "n", "<leader>q")
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
    end)
  end)

  describe("save keymaps", function()
    before_each(function()
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
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
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
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
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
    end)

    it("should map Alt+J to move line down", function()
      local keymap = get_keymap("n", "<A-j>")
      assert.is_not_nil(keymap)
    end)

    it("should map Alt+K to move line up", function()
      local keymap = get_keymap("n", "<A-k>")
      assert.is_not_nil(keymap)
    end)
  end)

  describe("diagnostics", function()
    before_each(function()
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
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
      dofile(vim.fn.fnamemodify(vim.fn.expand("<sfile>:p:h"), ":h:h") .. "/nvim/lua/config/keymaps.lua")
    end)

    it("should map <leader>y to yank to system clipboard", function()
      local keymap = get_keymap("n", "<leader>y")
      assert.is_not_nil(keymap)
    end)
  end)
end)
