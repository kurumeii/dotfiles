local utils = require("config.utils")
require("mini.files").setup({
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 30,
	},
	options = {
		use_as_default_explorer = true,
	},
	mappings = {
		go_out_plus = "h",
		synchronize = "<c-s>",
	},
	content = {
		filter = utils.filter_show,
	},
})

utils.map("n", utils.L("e"), function()
	local ok = pcall(MiniFiles.open, vim.api.nvim_buf_get_name(0), false)
	if not ok then
		MiniFiles.open(nil, false)
	end
end, " Open explore")
