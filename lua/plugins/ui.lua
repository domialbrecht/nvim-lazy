---@diagnostic disable: missing-fields
return {
  {
    "tokyonight.nvim",
    ---@module 'tokyonight.nvim'
    ---@type tokyonight.Config
    opts = {
      style = "moon",
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
          draw = { treesitter = true },
        },
        documentation = {
          window = {
            border = "rounded",
          },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      appearance = {
        kind_icons = {
          Text = "󰉿",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰖷",

          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",

          Unit = "󰪚",
          Value = "󰦨",
          Enum = "󰦨",
          EnumMember = "󰦨",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = "󰑕",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Folder = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "󰬛",
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
