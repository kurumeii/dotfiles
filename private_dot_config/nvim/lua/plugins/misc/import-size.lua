local import_size = require('import-size')
import_size.setup()
local utils = require('utils')
utils.map('n', utils.L('uc'), import_size.toggle, 'Toggle Import Size')
