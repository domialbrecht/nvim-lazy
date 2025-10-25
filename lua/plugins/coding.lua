return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
  {
    "jcha0713/classy.nvim",
    keys = {
      {
        "gac",
        "<cmd>ClassyAddClass<cr>",
        desc = "Add Classy",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      filetypes = { ["*"] = true },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = { useFlatConfig = true },
          },
        },
      },
    },
  },
  {
    "nvim-mini/mini.operators",
    version = false,
    opts = {
      evaluate = {
        prefix = "",
      },
      exchange = {
        prefix = "gx",
      },
      multiply = {
        prefix = "",
      },
      replace = {
        prefix = "gt",
      },
      sort = {
        prefix = "",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>\\", icon = "" },
        { "gx", desc = "+op exchange" },
        { "gt", desc = "+op replace" },
        { "ga", desc = "+op add" },
      },
    },
  },
}
