---@type LazySpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		opts.preset = "helix"
		opts.win = {
			col = 0,
			row = math.huge,
		}
	end,
}
