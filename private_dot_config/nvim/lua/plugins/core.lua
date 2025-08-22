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
		opt = {
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
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
	{
		"folke/flash.nvim",
		keys = {
			-- Disable default mappings
			{ "S", mode = { "n", "x", "o" }, false },
			{ "s", mode = { "n", "x", "o" }, false },
			{
				"<leader>j",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Jumping fast to",
			},
		},
	},
}
