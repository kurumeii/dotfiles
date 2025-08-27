---@type LazySpec[]
return {
	{
		"max397574/better-escape.nvim",
		opts = {
			default_mappings = false, -- setting this to false removes all the default mappings
			mappings = {
				-- i for insert
				i = {
					j = {
						j = false,
						k = "<Esc>",
					},
				},
				t = {
					q = {
						k = "<C-\\><C-n>",
					},
				},
				v = {
					j = {},
				},
				-- s = {
				--   j = {
				--     k = '<Esc>',
				--   },
				-- },
			},
		},
	},
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
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			win = {
				col = 0,
				row = math.huge,
			},
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader><tab>", group = "tabs" },
					{ "<leader>b", group = "Buffer", icon = "" },
					{ "<leader>c", group = "Code", icon = "" },
					{ "<leader>d", group = "Debugger", icon = "" },
					{ "<leader>f", group = "Find", icon = "" },
					{ "<leader>g", group = "Git", icon = "󰊢" },
					{ "<leader>l", group = "Lsp", icon = "'" },
					{ "<leader>s", group = "Sessions", icon = "" },
					{ "<leader>u", group = "Ui", icon = { icon = "󰙵 ", color = "cyan" } },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
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
		"SmiteshP/nvim-navic",
		event = { "BufReadPre" },
		init = function()
			mininvim.utils.lsp({
				on_attach = function(client, bufnr)
					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, bufnr)
					end
				end,
			})
		end,
		opts = {
			highlight = true,
			depth_limit = 4,
			-- lsp = {
			--   auto_attach = true,
			-- }
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			-- options = {
			--   component_separators = { left = '', right = '' },
			--   section_separators = { left = '', right = '' },
			-- },
			sections = {
				lualine_a = {
					{
						"filename",
						file_status = true,
						newfile_status = true,
						path = 4,
					},
				},
				lualine_b = {
					{
						"branch",
						icon = mininvim.icons.git_branch,
					},
					{
						"diff",
						symbols = {
							added = mininvim.icons.git_add .. " ",
							modified = mininvim.icons.git_edit .. " ",
							removed = mininvim.icons.git_remove .. " ",
						},
					},
					{
						"diagnostics",
						symbols = {
							error = mininvim.icons.error .. " ",
							warn = mininvim.icons.warn .. " ",
							info = mininvim.icons.info .. " ",
							hint = mininvim.icons.hint .. " ",
						},
					},
				},
				lualine_c = {
					-- {
					--   'filename',
					--   file_status = true,
					--   newfile_status = true,
					--   path = 1,
					-- },
					"%=",
				},
				lualine_x = {
					{
						"macro",
					},
					{
						"lsp_status",
						icon = mininvim.icons.lsp,
						symbols = {
							separator = ",",
						},
					},
					{
						"filetype",
					},
				},
				-- lualine_y = {
				--   'searchcount',
				-- },
				lualine_z = {
					{
						"datetime",
						style = "%R" .. " " .. mininvim.icons.clock,
					},
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			winbar = {
				lualine_c = {
					"navic",
					color_correction = nil,
					navic_opts = nil,
				},
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			-- { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			-- { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			-- { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
			-- { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		},
		---@module 'bufferline'
		---@type bufferline.Options
		opts = {
			options = {
				-- always_show_bufferline = true,
				show_close_icon = false,
				show_buffer_close_icons = false,
				separator_style = "slanted",
				groups = {
					options = {
						toggle_hidden_on_enter = true,
					},
				},
				diagnostics = "nvim_lsp",
				close_command = function(n)
					require("mini.bufremove").delete(n)
				end,
				diagnostics_indicator = function(_, _, diag)
					local icons = mininvim.icons
					local ret = (diag.error and icons.error .. diag.error .. " " or "")
						.. (diag.warning and icons.warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				get_element_icon = function(o)
					return require("mini.icons").get("filetype", o.filetype)
				end,
			},
		},
	},
}
