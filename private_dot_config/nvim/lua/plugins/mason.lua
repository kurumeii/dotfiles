local utils = require("utils")
return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	keys = {
		{ utils.L("uM"), utils.C("Mason"), desc = "Open Mason" },
	},
	opts = function(_, opts)
		local ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		}
		opts.ui = ui
	end
}
