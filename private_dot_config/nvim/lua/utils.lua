local H = {}
local hexChars = '0123456789abcdef'

--- @param mode string | table<string> -- n, v, i, x
--- @param keys string
--- @param func function|string
--- @param desc? string
--- @param opts? vim.keymap.set.Opts
H.map = function(mode, keys, func, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, keys, func, opts)
end

H.L = function(key)
  return '<leader>' .. key
end
H.C = function(cmd)
  return '<cmd>' .. cmd .. '<cr>'
end

--- @param msg string
--- @param level? 'ERROR' | 'WARN' | 'INFO'
--- @param title string?
H.notify = function(msg, level, title)
  level = level or 'INFO'
  vim.defer_fn(function()
    -- Snacks.notify[string.lower(level)](msg)
    vim.notify(msg, vim.log.levels[level], { title = title or 'Notification' })
  end, 1000)
end

--- @param msg string
--- @param level? 'ERROR' | 'WARN' | 'INFO'
--- @param title string?
H.notify_once = function(msg, level, title)
  level = level or 'INFO'
  vim.notify_once(msg, vim.log.levels[level], { title = title or 'Notification' })
end

H.debounce = function(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    if timer ~= nil then
      timer:start(ms, 0, function()
        timer:stop()
        vim.schedule_wrap(fn)(unpack(argv))
      end)
    end
  end
end

function H.hex_to_rgb(hex)
  hex = string.lower(hex)
  local ret = {}
  for i = 0, 2 do
    local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
    local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
    local digit1 = string.find(hexChars, char1) - 1
    local digit2 = string.find(hexChars, char2) - 1
    ret[i + 1] = (digit1 * 16 + digit2) / 255.0
  end
  return ret
end

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and l in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSL representation
]]
function H.rgbToHsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h = 0
  local s = 0
  local l = 0

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then
      s = d / (2 - max - min)
    else
      s = d / (max + min)
    end
    if max == r then
      h = (g - b) / d
      if g < b then
        h = h + 6
      end
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h * 360, s * 100, l * 100
end

--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  Array           The RGB representation
]]
function H.hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    local function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q
    if l < 0.5 then
      q = l * (1 + s)
    else
      q = l + s - l * s
    end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return r * 255, g * 255, b * 255
end

function H.hexToHSL(hex)
  local rgb = H.hex_to_rgb(hex)
  local h, s, l = H.rgbToHsl(rgb[1], rgb[2], rgb[3])

  return string.format('hsl(%d, %d, %d)', math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))
end

--[[
 * Converts an HSL color value to RGB in Hex representation.
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  String           The hex representation
]]
function H.hslToHex(h, s, l)
  local r, g, b = H.hslToRgb(h / 360, s / 100, l / 100)

  return string.format('#%02x%02x%02x', r, g, b)
end

function H.replaceHexWithHSL()
  -- Get the current line number
  local line_number = vim.api.nvim_win_get_cursor(0)[1]

  -- Get the line content
  local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

  -- Find hex code patterns and replace them
  for hex in line_content:gmatch('#[0-9a-fA-F]+') do
    local hsl = H.hexToHSL(hex)
    line_content = line_content:gsub(hex, hsl)
  end

  -- Set the line content back
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end

function H.rgbToHex(r, g, b, a)
  if a then
    return string.format('#%02x%02x%02x', r * a, g * a, b * a)
  end
  return string.format('#%02x%02x%02x', r, g, b)
end

