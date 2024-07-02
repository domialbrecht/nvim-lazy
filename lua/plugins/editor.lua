return {
  { "tpope/vim-abolish" },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<c-s>", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sf", LazyVim.pick("live_grep_glob"), desc = "Grep Glob (Root Dir)" },
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root(), reveal = true })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), reveal = true })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true, revael = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true, revael = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    opts = function(_, opts)
      opts.window.position = "current"
      opts.default_component_configs.file_size = {
        enabled = false,
      }
      opts.default_component_configs.type = {
        enabled = false,
      }
      opts.default_component_configs.last_modified = {
        enabled = false,
      }
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}

      opts.commands = {
        node_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          LazyVim.pick.open("live_grep", { cwd = path })
        end,
      }

      opts.filesystem.window = {
        mappings = {
          ["g"] = "node_find",
        },
      }

      vim.list_extend(opts.event_handlers, {
        {
          event = events.FILE_OPENED,
          handler = function(_)
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      })
    end,
  },
}
