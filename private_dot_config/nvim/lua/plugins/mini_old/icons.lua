local icon_groups = {
  eslint = {
    files = {
      '.eslintrc.js',
      '.eslintrc.json',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.cjs',
      '.eslintrc.mjs',
      '.eslintrc.ts',
      '.eslintrc',
      'eslint.config.js',
      'eslint.config.json',
      'eslint.config.yaml',
      'eslint.config.yml',
      'eslint.config.cjs',
      'eslint.config.mjs',
      'eslint.config.ts',
    },
    glyph = '󰱺',
    type = 'file',
    hl = 'MiniIconsPurple',
  },
  prettier = {
    files = {
      '.prettierrc',
      '.prettierrc.json',
      '.prettierrc.yaml',
      '.prettierrc.yml',
      '.prettierrc.json5',
      '.prettierrc.js',
      '.prettierrc.cjs',
      '.prettierrc.mjs',
      '.prettierrc.ts',
      'prettier.config.js',
      'prettier.config.cjs',
      'prettier.config.mjs',
      'prettier.config.ts',
    },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsYellow',
  },
  yarn = {
    files = { 'yarn.lock', '.yarnrc.yml', '.yarnrc.yaml' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsBlue',
  },
  ts = {
    files = {
      'tsconfig.json',
      'tsconfig.build.json',
      'tsconfig.app.json',
      'tsconfig.server.json',
      'tsconfig.web.json',
      'tsconfig.client.json',
    },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsAzure',
  },
  node = {
    files = { '.node-version', 'package.json', '.npmrc' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsGreen',
  },
  vite = {
    files = { 'vite.config.ts', 'vite.config.js' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsYellow',
  },
  pnpm = {
    files = { 'pnpm-lock.yaml', 'pnpm-workspace.yaml' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsYellow',
  },
  docker = {
    files = { '.dockerignore' },
    glyph = '󰡨',
    type = 'file',
    hl = 'MiniIconsBlue',
  },
  react_router = {
    files = { 'react-router.config.ts', 'react-router.config.js' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsRed',
  },
  bun = {
    files = { 'bun.lockb', 'bun.lock' },
    glyph = '',
    type = 'file',
    hl = 'MiniIconsGrey',
  },
  vscode = {
    type = 'directory',
    files = { '.vscode' },
    glyph = '',
    hl = 'MiniIconsBlue',
  },
  cspell = {
    type = 'directory',
    files = { 'cspell' },
    glyph = '󰓆',
    hl = 'MiniIconsPurple',
  },
  config = {
    type = 'directory',
    files = { 'config', 'configs' },
    glyph = '',
    hl = 'MiniIconsGrey',
  },
  app = {
    type = 'directory',
    files = { 'app', 'application' },
    glyph = '󰀻',
    hl = 'MiniIconsRed',
  },
  routes = {
    type = 'directory',
    files = { 'routes', 'route', 'router', 'routers' },
    glyph = '󰑪',
    hl = 'MiniIconsGreen',
  },
  server = {
    type = 'directory',
    files = { 'server', 'servers', 'api' },
    glyph = '󰒋',
    hl = 'MiniIconsCyan',
  },
  web = {
    type = 'directory',
    files = { 'web', 'client', 'frontend' },
    glyph = '󰖟',
    hl = 'MiniIconsBlue',
  },
  database = {
    type = 'directory',
    files = { 'database', 'db', 'databases' },
    glyph = '󰆼',
    hl = 'MiniIconsOrange',
  },
}

---@param type 'file' | 'directory'
local init_setup = function(type)
  local result = {}
  for _, group in pairs(icon_groups) do
    if group.type == type then
      for _, fname in ipairs(group.files) do
        result[fname] = { glyph = group.glyph, hl = group.hl }
      end
    end
  end
  return result
end

require('mini.icons').setup({
  file = init_setup('file'),
  directory = init_setup('directory'),
})

MiniIcons.mock_nvim_web_devicons()
MiniDeps.later(function()
  MiniIcons.tweak_lsp_kind('prepend')
end)
