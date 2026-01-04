-- Luacheck configuration for Neovim
std = "lua51+luajit"
cache = true
max_line_length = 120
codes = true

-- Global vim variable is read-only
globals = {
  "vim",
}

-- Ignore some common Neovim patterns
ignore = {
  "212", -- Unused argument (we often use _ for unused parameters)
}

-- Files and directories to exclude
exclude_files = {
  "nvim/lazy-lock.json",
  "nvim/.luarc.json",
}
