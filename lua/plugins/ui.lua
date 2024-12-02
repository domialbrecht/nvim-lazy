return {
  {
    "tokyonight.nvim",
    opts = {
      style = "moon",
      on_highlights = function(hl, c)
        hl.SnacksDashboardKey = { fg = c.yellow }
        hl.BlinkCmpMenuBorder = { fg = c.yellow }
        hl.BlinkCmpScrollBarThumb = { fg = c.yellow, bg = c.yellow }
      end,
    },
  },
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      windows = {
        autocomplete = {
          border = "rounded",
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        width = 70,
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
