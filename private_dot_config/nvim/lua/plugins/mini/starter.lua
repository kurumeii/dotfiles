local starter = require('mini.starter')

starter.setup({
  items = {
    starter.sections.sessions(1, true),
    starter.sections.recent_files(3, true, true),
    starter.sections.pick(),
    starter.sections.builtin_actions(),
  },

  header = function()
    return [[
 __       __ __          __ __     __ __              
|  \     /  \  \        |  \  \   |  \  \             
| ▓▓\   /  ▓▓\▓▓_______  \▓▓ ▓▓   | ▓▓\▓▓______ ____  
| ▓▓▓\ /  ▓▓▓  \       \|  \ ▓▓   | ▓▓  \      \    \ 
| ▓▓▓▓\  ▓▓▓▓ ▓▓ ▓▓▓▓▓▓▓\ ▓▓\▓▓\ /  ▓▓ ▓▓ ▓▓▓▓▓▓\▓▓▓▓\
| ▓▓\▓▓ ▓▓ ▓▓ ▓▓ ▓▓  | ▓▓ ▓▓ \▓▓\  ▓▓| ▓▓ ▓▓ | ▓▓ | ▓▓
| ▓▓ \▓▓▓| ▓▓ ▓▓ ▓▓  | ▓▓ ▓▓  \▓▓ ▓▓ | ▓▓ ▓▓ | ▓▓ | ▓▓
| ▓▓  \▓ | ▓▓ ▓▓ ▓▓  | ▓▓ ▓▓   \▓▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓
 \▓▓      \▓▓\▓▓\▓▓   \▓▓\▓▓    \▓    \▓▓\▓▓  \▓▓  \▓▓
    ]]
  end,
})

local utils = require('utils')
utils.map('n', utils.L('h'), MiniStarter.open, 'Open Dashboard')
