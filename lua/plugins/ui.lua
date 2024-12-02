return {
  {
    "tokyonight.nvim",
    opts = {
      style = "night",
      on_highlights = function(hl, c)
        hl.SnacksDashboardKey = { fg = c.yellow }
        hl.BlinkCmpMenuBorder = { fg = c.yellow, bg = c.yellow }
        hl.BlinkCmpScrollBarThumb = { fg = c.yellow, bg = c.yellow }
      end,
    },
  },
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        menu = {
          border = "rounded",
          winblend = 0,
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
          {
            section = "terminal",
            cmd = "greek",
            padding = 1,
            height = 17,
            align = "center",
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
