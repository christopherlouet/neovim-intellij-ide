-- Tests for utils module
local assert = require("luassert")
local helpers = require("tests.helpers")

describe("utils", function()
  local utils_path

  before_each(function()
    utils_path = helpers.get_nvim_config_path() .. "/lua/utils/init.lua"
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(utils_path)
    end)
  end)

  it("should return a table with has function", function()
    local utils = dofile(utils_path)
    assert.is_table(utils)
    assert.is_function(utils.has)
  end)

  describe("has()", function()
    it("should return true for existing commands", function()
      local utils = dofile(utils_path)
      -- 'ls' should exist on all Unix systems
      assert.is_true(utils.has("ls"))
    end)

    it("should return false for non-existing commands", function()
      local utils = dofile(utils_path)
      assert.is_false(utils.has("nonexistent_command_xyz_123"))
    end)

    it("should return true for nvim", function()
      local utils = dofile(utils_path)
      assert.is_true(utils.has("nvim"))
    end)
  end)
end)

describe("utils.env", function()
  local env_path

  before_each(function()
    env_path = helpers.get_nvim_config_path() .. "/lua/utils/env.lua"
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(env_path)
    end)
  end)

  it("should return a table", function()
    local env = dofile(env_path)
    assert.is_table(env)
  end)

  it("should have add_to_path function", function()
    local env = dofile(env_path)
    assert.is_function(env.add_to_path)
  end)

  it("should have setup_dev_paths function", function()
    local env = dofile(env_path)
    assert.is_function(env.setup_dev_paths)
  end)

  it("should have apply_lsp_compat function", function()
    local env = dofile(env_path)
    assert.is_function(env.apply_lsp_compat)
  end)

  describe("add_to_path()", function()
    it("should return false for non-existent directory", function()
      local env = dofile(env_path)
      assert.is_false(env.add_to_path("/nonexistent/path/xyz123"))
    end)
  end)

  describe("setup_dev_paths()", function()
    it("should not error when called", function()
      local env = dofile(env_path)
      assert.has_no.errors(function()
        env.setup_dev_paths()
      end)
    end)
  end)

  describe("apply_lsp_compat()", function()
    it("should not error when called", function()
      local env = dofile(env_path)
      assert.has_no.errors(function()
        env.apply_lsp_compat()
      end)
    end)
  end)
end)

describe("utils.sandbox", function()
  local sandbox_path

  before_each(function()
    sandbox_path = helpers.get_nvim_config_path() .. "/lua/utils/sandbox.lua"
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(sandbox_path)
    end)
  end)

  it("should return a table", function()
    local sandbox = dofile(sandbox_path)
    assert.is_table(sandbox)
  end)

  it("should have create_env function", function()
    local sandbox = dofile(sandbox_path)
    assert.is_function(sandbox.create_env)
  end)

  it("should have execute function", function()
    local sandbox = dofile(sandbox_path)
    assert.is_function(sandbox.execute)
  end)

  it("should have dofile function", function()
    local sandbox = dofile(sandbox_path)
    assert.is_function(sandbox.dofile)
  end)

  describe("create_env()", function()
    it("should return a table", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env)
    end)

    it("should include safe globals", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_function(env.pairs)
      assert.is_function(env.ipairs)
      assert.is_function(env.tostring)
      assert.is_function(env.tonumber)
      assert.is_function(env.type)
    end)

    it("should include string module", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env.string)
      assert.is_function(env.string.format)
    end)

    it("should include table module", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env.table)
      assert.is_function(env.table.insert)
    end)

    it("should include math module", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env.math)
      assert.is_function(env.math.floor)
    end)

    it("should include sandboxed vim", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env.vim)
    end)

    it("should include vim.keymap.set", function()
      local sandbox = dofile(sandbox_path)
      local env = sandbox.create_env()
      assert.is_table(env.vim.keymap)
      assert.is_function(env.vim.keymap.set)
    end)
  end)

  describe("execute()", function()
    it("should execute valid Lua code", function()
      local sandbox = dofile(sandbox_path)
      local ok, err = sandbox.execute("local x = 1 + 1")
      assert.is_true(ok)
      assert.is_nil(err)
    end)

    it("should return error for syntax errors", function()
      local sandbox = dofile(sandbox_path)
      local ok, err = sandbox.execute("local x = ")
      assert.is_false(ok)
      assert.is_string(err)
    end)

    it("should allow access to vim.g", function()
      local sandbox = dofile(sandbox_path)
      local ok, err = sandbox.execute("vim.g.test_sandbox_var = 'test'")
      assert.is_true(ok)
      assert.is_nil(err)
      assert.equals("test", vim.g.test_sandbox_var)
      -- Cleanup
      vim.g.test_sandbox_var = nil
    end)
  end)
end)

describe("utils.security_log", function()
  local security_log_path

  before_each(function()
    security_log_path = helpers.get_nvim_config_path() .. "/lua/utils/security_log.lua"
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(security_log_path)
    end)
  end)

  it("should return a table", function()
    local security_log = dofile(security_log_path)
    assert.is_table(security_log)
  end)

  it("should have log function", function()
    local security_log = dofile(security_log_path)
    assert.is_function(security_log.log)
  end)

  it("should have log_trust function", function()
    local security_log = dofile(security_log_path)
    assert.is_function(security_log.log_trust)
  end)

  it("should have log_load function", function()
    local security_log = dofile(security_log_path)
    assert.is_function(security_log.log_load)
  end)

  it("should have get_recent function", function()
    local security_log = dofile(security_log_path)
    assert.is_function(security_log.get_recent)
  end)

  it("should have clear function", function()
    local security_log = dofile(security_log_path)
    assert.is_function(security_log.clear)
  end)

  describe("log()", function()
    it("should not error when logging", function()
      local security_log = dofile(security_log_path)
      assert.has_no.errors(function()
        security_log.log("TEST", "Test message", { key = "value" })
      end)
    end)
  end)

  describe("get_recent()", function()
    it("should return a table", function()
      local security_log = dofile(security_log_path)
      local entries = security_log.get_recent()
      assert.is_table(entries)
    end)
  end)
end)

describe("config.defaults", function()
  local defaults_path

  before_each(function()
    defaults_path = helpers.get_nvim_config_path() .. "/lua/config/defaults.lua"
  end)

  it("should load without errors", function()
    assert.has_no.errors(function()
      dofile(defaults_path)
    end)
  end)

  it("should return a table", function()
    local defaults = dofile(defaults_path)
    assert.is_table(defaults)
  end)

  it("should have lsp configuration", function()
    local defaults = dofile(defaults_path)
    assert.is_table(defaults.lsp)
    assert.is_number(defaults.lsp.format_timeout_ms)
  end)

  it("should have ui configuration", function()
    local defaults = dofile(defaults_path)
    assert.is_table(defaults.ui)
    assert.is_number(defaults.ui.max_dimension_ratio)
    assert.is_number(defaults.ui.notify_timeout)
  end)

  it("should have security configuration", function()
    local defaults = dofile(defaults_path)
    assert.is_table(defaults.security)
    assert.is_number(defaults.security.max_body_size)
  end)

  it("should have reasonable default values", function()
    local defaults = dofile(defaults_path)
    assert.is_true(defaults.lsp.format_timeout_ms > 0)
    assert.is_true(defaults.ui.max_dimension_ratio > 0)
    assert.is_true(defaults.ui.max_dimension_ratio <= 1)
    assert.is_true(defaults.security.max_body_size > 0)
  end)
end)
