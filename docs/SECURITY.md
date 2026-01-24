# Security Model

This document describes the security features implemented in Neovim IntelliJ IDE to protect against malicious code execution.

## Overview

The configuration implements a defense-in-depth approach with multiple layers:

1. **Trust System** - Only execute project-specific configs from explicitly trusted directories
2. **Sandboxed Execution** - Project configs run in a restricted environment with limited API access
3. **Security Logging** - All trust and load events are logged for audit purposes
4. **Bootstrap Verification** - Plugin manager installation is verified for integrity

## Trust System

### How It Works

Project-specific configuration files (`.nvim.lua`) are only loaded from directories that have been explicitly trusted by the user.

- Trust state is stored in `~/.local/share/nvim/trusted_projects.json`
- The trust database file has restricted permissions (0600)
- Users are prompted before trusting any new directory

### Commands

| Command | Description |
|---------|-------------|
| `:ProjectConfig status` | Show trust status for current directory |
| `:ProjectConfig trust` | Trust current directory |
| `:ProjectConfig untrust` | Remove trust from current directory |
| `:ProjectConfig list` | List all trusted directories |
| `:ProjectConfig reload` | Reload project config (if trusted) |
| `:ProjectConfig edit` | Open project config file for editing |

### Trust Workflow

1. When Neovim starts in a directory with `.nvim.lua`:
   - If trusted: Load the config automatically
   - If not trusted: Prompt user with options:
     - "Yes, trust this project" - Trust and load
     - "No, ignore" - Skip loading
     - "View file first" - Open file for review

2. Trust persists across sessions until explicitly revoked

## Sandboxed Execution

### Purpose

Even trusted project configs are executed in a sandboxed environment to limit potential damage from bugs or compromised code.

### Allowed APIs

The sandbox provides access to:

**Safe Globals:**

- `assert`, `error`, `pcall`, `xpcall`
- `ipairs`, `pairs`, `next`, `select`
- `tonumber`, `tostring`, `type`, `unpack`
- `string`, `table`, `math` modules
- `print` for debugging

**Safe Vim APIs:**

- `vim.opt`, `vim.opt_local`, `vim.opt_global` - Editor options
- `vim.o`, `vim.bo`, `vim.wo`, `vim.go` - Option shortcuts
- `vim.g`, `vim.b`, `vim.w`, `vim.t` - Variables
- `vim.fn` - Vimscript functions
- `vim.api` - Neovim API
- `vim.keymap.set`, `vim.keymap.del` - Keymaps
- `vim.lsp.buf`, `vim.lsp.get_clients` - LSP (read-only state)
- `vim.diagnostic` - Diagnostics
- `vim.notify`, `vim.schedule`, `vim.defer_fn` - Utilities

### Blocked APIs

The following are explicitly blocked:

- `vim.cmd` - Arbitrary command execution
- `vim.system` - Shell command execution
- `vim.env` - Environment variable modification
- `require()` - Limited to `config.*` and `utils.*` modules only

### Error Handling

If sandboxed code attempts to access blocked APIs:

1. An error is raised with a clear message
2. The error is logged to the security log
3. The project config is not loaded

## Security Logging

### Log Location

Security events are logged to: `~/.local/state/nvim/security.log`

### Logged Events

| Event Type | Description |
|------------|-------------|
| `TRUST` | Directory was trusted |
| `UNTRUST` | Directory trust was removed |
| `LOAD` | Project config was successfully loaded |
| `LOAD_FAIL` | Project config failed to load |
| `BLOCK` | Sandbox blocked API access attempt |

### Log Format

```
[YYYY-MM-DD HH:MM:SS] [EVENT_TYPE] Message key=value key2=value2
```

### Commands

| Command | Description |
|---------|-------------|
| `:SecurityLog` | Show recent security events (last 50) |
| `:SecurityLog show` | Same as above |
| `:SecurityLog clear` | Clear the security log |
| `:SecurityLog path` | Show log file location |

## Bootstrap Verification

### lazy.nvim Verification

The plugin manager (lazy.nvim) installation is verified to ensure:

1. **Repository Integrity** - Confirms it's a valid git repository
2. **Remote URL Verification** - Confirms the remote matches expected GitHub URL

If verification fails:

- For fresh installs: Installation is aborted and directory removed
- For existing installs: Warning is shown to the user

### Expected Remote

```
https://github.com/folke/lazy.nvim.git
```

## Best Practices

### For Users

1. **Review before trusting** - Always use "View file first" for new projects
2. **Keep trust list minimal** - Only trust directories you actively work in
3. **Review security logs** - Periodically check `:SecurityLog` for unexpected events
4. **Update regularly** - Keep the configuration updated for security fixes

### For Project Config Authors

1. **Minimize scope** - Only configure what's needed for the project
2. **Avoid external calls** - Don't rely on network or shell commands
3. **Document clearly** - Add comments explaining what the config does
4. **Test in sandbox** - Ensure code works within sandbox restrictions

## Example Project Config

A safe `.nvim.lua` file:

```lua
-- Project-specific settings for my-project
-- Sets indent to 4 spaces and enables specific LSP features

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- Project-specific keymaps
vim.keymap.set("n", "<leader>pt", function()
  vim.notify("Running project tests...")
end, { desc = "Run project tests", buffer = true })

-- Project variables
vim.g.my_project_name = "my-project"
```

## Reporting Security Issues

If you discover a security vulnerability:

1. **Do not** open a public issue
2. Contact the maintainers privately
3. Provide detailed reproduction steps
4. Allow time for a fix before public disclosure

## Changelog

### v2.2.0

- Added sandboxed execution for project configs
- Added security logging
- Added lazy.nvim bootstrap verification
- Improved trust database file permissions
