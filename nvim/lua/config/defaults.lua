-- Global defaults and constants for Neovim IntelliJ IDE
local M = {}

-- LSP configuration
M.lsp = {
  format_timeout_ms = 2000,
}

-- UI dimensions (as ratios of screen size)
M.ui = {
  max_dimension_ratio = 0.75,
  notify_timeout = 3000,
}

-- Security limits
M.security = {
  max_body_size = 1024 * 1024, -- 1MB
}

-- Session settings
M.session = {
  suppressed_dirs = { "~/", "~/Downloads", "/" },
}

return M
