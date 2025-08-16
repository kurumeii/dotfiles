require('mini.notify').setup({
  content = {
    format = function(notification)
      if notification.data.source == 'lsp_progress' then
        return notification.msg
      end
      return MiniNotify.default_format(notification)
    end,
    sort = function(arr)
      table.sort(arr, function(a, b)
        return a.ts_update > b.ts_update
      end)
      return arr
    end,
  },
  -- window = {
  --   config = function()
  --     local has_statusline = vim.o.laststatus > 0
  --     local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
  --     return {
  --       anchor = 'SE',
  --       col = vim.o.columns,
  --       row = vim.o.lines - pad,
  --     }
  --   end,
  -- },
  lsp_progress = {
    enable = true,
    duration_last = 2000,
  },
})

vim.notify = MiniNotify.make_notify()

local utils = require('utils')
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path ~= '' then
      path = vim.fn.fnamemodify(path, ':~:.')
    end
    vim.notify('Saved ' .. vim.inspect(path))
  end,
})

-- README: This thing is annoying as heck
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     if vim.fn.getreg('"') then
--       local number_of_lines = vim.fn.getreg('"'):len()
--       utils.notify('Yanked ' .. number_of_lines .. ' lines', 'INFO')
--     end
--   end,
-- })

utils.map('n', utils.L('nd'), MiniNotify.clear, 'Notification Dismiss')
utils.map('n', utils.L('nh'), MiniNotify.show_history, 'Notification History')
