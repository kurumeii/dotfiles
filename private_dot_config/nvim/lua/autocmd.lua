local utils = require('utils')

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  callback = function(args)
    utils.map('i', '<C-l>', vim.lsp.buf.signature_help, 'Signature help', {
      buffer = args.buf,
    })
    utils.map('n', utils.L('cr'), function()
      vim.ui.input({ prompt = 'Rename to: ' }, function(new_name)
        if not new_name then
          utils.notify('Rename cancelled', 'WARN')
        else
          vim.lsp.buf.rename(new_name, { bufnr = args.buf })
          utils.notify('rename successfully')
        end
      end)
    end, 'Rename')
    if utils.has_lsp('vtsls') then
      utils.map('n', utils.L('co'), utils.action['source.organizeImports'], '[TS] Organize imports')
      utils.map('n', utils.L('cv'), function()
        utils.execute({ command = 'typescript.selectTypeScriptVersion' })
      end, '[TS] Select ts version')
    end
  end,
})
