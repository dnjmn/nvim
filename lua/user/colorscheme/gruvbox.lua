local M = {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  name = "gruvbox",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
}

function M.config()
  require("gruvbox").setup {
    -- undercurl = true,
    -- underline = true,
    -- bold = true,
    -- italic = {
    --   strings = true,
    --   comments = true,
    --   operators = false,
    --   folds = true,
    -- },
    -- strikethrough = true,
    -- invert_selection = false,
    -- invert_signs = false,
    -- invert_tabline = false,
    -- invert_intend_guides = false,
    -- inverse = true, -- invert background for search, diffs, statuslines and errors
    -- contrast = "", -- can be "hard", "soft" or empty string
    -- palette_overrides = {},
    -- overrides = {},
    -- dim_inactive = false,
    -- transparent_mode = false,
  }
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
