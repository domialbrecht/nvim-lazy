return {
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>fe",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>fE",
        function()
          require("yazi").yazi(nil, vim.uv.cwd())
        end,
        desc = "Open yazi in CWD",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
      integrations = {
        grep_in_selected_files = "snacks.picker",
        grep_in_directory = "snacks.picker",
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "o", "x" },
      },
      {
        "e",
        function()
          require("spider").motion("e")
        end,
        mode = { "n", "o", "x" },
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "o", "x" },
      },
    },
    opts = { subwordMovement = true },
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
      picker = {
        sources = {
          explorer = {
            layout = { preset = "default", preview = true },
            auto_close = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>E",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer Snacks (cwd)",
      },
    },
  },
  { "tpope/vim-abolish" },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView current File" },
    },
  },
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "custom.init" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leader>h", false },
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    },
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   keys = {
  --     {
  --       "<leader>fe",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root(), reveal = true })
  --       end,
  --       desc = "Explorer NeoTree (Root Dir)",
  --     },
  --     {
  --       "<leader>fE",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), reveal = true })
  --       end,
  --       desc = "Explorer NeoTree (cwd)",
  --     },
  --     {
  --       "<leader>ge",
  --       function()
  --         require("neo-tree.command").execute({ source = "git_status", toggle = true, revael = true })
  --       end,
  --       desc = "Git Explorer",
  --     },
  --     {
  --       "<leader>be",
  --       function()
  --         require("neo-tree.command").execute({ source = "buffers", toggle = true, revael = true })
  --       end,
  --       desc = "Buffer Explorer",
  --     },
  --   },
  --   opts = function(_, opts)
  --     opts.window.position = "float"
  --     opts.default_component_configs.file_size = {
  --       enabled = false,
  --     }
  --     opts.default_component_configs.type = {
  --       enabled = false,
  --     }
  --     opts.default_component_configs.last_modified = {
  --       enabled = false,
  --     }
  --
  --     opts.commands = {
  --       node_find = function(state)
  --         local node = state.tree:get_node()
  --         local path = node:get_id()
  --         LazyVim.pick.open("live_grep", { cwd = path })
  --       end,
  --     }
  --
  --     opts.filesystem.window = {
  --       mappings = {
  --         ["h"] = "node_find",
  --       },
  --     }
  --
  --     local events = require("neo-tree.events")
  --     opts.event_handlers = opts.event_handlers or {}
  --     vim.list_extend(opts.event_handlers, {
  --       {
  --         event = events.FILE_OPENED,
  --         handler = function(_)
  --           require("neo-tree.command").execute({ action = "close" })
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
