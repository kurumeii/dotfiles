local MiniStatusline = require('mini.statusline')
-- local navic = require('nvim-navic')

local function get_time()
  return os.date('%R') .. ' ' .. mininvim.icons.clock
end

local function recorder_section()
  local reg = vim.fn.reg_recording()
  if reg ~= '' then
    return mininvim.icons.recording .. ' ' .. reg
  end
  return ''
end

local function get_lsp(ignore_lsp)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return mininvim.icons.no_lsp
  end
  local names = {}
  for _, client in ipairs(clients) do
    if vim.tbl_contains(ignore_lsp, client.name) then
      goto continue
    else
      table.insert(names, client.name)
    end
    ::continue::
  end
  local supermaven_status = require('supermaven-nvim.api').is_running() and ' ' or ' '
  local icon = mininvim.icons.lsp .. ' ' .. supermaven_status
  if #names > 2 then
    return icon .. '+' .. #names
  else
    return icon .. '' .. table.concat(names, ',')
  end
end

--- @param mode 'percent' | 'line'
local function get_location(mode)
  if mode == 'percent' then
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local total_lines = vim.api.nvim_buf_line_count(0)
    if current_line == 1 then
      return 'TOP'
    elseif current_line == total_lines then
      return 'BOTTOM'
    else
      return '%p%%'
    end
  else
    return '%l|%v'
  end
end

local function custom_fileinfo(args)
  args = args or {}
  local filetype = vim.bo.filetype
  filetype = MiniIcons.get('filetype', filetype) .. ' ' .. filetype
  if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= '' then
    return filetype
  end

  local encoding = vim.bo.fileencoding or vim.bo.encoding
  -- local format = vim.bo.fileformat
  local get_size = function()
    local size = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
    if size < 1024 then
      return string.format('%dB', size)
    elseif size < 1048576 then
      return string.format('%.2fKiB', size / 1024)
    else
      return string.format('%.2fMiB', size / 1048576)
    end
  end

  return string.format('%s%s[%s] %s', filetype, filetype == '' and '' or ' ', encoding, get_size())
end

local function active_mode()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 75 })
  -- mode = mode:upper()

  local git = MiniStatusline.section_git({ icon = mininvim.icons.git_branch, trunc_width = 40 })
  local diff = MiniStatusline.section_diff({ icon = '', trunc_width = 100 })
  local diagnostics = MiniStatusline.section_diagnostics({
    icon = '',
    signs = {
      ERROR = mininvim.icons.error .. ' ',
      WARN = mininvim.icons.warn .. ' ',
      INFO = mininvim.icons.info .. ' ',
      HINT = mininvim.icons.hint .. ' ',
    },
    trunc_width = 75,
  })
  local lsp = get_lsp({ 'mini.snippets' })
  MiniStatusline.section_fileinfo = custom_fileinfo
  local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 150 })
  local location = get_location('percent')
  local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
  -- local nvim_battery = battery.get_status_line()
  local time = get_time()
  local recorder = recorder_section()
  local filename = MiniStatusline.section_filename({ trunc_width = 250 })
  filename = vim.fn.expand('%:h:t') .. '/' .. vim.fn.expand('%:t')
  -- local code_context = navic.is_available() and navic.get_location()
  return MiniStatusline.combine_groups({
    { hl = mode_hl, strings = { filename } },
    {
      hl = '',
      strings = { git },
    },
    {
      hl = 'MiniStatuslineDevinfo',
      strings = { diff, diagnostics },
    },
    '%<', -- Mark general truncate point
    {
      hl = '',
      strings = {},
    },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { recorder, lsp, fileinfo } },
    { hl = '', strings = { location } },
    { hl = mode_hl, strings = { search, time } },
  })
end

MiniStatusline.setup({
  content = {
    active = active_mode,
  },
})
