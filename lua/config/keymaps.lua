-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local util = require("util")

util.wezterm()

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Map <Leader>\ to insert |> in insert mode
vim.api.nvim_set_keymap("i", "<Leader>\\", "|> ", { noremap = true, silent = true, desc = "|>Elixir pipe shortcut" })

-- Map <Leader>\ to insert |> in normal mode
vim.api.nvim_set_keymap(
  "n",
  "<Leader>\\",
  "a|> <Esc>",
  { noremap = true, silent = true, desc = "|> Elixir pipe shortcut" }
)
