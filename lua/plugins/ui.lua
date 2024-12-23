---@diagnostic disable: missing-fields
return {
  {
    "tokyonight.nvim",
    ---@module 'tokyonight.nvim'
    ---@type tokyonight.Config
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      ---@param highlights tokyonight.Highlights
      on_highlights = function(highlights, colors)
        highlights.SnacksDashboardKey = { fg = colors.yellow }
        highlights.BlinkCmpMenuBorder = { fg = colors.yellow }
        highlights.BlinkCmpScrollBarThumb = { fg = colors.yellow, bg = colors.yellow }
        highlights.LspKindSnippet = { fg = colors.magenta }
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
          winblend = vim.o.pumblend,
        },
        documentation = {
          window = {
            border = "rounded",
          },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = false },
      },
      signature = {
        window = {
          border = "rounded",
        },
      },
      sources = {
        providers = {
          copilot = {
            score_offset = -100,
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        width = 70,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      indent = {
        chunk = { enabled = true },
        -- scope = { treesitter = { enabled = true } },
      },
    },
  },
}
