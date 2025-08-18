vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  desc = 'Supermaven: Lazy init',
  callback = function(args)
    local utils = require('utils')
    local helper = {
      api = require('supermaven-nvim.api'),
      main = require('supermaven-nvim'),
    }
    if not helper.api.is_running() then
      helper.main.setup({
        keymaps = {
          accept_suggestion = '<Tab>',
          clear_suggestion = '<C-c>',
          accept_word = '<c-j>',
        },
        ignore_filetypes = { 'bigfile', 'snacks_input' },
      })
    end

    utils.map({ 'n' }, utils.L('xat'), helper.api.toggle, 'Code: toggle supermaven', {
      buffer = args.buf,
    })
  end,
})
