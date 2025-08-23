---@type LazySpec
return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
			always_show_bufferline = true,
			show_buffer_close_icons = false,
			show_close_icon = false,
			separator_style = "slant",
		})
	end,
}
