local starter = require('mini.starter')

starter.setup({
  items = {
    starter.sections.sessions(1, true),
    starter.sections.recent_files(3, true, false),
    {
      { name = 'Open Mason', action = 'Mason', section = 'Tools' },
      {
        name = 'Update Mini Packages',
        action = 'DepsUpdate',
        section = 'Tools',
      },
    },
    starter.sections.pick(),
    {
      name = 'Edit config',
      action = 'edit $MYVIMRC',
      section = 'Core',
    },
    {
      name = 'Quit',
      action = 'qa',
      section = 'Core',
    },
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
  footer = function()
    return "It's - " .. os.date('%x %X')
  end,
})

local utils = require('utils')
utils.map('n', utils.L('h'), MiniStarter.open, 'Open Dashboard')
