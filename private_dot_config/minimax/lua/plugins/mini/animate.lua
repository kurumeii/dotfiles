local MiniAnimate = require("mini.animate")

MiniAnimate.setup({
	cursor = {
		enable = true,
		timing = MiniAnimate.gen_timing.quartic({
			duration = 2,
			unit = "step",
			easing = "in-out",
		}),
		path = MiniAnimate.gen_path.line(),
	},
	scroll = {
		enable = false,
		subscroll = MiniAnimate.gen_subscroll.equal({
			predicate = function(total_scroll)
				return total_scroll > 0
			end,
		}),
	},
	resize = {
		enable = false,
		timing = MiniAnimate.gen_timing.linear({
			duration = 50,
			unit = "total",
		}),
	},
	open = { enable = true },
	close = { enable = true },
})
