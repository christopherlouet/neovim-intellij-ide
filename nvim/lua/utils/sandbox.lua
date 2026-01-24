-- Sandbox environment for executing untrusted Lua code
-- Provides a restricted environment that limits access to dangerous APIs
local M = {}

-- Safe subset of the standard library
local SAFE_GLOBALS = {
  -- Basic types and functions
  "assert",
  "error",
  "ipairs",
  "pairs",
  "next",
  "pcall",
  "xpcall",
  "select",
  "tonumber",
  "tostring",
  "type",
  "unpack",
  -- Safe modules
  "string",
  "table",
  "math",
  -- Neovim read-only APIs
  "vim",
}

-- Restricted vim APIs (read-only or safe operations)
local SAFE_VIM_APIS = {
  -- Options (read/write)
  "opt",
  "opt_local",
  "opt_global",
  "o",
  "bo",
  "wo",
  "go",
  -- Global variables
  "g",
  "b",
  "w",
  "t",
  -- Read-only
  "fn",
  "api",
  "version",
  "loop",
  "uv",
  -- Safe utilities
  "notify",
  "schedule",
  "defer_fn",
  "tbl_extend",
  "tbl_deep_extend",
  "deepcopy",
  "inspect",
  "split",
  "trim",
  "startswith",
  "endswith",
}

-- APIs explicitly blocked
local BLOCKED_VIM_APIS = {
  "cmd", -- Can execute arbitrary commands
  "system", -- Shell execution
  "env", -- Environment modification
}

--- Create a sandboxed vim table with restricted access
---@return table Sandboxed vim table
local function create_safe_vim()
  local safe_vim = {}

  for _, api in ipairs(SAFE_VIM_APIS) do
    if vim[api] ~= nil then
      safe_vim[api] = vim[api]
    end
  end

  -- Add keymap.set (commonly used in project configs)
  safe_vim.keymap = {
    set = vim.keymap.set,
    del = vim.keymap.del,
  }

  -- Add lsp buffer-local settings (read-only access to lsp state)
  safe_vim.lsp = {
    buf = vim.lsp.buf,
    get_clients = vim.lsp.get_clients,
  }

  -- Add diagnostic (read-only)
  safe_vim.diagnostic = vim.diagnostic

  -- Create a metatable that blocks access to dangerous APIs
  setmetatable(safe_vim, {
    __index = function(_, key)
      for _, blocked in ipairs(BLOCKED_VIM_APIS) do
        if key == blocked then
          error(string.format("Access to vim.%s is not allowed in project configs", key), 2)
        end
      end
      return nil
    end,
  })

  return safe_vim
end

--- Create a sandbox environment for executing code
---@return table Environment table for setfenv/load
function M.create_env()
  local env = {}

  -- Add safe globals
  for _, name in ipairs(SAFE_GLOBALS) do
    if name == "vim" then
      env.vim = create_safe_vim()
    elseif _G[name] ~= nil then
      env[name] = _G[name]
    end
  end

  -- Add print for debugging
  env.print = print

  -- Add require with restrictions
  env.require = function(modname)
    -- Allow requiring specific safe modules
    local allowed_prefixes = {
      "config.", -- Allow project to read config
      "utils.", -- Allow utils
    }

    for _, prefix in ipairs(allowed_prefixes) do
      if vim.startswith(modname, prefix) then
        return require(modname)
      end
    end

    error(string.format("require('%s') is not allowed in project configs", modname), 2)
  end

  return env
end

--- Execute Lua code in a sandboxed environment
---@param code string The Lua code to execute
---@param source string Optional source name for error messages
---@return boolean success
---@return string|nil error_message
function M.execute(code, source)
  source = source or "sandbox"

  local env = M.create_env()
  local chunk, load_err = load(code, source, "t", env)

  if not chunk then
    return false, "Failed to load code: " .. tostring(load_err)
  end

  local ok, exec_err = pcall(chunk)
  if not ok then
    return false, "Execution error: " .. tostring(exec_err)
  end

  return true, nil
end

--- Execute a Lua file in a sandboxed environment
---@param filepath string Path to the Lua file
---@return boolean success
---@return string|nil error_message
function M.dofile(filepath)
  local content = vim.fn.readfile(filepath)
  if #content == 0 then
    return false, "File is empty or could not be read"
  end

  local code = table.concat(content, "\n")
  return M.execute(code, "@" .. filepath)
end

return M
