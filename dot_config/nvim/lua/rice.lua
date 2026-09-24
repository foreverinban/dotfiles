-- rice.lua — связка Neovim с единой палитрой системы.
--  * rice.palette(): цвета из ~/.cache/rice/colors.lua (генерирует rice-render)
--  * :PywalRestore — перечитать pywal + палитру без перезапуска
--    (rice-apply вызывает её во всех запущенных nvim через --server)
--  * событие User RicePalette — плагины (lualine, ibl, nvim-tree) перекрашиваются
local M = {}

local fallback = {
  accent = "#7f95ad", accent_dim = "#4a5563", bg = "#15181d", bg_alt = "#1d2127",
  bg_alt2 = "#262b33", fg = "#c5c9d0", fg_dim = "#868b93", muted = "#5a606a",
  ok = "#8fa88a", warn = "#b8a27a", urgent = "#c26a6a",
  color1 = "#c26a6a", color2 = "#8fa88a", color3 = "#b8a27a",
  color4 = "#7f95ad", color5 = "#9a8db0", color6 = "#7fa3a6",
}

function M.palette()
  local ok, c = pcall(dofile, vim.fn.expand("~/.cache/rice/colors.lua"))
  if ok and type(c) == "table" then return c end
  return fallback
end

function M.apply()
  local ok = pcall(function()
    require("pywal").setup()          -- pywal.nvim заново source-ит colors-wal.vim
    vim.cmd("colorscheme pywal")
  end)
  if not ok then vim.notify("pywal.nvim не загружен", vim.log.levels.WARN) end
  local p = M.palette()
  vim.api.nvim_set_hl(0, "RiceIndent", { fg = p.bg_alt2, nocombine = true })
  vim.api.nvim_set_hl(0, "RiceScope", { fg = p.accent, nocombine = true })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = p.accent })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.accent, bold = true })
  vim.api.nvim_exec_autocmds("User", { pattern = "RicePalette" })
end

vim.api.nvim_create_user_command("PywalRestore", M.apply, { desc = "Перечитать pywal/rice палитру" })

return M
