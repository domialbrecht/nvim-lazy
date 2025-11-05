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
      on_highlights = function(hl, colors)
        hl.SnacksDashboardKey = { fg = colors.yellow }
        hl.BlinkCmpMenuBorder = { fg = colors.yellow }
        hl.BlinkCmpScrollBarThumb = { fg = colors.yellow, bg = colors.yellow }
        hl.LspKindSnippet = { fg = colors.magenta }
        hl.SnacksIndentChunk = { fg = colors.yellow }

        -- Increase comment like colors in brightness
        local commentColor = colors.comment
        hl.LineNrAbove = {
          fg = commentColor,
        }
        hl.LineNrBelow = {
          fg = commentColor,
        }
        hl.DiagnosticUnnecessary = { fg = commentColor }
      end,
      on_colors = function(colors)
        colors.comment = "#A3A9F2"
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
            score_offset = 10,
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      -- { "<C-S>", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    },
    opts = {
      ---@class snacks.picker.explorer.Config: snacks.picker.files.Config|{}
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
      statuscolumn = {
        enabled = false,
      },
      indent = {
        chunk = { enabled = true },
        -- scope = { treesitter = { enabled = true } },
      },
    },
  },
}
