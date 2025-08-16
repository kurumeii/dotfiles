local battery = require('battery')

require('lualine').setup({
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        icons_enabled = false,
        fmt = function(str)
          return ' ' .. str:sub(1, 1)
        end,
      },
    },
    lualine_b = {
      {
        'branch',
        icon = mininvim.icons.git_branch,
      },
      {
        'diff',
        symbols = {
          added = mininvim.icons.git_add .. ' ',
          modified = mininvim.icons.git_edit .. ' ',
          removed = mininvim.icons.git_remove .. ' ',
        },
      },
      {
        'diagnostics',
        symbols = {
          error = mininvim.icons.error .. ' ',
          warn = mininvim.icons.warn .. ' ',
          info = mininvim.icons.info .. ' ',
          hint = mininvim.icons.hint .. ' ',
        },
      },
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        path = 1,
      },
      '%=',
    },
    lualine_x = {
      {
        'macro',
        fmt = function()
          local reg = vim.fn.reg_recording()
          if reg ~= '' then
            return mininvim.icons.recording .. ' ' .. reg
          end
          return nil
        end,
        draw_empty = false,
        color = { fg = '#fccccc' },
      },
      {
        'lsp_status',
        icon = mininvim.icons.lsp,
        symbols = {
          separator = ',',
        },
        ignore_lsp = {
          'mini.snippets',
        },
      },
      {
        'filetype',
      },
      { battery.get_status_line },
    },
    lualine_y = {
      'searchcount',
    },
    lualine_z = {
      {
        'datetime',
        style = '%R' .. ' ' .. mininvim.icons.clock,
      },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  winbar = {
    lualine_c = {
      'navic',
      color_correction = nil,
      navic_opts = nil,
    },
  },
})
