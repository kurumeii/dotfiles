local utils = require('utils')
local map, L, C = utils.map, utils.L, utils.C
-- Qol remap
map('n', '<Esc>', C('nohlsearch'))
-- map('n', L('cs'), C('source'), 'Code source current')
map('n', L('wq'), C('q'), '[W]indow [Q]uit')
map('n', L('ww'), C('w'), '[W]indow [W]rite')
map('n', ']t', C('tabnext'), 'Next tab')
map('n', '[t', C('tabprev'), 'Previous tab')
map('n', '<c-a>', 'ggVG', 'Visual select all', {
  noremap = true,
})
map('n', L('uM'), C('Mason'), 'Ui open mason')
map('n', L('wsl'), C(':vsplit'), 'Split window right')
map('n', L('wsj'), C(':split'), 'Split window horizontally')
