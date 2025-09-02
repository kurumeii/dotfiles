---@type LazySpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		win = {
			col = 0,
			row = math.huge,
		},
		spec = {
			{
				mode = { "n", "v" },
				-- { "<leader><tab>", group = "tabs" },
				{ "<leader>c", group = "Code", icon = "" },
				{ "<leader>cs", group = "Spelling", icon = "󰘝" },
				{ "<leader>d", group = "Debugger", icon = "" },
				{ "<leader>f", group = "Find", icon = "" },
				{ "<leader>g", group = "Git", icon = "󰊢" },
				{ "<leader>l", group = "Lsp", icon = "'" },
				{ "<leader>s", group = "Sessions", icon = "" },
				{ "<leader>u", group = "Ui", icon = { icon = "󰙵", color = "cyan" } },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
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
				{
					"<leader>n",
					group = "Notification",
					icon = "󱀉",
				},
				{
					"<leader>t",
					group = "Terminal",
					icon = "",
				},
				{
					"<leader>x",
					group = "Trouble",
					icon = "",
				},
				{
					"<leader>ul",
					"<cmd>Lazy<cr>",
					icon = "󰒲",
				},
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
}
