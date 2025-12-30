local M = {}

local function ok(msg)
  vim.api.nvim_echo({ { "[OK] " .. msg, "DiagnosticOk" } }, false, {})
end

local function warn(msg)
  vim.api.nvim_echo({ { "[WARN] " .. msg, "DiagnosticWarn" } }, false, {})
end

local function err(msg)
  vim.api.nvim_echo({ { "[ERROR] " .. msg, "DiagnosticError" } }, false, {})
end

local function has(bin)
  return vim.fn.executable(bin) == 1
end

local function version_ge(major, minor)
  -- nvim 0.11+ exposes vim.version()
  local v = vim.version and vim.version() or { major = 0, minor = 0, patch = 0 }
  if v.major > major then return true end
  if v.major < major then return false end
  return (v.minor or 0) >= minor
end

function M.run()
  vim.api.nvim_echo({ { "Neovim IntelliJ IDE — IdeDoctor\n", "Title" } }, false, {})

  -- Neovim version
  if version_ge(0, 11) then
    ok("Neovim version >= 0.11")
  else
    err("Neovim version is below 0.11 (required)")
  end

  -- Core CLI tools
  local required = { "git", "rg", "fd" }
  for _, b in ipairs(required) do
    if has(b) then ok("Found: " .. b) else warn("Missing: " .. b .. " (recommended)") end
  end

  local optional = { "node", "npm", "pnpm", "python3" }
  for _, b in ipairs(optional) do
    if has(b) then ok("Found: " .. b) else warn("Missing: " .. b .. " (optional / language-specific)") end
  end

  -- Mason
  local mason_ok = pcall(require, "mason")
  if mason_ok then
    ok("mason.nvim loaded")
  else
    warn("mason.nvim not loaded (LSP installs may not work)")
  end

  -- none-ls
  local none_ls_ok, _ = pcall(require, "null-ls")
  if none_ls_ok then
    ok("none-ls loaded")
  else
    warn("none-ls not loaded (format/lint sources may be disabled)")
  end

  -- eslint_d
  if has("eslint_d") then
    ok("eslint_d available")
  else
    warn("eslint_d not found (JS/TS diagnostics may fallback to eslint)")
  end

  vim.api.nvim_echo({ { "\nDone.", "Normal" } }, false, {})
end

function M.setup()
  vim.api.nvim_create_user_command("IdeDoctor", function() M.run() end, {
    desc = "Check common dependencies and configuration health",
  })
end

M.setup()

return M
