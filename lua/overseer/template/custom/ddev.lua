local overseer = require("overseer")

---@param opts overseer.SearchParams
---@return nil|string
local function get_ddev_folder(opts)
  return vim.fs.find(".ddev", { upward = false, type = "directory", path = opts.dir })[1]
end

---@type overseer.TemplateFileDefinition
local tmpl = {
  priority = 60,
  params = {
    args = { optional = true, type = "list", delimiter = " " },
    cwd = { optional = true },
    bin = { optional = true, type = "string" },
  },
  builder = function(params)
    return {
      cmd = { params.bin },
      args = params.args,
      cwd = params.cwd,
    }
  end,
}

return {
  condition = {
    dir = vim.fn.getcwd(),
    callback = function(opts)
      if vim.fn.executable("ddev") == 0 then
        return false, 'Command "ddev" not found'
      end
      if not get_ddev_folder(opts) then
        return false, "No ddev file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local ddevFile = get_ddev_folder(opts)
    if not ddevFile then
      cb({})
      return
    end
    local ret = {}
    local bin = "ddev"
    -- TODO: THIS IS FIXED ATM
    local command = "frontend"
    local tasks = { "build", "watch", "serve" }

    for _, task in ipairs(tasks) do
      table.insert(
        ret,
        overseer.wrap_template(
          tmpl,
          { name = string.format("%s %s %s", bin, command, task) },
          { args = { task }, bin = bin, cwd = vim.fs.dirname(ddevFile) }
        )
      )
    end
  end,
}
