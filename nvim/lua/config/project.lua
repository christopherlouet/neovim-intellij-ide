-- Project-specific configuration loader
-- Safely loads .nvim.lua from the project root
--
-- Security model:
-- - Only loads from directories explicitly trusted by the user
-- - Trust is stored in stdpath("data")/trusted_projects.json
-- - User can trust/untrust via :ProjectConfig commands

local M = {}

-- Project config file name
M.config_file = ".nvim.lua"

-- Get trust database path
local function get_trust_db_path()
  return vim.fn.stdpath("data") .. "/trusted_projects.json"
end

-- Load trusted projects from database
local function load_trusted_projects()
  local path = get_trust_db_path()
  if vim.fn.filereadable(path) == 0 then
    return {}
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {}
  end

  local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
  if ok and type(data) == "table" then
    return data
  end
  return {}
end

-- Save trusted projects to database
local function save_trusted_projects(projects)
  local path = get_trust_db_path()
  local ok, json = pcall(vim.json.encode, projects)
  if ok then
    vim.fn.writefile({ json }, path)
  end
end

-- Check if a directory is trusted
function M.is_trusted(dir)
  local projects = load_trusted_projects()
  return projects[dir] == true
end

-- Trust a directory
function M.trust(dir)
  local projects = load_trusted_projects()
  projects[dir] = true
  save_trusted_projects(projects)
  vim.notify("Trusted: " .. dir, vim.log.levels.INFO)
end

-- Untrust a directory
function M.untrust(dir)
  local projects = load_trusted_projects()
  projects[dir] = nil
  save_trusted_projects(projects)
  vim.notify("Untrusted: " .. dir, vim.log.levels.INFO)
end

-- List all trusted directories
function M.list_trusted()
  local projects = load_trusted_projects()
  local list = {}
  for dir, _ in pairs(projects) do
    table.insert(list, dir)
  end
  table.sort(list)
  return list
end

-- Get project config path for a directory
local function get_config_path(dir)
  return dir .. "/" .. M.config_file
end

-- Load project config if trusted
function M.load(dir)
  dir = dir or vim.fn.getcwd()
  local config_path = get_config_path(dir)

  -- Check if config file exists
  if vim.fn.filereadable(config_path) == 0 then
    return false
  end

  -- Check if directory is trusted
  if not M.is_trusted(dir) then
    -- Prompt user to trust
    vim.schedule(function()
      local msg = string.format("Project config found: %s\nDo you want to trust this directory?", config_path)
      vim.ui.select({ "Yes, trust this project", "No, ignore", "View file first" }, {
        prompt = msg,
      }, function(choice)
        if choice == "Yes, trust this project" then
          M.trust(dir)
          M.load(dir)
        elseif choice == "View file first" then
          vim.cmd("edit " .. vim.fn.fnameescape(config_path))
        end
      end)
    end)
    return false
  end

  -- Load the config
  local ok, err = pcall(dofile, config_path)
  if not ok then
    vim.notify("Error loading project config: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  if vim.g.nvim_project_verbose then
    vim.notify("Loaded project config: " .. config_path, vim.log.levels.INFO)
  end

  return true
end

-- Setup autocommand to load project config on directory change
function M.setup()
  local augroup = vim.api.nvim_create_augroup("ProjectConfig", { clear = true })

  -- Load on startup
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      M.load()
    end,
    desc = "Load project config on startup",
  })

  -- Load when changing directory
  vim.api.nvim_create_autocmd("DirChanged", {
    group = augroup,
    callback = function()
      M.load()
    end,
    desc = "Load project config on directory change",
  })
end

-- Create user commands
vim.api.nvim_create_user_command("ProjectConfig", function(opts)
  local cmd = opts.args

  if cmd == "" or cmd == "status" then
    local cwd = vim.fn.getcwd()
    local config_path = get_config_path(cwd)
    local exists = vim.fn.filereadable(config_path) == 1
    local trusted = M.is_trusted(cwd)

    print("Current directory: " .. cwd)
    print("Config file: " .. (exists and "found" or "not found"))
    print("Trust status: " .. (trusted and "trusted" or "not trusted"))
  elseif cmd == "trust" then
    M.trust(vim.fn.getcwd())
    M.load()
  elseif cmd == "untrust" then
    M.untrust(vim.fn.getcwd())
  elseif cmd == "reload" then
    if M.is_trusted(vim.fn.getcwd()) then
      M.load()
    else
      print("Directory not trusted. Use :ProjectConfig trust first.")
    end
  elseif cmd == "list" then
    local trusted = M.list_trusted()
    if #trusted == 0 then
      print("No trusted directories")
    else
      print("Trusted directories:")
      for _, dir in ipairs(trusted) do
        print("  " .. dir)
      end
    end
  elseif cmd == "edit" then
    local config_path = get_config_path(vim.fn.getcwd())
    vim.cmd("edit " .. vim.fn.fnameescape(config_path))
  else
    print("Usage: :ProjectConfig [status|trust|untrust|reload|list|edit]")
  end
end, {
  nargs = "?",
  complete = function()
    return { "status", "trust", "untrust", "reload", "list", "edit" }
  end,
  desc = "Manage project-specific configuration",
})

return M
