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
				changedelete = { text = mininvim.icons.git_signs.change },
				untracked = { text = mininvim.icons.git_signs.add },
			},
			signs_staged = {
				add = { text = mininvim.icons.git_signs.add },
				change = { text = mininvim.icons.git_signs.change },
				delete = { text = mininvim.icons.git_signs.delete },
				topdelete = { text = mininvim.icons.git_signs.delete },
				changedelete = { text = mininvim.icons.git_signs.change },
			},
			numhl = false,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 3000,
				ignore_whitespace = true,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "Cooked (<author_time:%R>) by <author> - <summary>",
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
		}):map("<leader>ugs")
		Snacks.toggle({
			name = "Toggle num hightlight",
			get = function()
				return require("gitsigns.config").config.numhl
			end,
			set = function(state)
				require("gitsigns").toggle_numhl(state)
			end,
		}):map("<leader>ugn")
		Snacks.toggle({
			name = "Toggle line hightlight",
			get = function()
				return require("gitsigns.config").config.linehl
			end,
			set = function(state)
				require("gitsigns").toggle_linehl(state)
			end,
		}):map("<leader>ugl")

		Snacks.toggle({
			name = "Toggle blame line",
			get = function()
				return require("gitsigns.config").config.current_line_blame
			end,
			set = function(state)
				require("gitsigns").toggle_current_line_blame(state)
			end,
		}):map("<leader>ugb")

		Snacks.toggle({
			name = "Toggle word diff",
			get = function()
				return require("gitsigns.config").config.word_diff
			end,
			set = function(state)
				require("gitsigns").toggle_word_diff(state)
			end,
		}):map("<leader>ugw")
	end,
	keys = {
		{
			"]h",
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					require("gitsigns").nav_hunk("next")
				end
			end,
			desc = "Next Hunk",
		},
		{
			"[h",
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					require("gitsigns").nav_hunk("prev")
				end
			end,
			desc = "Prev Hunk",
		},
		{
			"]H",
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					require("gitsigns").nav_hunk("last")
				end
			end,
			desc = "Last Hunk",
		},
		{
			"[H",
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					require("gitsigns").nav_hunk("first")
				end
			end,
			desc = "First Hunk",
		},
		{
			mode = { "n", "v" },
			"<leader>gr",
			desc = "Revert Hunk",
			function()
				local start_line = vim.fn.getpos("v")[2]
				local end_line = vim.fn.getpos(".")[2]
				require("gitsigns").reset_hunk({
					range = {
						start_line,
						end_line,
					},
				})
			end,
		},
		{
			mode = { "n" },
			"<leader>gh",
			desc = "Show hunk",
			function()
				require("gitsigns").preview_hunk()
			end,
		},
		{
			"<leader>gc",
			desc = "Git show commit",
			function()
				vim.ui.input({ prompt = "Enter commit hash or indexed (e.g. ~1): " }, function(input)
					if input then
						require("gitsigns").show_commit(input)
					else
						require("gitsigns").show_commit()
					end
				end)
			end,
		},
		{
			"<leader>gd",
			desc = "Git diff (input)",
			function()
				vim.ui.input({ prompt = "Enter commit hash or indexed (e.g. ~1): " }, function(input)
					if input then
						require("gitsigns").diffthis(input)
					else
						require("gitsigns").diffthis()
					end
				end)
			end,
		},
	},
}
