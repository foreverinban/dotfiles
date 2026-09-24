-- rice: статуслайн, отступы и дерево файлов в единой палитре (~/.cache/rice/colors.lua).
-- Всё перекрашивается по событию User RicePalette (его шлёт :PywalRestore).
local function lualine_theme()
  local p = require("rice").palette()
  local function mode(c)
    return {
      a = { fg = p.bg, bg = c, gui = "bold" },
      b = { fg = p.fg, bg = p.bg_alt2 },
      c = { fg = p.fg_dim, bg = p.bg_alt },
    }
  end
  return {
    normal = mode(p.accent),
    insert = mode(p.ok),
    visual = mode(p.color5),
    replace = mode(p.urgent),
    command = mode(p.warn),
    inactive = {
      a = { fg = p.muted, bg = p.bg },
      b = { fg = p.muted, bg = p.bg },
      c = { fg = p.muted, bg = p.bg },
    },
  }
end

return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local function setup()
        require("lualine").setup({
          options = {
            theme = lualine_theme(),
            globalstatus = true,
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { statusline = { "NvimTree" } },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })
      end
      setup()
      vim.api.nvim_create_autocmd("User", { pattern = "RicePalette", callback = setup })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local p = require("rice").palette()
        vim.api.nvim_set_hl(0, "RiceIndent", { fg = p.bg_alt2, nocombine = true })
        vim.api.nvim_set_hl(0, "RiceScope", { fg = p.accent, nocombine = true })
      end)
      require("ibl").setup({
        indent = { char = "│", highlight = "RiceIndent" },
        scope = { enabled = true, highlight = "RiceScope", show_start = false, show_end = false },
        exclude = { filetypes = { "NvimTree", "lazy", "help", "markdown" } },
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "RicePalette",
        callback = function() pcall(vim.cmd, "IBLEnable") end,
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Дерево файлов" },
      { "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Найти файл в дереве" },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      local function colors()
        local p = require("rice").palette()
        vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = p.accent })
        vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = p.fg })
        vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = p.accent, bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = p.accent, bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = p.bg_alt2 })
        vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = p.warn })
        vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = p.ok })
      end
      require("nvim-tree").setup({
        view = { width = 32 },
        renderer = {
          root_folder_label = ":~:s?$?/..?",
          indent_markers = { enable = true },
          highlight_git = true,
        },
        filters = { dotfiles = false, custom = { "^.git$" } },
        update_focused_file = { enable = true },
      })
      colors()
      vim.api.nvim_create_autocmd("User", { pattern = "RicePalette", callback = colors })
    end,
  },
}
