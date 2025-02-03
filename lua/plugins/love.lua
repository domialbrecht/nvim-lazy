return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { library = { "${3rd}/love2d/library" } },
            },
          },
        },
      },
    },
  },
}
