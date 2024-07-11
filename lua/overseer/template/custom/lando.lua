local overseer = require("overseer")

---@param opts overseer.SearchParams
---@return nil|string
local function get_lando_file(opts)
  return vim.fs.find(".lando.yml", { upward = true, type = "file", path = opts.dir })[1]
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
      if vim.fn.executable("lando") == 0 then
        return false, 'Command "lando" not found'
      end
      if not get_lando_file(opts) then
        return false, "No lando file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local landoFile = get_lando_file(opts)
    if not landoFile then
      cb({})
      return
    end
    local ret = {}
    local bin = "lando"
    -- TODO: THIS IS FIXED ATM
    local command = "yarn"
    local tasks = { "build", "watch" }

    for _, task in ipairs(tasks) do
      table.insert(
        ret,
        overseer.wrap_template(
          tmpl,
          { name = string.format("%s %s %s", bin, command, task) },
          { args = { task }, bin = bin, cwd = vim.fs.dirname(landoFile) }
        )
      )
    end
  end,
}
