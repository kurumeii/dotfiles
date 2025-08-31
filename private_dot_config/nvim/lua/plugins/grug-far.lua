return {
	"MagicDuck/grug-far.nvim",
	lazy = true,
	opts = {
		headerMaxWidth = 80,
		transient = true,
	},
	keys = {
		{
			mode = { "n", "x" },
			"<leader>fg",
			function()
				local mode = vim.fn.mode(true)
				local grug = require("grug-far")
				local inBuffer = vim.fn.expand("%:p")
				-- In visual mode, grep for the selection
				if mode:find("[vV\22]") then
					grug.with_visual_selection({
						prefills = {
							paths = inBuffer,
						},
					})
				else
					grug.open({
						prefills = {
							paths = inBuffer,
						},
					})
				end
			end,
			desc = "Find & Grug in current buffer",
		},
	},
}
