local hi = require('mini.hipatterns')
local hi_words = MiniExtra.gen_highlighter.words
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
