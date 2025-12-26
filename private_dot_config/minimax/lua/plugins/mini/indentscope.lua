local MiniIndentScope = require("mini.indentscope")
MiniIndentScope.setup({
	options = { try_as_border = false },
	draw = {
		animation = MiniIndentScope.gen_animation.quadratic({
			easing = "in-out",
			duration = 200,
			unit = "total",
		}),
	},
})
