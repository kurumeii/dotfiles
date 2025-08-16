local utils = require('utils')
local H = {
  show_dotfiles = true,
  filter_show = function(_)
    return true
  end,
  filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end,
}

require('mini.files').setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 30,
  },
  options = {
    use_as_default_explorer = true,
  },
  mappings = {
    go_out_plus = 'h',
    synchronize = '<c-s>',
  },
  content = {
    filter = H.filter_show,
  },
})

H.map_split = function(buf_id, lhs, direction, close_on_file)
  local rhs = function()
    local new_target_window
    local cur_target_window = MiniFiles.get_explorer_state().target_window
    if cur_target_window ~= nil then
      vim.api.nvim_win_call(cur_target_window, function()
        vim.cmd('belowright ' .. direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      MiniFiles.set_target_window(new_target_window)
      MiniFiles.go_in({ close_on_file = close_on_file })
    end
  end

  local desc = 'Open in ' .. direction .. ' split'
  if close_on_file then
    desc = desc .. ' and close'
  end
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    utils.map({ 'n' }, '//', function()
      H.show_dotfiles = not H.show_dotfiles
      local new_filter = H.show_dotfiles and H.filter_show or H.filter_hide
      MiniFiles.refresh({ content = { filter = new_filter } })
    end, 'Toggle hidden files', { buffer = args.buf })
    H.map_split(args.buf, '<C-w>s', 'horizontal', false)
    H.map_split(args.buf, '<C-w>v', 'vertical', false)
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  callback = function(e)
    Snacks.rename.on_rename_file(e.data.from, e.data.to)
    utils.notify('Renamed ' .. e.data.from .. ' to ' .. e.data.to .. ' successfully')
  end,
})

utils.map('n', utils.L('e'), function()
  local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
  if not ok then
    MiniFiles.open(nil, false)
  end
end, 'Open explore')
