local MiniIndentScope = require("mini.indentscope")
MiniIndentScope.setup({
	-- symbol = "│",
	options = { try_as_border = false },
	draw = {
		animation = MiniIndentScope.gen_animation.cubic({
			easing = "in",
			duration = 300,
			unit = "total",
		}),
	},
})
