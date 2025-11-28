local utils = require("config.utils")
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = {
			add = mininvim.icons.git_signs.add,
			change = mininvim.icons.git_signs.change,
			delete = mininvim.icons.git_signs.delete,
		},
	},
	mappings = {
		reset = utils.L("gr"),
		textobject = "gh",
		goto_first = "[H",
		goto_last = "]H",
		goto_next = "]h",
		goto_prev = "[h",
	},
})
