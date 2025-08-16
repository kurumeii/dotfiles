local util = require('utils')
local map, L = util.map, util.L

-- Dashboard =================================================================
-- map('n', L('h'), Snacks.dashboard.open, 'Open Dashboard')
-- Terminal ==================================================================
map('n', L('ts'), Snacks.terminal.toggle, 'Toggle Terminal split')
map('n', L('tf'), function()
  Snacks.terminal.toggle(nil, {
    win = {
      style = 'float',
      border = 'rounded',
    },
  })
end, 'Toggle Terminal float')
-- Lazygit ==================================================================
map('n', L('gg'), Snacks.lazygit.open, Snacks.lazygit.meta.desc)
-- And rename file in current buffer
-- map('n', L('cr'), Snacks.rename.rename_file, '[C]ode [R]ename')
-- Delete buffer with snacks
-- map('n', L('bd'), Snacks.bufdelete.delete, 'Budder delete')
-- map('n', L('bo'), Snacks.bufdelete.other, 'Buffer delete other')
-- map('n', L('bD'), Snacks.bufdelete.all, 'Buffer delete all')

-- Picker
-- map('n', L('ff'), Snacks.picker.files, 'Search files')
-- map('n', L('fw'), Snacks.picker.grep, 'Search word')
-- map('n', L('ft'), Snacks.picker.colorschemes, 'Search colorschemes')
-- map('n', L('fr'), Snacks.picker.registers, 'Search registers')
-- map('n', L('fc'), Snacks.picker.commands, 'Search commands')
-- map('n', L('fh'), Snacks.picker.help, 'Search help')
-- map('n', L('fk'), Snacks.picker.keymaps, 'Search keymaps')
-- map('n', L('fb'), Snacks.picker.buffers, 'Search buffers')
-- map('n', L('fq'), Snacks.picker.qflist, 'Search quickfix list')
-- map('n', L('fC'), function()
--   Snacks.picker.files({
--     cwd = vim.fn.stdpath('config'),
--   })
-- end, 'Find Config files')
-- map('n', L('fp'), Snacks.picker.projects, 'Find Projects')
-- map('n', L('fd'), Snacks.picker.diagnostics_buffer, 'Find Diagnostics in buffer')
-- map('n', L('fD'), Snacks.picker.diagnostics, 'Find Diagnostics')
-- map('n', L('fm'), Snacks.picker.marks, 'Find marks')
-- map('n', L('fn'), Snacks.picker.notifications, 'Find notifications')
-- LSP =======================================================================
-- map('n', L('lr'), Snacks.picker.lsp_references, 'LSP references')
-- map('n', L('ld'), Snacks.picker.lsp_definitions, 'LSP definitions')
-- map('n', L('lt'), Snacks.picker.lsp_type_definitions, 'LSP type definitions')
-- map('n', L('li'), Snacks.picker.lsp_implementations, 'LSP implementations')
-- map('n', L('lD'), Snacks.picker.lsp_declarations, 'LSP declarations')
-- map('n', L('ls'), Snacks.picker.lsp_symbols, 'LSP symbols')
-- map('n', L('lS'), Snacks.picker.lsp_workspace_symbols, 'LSP workspace symbols')