local function oklch_to_srgb(l, c, h)
  -- OKLCH -> OKLab
  local h_rad = h * math.pi / 180
  local a = c * math.cos(h_rad)
  local b = c * math.sin(h_rad)

  -- OKLab -> linear sRGB
  local L = l
  local A = a
  local B = b

  local l_ = L + 0.3963377774 * A + 0.2158037573 * B
  local m_ = L - 0.1055613458 * A - 0.0638541728 * B
  local s_ = L - 0.0894841775 * A - 1.2914855480 * B

  local l3 = l_ * l_ * l_
  local m3 = m_ * m_ * m_
  local s3 = s_ * s_ * s_

  local r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3
  local g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3
  b = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3

  -- Gamma correction
  local function to_srgb_channel(x)
    if x <= 0.0031308 then
      return 12.92 * x
    else
      return 1.055 * x ^ (1 / 2.4) - 0.055
    end
  end

  r = to_srgb_channel(r)
  g = to_srgb_channel(g)
  b = to_srgb_channel(b)

  -- Clamp and convert to 0-255
  local function clamp(x)
    return math.max(0, math.min(1, x))
  end

  return math.floor(clamp(r) * 255 + 0.5), math.floor(clamp(g) * 255 + 0.5), math.floor(clamp(b) * 255 + 0.5)
end

function H.oklchToHex(l, c, h, a)
  local r, g, b = oklch_to_srgb(l, c, h)
  return H.rgbToHex(r, g, b, a)
end

--- @param tbl table
function H.uniq(tbl)
  local seen, result = {}, {}
  for _, value in ipairs(tbl) do
    if not seen[value] then
      seen[value] = true
      result[#result + 1] = value
    end
  end
  return result
end

---@type MiniHookFunction
function H.build_blink(params)
  H.notify('Building blink.cmp', 'INFO')
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    H.notify('Building blink.cmp done', 'INFO')
  else
    H.notify('Building blink.cmp failed', 'ERROR')
  end
end

local function progress(opts)
  local count = 1
  local timer = vim.loop.new_timer()
  if timer == nil then
    return
  end
  local notif = MiniNotify.add('Building', 'INFO')
  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      count = count + 1
      local icon = mininvim.icons.spinner[count % #mininvim.icons.spinner + 1]
      local content = string.format('Building... %s', icon)
      MiniNotify.update(notif, {
        msg = content,
        level = 'INFO',
      })
    end)
  )
  vim.system(opts.cmd, { cwd = opts.cwd }, function(result)
    timer:stop()
    timer:close()
    if result.code == 0 then
      MiniNotify.update(notif, {
        msg = '✓ ' .. opts.on_success,
        level = 'INFO',
      })
    else
      MiniNotify.update(notif, {
        msg = '✗ ' .. opts.on_failure .. ': ' .. result.stderr,
        level = 'ERROR',
      })
    end
    vim.defer_fn(function()
      MiniNotify.remove(notif)
    end, 1000)
  end)
end

---@type MiniHookFunction
function H.build_avante(params)
  if vim.fn.has('win32') == 1 then
    progress({
      cmd = { 'powershell', '-File', 'Build.ps1', '-BuildFromSource ', 'true' },
      cwd = params.path,
      on_success = 'Building Avante done',
      on_failure = 'Building Avante failed',
    })
  else
    progress({
      cmd = { 'make' },
      cwd = params.path,
      on_success = 'Building Avante done',
      on_failure = 'Building Avante failed',
    })
  end
end

---@param dot_ext string
---@param target_ft string
function H.set_ft(dot_ext, target_ft)
  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = '*.' .. dot_ext,
    desc = 'Set filetype to ' .. target_ft,
    callback = function(args)
      vim.bo[args.buf].ft = target_ft
    end,
  })
end

---@param lsp_name string
---@return boolean
function H.has_lsp(lsp_name)
  local find_lsp = vim.lsp.get_clients({
    name = lsp_name,
    bufnr = vim.api.nvim_get_current_buf(),
  })
  return #find_lsp > 0
end

H.action = setmetatable({}, {
  ---@param action lsp.CodeActionKind
  __index = function(action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})
-- function H.lsp_action(action)
--   vim.lsp.buf.code_action({
--     apply = true,
--     context = {
--       only = { action },
--       diagnostics = {},
--     },
--   })
-- end

---@param opts lsp.ExecuteCommandParams
---@param buffer? number
function H.execute(opts, buffer)
  vim.lsp.buf_request(buffer or 0, 'workspace/executeCommand', {
    command = opts.command,
    arguments = opts.args,
  }, function(err)
    if err then
      H.notify(err.message, 'ERROR')
    end
  end)
end

return H
