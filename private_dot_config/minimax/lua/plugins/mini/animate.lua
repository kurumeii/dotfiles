local MiniAnimate = require("mini.animate")

MiniAnimate.setup({
	cursor = {
		enable = false,
	},
	scroll = {
		enable = false,
		timing = MiniAnimate.gen_timing.quadratic({
			duration = 200,
			unit = "total",
		}),
		subscroll = MiniAnimate.gen_subscroll.equal({
			predicate = function(total_scroll)
				return total_scroll > 1
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
