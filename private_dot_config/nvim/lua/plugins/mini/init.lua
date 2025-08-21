local utils = require('utils')
local H = {
  show_dotfiles = true,
  filter_show = function(_)
    return true
  end,
  filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end,
}
return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  version = false,
  config = function()
    local extra = require('mini.extra')
    require('mini.colors').setup()
    require('mini.keymap').setup()
    -- require('mini.trailspace').setup()
    require('mini.fuzzy').setup()
    require('mini.operators').setup()
    require('mini.move').setup()
    require('mini.basics').setup({
      options = {
        basic = true,
        extra_ui = false,
        win_borders = 'shadow',
      },
      mappings = {
        windows = true,
        move_with_alt = true,
      },
    })
    -- Actual setup
    local ai = require('mini.ai')
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        L = require('mini.extra').gen_ai_spec.line(), -- Line
        -- Tweak function call to not detect dot in function name
        f = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
        -- Function definition (needs treesitter queries with these captures)
        F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        o = ai.gen_spec.treesitter({
          a = { '@block.outer', '@loop.outer', '@conditional.outer' },
          i = { '@block.inner', '@loop.inner', '@conditional.inner' },
        }),
        B = require('mini.extra').gen_ai_spec.buffer(),
        D = require('mini.extra').gen_ai_spec.diagnostic(),
        I = require('mini.extra').gen_ai_spec.indent(),
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }),
        N = require('mini.extra').gen_ai_spec.number(),
      },
    })
    --
    local MiniBracketed = require('mini.bracketed')
    MiniBracketed.setup({
      treesitter = { suffix = 's' },
    })
    utils.map('n', 'L', function()
      MiniBracketed.buffer('forward')
    end, 'Next buffer ->')
    utils.map('n', 'H', function()
      MiniBracketed.buffer('backward')
    end, 'Previous buffer <-')
    --
    require('plugins.mini.comment')
    --
    local miniclue = require('mini.clue')
    miniclue.setup({
      window = {
        config = {
          width = 'auto',
          anchor = 'SW',
          row = 'auto',
          col = 'auto',
          -- width = vim.api.nvim_list_uis()[1]['width'],
          border = 'double',
        },
      },
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- `[]` keys
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- `\` key
        { mode = 'n', keys = [[\]] },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
        { mode = 'n', keys = '<C-w>' },
        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        { mode = 'n', keys = '<leader>b', desc = 'Buffers ' },
        { mode = 'n', keys = '<leader>c', desc = 'Code ' },
        { mode = 'n', keys = '<leader>cs', desc = 'Spelling ' },
        { mode = 'n', keys = '<leader>g', desc = 'Git 󰊢' },
        { mode = 'n', keys = '<leader>f', desc = 'Find ' },
        { mode = 'n', keys = '<leader>t', desc = 'Terminal  ' },
        { mode = 'n', keys = '<leader>w', desc = 'Window ' },
        { mode = 'n', keys = '<leader>n', desc = 'Notify ' },
        { mode = 'n', keys = '<leader>l', desc = 'Lsp ' },
        { mode = 'n', keys = '<leader>d', desc = 'Debugger ' },
        { mode = 'n', keys = '<leader>s', desc = 'Sessions ' },
        { mode = 'n', keys = '<leader>u', desc = 'Ui ' },
        { mode = 'n', keys = '<leader>p', desc = 'Profile ' },
        { mode = 'n', keys = '<leader>x', desc = 'Extras ' },
        { mode = 'n', keys = '<leader>xa', desc = 'AI' },
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows({
          submode_move = true,
          submode_navigate = true,
          submode_resize = true,
        }),
        miniclue.gen_clues.z(),
      },
    })

    require('mini.files').setup({
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        use_as_default_explorer = true,
      },
      mappings = {
        go_out_plus = 'h',
        synchronize = '<c-s>',
      },
      content = {
        filter = H.filter_show,
      },
    })

    H.map_split = function(buf_id, lhs, direction, close_on_file)
      local rhs = function()
        local new_target_window
        local cur_target_window = MiniFiles.get_explorer_state().target_window
        if cur_target_window ~= nil then
          vim.api.nvim_win_call(cur_target_window, function()
            vim.cmd('belowright ' .. direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target_window)
          MiniFiles.go_in({ close_on_file = close_on_file })
        end
      end

      local desc = 'Open in ' .. direction .. ' split'
      if close_on_file then
        desc = desc .. ' and close'
      end
      vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        utils.map({ 'n' }, '//', function()
          H.show_dotfiles = not H.show_dotfiles
          local new_filter = H.show_dotfiles and H.filter_show or H.filter_hide
          MiniFiles.refresh({ content = { filter = new_filter } })
        end, 'Toggle hidden files', { buffer = args.buf })
        H.map_split(args.buf, '<C-w>s', 'horizontal', false)
        H.map_split(args.buf, '<C-w>v', 'vertical', false)
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(e)
        Snacks.rename.on_rename_file(e.data.from, e.data.to)
        utils.notify('Renamed ' .. e.data.from .. ' to ' .. e.data.to .. ' successfully')
      end,
    })

    utils.map('n', utils.L('e'), function()
      local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
      if not ok then
        MiniFiles.open(nil, false)
      end
    end, 'Open explore')

    local hi = require('mini.hipatterns')
    local hi_words = extra.gen_highlighter.words
    local util = require('utils')
    local M = {}
    ---@type table<string, boolean>
    M.hl = {}
    hi.setup({
      highlighters = {
        fixme = hi_words({ 'FIXME', 'fixme' }, 'MiniHiPatternsFixme'),
        todo = hi_words({ 'TODO', 'todo' }, 'MiniHiPatternsTodo'),
        note = hi_words({ 'NOTE', 'note' }, 'MiniHiPatternsNote'),
        bug = hi_words({ 'BUG', 'bug', 'HACK', 'hack', 'hax' }, 'MiniHiPatternsHack'),
        hex_color = hi.gen_highlighter.hex_color({ priority = 200 }),
        hex_shorthand = {
          pattern = '()#%x%x%x()%f[^%x%w]',
          group = function(_, _, data)
            ---@type string
            local match = data.full_match
            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
            local hex_color = '#' .. r .. r .. g .. g .. b .. b
            return hi.compute_hex_color_group(hex_color, 'bg')
          end,
        },
        hsl_color = {
          pattern = 'hsl%(%s*[%d%.]+%%?%s*[, ]%s*[%d%.]+%%?%s*[, ]%s*[%d%.]+%%?%s*%)',
          group = function(_, match)
            local h, s, l = match:match('([%d%.]+)%%?%s*[, ]%s*([%d%.]+)%%?%s*[, ]%s*([%d%.]+)%%?')
            h, s, l = tonumber(h), tonumber(s), tonumber(l)
            local hex = util.hslToHex(h, s, l)
            return hi.compute_hex_color_group(hex, 'bg')
          end,
        },
        rgb_color = {
          pattern = 'rgb%(%d+,? %d+,? %d+%)',
          group = function(_, match)
            local r, g, b = match:match('rgb%((%d+),? (%d+),? (%d+)%)')
            r, g, b = tonumber(1), tonumber(2), tonumber(3)
            local hex = util.rgbToHex(r, g, b)
            return hi.compute_hex_color_group(hex, 'bg')
          end,
        },
        rgba_color = {
          pattern = 'rgba%(%d+,? %d+,? %d+,? %d*%.?%d*%)',
          group = function(_, match)
            local r, g, b, a = match:match('rgba%((%d+),? (%d+),? (%d+),? (%d*%.?%d*)%)')
            r, g, b, a = tonumber(r), tonumber(g), tonumber(b), tonumber(a)
            if a == nil or a < 0 or a > 1 then
              return false
            end
            local hex = util.rgbToHex(r, g, b, a)
            return hi.compute_hex_color_group(hex, 'bg')
          end,
        },
        oklch_color = {
          pattern = 'oklch%(%s*[%d%.]+%s+[%d%.]+%s+[%d%.]+%s*/?%s*[%d%.]*%%?%s*%)',
          group = function(_, match)
            local l, c, h, a = match:match('oklch%(%s*([%d%.]+)%s+([%d%.]+)%s+([%d%.]+)%s*/?%s*([%d%.]*)%%?%s*%)')
            l, c, h = tonumber(l), tonumber(c), tonumber(h)
            if a == '' or a == nil then
              a = 1
            else
              a = tonumber(a)
              if a > 1 then
                a = a / 100
              end
            end
            local hex = util.oklchToHex(l, c, h, a)
            return hi.compute_hex_color_group(hex, 'bg')
          end,
        },
        tailwind_color = {
          pattern = function()
            local ft = {
              'css',
              'html',
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
            }
            if not vim.tbl_contains(ft, vim.bo.filetype) then
              return
            end
            return '%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]'
          end,
          group = function(_, match)
            local color, shade = match:match('[%w-]+%-([a-z%-]+)%-(%d+)')
            shade = tonumber(shade)
            local bg = vim.tbl_get(mininvim.tw_colors, color, shade)
            if bg == nil then
              return
            end
            local word_color = mininvim.word_colors[color]
            if word_color ~= nil then
              return hi.compute_hex_color_group(word_color, 'bg')
            end
            local hl = 'MiniHiPatternsTailwind' .. color .. shade
            if not M.hl[hl] then
              M.hl[hl] = true
              local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
              local fg = vim.tbl_get(mininvim.tw_colors, color, bg_shade)
              vim.api.nvim_set_hl(0, hl, { bg = '#' .. bg, fg = '#' .. fg })
            end
            return hl
          end,
          extmark_opts = { priority = 1000 },
        },
        word_color = {
          pattern = '%S+',
          group = function(_, match)
            local hex = mininvim.word_colors[match]
            if hex == nil then
              return nil
            end
            return hi.compute_hex_color_group(hex, 'bg')
          end,
        },
      },
    })

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        M.hl = {}
      end,
    })

		--

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
local MiniIcons = require('mini.icons')
MiniIcons.setup({
  file = init_setup('file'),
  directory = init_setup('directory'),
})

MiniIcons.mock_nvim_web_devicons()


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
  end

}
