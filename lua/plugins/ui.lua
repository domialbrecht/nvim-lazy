return {
  -- {
  --   "tokyonight.nvim",
  --   opts = function()
  --     return {
  --       style = "moon",
  --       transparent = true,
  --       styles = {
  --         sidebars = "transparent",
  --         floats = "transparent",
  --       },
  --       sidebars = {
  --         "qf",
  --         "vista_kind",
  --         -- "terminal",
  --         "spectre_panel",
  --         "startuptime",
  --         "Outline",
  --       },
  --       on_highlights = function(hl, c)
  --         hl.SnacksDashboardKey = { fg = c.yellow }
  --       end,
  --     }
  --   end,
  -- },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      styles = {
        keywords = { "bold" },
        functions = { "italic" },
      },
      custom_highlights = function(colors)
        return {
          SnacksDashboardKey = { fg = colors.mauve },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
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
