---@type LazySpec[]
return {
	{
		"echasnovski/mini.basics",
		opts = {
			options = {
				basic = true,
				extra_ui = false,
				win_borders = "default",
			},
			mappings = {
				basic = true,
			},
			autocommands = {
				basic = true,
			},
		},
	},
	{
		"echasnovski/mini.files",
		opts = {
			mappings = {
				go_out_plus = "h",
				synchronize = "<c-s>",
			},
		},
		keys = {
			-- Disabled default keymaps from lazynvim
			{ "<leader>fm", false },
			{ "<leader>fM", false },
			{
				"<leader>e",
				function()
					local files = require("mini.files")
					files.open(vim.api.nvim_buf_get_name(0), false)
				end,
				desc = "Open mini.files",
			},
		},
	},
}
