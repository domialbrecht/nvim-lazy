-- ===== sitepackage jump (drop-in) =====
-- Jumps from <prefix:kind.name> or <prefix:kind.sub.name> to:
-- <site_root>/Resources/Private/Components/<Kind>/<Seg1>/.../<SegN>/<SegN>.<ext>
-- - prefix (e.g. mybvk, sow) is ignored
-- - site_root is the nearest directory upward containing composer.json
-- - <Kind> is derived from the tag kind via PascalCase (no hardcoded map)
-- - extension can be global or per (lowercased) kind
-- - supports arbitrary nesting via dots in the name (button.link.item)

-- =========================
-- config
-- =========================
local sitepackage = {
  ext = ".html", -- default extension
  ext_by_kind = nil, -- e.g. { atom = ".html", icon = ".svg" }
  echo_attempt = true,
  create_missing = false, -- set true to auto-create missing files/folders
  -- limit keymaps to certain filetypes? set to nil for global
  keymap_filetypes = { "html" }, -- e.g. { "html", "xml", "php", "typoscript" }
}

-- =========================
-- utils
-- =========================

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

-- Split "button.link" -> { "button", "link" }
local function sitepackage_split_name(name_raw)
  local parts = {}
  for part in (name_raw or ""):gmatch("[^%.]+") do
    table.insert(parts, part)
  end
  return parts
end

-- resolve extension (per top-level kind or default)
local function sitepackage_ext_for(kind_lc)
  if sitepackage.ext_by_kind and sitepackage.ext_by_kind[kind_lc] then
    return sitepackage.ext_by_kind[kind_lc]
  end
  return sitepackage.ext
end

-- =========================
-- extraction
-- =========================

-- Find tags like "<prefix:kind.name>" or "<prefix:kind.sub.name>" (prefix ignored, colon required).
-- Prefers the match that spans the cursor; falls back to the nearest previous match.
local function sitepackage_extract()
  local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local col = col0 + 1 -- Lua strings are 1-indexed

  local best = nil
  local i = 1
  while true do
    -- captures: prefix (ignored), kind, name (can contain dots)
    local s, e, _prefix, kind, name = line:find("([%w_%-]+):([%w_%-]+)%.([%w_%-%.]+)", i)
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

  -- fallback: word under cursor (allow multiple dots)
  local word = vim.fn.expand("<cword>")
  local _p, k, n = word:match("^([%w_%-]+):([%w_%-]+)%.([%w_%-%.]+)$")
  if k and n then
    return k, n
  end

  return nil, nil
end

-- =========================
-- path building
-- =========================

-- Build path relative to nearest site-package composer.json:
-- <site_root>/Resources/Private/Components/<Kind>/<Seg1>/.../<SegN>/<SegN>.<ext>
local function sitepackage_build_path(kind_raw, name_raw, bufpath)
  local root = sitepackage_find_root(bufpath)
  if not root then
    return nil, "composer.json not found upwards from " .. bufpath
  end

  local components_base = root .. "/Resources/Private/Components"

  local kind_lc = (kind_raw or ""):lower()
  local kind_dir = sitepackage_to_pascal(kind_raw or "")
  if kind_dir == "" then
    return nil, "Empty component kind"
  end

  local name_parts_raw = sitepackage_split_name(name_raw)
  if #name_parts_raw == 0 then
    return nil, "Empty component name"
  end

  -- PascalCase each segment
  local name_parts = {}
  for _, p in ipairs(name_parts_raw) do
    table.insert(name_parts, sitepackage_to_pascal(p))
  end

  local ext = sitepackage_ext_for(kind_lc)

  -- directories: <Components>/<Kind>/<Seg1>/.../<SegN>
  -- file: <SegN><ext>
  local path_parts = { components_base, kind_dir }
  vim.list_extend(path_parts, name_parts)

  local dir_path = table.concat(path_parts, "/")
  local file = dir_path .. "/" .. name_parts[#name_parts] .. ext

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

-- =========================
-- main cmds
-- =========================

-- jump (and optionally create)
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
      end -- or write a scaffold here if you like
    end
    vim.cmd.edit(vim.fn.fnameescape(target))
  else
    local msg = "File not found: " .. target
    if sitepackage.echo_attempt then
      vim.notify(msg, vim.log.levels.ERROR)
    end
  end
end

-- echo resolved path
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

-- =========================
-- wiring (commands + keymaps)
-- =========================
vim.api.nvim_create_user_command("SitePackageJump", SitePackageJump, {})
vim.api.nvim_create_user_command("SitePackageEcho", SitePackageEcho, {})

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
