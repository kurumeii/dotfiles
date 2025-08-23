---@type LazySpec
return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		---@module 'bufferline'
		---@type bufferline.Options
		local overrides = {
			-- always_show_bufferline = true,
			show_close_icon = false,
			show_buffer_close_icons = false,
			-- separator_style = "slope",
			groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
			},
		}
		opts.options = vim.tbl_deep_extend("force", opts.options or {}, overrides)
	end,
}
