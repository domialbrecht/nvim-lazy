local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require("CopilotChat.actions")
    local items = actions[kind .. "_actions"]()
    if not items then
      LazyVim.warn("No " .. kind .. " found on the current line")
      return
    end
    local ok = pcall(require, "fzf-lua")
    require("CopilotChat.integrations." .. (ok and "fzflua" or "telescope")).pick(items)
  end
end

return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = function()
      return {
        { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
        { "<leader>h", "", desc = "+ai", mode = { "n", "v" } },
        {
          "<leader>ha",
          function()
            return require("CopilotChat").toggle()
          end,
          desc = "Toggle (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>hx",
          function()
            return require("CopilotChat").reset()
          end,
          desc = "Clear (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>hq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end,
          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "v" },
        },
        -- Show help actions with telescope
        { "<leader>hd", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
        -- Show prompts actions with telescope
        { "<leader>hp", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
      }
    end,
  },
}
