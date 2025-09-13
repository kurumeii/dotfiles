---@module "lazy"
---@type LazySpec
return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = function()
		require("gitsigns").setup({
			signs = {
				add = { text = mininvim.icons.git_signs.add },
				change = { text = mininvim.icons.git_signs.change },
				delete = { text = mininvim.icons.git_signs.delete },
				topdelete = { text = mininvim.icons.git_signs.delete },
				changedelete = { text = mininvim.icons.git_add },
				untracked = { text = mininvim.icons.git_add },
			},
			signs_staged = {
				add = { text = mininvim.icons.git_signs.add },
				change = { text = mininvim.icons.git_signs.change },
				delete = { text = mininvim.icons.git_signs.delete },
				topdelete = { text = mininvim.icons.git_remove },
				changedelete = { text = mininvim.icons.git_add },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = true,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author> -> <summary> (<author_time:%R>)",
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = require("utils").map
				map(
					"n",
					"]h",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gs.nav_hunk("next")
						end
					end,
					"Next Hunk",
					{
						buffer = bufnr,
					}
				)
				map(
					"n",
					"[h",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gs.nav_hunk("prev")
						end
					end,
					"Prev Hunk",
					{
						buffer = bufnr,
					}
				)
				map(
					"n",
					"]H",
					function()
						gs.nav_hunk("last")
					end,
					"Last Hunk",
					{
						buffer = bufnr,
					}
				)
				map(
					"n",
					"[H",
					function()
						gs.nav_hunk("first")
					end,
					"First Hunk",
					{
						buffer = bufnr,
					}
				)
			end,
		})
		Snacks.toggle({
			name = "Git Signs",
			get = function()
				return require("gitsigns.config").config.signcolumn
			end,
			set = function(state)
				require("gitsigns").toggle_signs(state)
			end,
		}):map("<leader>uG")
	end,
}
