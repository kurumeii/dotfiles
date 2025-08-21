_G.cursorword_blocklist = function()
  local curword = vim.fn.expand('<cword>')
  local filetype = vim.bo.filetype

  -- Add any disabling global or filetype-specific logic here
  local blocklist = {}
  if filetype == 'lua' then
    blocklist = { 'local', 'require' }
  elseif filetype == 'javascript' then
    blocklist = { 'import' }
  end

  vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
end

-- Make sure to add this autocommand *before* calling module's `setup()`.
vim.cmd('au CursorMoved * lua _G.cursorword_blocklist()')

require('mini.cursorword').setup()
