-- ===== sitepackage jump (drop-in) =====
-- Jumps from <prefix:kind.name> to <site_root>/Resources/Private/Components/<Kind>/<Name>/<Name>.<ext>
-- - prefix (e.g. mybvk, sow) is ignored
-- - site_root is the nearest directory upward containing composer.json
-- - kind maps to a subfolder (Atom/Molecule/Organism by default)
-- - extension can be global or per kind

-- config
local sitepackage = {
  components_map = { atom = "Atom", molecule = "Molecule", organism = "Organism" },
  ext = ".html", -- default extension
  ext_by_kind = nil, -- e.g. { icon = ".svg" }
  echo_attempt = true,
  create_missing = false, -- set true to auto-create missing files/folders
  -- limit keymaps to certain filetypes? set to nil for global
  keymap_filetypes = { "html" }, -- e.g. { "html", "xml" }
}

-- find project root (composer.json)
local function sitepackage_find_root(bufpath)
  local start = vim.fs.dirname(bufpath)
  if not start or start == "" then
    return nil
  end
  local hit = vim.fs.find("composer.json", { upward = true, path = start, type = "file" })[1]
  return hit and vim.fs.dirname(hit) or nil
end

-- "pageTitle" / "page-title" / "page_title" -> "PageTitle"
local function sitepackage_to_pascal(s)
  s = (s or ""):gsub("[_-]", " ")
  s = s:gsub("([a-z0-9])([A-Z])", "%1 %2")
  local out = {}
  for part in s:gmatch("%S+") do
    table.insert(out, part:sub(1, 1):upper() .. part:sub(2))
  end
  return table.concat(out, "")
end

-- Find tags like "<prefix:kind.name>" (prefix ignored, colon required).
-- Prefers the match that spans the cursor; falls back to the nearest previous match.
local function sitepackage_extract()
  local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local col = col0 + 1 -- Lua strings are 1-indexed

  local best = nil
  local i = 1
  while true do
    -- captures: prefix (ignored), kind, name
    local s, e, _prefix, kind, name = line:find("([%w_%-]+):([%w_%-]+)%.([%w_%-]+)", i)
    if not s then
      break
    end
    if s <= col and e >= col then
      return kind, name
    end
    best = { kind = kind, name = name, s = s, e = e }
    i = e + 1
  end

  if best then
    return best.kind, best.name
  end

  -- fallback: word under cursor
  local word = vim.fn.expand("<cword>")
  local _p, k, n = word:match("^([%w_%-]+):([%w_%-]+)%.([%w_%-]+)$")
  if k and n then
    return k, n
  end

  return nil, nil
end

-- resolve extension (per kind or default)
local function sitepackage_ext_for(kind_lc)
  if sitepackage.ext_by_kind and sitepackage.ext_by_kind[kind_lc] then
    return sitepackage.ext_by_kind[kind_lc]
  end
  return sitepackage.ext
end

-- Build path relative to nearest site-package composer.json:
-- <site_root>/Resources/Private/Components/<Kind>/<Name>/<Name>.<ext>
local function sitepackage_build_path(kind_raw, name_raw, bufpath)
  local root = sitepackage_find_root(bufpath)
  if not root then
    return nil, "composer.json not found upwards from " .. bufpath
  end

  local components_base = root .. "/Resources/Private/Components"

  local kind_lc = (kind_raw or ""):lower()
  local comp_dir = sitepackage.components_map[kind_lc]
  if not comp_dir then
    return nil, "Unknown component kind: " .. tostring(kind_raw)
  end

  local pascal = sitepackage_to_pascal(name_raw or "")
  if pascal == "" then
    return nil, "Empty component name"
  end

  local ext = sitepackage_ext_for(kind_lc)

  local file = table.concat({
    components_base,
    comp_dir,
    pascal,
    pascal .. ext,
  }, "/")

  return file, nil
end

local function sitepackage_exists(p)
  return vim.loop.fs_stat(p) ~= nil
end

local function sitepackage_ensure_dirs(file)
  local dir = vim.fs.dirname(file)
  if not dir then
    return
  end
  vim.fn.mkdir(dir, "p")
end

-- main: jump (and optionally create)
function _G.SitePackageJump()
  local kind, name = sitepackage_extract()
  if not kind or not name then
    vim.notify("No tag under cursor (expected <prefix:kind.name>)", vim.log.levels.WARN)
    return
  end
  local bufpath = vim.api.nvim_buf_get_name(0)
  local target, err = sitepackage_build_path(kind, name, bufpath)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  if sitepackage_exists(target) then
    vim.cmd.edit(vim.fn.fnameescape(target))
    return
  end

  if sitepackage.create_missing then
    sitepackage_ensure_dirs(target)
    if not sitepackage_exists(target) then
      local f = io.open(target, "w")
      if f then
        f:write("")
        f:close()
      end -- or write a scaffold
    end
    vim.cmd.edit(vim.fn.fnameescape(target))
  else
    local msg = "File not found: " .. target
    if sitepackage.echo_attempt then
      vim.notify(msg, vim.log.levels.ERROR)
    end
  end
end

-- helper: echo resolved path
function _G.SitePackageEcho()
  local kind, name = sitepackage_extract()
  if not kind or not name then
    print("No tag under cursor (expected <prefix:kind.name>)")
    return
  end
  local bufpath = vim.api.nvim_buf_get_name(0)
  local target, err = sitepackage_build_path(kind, name, bufpath)
  if err then
    print(err)
  else
    print(target)
  end
end

-- commands
vim.api.nvim_create_user_command("SitePackageJump", SitePackageJump, {})
vim.api.nvim_create_user_command("SitePackageEcho", SitePackageEcho, {})

-- keymaps (global by default; set sitepackage.keymap_filetypes to limit)
local function sitepackage_set_keymaps(buflocal)
  local opts = { desc = "Jump to site package component file" }
  local opts_echo = { desc = "Echo site package component path" }
  if buflocal then
    opts.buffer, opts_echo.buffer = 0, 0
  end
  vim.keymap.set("n", "gj", "<cmd>SitePackageJump<cr>", opts)
  vim.keymap.set("n", "gJ", "<cmd>SitePackageEcho<cr>", opts_echo)
end

if sitepackage.keymap_filetypes and type(sitepackage.keymap_filetypes) == "table" then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = sitepackage.keymap_filetypes,
    callback = function()
      sitepackage_set_keymaps(true)
    end,
  })
else
  sitepackage_set_keymaps(false)
end
