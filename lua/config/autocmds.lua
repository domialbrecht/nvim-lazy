-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})
vim.api.nvim_create_user_command("EpochToDate", function()
  local word = vim.fn.expand("<cword>")
  local timestamp = tonumber(word)
  if timestamp then
    local result = os.date("%Y-%m-%d %H:%M:%S", timestamp)
    vim.notify("Converted: " .. result, vim.log.levels.INFO, { title = "Epoch Converter" })
  else
    vim.notify("Invalid Timestamp", vim.log.levels.ERROR, { title = "Epoch Converter" })
  end
end, {})

vim.api.nvim_create_user_command("Epoch", function(opts)
  local date_str = opts.args ~= "" and opts.args or os.date("%d/%m/%Y")
  local pattern = "(%d+)%/(%d+)%/(%d+)"
  local day, month, year = date_str:match(pattern)

  if day and month and year then
    local epoch = os.time({ year = year, month = month, day = day, hour = 0, min = 0, sec = 0 })
    if epoch then
      vim.fn.setreg("+", tostring(epoch))
      vim.notify(
        "Epoch timestamp: " .. epoch .. " (copied to clipboard)",
        vim.log.levels.INFO,
        { title = "Epoch Converter" }
      )
    else
      vim.notify("Failed to convert date", vim.log.levels.ERROR, { title = "Epoch Converter" })
    end
  else
    vim.notify("Invalid date format. Use DD/MM/YYYY", vim.log.levels.ERROR, { title = "Epoch Converter" })
  end
end, { nargs = "?" })
