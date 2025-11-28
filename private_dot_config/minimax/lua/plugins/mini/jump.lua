local utils = require("config.utils")
require("mini.jump").setup({
	mappings = {
		forward = "f",
		backward = "F",
		repeat_jump = ";",
	},
})
local MiniJump2d = require("mini.jump2d")
MiniJump2d.setup({
	labels = "abcdefghijklmnopqrstuvwxyz",
	view = {
		dim = true,
		n_steps_ahead = 2,
	},
	mappings = {
		start_jumping = "<leader>j",
	},
})
utils.map({ "n", "x", "o" }, utils.L("j"), function()
	MiniJump2d.start(MiniJump2d.builtin_opts.query)
end, " Start jumping around")
