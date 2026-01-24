-- UI plugins orchestrator
-- This file imports all UI-related plugin modules
return {
  { import = "plugins.ui.theme" },
  { import = "plugins.ui.statusline" },
  { import = "plugins.ui.feedback" },
  { import = "plugins.ui.noice" },
  { import = "plugins.ui.diagnostics" },
  { import = "plugins.ui.session" },
}
