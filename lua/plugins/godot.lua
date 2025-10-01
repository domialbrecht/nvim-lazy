-- local is_godot = require("lspconfig.util").root_pattern("project.godot")
-- local root = LazyVim.root.get({ normalize = true })
-- if is_godot(root) then
--   local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
--   if not (vim.uv or vim.loop).fs_stat(pipepath) then
--     vim.fn.serverstart(pipepath)
--   end
-- end
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "gdscript" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {},
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "gdtoolkit",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        gdscript = { "gdlint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
      },
    },
  },
}
