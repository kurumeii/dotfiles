local utils = require('utils')
local map, L = utils.map, utils.L
local notify = utils.notify

require('mini.sessions').setup({
  autoread = false,
  autowrite = true,
  force = {
    delete = true,
    write = true,
  },
  directory = vim.fn.stdpath('data') .. '/sessions',
})

-- Autoload session
local default_session = 'last-session'
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if vim.bo.ft == 'ministarter' then
      return
    end
    local session_name = MiniSessions.get_latest() or default_session
    MiniSessions.write(session_name)
  end,
})

-- keymaps
map({ 'n' }, L('ss'), function()
  vim.ui.input({ prompt = 'Enter session name: ', default = default_session }, function(input)
    if input == nil or input == '' then
      notify('Name is required for session', 'WARN')
      return
    end
    MiniSessions.write(input)
    notify('Session ' .. input .. ' saved', 'INFO')
  end)
end, 'Save session')

map({ 'n' }, L('sd'), function()
  local ok, err = pcall(function()
    MiniSessions.select('delete')
  end)
  if not ok then
    notify('Error: ' .. tostring(err), 'ERROR')
  end
  -- notify('Session deleted', 'INFO')
end, 'Delete session')

map({ 'n' }, L('sl'), function()
  MiniSessions.select()
end, 'Load session')
