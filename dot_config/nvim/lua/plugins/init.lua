return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable({ "pyright", "bashls" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "bash", "lua" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black" },
          sh = { "shfmt" },
        },
        format_on_save = { timeout_ms = 3000 },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        sh = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "AlphaTechnolog/pywal.nvim",
    priority = 1000,
    config = function()
      require("pywal").setup({})
      vim.cmd("colorscheme pywal")
    end,
  },
}
