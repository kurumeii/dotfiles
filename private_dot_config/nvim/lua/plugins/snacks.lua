---@type LazySpec
return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		explorer = {
			enabled = false,
		},
		scratch = {
			enabled = false,
		},
		picker = {
			sources = {
				explorer = {
					layout = {
						preset = "sidebar",
						preview = "main",
					},
					ignored = true,
					hidden = true,
				},
			},
		},
	},
	keys = {
		{ "<leader>S", false },
		{ "<leader>.", false },
		{ "<leader>E", false },
		{ "<leader>e", false },
		{ "<leader>fe", false },
		{ "<leader>fE", false },
	},
}
