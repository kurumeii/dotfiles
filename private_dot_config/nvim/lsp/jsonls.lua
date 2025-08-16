return {
  filetypes = { 'json', 'jsonc', 'bak' },
  settings = {
    json = {
      format = { enable = false },
      schemas = require('schemastore').json.schemas({
        extra = {
          {
            description = 'Shadcn JSON schema',
            fileMatch = { 'components.json' },
            name = 'components.json',
            url = 'https://ui.shadcn.com/schema.json',
          },
          {
            description = 'Lua_ls JSON schema',
            fileMatch = { '.luarc.json' },
            name = '.luarc.json',
            url = 'https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json',
          },
        },
      }),
    },
  },
}
