return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "twig",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        twiggy_language_server = {
          settings = {
            twiggy = {
              framework = "symfony",
              phpExecutable = "php-legacy",
              symfonyConsolePath = "bin/console",
            },
          },
        },
        denols = {},
      },
    },
  },
}
