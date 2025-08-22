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
				basic = false,
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
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "sa",
					delete = "sd",
					find = "sf",
					find_left = "",
					highlight = "",
					replace = "sr",
					update_n_lines = "",

					-- Add this only if you don't want to use extended mappings
					suffix_last = "",
					suffix_next = "",
				},
				search_method = "cover_or_next",
			})
		end,
	},
}
