local MiniAnimate = require("mini.animate")

MiniAnimate.setup({
	cursor = { enable = false },
	scroll = {
		enable = true,
		timing = MiniAnimate.gen_timing.quadratic({
			unit = "total",
		}),
	},
	resize = { enable = false },
	open = { enable = false },
	close = { enable = false },
})
