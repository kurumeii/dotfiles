return {
  {
    'kevinhwang91/nvim-ufo',
    lazy = true,
    dependencies = {
      'kevinhwang91/promise-async',
    },
    opts = {
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
      },
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virt_text, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virt_text) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    opts = {
      sections = {
        lualine_a = {
          {
            'mode',
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
            path = 4,
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
    }
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = {
      'folke/snacks.nvim'
    },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      signcolumn = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author> -> <summary> <author_time:%R>',
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        -- map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        -- map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        -- map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        -- map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        -- map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
        -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        Snacks.toggle({
          name = "Git Signs",
          get = function()
            return require("gitsigns.config").config.signcolumn
          end,
          set = function(state)
            require("gitsigns").toggle_signs(state)
          end,
        }):map("<leader>ug")
      end,
    },
  }
}
