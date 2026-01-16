-- Tests for config/options.lua
local assert = require("luassert")
local helpers = require("tests.helpers")

describe("config.options", function()
  local options_path

  before_each(function()
    -- Get the path to options.lua
    options_path = helpers.get_nvim_config_path() .. "/lua/config/options.lua"
    -- Reset options to defaults before each test
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.termguicolors = false
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(options_path)
    end)
  end)

  it("should enable line numbers", function()
    dofile(options_path)
    assert.is_true(vim.opt.number:get())
  end)

  it("should enable relative line numbers", function()
    dofile(options_path)
    assert.is_true(vim.opt.relativenumber:get())
  end)

  it("should enable termguicolors", function()
    dofile(options_path)
    assert.is_true(vim.opt.termguicolors:get())
  end)

  it("should set correct indentation (2 spaces)", function()
    dofile(options_path)
    assert.equals(2, vim.opt.tabstop:get())
    assert.equals(2, vim.opt.shiftwidth:get())
    assert.is_true(vim.opt.expandtab:get())
  end)

  it("should enable undo file", function()
    dofile(options_path)
    assert.is_true(vim.opt.undofile:get())
  end)

  it("should set clipboard to unnamedplus", function()
    dofile(options_path)
    local clipboard = vim.opt.clipboard:get()
    assert.is_true(vim.tbl_contains(clipboard, "unnamedplus"))
  end)

  it("should set scrolloff to 8", function()
    dofile(options_path)
    assert.equals(8, vim.opt.scrolloff:get())
  end)

  it("should enable smart case search", function()
    dofile(options_path)
    assert.is_true(vim.opt.ignorecase:get())
    assert.is_true(vim.opt.smartcase:get())
  end)
end)
