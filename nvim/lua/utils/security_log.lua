-- Security event logging
-- Logs security-relevant events to ~/.local/state/nvim/security.log
local M = {}

-- Get the log file path
local function get_log_path()
  local state_dir = vim.fn.stdpath("state")
  return state_dir .. "/security.log"
end

-- Ensure the state directory exists
local function ensure_state_dir()
  local state_dir = vim.fn.stdpath("state")
  if vim.fn.isdirectory(state_dir) == 0 then
    vim.fn.mkdir(state_dir, "p")
  end
end

-- Format a timestamp
local function timestamp()
  return os.date("%Y-%m-%d %H:%M:%S")
end

--- Log a security event
---@param event_type string The type of event (e.g., "TRUST", "LOAD", "BLOCK")
---@param message string The event message
---@param details table|nil Optional additional details
function M.log(event_type, message, details)
  ensure_state_dir()

  local log_path = get_log_path()
  local entry = string.format("[%s] [%s] %s", timestamp(), event_type, message)

  if details then
    for key, value in pairs(details) do
      entry = entry .. string.format(" %s=%s", key, tostring(value))
    end
  end

  -- Append to log file
  local file = io.open(log_path, "a")
  if file then
    file:write(entry .. "\n")
    file:close()
  end
end

--- Log a trust event (directory trusted or untrusted)
---@param dir string The directory path
---@param trusted boolean Whether the directory was trusted or untrusted
function M.log_trust(dir, trusted)
  local event = trusted and "TRUST" or "UNTRUST"
  M.log(event, "Directory trust changed", { dir = dir })
end

--- Log a config load event
---@param path string The config file path
---@param success boolean Whether the load succeeded
---@param error_msg string|nil Error message if load failed
function M.log_load(path, success, error_msg)
  if success then
    M.log("LOAD", "Project config loaded", { path = path })
  else
    M.log("LOAD_FAIL", "Project config failed to load", { path = path, error = error_msg })
  end
end

--- Log a sandbox block event (when code tries to access blocked API)
---@param api string The blocked API
---@param source string The source file/location
function M.log_block(api, source)
  M.log("BLOCK", "Sandbox blocked API access", { api = api, source = source })
end

--- Get recent log entries
---@param count number|nil Number of entries to return (default 20)
---@return table List of log entries
function M.get_recent(count)
  count = count or 20
  local log_path = get_log_path()

  if vim.fn.filereadable(log_path) == 0 then
    return {}
  end

  local lines = vim.fn.readfile(log_path)
  local start = math.max(1, #lines - count + 1)
  local result = {}

  for i = start, #lines do
    table.insert(result, lines[i])
  end

  return result
end

--- Clear the security log
function M.clear()
  local log_path = get_log_path()
  if vim.fn.filereadable(log_path) == 1 then
    vim.fn.delete(log_path)
  end
end

-- Create user command to view security log
vim.api.nvim_create_user_command("SecurityLog", function(opts)
  local subcmd = opts.args

  if subcmd == "" or subcmd == "show" then
    local entries = M.get_recent(50)
    if #entries == 0 then
      print("No security log entries")
    else
      print("Recent security events:")
      for _, entry in ipairs(entries) do
        print(entry)
      end
    end
  elseif subcmd == "clear" then
    M.clear()
    print("Security log cleared")
  elseif subcmd == "path" then
    print("Security log: " .. get_log_path())
  else
    print("Usage: :SecurityLog [show|clear|path]")
  end
end, {
  nargs = "?",
  complete = function()
    return { "show", "clear", "path" }
  end,
  desc = "View or manage security log",
})

return M
