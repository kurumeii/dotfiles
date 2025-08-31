local utils = require("utils")
---@type LazySpec[]
return {
	{
		"stuckinsnow/import-size.nvim",
		ft = {
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opt = {
			signs = {
				add = { text = mininvim.icons.git_add },
				change = { text = mininvim.icons.git_edit },
				delete = { text = mininvim.icons.git_remove },
				topdelete = { text = mininvim.icons.git_remove },
				changedelete = { text = mininvim.icons.git_add },
				untracked = { text = mininvim.icons.git_add },
			},
			signs_staged = {
				add = { text = mininvim.icons.git_add },
				change = { text = mininvim.icons.git_edit },
				delete = { text = mininvim.icons.git_remove },
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
			current_line_blame_formatter = "<author> -> <summary> <author_time:%R>",
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
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		dependencies = {
			{ "justinsgithub/wezterm-types", lazy = true },
		},
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			enable_close_on_slash = true,
		},
	},
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
				test = {
					mode = "diagnostics",
					preview = {
						type = "split",
						relative = "win",
						position = "right",
						size = 0.3,
					},
				},
			},
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost" },
		dependencies = {
			"kevinhwang91/promise-async",
		},
		keys = {
			{
				"zO",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zC",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{
				"<s-k>",
				function()
					local winid = require("ufo").peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end,
			},
		},
		---@type UfoConfig
		opts = {
			open_fold_hl_timeout = 150,
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
			},
			-- provider_selector = {},
			fold_virt_text_handler = function(virt_text, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󱞡 %d "):format(endLnum - lnum)
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
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
		},
	},
}
